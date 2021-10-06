module Page.User exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Http
import Image
import State
import Task
import User
import Utils exposing (Status(..))



--MODEL


type alias Model =
    { state : State.Model
    , user : Status User.Model
    }



-- UPDATE


type Msg
    = GotUser (Result Http.Error User.Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotUser res ->
            case res of
                Ok user ->
                    ( { model | user = Loaded user }, Cmd.none )

                Err e ->
                    let
                        _ =
                            Debug.log "Failed to load user" e
                    in
                    ( { model | user = Failed }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        content =
            case model.user of
                Loading ->
                    [ div [] [ {- i18n -} text "Loading user..." ] ]

                Failed ->
                    [ div [] [ {- i18n -} text "Failed to load user." ] ]

                Loaded user ->
                    let
                        t =
                            State.toI18n model.state

                        zone =
                            model.state.timeZone
                    in
                    [ div [ class "avatar" ] [ Image.avatarToImg user.avatar ]
                    , div [ class "name" ] [ text user.firstName ]
                    , div [ class "info" ] [ {- i18n -} text <| "Completed " ++ String.fromInt (user.wasDriverCount + user.wasPassengerCount) ++ " drives." ]
                    , div [ class "info" ] [ {- i18n -} text <| "Member since " ++ Utils.posixToDate zone user.memberFromDateTime ]
                    ]
    in
    div [ class "user-page" ] content



-- INIT


init : State.Model -> User.UserId -> ( Model, Cmd Msg )
init state id =
    ( { state = state
      , user = Loading
      }
    , Task.attempt GotUser (User.getUser state.viewer id)
    )
