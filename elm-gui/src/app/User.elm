module User exposing (..)

import Api
import Http
import Image
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Task exposing (Task)
import Time
import Viewer exposing (Viewer)


type UserId
    = UserId String


idToString : UserId -> String
idToString (UserId str) =
    str


stringToId : String -> UserId
stringToId =
    UserId


type alias Model =
    { id : UserId
    , firstName : String
    , lastName : String
    , avatar : Image.Avatar
    , wasDriverCount : Int
    , wasPassengerCount : Int
    , memberFromDateTime : Time.Posix
    }


decoder : JD.Decoder Model
decoder =
    JD.succeed Model
        |> JDP.required "id" (JD.string |> JD.map UserId)
        |> JDP.required "firstName" JD.string
        |> JDP.required "lastName" JD.string
        |> JDP.required "avatar" Image.decoder
        |> JDP.required "wasDriverCount" JD.int
        |> JDP.required "wasPassengerCount" JD.int
        |> JDP.required "memberFromDate" Iso8601.decoder


getUser : Viewer -> UserId -> Task Http.Error Model
getUser viewer id =
    Http.task
        { method = "GET"
        , url = Api.getApiUrl [ "user", idToString id ] []
        , headers = Api.createRequestHeaders viewer
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = Http.stringResolver <| Api.handleJsonResponse <| decoder
        }
