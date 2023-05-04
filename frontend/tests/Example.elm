module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Time
import Utils


suite : Test
suite =
    test "Posix to date" <|
        \_ ->
            Time.millisToPosix 834876000000
                |> Utils.posixToDate Time.utc
                |> Expect.equal "15. 06. 1996."
