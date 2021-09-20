module Page.Results exposing (..)

import Api exposing (Viewer)
import Html exposing (Html, div, text)
import Http
import Schedule exposing (ScheduleBrief)
import Task
import Utils exposing (Status(..))



-- MODEL


type alias Model =
    { viewer : Viewer
    , schedules : Status (List ScheduleBrief)
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = GotSchedules (Result Http.Error (List ScheduleBrief))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSchedules (Ok newSchedules) ->
            ( { model | schedules = Loaded newSchedules }, Cmd.none )

        GotSchedules (Err error) ->
            let
                e =
                    Debug.log "Error while loading schedules" error
            in
            ( { model | schedules = Failed }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        schedulesHtml : List (Html Msg)
        schedulesHtml =
            case model.schedules of
                Loading ->
                    [ text "Loading schedules..." ]

                Loaded schedules ->
                    [ text "Loaded schedules!" ]

                Failed ->
                    [ text "Failed to load schedules." ]
    in
    div [] schedulesHtml



-- INIT


init : Viewer -> ( Model, Cmd Msg )
init viewer =
    ( Model viewer Loading, Task.attempt GotSchedules (Schedule.getSchedules viewer) )
