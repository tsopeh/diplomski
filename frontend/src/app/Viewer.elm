module Viewer exposing (LoggedInUserData, Model, Msg(..), createWithDataAndToken, initViewer, isAuthenticated, toAvatar, toFirstName, toToken, toUserId)

import Api
import Http
import Image
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Task exposing (Task)


type Model
    = Guest
    | WithTokenOnly Api.Token
    | WithDataAndToken LoggedInUserData Api.Token


createWithDataAndToken : LoggedInUserData -> Api.Token -> Model
createWithDataAndToken userData token =
    WithDataAndToken userData token


isAuthenticated : Model -> Bool
isAuthenticated viewer =
    case viewer of
        Guest ->
            False

        _ ->
            True


toToken : Model -> Maybe Api.Token
toToken model =
    case model of
        Guest ->
            Nothing

        WithTokenOnly token ->
            Just token

        WithDataAndToken _ token ->
            Just token


toUserId : Model -> Maybe String
toUserId model =
    case model of
        Guest ->
            Nothing

        WithTokenOnly _ ->
            Nothing

        WithDataAndToken data _ ->
            Just data.id


toFirstName : Model -> Maybe String
toFirstName model =
    case model of
        Guest ->
            Nothing

        WithTokenOnly _ ->
            Nothing

        WithDataAndToken data _ ->
            Just data.firstName


toAvatar : Model -> Image.Avatar
toAvatar model =
    case model of
        Guest ->
            Image.guestAvatar

        WithTokenOnly _ ->
            Image.guestAvatar

        WithDataAndToken data _ ->
            data.avatar


type Msg
    = GotLoggedInUserData (Result Http.Error LoggedInUserData)


initViewer : Maybe Api.Token -> ( Model, Cmd Msg )
initViewer maybeToken =
    case maybeToken of
        Nothing ->
            ( Guest, Cmd.none )

        Just token ->
            ( WithTokenOnly token, Task.attempt GotLoggedInUserData (getLoggedInUserData maybeToken) )


type alias LoggedInUserData =
    { id : String
    , firstName : String
    , avatar : Image.Avatar
    }


loggedInUserDataDecoder : JD.Decoder LoggedInUserData
loggedInUserDataDecoder =
    JD.succeed LoggedInUserData
        |> JDP.required "id" JD.string
        |> JDP.required "firstName" JD.string
        |> JDP.required "avatar" Image.decoder


getLoggedInUserData : Maybe Api.Token -> Task Http.Error LoggedInUserData
getLoggedInUserData maybeToken =
    Http.task
        { method = "get"
        , url = Api.getApiUrl [ "user", "me" ] []
        , headers = Api.createRequestHeaders maybeToken
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            Http.stringResolver <| Api.handleJsonResponse <| loggedInUserDataDecoder
        }
