module State exposing (..)

import Browser.Navigation as Nav
import I18n
import Time
import Viewer


type alias Model =
    { viewer : Viewer.Model
    , navKey : Nav.Key
    , timeZone : Time.Zone
    , language : I18n.Language
    }


toI18n : Model -> I18n.TransFn
toI18n model =
    I18n.translate <| model.language
