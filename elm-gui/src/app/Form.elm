module Form exposing (..)

import Html as H
import Html.Attributes as HA
import Html.Events as HE


type Autocomplete
    = On
    | Off


type alias InputConfig msg =
    { type_ : String
    , name : String
    , placeholder : String
    , label : String
    , value : String
    , onInput : String -> msg
    , shouldAutocomplete : Bool
    }


viewInput : InputConfig msg -> H.Html msg
viewInput conf =
    H.label []
        [ H.span [] [ H.text conf.label ]
        , H.input
            [ HA.type_ conf.type_
            , HA.name conf.name
            , HA.placeholder conf.placeholder
            , HA.value conf.value
            , HA.autocomplete conf.shouldAutocomplete
            , HE.onInput conf.onInput
            ]
            []
        ]


type alias SelectConf msg =
    { name : String
    , placeholder : String
    , label : String
    , options : List ( String, String )
    , selected : Maybe String
    , onInput : String -> msg
    }


viewSelect : SelectConf msg -> H.Html msg
viewSelect conf =
    H.label []
        [ H.span [] [ H.text conf.label ]
        , H.select [ HE.onInput conf.onInput ] <|
            [ H.option [ HA.hidden True, HA.selected <| conf.selected == Nothing ] [ H.text conf.placeholder ] ]
                ++ List.map
                    (\( id, value ) ->
                        H.option [ HA.value id, HA.selected <| conf.selected == Just id ] [ H.text value ]
                    )
                    conf.options
        ]
