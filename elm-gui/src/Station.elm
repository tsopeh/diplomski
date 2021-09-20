module Station exposing (..)

import Api exposing (Viewer, createRequestHeaders, handleJsonResponse)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Task exposing (Task)


type alias Station =
    { id : String
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


decoder : JD.Decoder Station
decoder =
    JD.succeed Station
        |> JDP.required "id" JD.string
        |> JDP.required "name" JD.string
