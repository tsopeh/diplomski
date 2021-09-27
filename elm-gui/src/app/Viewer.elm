module Viewer exposing (..)

import Browser.Navigation as Nav
import I18n
import Time


type alias CommonState =
    { navKey : Nav.Key
    , timeZone : Time.Zone
    , language : I18n.Language
    }


type Viewer
    = Anon CommonState
    | Admin CommonState Token


toZone : Viewer -> Time.Zone
toZone viewer =
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


toNavKey : Viewer -> Nav.Key
toNavKey viewer =
    case viewer of
        Anon state ->
            state.navKey

        Admin state _ ->
            state.navKey


toLanguage : Viewer -> I18n.Language
toLanguage viewer =
    case viewer of
        Anon state ->
            state.language

        Admin state _ ->
            state.language


updateLanguage : Viewer -> I18n.Language -> Viewer
updateLanguage viewer language =
    case viewer of
        Anon state ->
            Anon { state | language = language }

        Admin state token ->
            Admin { state | language = language } token


toI18n : Viewer -> I18n.TransFn
toI18n viewer =
    I18n.translate <| toLanguage viewer


type Token
    = Token String
