module Schedule exposing (..)

import Api exposing (Viewer)
import Http
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Station exposing (Station)
import Task exposing (Task)
import Time
import Train


type alias ScheduleFull =
    { id : String
    , train : Train.Model
    , latency : Int
    , ticketStartingPrice : Float
    , timeTable :
        List
            { station : Station
            , departureDateTime : Time.Posix
            , arrivalDateTime : Time.Posix
            }
    }


type alias ScheduleBrief =
    { id : String
    , train : Train.Model
    , latency : Int
    , ticketStartingPrice : Float
    , departure : StationDateTime
    , arrival : StationDateTime
    }


type ScheduleId
    = ScheduleId String


scheduleFullDecoder : JD.Decoder ScheduleFull
scheduleFullDecoder =
    Debug.todo "scheduleFullDecoder"


scheduleBriefDecoder : JD.Decoder ScheduleBrief
scheduleBriefDecoder =
    JD.succeed ScheduleBrief
        |> JDP.required "id" JD.string
        |> JDP.required "train" Train.decoder
        |> JDP.required "latency" JD.int
        |> JDP.required "ticketStartingPrice" JD.float
        |> JDP.required "departure" stationDateTimeDecoder
        |> JDP.required "arrival" stationDateTimeDecoder


getSchedules : Viewer -> Task Http.Error (List ScheduleBrief)
getSchedules viewer =
    Http.task
        { method = "GET"
        , url = "http://localhost:8080/schedule"
        , body = Http.emptyBody
        , headers = Api.createRequestHeaders viewer
        , timeout = Nothing
        , resolver = Http.stringResolver <| Api.handleJsonResponse <| JD.list scheduleBriefDecoder
        }



-- STATION DATE TIME


type alias StationDateTime =
    { station : Station, dateTime : Time.Posix }


type alias StationDateTimeBE =
    { id : String, name : String, dateTime : String }


stationDateTimeDecoder : JD.Decoder StationDateTime
stationDateTimeDecoder =
    JD.succeed StationDateTimeBE
        |> JDP.required "id" JD.string
        |> JDP.required "name" JD.string
        |> JDP.required "dateTime" JD.string
        |> JD.andThen
            (\{ id, name, dateTime } ->
                case Iso8601.toTime dateTime of
                    Ok posixDate ->
                        JD.succeed
                            { station =
                                { id = id
                                , name = name
                                }
                            , dateTime = posixDate
                            }

                    Err err ->
                        JD.fail "Failed to decode `StationDateTimeBE."
            )
