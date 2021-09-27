module AppLayout exposing (..)

import Html exposing (Html, a, footer, header, main_, option, select, text)
import Html.Attributes exposing (class, href, selected, value)
import Html.Events exposing (onInput)
import I18n
import Route
import Viewer exposing (Viewer)


type alias Model =
    { viewer : Viewer
    }


type Msg msg
    = LanguageChanged String
    | GotFromContent msg


view : Model -> Html msg -> List (Html (Msg msg))
view model content =
    viewHeader :: main_ [] [ Html.map GotFromContent content ] :: [ viewFooter (Viewer.toLanguage model.viewer) ]


viewHeader : Html (Msg msg)
viewHeader =
    header [] [ a [ class "logo", href (Route.routeToString Route.Home) ] [] ]


viewFooter : I18n.Language -> Html (Msg msg)
viewFooter language =
    footer []
        [ text "footer"
        , select [ class "select-lang", onInput LanguageChanged ] <|
            List.map
                (\( id, name ) ->
                    let
                        isSelected =
                            id == Tuple.first (I18n.languageToIdValue language)
                    in
                    option [ value id, selected isSelected ] [ text name ]
                )
                I18n.languagesIdValues
        ]



-- INIT


init : Viewer -> Model
init viewer =
    { viewer = viewer
    }
