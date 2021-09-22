module Page exposing (..)

import Html exposing (Html, a, div, footer, header, text)
import Html.Attributes exposing (class, href)
import Route


type Msg msg
    = GotFromContent msg


view : Html msg -> List (Html (Msg msg))
view content =
    viewHeader :: div [ class "page" ] [ Html.map GotFromContent content ] :: [ viewFooter ]


viewHeader : Html (Msg msg)
viewHeader =
    header [] [ a [ class "logo", href (Route.routeToString Route.Home) ] [] ]


viewFooter : Html (Msg msg)
viewFooter =
    footer [] [ text "footer" ]
