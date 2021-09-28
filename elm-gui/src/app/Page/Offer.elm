module Page.Offer exposing (..)

import Html exposing (Html, text)
import Http
import Offer
import Suggestion
import Task
import Utils exposing (Status(..))
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { viewer : Viewer
    , offer : Status Offer.Model
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = GotOffer (Result Http.Error Offer.Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotOffer (Ok offer) ->
            ( { model | offer = Loaded offer }, Cmd.none )

        GotOffer (Err e) ->
            let
                _ =
                    Debug.log "Failed to load offer" e
            in
            ( { model | offer = Failed }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text "offer page"



-- INIT


init : Viewer -> Suggestion.SuggestionId -> ( Model, Cmd Msg )
init viewer id =
    ( { viewer = viewer
      , offer = Loading
      }
    , Task.attempt GotOffer (Offer.getOffer viewer id)
    )
