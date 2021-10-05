module Page.Login exposing (..)

import Html exposing (Html, a, button, div, form, input, text)
import Html.Attributes exposing (class, href, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Ports
import Viewer exposing (Token, Viewer)



-- MODEL


type alias Model =
    { viewer : Viewer
    , email : String
    , password : String
    , problems : List String
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = EmailChanged String
    | PasswordChanged String
    | Submit
    | GotToken (Result Http.Error Token)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailChanged email ->
            ( { model | email = email }, Cmd.none )

        PasswordChanged password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model, Debug.todo "try login" )

        GotToken res ->
            case res of
                Ok token ->
                    ( model, Ports.persistToken (Viewer.tokenToString token) )

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
        [ form [ onSubmit Submit ]
            [ input
                [ type_ "email"
                , {- i18n -} placeholder "E-mail"
                , value model.email
                , onInput EmailChanged
                ]
                []
            , input
                [ type_ "password"
                , {- i18n -} placeholder "Password"
                , value model.password
                , onInput PasswordChanged
                ]
                []
            , button [ type_ "submit" ] [ {- i18n -} text "Login" ]
            ]
        , a [ class "alternative", href "" ] [ {- i18n -} text "Did you forget your password? Let's reset it." ]
        , a [ class "alternative", href "" ] [ {- i18n -} text "Already have an account? Log in." ]
        ]



-- INIT


init : Viewer -> ( Model, Cmd Msg )
init viewer =
    ( { viewer = viewer
      , email = ""
      , password = ""
      , problems = []
      }
    , Cmd.none
    )
