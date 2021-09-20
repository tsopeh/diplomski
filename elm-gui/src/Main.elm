module Main exposing (..)

import Api exposing (Token, Viewer(..))
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Page
import Page.Results as Result
import Page.Search as Search
import Ports
import Route as Route exposing (Route)
import Task
import Time
import Url



-- MODEL


type Model
    = Redirect Viewer
    | Search Search.Model
    | Result Result.Model


toViewer : Model -> Viewer
toViewer model =
    case model of
        Redirect viewer ->
            viewer

        Search searchModel ->
            Search.toViewer searchModel

        Result resultModel ->
            Result.toViewer resultModel


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    case model of
        Redirect _ ->
            Redirect viewer

        Search searchModel ->
            Search <| Search.updateViewer searchModel viewer

        Result resultModel ->
            Result <| Result.updateViewer resultModel viewer



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotToken String
    | GotHereZone Time.Zone
    | GotFromPage (Page.Msg Msg)
    | GotSearchMsg Search.Msg
    | GotResultMsg Result.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( UrlRequested urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    let
                        key =
                            Api.toNavKey <| toViewer model
                    in
                    ( model, Nav.pushUrl key (Url.toString url) )

                External url ->
                    ( model, Nav.load url )

        ( UrlChanged url, _ ) ->
            changeModelTo (Route.fromUrl url) model

        ( GotHereZone zone, _ ) ->
            let
                viewer =
                    toViewer model

                updated =
                    updateViewer model <| Api.updateZone viewer zone
            in
            ( updated, Cmd.none )

        ( GotFromPage (Page.GotFromContent contentMsg), _ ) ->
            update contentMsg model

        ( GotSearchMsg searchMsg, Search searchModel ) ->
            let
                ( updatedModel, cmd ) =
                    Search.update searchMsg searchModel
            in
            ( Search updatedModel, Cmd.map GotSearchMsg cmd )

        ( GotResultMsg resultMsg, Result resultModel ) ->
            let
                ( updatedModel, cmd ) =
                    Result.update resultMsg resultModel
            in
            ( Result updatedModel, Cmd.map GotResultMsg cmd )

        ( _, _ ) ->
            let
                _ =
                    Debug.log "Impossible state" ( msg, model )
            in
            ( model, Cmd.none )


changeModelTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeModelTo maybeRoute model =
    let
        viewer =
            toViewer model
    in
    case maybeRoute of
        Nothing ->
            mapInit Search GotSearchMsg <| Search.init viewer

        Just Route.Search ->
            mapInit Search GotSearchMsg <| Search.init viewer

        Just (Route.Result _ _ _) ->
            mapInit Result GotResultMsg <| Result.init viewer


mapInit : (subModel -> Model) -> (msg -> Msg) -> ( subModel, Cmd msg ) -> ( Model, Cmd Msg )
mapInit mapModel mapMsg ( subModel, cmd ) =
    ( mapModel subModel, Cmd.map mapMsg cmd )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        content : Html.Html Msg
        content =
            case model of
                Redirect _ ->
                    Html.div [] [ Html.text "Redirecting..." ]

                Search searchModel ->
                    Html.map GotSearchMsg <| Search.view searchModel

                Result resultModel ->
                    Html.map GotResultMsg <| Result.view resultModel

        body =
            List.map (Html.map GotFromPage) (Page.view content)
    in
    { title = "Title"
    , body = body
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.tokenChanged GotToken
        , Sub.map GotSearchMsg (Ports.receiveSearchFormFromStorage Search.GotFormFromStorage)
        ]



-- MAIN


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        viewer : Viewer
        viewer =
            Anon { navKey = key, timeZone = Time.utc }

        ( model, cmd ) =
            changeModelTo (Route.fromUrl url) <| Redirect viewer
    in
    ( model
    , Cmd.batch
        [ Task.perform GotHereZone Time.here
        , cmd
        ]
    )


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
