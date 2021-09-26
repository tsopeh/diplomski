module Schedule exposing (ScheduleBrief, ScheduleFull, ScheduleId, getBriefSchedules, getFullSchedule, idToString, stringToId)

import Api exposing (Viewer)
import Http
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Station exposing (Station)
import Task exposing (Task)
import Time
import Train


type ScheduleId
    = ScheduleId String


stringToId : String -> ScheduleId
stringToId =
    ScheduleId


idToString : ScheduleId -> String
idToString (ScheduleId str) =
    str


type alias ScheduleFull =
    { id : ScheduleId
    , train : Train.Model
    , latency : Int
    , ticketStartingPrice : Float
    , timeTable : List ScheduleFullStation
    }


scheduleFullDecoder : JD.Decoder ScheduleFull
scheduleFullDecoder =
    JD.succeed ScheduleFull
        |> JDP.required "id" (JD.string |> JD.map ScheduleId)
        |> JDP.required "train" Train.decoder
        |> JDP.required "latency" JD.int
        |> JDP.required "ticketStartingPrice" JD.float
        |> JDP.required "stations" (JD.list scheduleFullStationDecoder)


type alias ScheduleFullStation =
    { station : Station
    , arrivalDateTime : Time.Posix
    , departureDateTime : Time.Posix
    }


type alias StationDepartureArrivalDateTimeBE =
    { id : String, name : String, arrivalDateTime : String, departureDateTime : String }


scheduleFullStationDecoder : JD.Decoder ScheduleFullStation
scheduleFullStationDecoder =
    JD.succeed StationDepartureArrivalDateTimeBE
        |> JDP.required "id" JD.string
        |> JDP.required "name" JD.string
        |> JDP.required "arrivalDateTime" JD.string
        |> JDP.required "departureDateTime" JD.string
        |> JD.andThen
            (\fromBe ->
                case Iso8601.toTime fromBe.arrivalDateTime of
                    Ok arrivalPosix ->
                        case Iso8601.toTime fromBe.departureDateTime of
                            Ok departurePosix ->
                                JD.succeed
                                    { station =
                                        { id = Station.stringToId fromBe.id
                                        , name = fromBe.name
                                        }
                                    , arrivalDateTime = arrivalPosix
                                    , departureDateTime = departurePosix
                                    }

                            Err _ ->
                                JD.fail "Failed to decode 'departureDateTime'."

                    Err _ ->
                        JD.fail "Failed to decode 'arrivalDateTime'."
            )


type alias ScheduleBrief =
    { id : ScheduleId
    , train : Train.Model
    , latency : Int
    , ticketStartingPrice : Float
    , departure : StationDateTime
    , arrival : StationDateTime
    }


scheduleBriefDecoder : JD.Decoder ScheduleBrief
scheduleBriefDecoder =
    JD.succeed ScheduleBrief
        |> JDP.required "id" (JD.string |> JD.map ScheduleId)
        |> JDP.required "train" Train.decoder
        |> JDP.required "latency" JD.int
        |> JDP.required "ticketStartingPrice" JD.float
        |> JDP.required "departure" stationDateTimeDecoder
        |> JDP.required "arrival" stationDateTimeDecoder


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
                                { id = Station.stringToId id
                                , name = name
                                }
                            , dateTime = posixDate
                            }

                    Err _ ->
                        JD.fail "Failed to decode `StationDateTimeBE."
            )



-- HTTP


getBriefSchedules : Viewer -> Task Http.Error (List ScheduleBrief)
getBriefSchedules viewer =
    Http.task
        { method = "GET"
        , url = "http://localhost:8080/schedule"
        , body = Http.emptyBody
        , headers = Api.createRequestHeaders viewer
        , timeout = Nothing
        , resolver = Http.stringResolver <| Api.handleJsonResponse <| JD.list scheduleBriefDecoder
        }


getFullSchedule : Viewer -> ScheduleId -> Task Http.Error ScheduleFull
getFullSchedule viewer id =
    Http.task
        { method = "GET"
        , url = "http://localhost:8080/schedule/" ++ idToString id
        , body = Http.emptyBody
        , headers = Api.createRequestHeaders viewer
        , timeout = Nothing
        , resolver = Http.stringResolver <| Api.handleJsonResponse <| scheduleFullDecoder
        }
