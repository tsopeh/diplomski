module Main exposing (..)

import Api exposing (Viewer(..))
import Browser
import Browser.Navigation as Nav
import Html exposing (div, text)
import Page.Search as Search
import Url



-- MODEL


type Model
    = Search Search.Model
    | Results Viewer



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | GotSearchMsg Search.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotSearchMsg searchMsg, Search searchModel ) ->
            let
                ( updatedModel, cmd ) =
                    Search.update searchMsg searchModel
            in
            ( Search updatedModel, Cmd.map GotSearchMsg cmd )

        ( _, _ ) ->
            let
                l =
                    Debug.log "Impossible state" ( msg, model )
            in
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        content =
            case model of
                Search searchModel ->
                    Html.map GotSearchMsg <| Search.view searchModel

                _ ->
                    text "TODO"
    in
    { title = "Title"
    , body = [ div [] [ content ] ]
    }



-- MAIN


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        viewer : Viewer
        viewer =
            Anon key

        ( searchModel, searchCmd ) =
            Search.init viewer
    in
    ( Search searchModel, Cmd.map GotSearchMsg searchCmd )


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
