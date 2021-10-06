module Location exposing (Location, LocationId, decoder, getAllLocations, getLocation, idToString, stringToId)

import Api exposing (handleJsonResponse)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Task exposing (Task)
import Viewer


type LocationId
    = LocationId String


stringToId =
    LocationId


idToString : LocationId -> String
idToString (LocationId str) =
    str


type alias Location =
    { id : LocationId
    , name : String
    }


getAllLocations : Viewer.Model -> Task Http.Error (List Location)
getAllLocations viewer =
    Http.task
        { method = "GET"
        , url = Api.getApiUrl [ "locations" ] []
        , headers = Api.createRequestHeaders (Viewer.toToken viewer)
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            Http.stringResolver <|
                handleJsonResponse <|
                    JD.list decoder
        }


getLocation : Viewer.Model -> LocationId -> Task Http.Error Location
getLocation viewer id =
    Http.task
        { method = "GET"
        , url = Api.getApiUrl [ "locations", idToString id ] []
        , headers = Api.createRequestHeaders (Viewer.toToken viewer)
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = Http.stringResolver <| handleJsonResponse <| decoder
        }


decoder : JD.Decoder Location
decoder =
    JD.succeed Location
        |> JDP.required "id" (JD.string |> JD.map LocationId)
        |> JDP.required "name" JD.string
