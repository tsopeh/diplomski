port module Ports exposing (..)

import Json.Encode as JE



-- TOKEN


port persistToken : String -> Cmd msg


port tokenChanged : (String -> msg) -> Sub msg



-- SEARCH PAGE


port persistSearchForm : JE.Value -> Cmd msg


port requestSearchFormFromStorage : () -> Cmd msg


port receiveSearchFormFromStorage : (JE.Value -> msg) -> Sub msg
