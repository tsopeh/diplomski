module Offer exposing (..)

import Http
import Suggestion exposing (SuggestionId)
import Task exposing (Task)
import Viewer exposing (Viewer)


type alias Model =
    {}


getOffer : Viewer -> SuggestionId -> Task Http.Error Model
getOffer viewer id =
    Debug.todo "getOffer"
