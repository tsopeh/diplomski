module Vehicle exposing (..)

import Json.Decode as JD
import Json.Decode.Pipeline as JDP


type alias Model =
    { name : String
    , description : String
    , avatar : String
    }


decoder : JD.Decoder Model
decoder =
    JD.succeed Model
        |> JDP.required "name" JD.string
        |> JDP.required "description" JD.string
        |> JDP.required "avatar" JD.string
