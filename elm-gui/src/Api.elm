module Api exposing (..)

import Browser.Navigation as Nav
import Http exposing (Header)
import Json.Decode as Decode exposing (Decoder)


type Viewer
    = Anon Nav.Key
    | Admin Nav.Key Token


type Token
    = String Token


createRequestHeaders : Viewer -> List Header
createRequestHeaders model =
    []


handleJsonResponse : Decoder a -> Http.Response String -> Result Http.Error a
handleJsonResponse decoder response =
    case response of
        Http.BadUrl_ url ->
            Err (Http.BadUrl url)

        Http.Timeout_ ->
            Err Http.Timeout

        Http.BadStatus_ { statusCode } _ ->
            Err (Http.BadStatus statusCode)

        Http.NetworkError_ ->
            Err Http.NetworkError

        Http.GoodStatus_ _ body ->
            case Decode.decodeString decoder body of
                Err _ ->
                    Err (Http.BadBody body)

                Ok result ->
                    Ok result
