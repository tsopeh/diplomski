port module Api exposing (Token, createRequestHeaders, decodeToken, getApiUrl, handleJsonResponse, logout, persistToken, tokenChanged, tokenToString)

import Http exposing (Header)
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE
import Url.Builder exposing (QueryParameter)


type Token
    = Token String


tokenToString : Token -> String
tokenToString (Token str) =
    str


decodeToken : JD.Decoder Token
decodeToken =
    JD.string |> JD.map Token


getApiUrl : List String -> List QueryParameter -> String
getApiUrl path queryParams =
    "http://localhost:8080" ++ Url.Builder.absolute path queryParams


createRequestHeaders : Maybe Token -> List Header
createRequestHeaders maybeToken =
    case maybeToken of
        Just (Token token) ->
            [ Http.header "authorization" ("Bearer " ++ token) ]

        Nothing ->
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
            case JD.decodeString decoder body of
                Err _ ->
                    Err (Http.BadBody body)

                Ok result ->
                    Ok result



-- PORTS


port persistToken : Maybe String -> Cmd msg


port tokenChanged : (JE.Value -> msg) -> Sub msg


logout : Cmd msg
logout =
    persistToken Nothing
