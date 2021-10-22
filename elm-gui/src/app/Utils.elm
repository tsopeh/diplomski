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


posixToDate : Time.Zone -> Time.Posix -> String
posixToDate zone posix =
    DateFormat.format "dd. MM. yyyy." zone posix


toJSMonth : Time.Zone -> Time.Posix -> number
toJSMonth zone posix =
    case Time.toMonth zone posix of
        Time.Jan ->
            0

        Time.Feb ->
            1

        Time.Mar ->
            2

        Time.Apr ->
            3

        Time.May ->
            4

        Time.Jun ->
            5

        Time.Jul ->
            6

        Time.Aug ->
            7

        Time.Sep ->
            8

        Time.Oct ->
            9

        Time.Nov ->
            10

        Time.Dec ->
            11


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


emptyHtml : Html msg
emptyHtml =
    Html.text ""


viewIf : Bool -> Html msg -> Html msg
viewIf shouldRender html =
    case shouldRender of
        True ->
            html

        False ->
            emptyHtml


viewListIf : Bool -> List (Html msg) -> List (Html msg)
viewListIf shouldRender htmlList =
    case shouldRender of
        True ->
            htmlList

        False ->
            []
