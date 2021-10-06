module AppLayout exposing (..)

import Html exposing (Html, a, div, footer, header, main_, option, select, text)
import Html.Attributes exposing (class, href, selected, value)
import Html.Events exposing (onInput)
import I18n
import Image
import Route
import State
import Viewer


type alias Model =
    { state : State.Model
    }


type Msg msg
    = LanguageChanged String
    | GotFromContent msg


view : Model -> Html msg -> List (Html (Msg msg))
view model content =
    viewHeader model :: main_ [] [ Html.map GotFromContent content ] :: [ viewFooter model.state.language ]


viewHeader : Model -> Html (Msg msg)
viewHeader model =
    let
        url =
            if Viewer.isAuthenticated model.state.viewer then
                Route.routeToString Route.Logout

            else
                Route.routeToString Route.Login
    in
    header []
        [ a [ class "logo", href <| Route.routeToString Route.Home ] []
        , a [ class "avatar", href <| url ] [ Image.avatarToImg Image.guestAvatar ]
        ]


viewFooter : I18n.Language -> Html (Msg msg)
viewFooter language =
    footer []
        [ div [] [ text "TruchCar©" ]
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


init : State.Model -> Model
init state =
    { state = state
    }
