module Utils exposing (..)

import DateFormat
import Html exposing (Html)
import Process
import Task
import Time


posixToIsoDate : Time.Zone -> Time.Posix -> String
posixToIsoDate zone posix =
    -- The format is "yyyy-MM-dd".
    DateFormat.format "yyyy-MM-dd" zone posix


posixToHoursMinutes : Time.Zone -> Time.Posix -> String
posixToHoursMinutes zone posix =
    DateFormat.format "hh:mm" zone posix


posixToIsoDateTime : Time.Zone -> Time.Posix -> String
posixToIsoDateTime zone posix =
    -- The format is "yyyy-MM-ddThh:mm" followed by optional ":ss" or ":ss.SSS".
    DateFormat.format "yyyy-MM-ddThh:mm:ss" zone posix


type Status a
    = Loading
    | Loaded a
    | Failed


delayMsg : Int -> msg -> Cmd msg
delayMsg time msg =
    Process.sleep (toFloat time)
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


find : (a -> comparable) -> comparable -> List a -> Maybe a
find get x list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            case get first == x of
                True ->
                    Just first

                _ ->
                    find get x rest


viewIf : Bool -> Html msg -> Html msg
viewIf shouldRender html =
    case shouldRender of
        True ->
            html

        False ->
            Html.text ""


viewListIf : Bool -> List (Html msg) -> List (Html msg)
viewListIf shouldRender htmlList =
    case shouldRender of
        True ->
            htmlList

        False ->
            []
