module Page.NotFound exposing (..)

import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (class, href)
import I18n
import Route
import State


type alias Model =
    { state : State.Model
    }


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        t =
            State.toI18n model.state
    in
    div [ class "not-found-page" ]
        [ h1 [] [ text "404" ]
        , a [ href (Route.routeToString Route.Home) ] [ text <| t I18n.TakeMeToHomePage ]
        ]


init : State.Model -> ( Model, Cmd Msg )
init state =
    ( { state = state
      }
    , Cmd.none
    )
