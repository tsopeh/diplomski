module Api exposing (..)

import Browser.Navigation as Nav
import Http exposing (Header)
import Json.Decode as Decode exposing (Decoder)
import Time


type alias CommonState =
    { navKey : Nav.Key
    , timeZone : Time.Zone
    }


type Viewer
    = Anon CommonState
    | Admin CommonState Token


viewerToZone : Viewer -> Time.Zone
viewerToZone viewer =
    case viewer of
        Anon state ->
            state.timeZone

        Admin state _ ->
            state.timeZone


updateZone : Viewer -> Time.Zone -> Viewer
updateZone viewer zone =
    case viewer of
        Anon state ->
            Anon { state | timeZone = zone }

        Admin state token ->
            Admin { state | timeZone = zone } token


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
