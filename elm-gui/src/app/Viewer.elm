module Viewer exposing (Model, createViewer, isAuthenticated, toAvatar, toToken)

import Api
import Image


type Model
    = Guest
        { avatar : Image.Avatar
        }
    | LoggedIn
        { token : Api.Token
        , avatar : Image.Avatar
        }


createGuest : Image.Avatar -> Model
createGuest avatar =
    Guest
        { avatar = avatar
        }


createLoggedIn : Image.Avatar -> Api.Token -> Model
createLoggedIn avatar token =
    LoggedIn
        { avatar = avatar
        , token = token
        }


createViewer : Image.Avatar -> Maybe Api.Token -> Model
createViewer avatar maybeToken =
    case maybeToken of
        Just token ->
            createLoggedIn avatar token

        Nothing ->
            createGuest avatar


isAuthenticated : Model -> Bool
isAuthenticated viewer =
    case viewer of
        Guest _ ->
            False

        LoggedIn _ ->
            True


toToken : Model -> Maybe Api.Token
toToken model =
    case model of
        Guest _ ->
            Nothing

        LoggedIn data ->
            Just data.token


toAvatar : Model -> Image.Avatar
toAvatar model =
    case model of
        Guest data ->
            data.avatar

        LoggedIn data ->
            data.avatar
