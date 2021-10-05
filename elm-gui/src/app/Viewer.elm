module Viewer exposing (Token, Viewer(..), decodeToken, toI18n, toLanguage, toNavKey, toZone, tokenToString, updateLanguage, updateZone)

import Browser.Navigation as Nav
import I18n
import Json.Decode as JD
import Time


type alias State =
    { navKey : Nav.Key
    , timeZone : Time.Zone
    , language : I18n.Language
    }


type Viewer
    = Anon State
    | LoggedIn State Token


type Token
    = Token String


tokenToString : Token -> String
tokenToString (Token str) =
    str


decodeToken : JD.Decoder Token
decodeToken =
    JD.string |> JD.map Token


toZone : Viewer -> Time.Zone
toZone viewer =
    case viewer of
        Anon state ->
            state.timeZone

        LoggedIn state _ ->
            state.timeZone


updateZone : Viewer -> Time.Zone -> Viewer
updateZone viewer zone =
    case viewer of
        Anon state ->
            Anon { state | timeZone = zone }

        LoggedIn state token ->
            LoggedIn { state | timeZone = zone } token


toNavKey : Viewer -> Nav.Key
toNavKey viewer =
    case viewer of
        Anon state ->
            state.navKey

        LoggedIn state _ ->
            state.navKey


toLanguage : Viewer -> I18n.Language
toLanguage viewer =
    case viewer of
        Anon state ->
            state.language

        LoggedIn state _ ->
            state.language


updateLanguage : Viewer -> I18n.Language -> Viewer
updateLanguage viewer language =
    case viewer of
        Anon state ->
            Anon { state | language = language }

        LoggedIn state token ->
            LoggedIn { state | language = language } token


toI18n : Viewer -> I18n.TransFn
toI18n viewer =
    I18n.translate <| toLanguage viewer
