module Page.Schedule exposing (..)

import Html exposing (Html, div, table, tbody, td, text, th, tr)
import Html.Attributes exposing (class)
import Http
import I18n
import Schedule exposing (ScheduleFull, ScheduleId, getFullSchedule)
import Task
import Utils exposing (Status(..), posixToHoursMinutes)
import Viewer exposing (Viewer)



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
        t =
            Viewer.toI18n model.viewer

        scheduleHtml : List (Html Msg)
        scheduleHtml =
            case model.schedule of
                Loading ->
                    [ text <| t I18n.LoadingSchedule ]

                Loaded schedule ->
                    [ div [ class "train" ]
                        [ text <|
                            t I18n.Schedule_Train
                                ++ schedule.train.trainNumber
                                ++ " "
                                ++ String.fromFloat schedule.ticketStartingPrice
                                ++ " "
                                ++ "RSD"
                        ]
                    , table [ class "stations" ]
                        [ th [] [ text <| t I18n.StationName ]
                        , th [] [ text <| t I18n.TimeOfArrival ]
                        , th [] [ text <| t I18n.TimeOfDeparture ]
                        , tbody [] <|
                            List.map
                                (\entry ->
                                    tr []
                                        [ td [ class "name" ]
                                            [ text entry.station.name ]
                                        , td [ class "dateTime" ]
                                            [ text <|
                                                posixToHoursMinutes
                                                    (Viewer.toZone model.viewer)
                                                    entry.arrivalDateTime
                                            ]
                                        , td [ class "dateTime" ]
                                            [ text <|
                                                posixToHoursMinutes
                                                    (Viewer.toZone model.viewer)
                                                    entry.departureDateTime
                                            ]
                                        ]
                                )
                                schedule.timeTable
                        ]
                    ]

                Failed ->
                    [ text <| t I18n.FailedToLoadStations ]
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
