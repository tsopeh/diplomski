module Page exposing (..)

import Html exposing (Html, footer, header, text)


type Msg msg
    = GotFromContent msg


view : Html msg -> List (Html (Msg msg))
view content =
    viewHeader :: Html.map GotFromContent content :: [ viewFooter ]


viewHeader : Html (Msg msg)
viewHeader =
    header [] [ text "header" ]


viewFooter : Html (Msg msg)
viewFooter =
    footer [] [ text "footer" ]
