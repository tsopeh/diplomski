module Utils exposing (..)

import DateFormat
import Process
import Task
import Time


posixToIsoDate : Time.Zone -> Time.Posix -> String
posixToIsoDate zone posix =
    -- The format is "yyyy-MM-ddThh:mm" followed by optional ":ss" or ":ss.SSS".
    DateFormat.format "yyyy-MM-ddThh:mm:ss" zone posix


type Status a
    = Loading
    | Loaded a
    | Failed


delay : Int -> msg -> Cmd msg
delay time msg =
    Process.sleep (toFloat time)
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
