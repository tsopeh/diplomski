module User exposing (..)

import Api exposing (Token)
import Http
import Image
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Json.Encode as JE
import Task exposing (Task)
import Time
import Viewer


type alias Model =
    { id : UserId
    , firstName : String
    , lastName : String
    , avatar : Image.Avatar
    , wasDriverCount : Int
    , wasPassengerCount : Int
    , memberFromDateTime : Time.Posix
    }


type UserId
    = UserId String


idToString : UserId -> String
idToString (UserId str) =
    str


stringToId : String -> UserId
stringToId =
    UserId


type Gender
    = Male
    | Female
    | Other


genderToString : Gender -> String
genderToString gender =
    case gender of
        Male ->
            "male"

        Female ->
            "female"

        Other ->
            "other"


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


getUser : Viewer.Model -> UserId -> Task Http.Error Model
getUser viewer id =
    Http.task
        { method = "GET"
        , url = Api.getApiUrl [ "user", idToString id ] []
        , headers = Api.createRequestHeaders (Viewer.toToken viewer)
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = Http.stringResolver <| Api.handleJsonResponse <| decoder
        }


login : { email : String, password : String } -> Task Http.Error Token
login { email, password } =
    let
        body : Http.Body
        body =
            Http.jsonBody <|
                JE.object
                    [ ( "email", JE.string email )
                    , ( "password", JE.string password )
                    ]
    in
    Http.task
        { method = "POST"
        , url = Api.getApiUrl [ "user", "login" ] []
        , headers = []
        , body = body
        , timeout = Nothing
        , resolver =
            Http.stringResolver <|
                Api.handleJsonResponse <|
                    JD.field "token" Api.decodeToken
        }


type alias RegisterUser =
    { firstName : String
    , lastName : String
    , gender : Maybe Gender
    , dateOfBirth :
        { day : Maybe Int
        , month : Maybe Int
        , year : Maybe Int
        }
    , phone : String
    , email : String
    , password : String
    }


dateOfBirthToIsoString : { day : Maybe Int, month : Maybe Int, year : Maybe Int } -> String
dateOfBirthToIsoString maybeDate =
    let
        day =
            maybeDate.day |> Maybe.withDefault 1

        month =
            maybeDate.day |> Maybe.withDefault 0

        year =
            maybeDate.year |> Maybe.withDefault 1900

        posix =
            Time.millisToPosix 0
    in
    Iso8601.fromTime posix


register : RegisterUser -> Task Http.Error Token
register registerUser =
    let
        body : Http.Body
        body =
            Http.jsonBody <|
                JE.object
                    [ ( "email", JE.string registerUser.email )
                    , ( "password", JE.string registerUser.password )
                    , ( "firstName", JE.string registerUser.firstName )
                    , ( "lastName", JE.string registerUser.lastName )
                    , ( "gender", JE.string <| genderToString (Maybe.withDefault Other registerUser.gender) )
                    , ( "phone", JE.string registerUser.phone )
                    , ( "dateOfBirth", JE.string (dateOfBirthToIsoString registerUser.dateOfBirth) )
                    ]
    in
    Http.task
        { method = "POST"
        , url = Api.getApiUrl [ "user", "register" ] []
        , headers = []
        , body = body
        , timeout = Nothing
        , resolver =
            Http.stringResolver <|
                Api.handleJsonResponse <|
                    JD.field "token" Api.decodeToken
        }
