module Station exposing (Station, StationId, decoder, getAllStations, getStation, idToString, stringToId)

import Api exposing (Viewer, createRequestHeaders, handleJsonResponse)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Task exposing (Task)


type StationId
    = StationId String


stringToId =
    StationId


idToString : StationId -> String
idToString (StationId str) =
    str


type alias Station =
    { id : StationId
    , name : String
    }


getAllStations : Viewer -> Task Http.Error (List Station)
getAllStations viewer =
    Http.task
        { method = "GET"
        , url = "http://localhost:8080/stations"
        , headers = createRequestHeaders viewer
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            Http.stringResolver <|
                handleJsonResponse <|
                    JD.list decoder
        }


getStation : Viewer -> StationId -> Task Http.Error Station
getStation viewer id =
    Http.task
        { method = "GET"
        , url = "http://localhost:8080/stations/" ++ idToString id
        , headers = createRequestHeaders viewer
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = Http.stringResolver <| handleJsonResponse <| decoder
        }


decoder : JD.Decoder Station
decoder =
    JD.succeed Station
        |> JDP.required "id" (JD.string |> JD.map StationId)
        |> JDP.required "name" JD.string
