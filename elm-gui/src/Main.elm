module Main exposing (..)

import Api exposing (Token, Viewer(..))
import Browser
import Browser.Navigation as Nav
import Html
import Page
import Page.Search as Search
import Ports exposing (Flags)
import Task
import Time
import Url



-- MODEL


type Model
    = Search Search.Model


toViewer : Model -> Viewer
toViewer model =
    case model of
        Search searchModel ->
            Search.toViewer searchModel


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    case model of
        Search searchModel ->
            Search <| Search.updateViewer searchModel viewer



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotToken String
    | GotHereZone Time.Zone
    | GotFromPage (Page.Msg Msg)
    | GotSearchMsg Search.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
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

        ( _, _ ) ->
            let
                l =
                    Debug.log "Impossible state" ( msg, model )
            in
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        content =
            case model of
                Search searchModel ->
                    Html.map GotSearchMsg <| Search.view searchModel

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
        ]



-- MAIN


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        viewer : Viewer
        viewer =
            Anon { navKey = key, timeZone = Time.utc }

        ( searchModel, searchCmd ) =
            Search.init flags viewer
    in
    ( Search searchModel
    , Cmd.batch
        [ Task.perform GotHereZone Time.here
        , Cmd.map GotSearchMsg searchCmd
        ]
    )


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
