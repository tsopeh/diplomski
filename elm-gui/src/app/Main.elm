module Main exposing (..)

import Api exposing (Token, Viewer(..))
import AppLayout
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Page.Home as Home
import Page.Schedule as Schedule
import Page.SearchResults as SearchResults
import Ports
import Route as Route exposing (Route)
import Task
import Time
import Url



-- MODEL


type Model
    = Redirect Viewer
    | Home Home.Model
    | SearchResults SearchResults.Model
    | Schedule Schedule.Model


toViewer : Model -> Viewer
toViewer mainModel =
    case mainModel of
        Redirect viewer ->
            viewer

        Home model ->
            Home.toViewer model

        SearchResults model ->
            SearchResults.toViewer model

        Schedule model ->
            Schedule.toViewer model


updateViewer : Model -> Viewer -> Model
updateViewer mainModel viewer =
    case mainModel of
        Redirect _ ->
            Redirect viewer

        Home model ->
            Home <| Home.updateViewer model viewer

        SearchResults model ->
            SearchResults <| SearchResults.updateViewer model viewer

        Schedule model ->
            Schedule <| Schedule.updateViewer model viewer



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotToken String
    | GotHereZone Time.Zone
    | GotFromAppLayout (AppLayout.Msg Msg)
    | GotHomeMsg Home.Msg
    | GotSearchResultsMsg SearchResults.Msg
    | GotScheduleMsg Schedule.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update mainMsg mainModel =
    case ( mainMsg, mainModel ) of
        ( UrlRequested urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    let
                        key =
                            Api.toNavKey <| toViewer mainModel
                    in
                    ( mainModel, Nav.pushUrl key (Url.toString url) )

                External url ->
                    ( mainModel, Nav.load url )

        ( UrlChanged url, _ ) ->
            changeModelTo (Route.fromUrl url) mainModel

        ( GotHereZone zone, _ ) ->
            let
                viewer =
                    toViewer mainModel

                updated =
                    updateViewer mainModel <| Api.updateZone viewer zone
            in
            ( updated, Cmd.none )

        ( GotFromAppLayout (AppLayout.GotFromContent contentMsg), _ ) ->
            update contentMsg mainModel

        ( GotHomeMsg msg, Home model ) ->
            let
                ( updatedModel, cmd ) =
                    Home.update msg model
            in
            ( Home updatedModel, Cmd.map GotHomeMsg cmd )

        ( GotSearchResultsMsg msg, SearchResults model ) ->
            let
                ( updatedModel, cmd ) =
                    SearchResults.update msg model
            in
            ( SearchResults updatedModel, Cmd.map GotSearchResultsMsg cmd )

        ( GotScheduleMsg msg, Schedule model ) ->
            let
                ( updatedModel, cmd ) =
                    Schedule.update msg model
            in
            ( Schedule updatedModel, Cmd.map GotScheduleMsg cmd )

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

        Just (Route.SearchResults depId arrId depDateTime) ->
            mapInit SearchResults GotSearchResultsMsg <| SearchResults.init viewer depId arrId (Time.millisToPosix depDateTime)

        Just (Route.Schedule scheduleId) ->
            mapInit Schedule GotScheduleMsg <| Schedule.init viewer scheduleId


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

                SearchResults model ->
                    Html.map GotSearchResultsMsg <| SearchResults.view model

                Schedule model ->
                    Html.map GotScheduleMsg <| Schedule.view model

        body =
            List.map (Html.map GotFromAppLayout) (AppLayout.view content)
    in
    { title = "Title"
    , body = body
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.tokenChanged GotToken
        , Sub.map GotHomeMsg (Ports.receiveSearchFormFromStorage Home.GotFormFromStorage)
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
