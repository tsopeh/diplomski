module Main exposing (..)

import AppLayout
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import I18n
import Json.Decode as JD
import Json.Encode as JE
import Page.Home as Home
import Page.Offer as Offer
import Page.Suggestions as Suggestions
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


toViewer : Model -> Viewer
toViewer mainModel =
    case mainModel of
        Redirect viewer ->
            viewer

        Home model ->
            Home.toViewer model

        Suggestions model ->
            Suggestions.toViewer model

        Offer model ->
            Offer.toViewer model


updateViewer : Model -> Viewer -> Model
updateViewer mainModel viewer =
    case mainModel of
        Redirect _ ->
            Redirect viewer

        Home model ->
            Home <| Home.updateViewer model viewer

        Suggestions model ->
            Suggestions <| Suggestions.updateViewer model viewer

        Offer model ->
            Offer <| Offer.updateViewer model viewer



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

                Home model ->
                    Html.map GotHomeMsg <| Home.view model

                Suggestions model ->
                    Html.map GotSuggestionMsg <| Suggestions.view model

                Offer model ->
                    Html.map GotOfferMsg <| Offer.view model

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
