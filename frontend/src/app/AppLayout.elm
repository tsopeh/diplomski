module AppLayout exposing (..)

import Html exposing (Html, a, div, footer, header, main_, option, select, span, text)
import Html.Attributes exposing (class, href, selected, value)
import Html.Events exposing (onInput)
import I18n
import Image
import Route
import State
import Utils
import Viewer


type alias Model =
    { state : State.Model
    }


type Msg msg
    = LanguageChanged String
    | GotFromContent msg


view : Model -> Html msg -> List (Html (Msg msg))
view model content =
    viewHeader model :: main_ [] [ Html.map GotFromContent content ] :: [ viewFooter model model.state.language ]


viewHeader : Model -> Html (Msg msg)
viewHeader model =
    let
        url =
            if Viewer.isAuthenticated model.state.viewer then
                Route.routeToString Route.Logout

            else
                Route.routeToString Route.Login

        userInfo =
            case Viewer.toFirstName model.state.viewer of
                Nothing ->
                    Utils.emptyHtml

                Just username ->
                    span [] [ text username ]
    in
    header []
        [ a [ class "logo", href <| Route.routeToString Route.Home ] []
        , a [ class "avatar", href <| url ]
            [ Image.avatarToImg (Viewer.toAvatar model.state.viewer)
            , userInfo
            ]
        ]


viewFooter : Model -> I18n.Language -> Html (Msg msg)
viewFooter model language =
    let
        t =
            State.toI18n model.state
    in
    footer []
        [ div [] [ text <| t I18n.Trademark ]
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
