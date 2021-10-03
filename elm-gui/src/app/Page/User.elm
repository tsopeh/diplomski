module Page.User exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Http
import Image
import Task
import User
import Utils exposing (Status(..))
import Viewer exposing (Viewer)



--MODEL


type alias Model =
    { viewer : Viewer
    , user : Status User.Model
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



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
                            Viewer.toI18n model.viewer

                        zone =
                            Viewer.toZone model.viewer
                    in
                    [ div [ class "avatar" ] [ Image.avatarToImg user.avatar ]
                    , div [ class "name" ] [ text user.firstName ]
                    , div [ class "info" ] [ {- i18n -} text <| "Completed " ++ String.fromInt (user.wasDriverCount + user.wasPassengerCount) ++ " drives." ]
                    , div [ class "info" ] [ {- i18n -} text <| "Member since " ++ Utils.posixToDate zone user.memberFromDateTime ]
                    ]
    in
    div [ class "user-page" ] content



-- INIT


init : Viewer -> User.UserId -> ( Model, Cmd Msg )
init viewer id =
    ( { viewer = viewer
      , user = Loading
      }
    , Task.attempt GotUser (User.getUser viewer id)
    )
