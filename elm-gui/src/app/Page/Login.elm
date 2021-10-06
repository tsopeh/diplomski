module Page.Login exposing (..)

import Api
import Form as F
import Html exposing (Html, a, button, div, form, h1, input, text)
import Html.Attributes exposing (class, href, name, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Route
import State
import Task exposing (Task)



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
            ( model, Task.attempt GotToken <| Api.login { email = model.email, password = model.password } )

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
    div [ class "login-page" ]
        [ h1 [] [ {- i18n -} text "Log in" ]
        , form [ onSubmit Submit ]
            [ F.viewInput
                { type_ = "email"
                , name = "email"
                , placeholder = {- i18n -} "E-mail"
                , label = {- i18n -} "E-mail"
                , value = model.email
                , onInput = EmailChanged
                }
            , F.viewInput
                { type_ = "password"
                , name = "password"
                , placeholder = {- i18n -} "Password"
                , label = {- i18n -} "Password"
                , value = model.password
                , onInput = PasswordChanged
                }
            , button [ type_ "submit" ] [ {- i18n -} text "Login" ]
            ]
        , a [ class "alternative", href (Route.routeToString Route.Register) ] [ {- i18n -} text "Don't have an account? Register here." ]
        , a [ class "alternative", href "" ] [ {- i18n -} text "Did you forget your password? Let's reset it." ]
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
