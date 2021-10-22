module Offer exposing (..)

import Api exposing (handleJsonResponse)
import Http
import Image
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Suggestion exposing (SuggestionId)
import Task exposing (Task)
import Time
import Vehicle
import Viewer


type alias Model =
    { id : SuggestionId
    , startLocationName : String
    , finishLocationName : String
    , departureDateTime : Time.Posix
    , arrivalDateTime : Time.Posix
    , duration : String
    , price : String
    , driver : Driver
    , vehicle : Vehicle.Model
    , numberOfSeats : Int
    , passengers : List Passenger
    , smokingAllowed : Bool
    , petsAllowed : Bool
    , childrenAllowed : Bool
    }


type alias Driver =
    { id : String
    , firstName : String
    , lastName : String
    , avatar : Image.Avatar
    , phone : String
    }


type alias Passenger =
    { id : String
    , firstName : String
    , avatar : Image.Avatar
    , contact : Maybe String
    }


hasFreeSeats : Model -> Bool
hasFreeSeats model =
    (model.numberOfSeats - List.length model.passengers) > 0


decoder : JD.Decoder Model
decoder =
    JD.succeed Model
        |> JDP.required "id" (JD.string |> JD.map Suggestion.SuggestionId)
        |> JDP.required "startLocationName" JD.string
        |> JDP.required "finishLocationName" JD.string
        |> JDP.required "departureDate" Iso8601.decoder
        |> JDP.required "arrivalDate" Iso8601.decoder
        |> JDP.required "duration" JD.string
        |> JDP.required "price" JD.string
        |> JDP.required "driver" driverDecoder
        |> JDP.required "vehicle" Vehicle.decoder
        |> JDP.required "numberOfSeats" JD.int
        |> JDP.required "passengers" (JD.list passengerDecoder)
        |> JDP.required "smokingAllowed" JD.bool
        |> JDP.required "petsAllowed" JD.bool
        |> JDP.required "childrenAllowed" JD.bool


passengerDecoder : JD.Decoder Passenger
passengerDecoder =
    JD.succeed Passenger
        |> JDP.required "id" JD.string
        |> JDP.required "firstName" JD.string
        |> JDP.required "avatar" Image.decoder
        |> JDP.optional "contact" (JD.maybe JD.string) Nothing


driverDecoder : JD.Decoder Driver
driverDecoder =
    JD.succeed Driver
        |> JDP.required "id" JD.string
        |> JDP.required "firstName" JD.string
        |> JDP.required "lastName" JD.string
        |> JDP.required "avatar" Image.decoder
        |> JDP.required "phone" JD.string


getOffer : Viewer.Model -> SuggestionId -> Task Http.Error Model
getOffer viewer id =
    Http.task
        { method = "GET"
        , url = Api.getApiUrl [ "rides", "offer", Suggestion.idToString id ] []
        , headers = Api.createRequestHeaders (Viewer.toToken viewer)
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = Http.stringResolver <| handleJsonResponse <| decoder
        }


postToggleOffer : Viewer.Model -> SuggestionId -> Task Http.Error Model
postToggleOffer viewer id =
    Http.task
        { method = "POST"
        , url = Api.getApiUrl [ "rides", "offer", Suggestion.idToString id ] []
        , headers = Api.createRequestHeaders (Viewer.toToken viewer)
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = Http.stringResolver <| handleJsonResponse <| decoder
        }
