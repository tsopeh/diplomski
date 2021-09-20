module Train exposing (..)

import Json.Decode as JD
import Json.Decode.Pipeline as JDP


type alias Model =
    { id : Int
    , trainNumber : String
    , trainType : TrainType
    }


type TrainType
    = Local
    | Regional


decoder : JD.Decoder Model
decoder =
    JD.succeed Model
        |> JDP.required "id" JD.int
        |> JDP.required "trainNumber" JD.string
        |> JDP.required "type"
            (JD.string
                |> JD.andThen
                    (\str ->
                        case str of
                            "local" ->
                                JD.succeed Local

                            "regional" ->
                                JD.succeed Regional

                            notFound ->
                                JD.fail ("Cannot convert " ++ notFound ++ " to TrainType")
                    )
            )
