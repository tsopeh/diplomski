module Main exposing (..)

import AppLayout
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import I18n
import Json.Decode as JD
import Json.Encode as JE
import Page.Home as Home
import Page.Login as Login
import Page.Offer as Offer
import Page.Suggestions as Suggestions
import Page.User as User
import Ports
import Route as Route exposing (Route)
import Task
import Time
import Url
import Viewer exposing (Viewer)



-- MODEL


type Model
    = Redirect Viewer
    | Home Home.Model
    | Suggestions Suggestions.Model
    | Offer Offer.Model
    | User User.Model
    | Login Login.Model


toViewer : Model -> Viewer
toViewer model =
    case model of
        Redirect viewer ->
            viewer

        Home homeModel ->
            Home.toViewer homeModel

        Suggestions suggestionsModel ->
            Suggestions.toViewer suggestionsModel

        Offer offerModel ->
            Offer.toViewer offerModel

        User userModel ->
            User.toViewer userModel

        Login loginMOdel ->
            Login.toViewer loginMOdel


updateViewer : Model -> Viewer -> Model
updateViewer mainModel viewer =
    case mainModel of
        Redirect _ ->
            Redirect viewer

        Home homeModel ->
            Home <| Home.updateViewer homeModel viewer

        Suggestions suggestionsModel ->
            Suggestions <| Suggestions.updateViewer suggestionsModel viewer

        Offer offerModel ->
            Offer <| Offer.updateViewer offerModel viewer

        User userModel ->
            User <| User.updateViewer userModel viewer

        Login loginModel ->
            Login <| Login.updateViewer loginModel viewer



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | LanguageChanged I18n.Language
    | GotToken (Maybe Viewer.Token)
    | GotHereZone Time.Zone
    | GotFromAppLayout (AppLayout.Msg Msg)
    | GotHomeMsg Home.Msg
    | GotSuggestionMsg Suggestions.Msg
    | GotOfferMsg Offer.Msg
    | GotUserMsg User.Msg
    | GotLoginMsg Login.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update mainMsg mainModel =
    case ( mainMsg, mainModel ) of
        ( UrlRequested urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    let
                        key =
                            Viewer.toNavKey <| toViewer mainModel
                    in
                    ( mainModel, Nav.pushUrl key (Url.toString url) )

                External url ->
                    ( mainModel, Nav.load url )

        ( UrlChanged url, _ ) ->
            changeModelTo (Route.fromUrl url) mainModel

        ( LanguageChanged language, _ ) ->
            let
                updatedModel =
                    updateViewer mainModel (Viewer.updateLanguage (toViewer mainModel) language)
            in
            ( updatedModel, Cmd.none )

        ( GotHereZone zone, _ ) ->
            let
                viewer =
                    toViewer mainModel

                updated =
                    updateViewer mainModel <| Viewer.updateZone viewer zone
            in
            ( updated, Cmd.none )

        ( GotFromAppLayout msg, _ ) ->
            case msg of
                AppLayout.GotFromContent contentMsg ->
                    update contentMsg mainModel

                AppLayout.LanguageChanged languageStringId ->
                    ( mainModel, Ports.persistLanguage languageStringId )

        ( GotHomeMsg msg, Home model ) ->
            let
                ( updatedModel, cmd ) =
                    Home.update msg model
            in
            ( Home updatedModel, Cmd.map GotHomeMsg cmd )

        ( GotSuggestionMsg msg, Suggestions model ) ->
            let
                ( updatedModel, cmd ) =
                    Suggestions.update msg model
            in
            ( Suggestions updatedModel, Cmd.map GotSuggestionMsg cmd )

        ( GotOfferMsg msg, Offer model ) ->
            let
                ( updatedModel, cmd ) =
                    Offer.update msg model
            in
            ( Offer updatedModel, Cmd.map GotOfferMsg cmd )

        ( GotUserMsg userMsg, User userModel ) ->
            let
                ( updatedModel, cmd ) =
                    User.update userMsg userModel
            in
            ( User updatedModel, Cmd.map GotUserMsg cmd )

        ( GotLoginMsg loginMsg, Login loginModel ) ->
            let
                ( updatedModel, cmd ) =
                    Login.update loginMsg loginModel
            in
            ( Login updatedModel, Cmd.map GotLoginMsg cmd )

        ( _, _ ) ->
            let
                _ =
                    Debug.log "Impossible state" ( mainMsg, mainModel )
            in
            ( mainModel, Cmd.none )


changeModelTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeModelTo maybeRoute mainModel =
    let
        viewer =
            toViewer mainModel
    in
    case maybeRoute of
        Nothing ->
            ( mainModel, Route.navTo viewer Route.Home )

        Just Route.Home ->
            mapInit Home GotHomeMsg <| Home.init viewer

        Just (Route.Suggestions startId finishId depDateTime) ->
            mapInit Suggestions GotSuggestionMsg <| Suggestions.init viewer startId finishId (Time.millisToPosix depDateTime)

        Just (Route.Offer offerId) ->
            mapInit Offer GotOfferMsg <| Offer.init viewer offerId

        Just (Route.User id) ->
            mapInit User GotUserMsg <| User.init viewer id

        Just Route.Login ->
            mapInit Login GotLoginMsg <| Login.init viewer


mapInit : (subModel -> Model) -> (msg -> Msg) -> ( subModel, Cmd msg ) -> ( Model, Cmd Msg )
mapInit mapModel mapMsg ( subModel, cmd ) =
    ( mapModel subModel, Cmd.map mapMsg cmd )



-- VIEW


view : Model -> Browser.Document Msg
view mainModel =
    let
        content : Html.Html Msg
        content =
            case mainModel of
                Redirect _ ->
                    Html.div [] [ Html.text "Redirecting..." ]

                Home homeModel ->
                    Html.map GotHomeMsg <| Home.view homeModel

                Suggestions suggestionModel ->
                    Html.map GotSuggestionMsg <| Suggestions.view suggestionModel

                Offer offerModel ->
                    Html.map GotOfferMsg <| Offer.view offerModel

                User userModel ->
                    Html.map GotUserMsg <| User.view userModel

                Login loginModel ->
                    Html.map GotLoginMsg <| Login.view loginModel

        body =
            List.map (Html.map GotFromAppLayout) (AppLayout.view (AppLayout.init (toViewer mainModel)) content)
    in
    { title = "Title"
    , body = body
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        updateLang : JE.Value -> Msg
        updateLang raw =
            let
                language =
                    case JD.decodeValue I18n.languageDecoder raw of
                        Ok lang ->
                            lang

                        _ ->
                            I18n.Eng
            in
            LanguageChanged language
    in
    Sub.batch
        [ Sub.map GotHomeMsg (Ports.receiveSearchFormFromStorage Home.GotFormFromStorage)
        , Ports.languageChanged updateLang

        -- , Ports.tokenChanged GotToken
        ]



-- MAIN


init : JE.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        language : I18n.Language
        language =
            case JD.decodeValue (JD.field "language" I18n.languageDecoder) flags of
                Ok lang ->
                    lang

                Err err ->
                    let
                        _ =
                            Debug.log "Falling back to Eng. Failed to decode language" err
                    in
                    I18n.Eng

        viewer : Viewer
        viewer =
            Viewer.Anon { navKey = key, timeZone = Time.utc, language = language }

        ( model, cmd ) =
            changeModelTo (Route.fromUrl url) <| Redirect viewer
    in
    ( model
    , Cmd.batch
        [ Task.perform GotHereZone Time.here
        , cmd
        ]
    )


main : Program JE.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
