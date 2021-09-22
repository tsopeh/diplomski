module Page.Schedule exposing (..)

import Api exposing (Viewer, toZone)
import Html exposing (Html, div, table, tbody, td, text, th, tr)
import Html.Attributes exposing (class)
import Http
import Schedule exposing (ScheduleFull, ScheduleId, getFullSchedule)
import Task
import Utils exposing (Status(..), posixToHoursMinutes)



-- MODEL


type alias Model =
    { viewer : Viewer
    , schedule : Status ScheduleFull
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = GotSchedule (Result Http.Error ScheduleFull)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSchedule (Ok schedule) ->
            ( { model | schedule = Loaded schedule }, Cmd.none )

        GotSchedule (Err e) ->
            let
                _ =
                    Debug.log "Failed to load full schedule" e
            in
            ( { model | schedule = Failed }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        scheduleHtml : List (Html Msg)
        scheduleHtml =
            case model.schedule of
                Loading ->
                    [ text "Loading schedule..." ]

                Loaded schedule ->
                    [ div [ class "train" ]
                        [ text <|
                            "Train: "
                                ++ schedule.train.trainNumber
                                ++ " "
                                ++ String.fromFloat schedule.ticketStartingPrice
                                ++ " "
                                ++ "RSD"
                        ]
                    , table [ class "stations" ]
                        [ th [] [ text "Station" ]
                        , th [] [ text "Arrival" ]
                        , th [] [ text "Departure" ]
                        , tbody [] <|
                            List.map
                                (\entry ->
                                    tr []
                                        [ td [ class "name" ] [ text entry.station.name ]
                                        , td [ class "dateTime" ] [ text <| posixToHoursMinutes (toZone model.viewer) entry.arrivalDateTime ]
                                        , td [ class "dateTime" ] [ text <| posixToHoursMinutes (toZone model.viewer) entry.departureDateTime ]
                                        ]
                                )
                                schedule.timeTable
                        ]
                    ]

                Failed ->
                    [ text "Failed to load schedule." ]
    in
    div [ class "schedule-page" ] scheduleHtml



-- INIT


init : Viewer -> ScheduleId -> ( Model, Cmd Msg )
init viewer id =
    ( { viewer = viewer
      , schedule = Loading
      }
    , Task.attempt GotSchedule (getFullSchedule viewer id)
    )
