module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (div, text)
import Url



-- MODEL


type Model
    = NoOp



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Title"
    , body = [ div [] [ text "text" ] ]
    }



-- MAIN


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( NoOp, Cmd.none )


main : Program (Maybe String) Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
