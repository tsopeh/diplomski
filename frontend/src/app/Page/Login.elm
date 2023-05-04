module Page.Login exposing (..)

import Api
import Form as F
import Html exposing (Html, a, button, div, form, h1, text)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (onSubmit)
import Http
import I18n
import Route
import State
import Task exposing (Task)
import User



-- MODEL


type alias Model =
    { state : State.Model
    , email : String
    , password : String
    , problems : List String
    }



-- UPDATE


type Msg
    = EmailChanged String
    | PasswordChanged String
    | Submit
    | GotToken (Result Http.Error Api.Token)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailChanged email ->
            ( { model | email = email }, Cmd.none )

        PasswordChanged password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model, Task.attempt GotToken <| User.login { email = model.email, password = model.password } )

        GotToken res ->
            case res of
                Ok token ->
                    ( model, Api.persistToken (Just <| Api.tokenToString token) )

                Err err ->
                    case err of
                        _ ->
                            let
                                _ =
                                    Debug.log "Failed to retrieve the token" err
                            in
                            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        t =
            State.toI18n model.state
    in
    div [ class "login-page" ]
        [ h1 [] [ text <| t I18n.Login ]
        , form [ onSubmit Submit ]
            [ F.viewInput
                { type_ = "email"
                , name = "email"
                , placeholder = t I18n.Email
                , label = t I18n.Email
                , value = model.email
                , onInput = EmailChanged
                , shouldAutocomplete = True
                }
            , F.viewInput
                { type_ = "password"
                , name = "password"
                , placeholder = t I18n.Password
                , label = t I18n.Password
                , value = model.password
                , onInput = PasswordChanged
                , shouldAutocomplete = True
                }
            , button [ type_ "submit" ] [ text <| t I18n.Login ]
            ]
        , a [ class "alternative", href (Route.routeToString Route.Register) ] [ text <| t I18n.RegisterHere ]
        , a [ class "alternative", href "" ] [ text <| t I18n.ResetPassword ]
        ]



-- INIT


init : State.Model -> ( Model, Cmd Msg )
init state =
    ( { state = state
      , email = ""
      , password = ""
      , problems = []
      }
    , Cmd.none
    )



-- HTTP


type alias PostLoginModel =
    { email : String
    , password : String
    }
