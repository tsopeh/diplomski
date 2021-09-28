module Suggestion exposing (..)

import Api
import Http
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Location exposing (LocationId)
import Task exposing (Task)
import Time
import Vehicle
import Viewer exposing (Viewer)


type SuggestionId
    = SuggestionId String


stringToId : String -> SuggestionId
stringToId str =
    SuggestionId str


idToString : SuggestionId -> String
idToString (SuggestionId id) =
    id


type alias Model =
    { id : SuggestionId
    , startLocationName : String
    , finishLocationName : String
    , departureDateTime : Time.Posix
    , arrivalDateTime : Time.Posix
    , duration : String
    , driverName : String
    , driverAvatar : String
    , vehicle : Vehicle.Model
    , price : String
    , numberOfSeats : Int
    , numberOfFreeSeats : Int
    , smokingAllowed : Bool
    , petsAllowed : Bool
    , childrenAllowed : Bool
    }


decoder : JD.Decoder Model
decoder =
    JD.succeed Model
        |> JDP.required "id" (JD.string |> JD.map SuggestionId)
        |> JDP.required "startLocationName" JD.string
        |> JDP.required "finishLocationName" JD.string
        |> JDP.required "departureDate" Iso8601.decoder
        |> JDP.required "arrivalDate" Iso8601.decoder
        |> JDP.required "duration" JD.string
        |> JDP.required "driverName" JD.string
        |> JDP.required "driverAvatar" JD.string
        |> JDP.required "vehicle" Vehicle.decoder
        |> JDP.required "price" JD.string
        |> JDP.required "numberOfSeats" JD.int
        |> JDP.required "numberOfFreeSeats" JD.int
        |> JDP.required "smokingAllowed" JD.bool
        |> JDP.required "petsAllowed" JD.bool
        |> JDP.required "childrenAllowed" JD.bool


type alias GetSuggestionsParams =
    { startStation : LocationId
    , finishStationId : LocationId
    , departureDateTime : Time.Posix
    }


getSuggestions : Viewer -> GetSuggestionsParams -> Task Http.Error (List Model)
getSuggestions viewer { startStation, finishStationId, departureDateTime } =
    Http.task
        { method = "GET"
        , url =
            Api.getApiUrl
                [ "rides"
                , "suggestions"
                , Location.idToString startStation
                , Location.idToString finishStationId
                , Iso8601.fromTime departureDateTime
                ]
                []
        , body = Http.emptyBody
        , headers = Api.createRequestHeaders viewer
        , timeout = Nothing
        , resolver = Http.stringResolver <| Api.handleJsonResponse <| JD.list decoder
        }
