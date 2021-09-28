module Api exposing (..)

import Http exposing (Header)
import Json.Decode as Decode exposing (Decoder)
import Url.Builder exposing (QueryParameter)
import Viewer exposing (Viewer)


getApiUrl : List String -> List QueryParameter -> String
getApiUrl path queryParams =
    "http://localhost:8080" ++ Url.Builder.absolute path queryParams


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
