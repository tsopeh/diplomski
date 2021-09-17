port module Ports exposing (..)

import Json.Encode as JE


type alias Flags =
    JE.Value


port persistSearchForm : JE.Value -> Cmd msg


port persistToken : String -> Cmd msg


port tokenChanged : (String -> msg) -> Sub msg
