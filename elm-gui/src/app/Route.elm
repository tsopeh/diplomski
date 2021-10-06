module Route exposing (..)

import Browser.Navigation as Nav
import Location exposing (LocationId)
import Suggestion
import Url
import Url.Builder as UrlBuilder
import Url.Parser as UrlParser exposing ((</>))
import User


type Route
    = Home
    | Suggestions LocationId LocationId Int
    | Offer Suggestion.SuggestionId
    | User User.UserId
    | Login
    | Logout
    | Register


parser : UrlParser.Parser (Route -> a) a
parser =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Suggestions (UrlParser.s "suggestions" </> (UrlParser.string |> UrlParser.map Location.stringToId) </> (UrlParser.string |> UrlParser.map Location.stringToId) </> UrlParser.int)
        , UrlParser.map Offer (UrlParser.s "offer" </> (UrlParser.string |> UrlParser.map Suggestion.stringToId))
        , UrlParser.map User (UrlParser.s "user" </> (UrlParser.string |> UrlParser.map User.stringToId))
        , UrlParser.map Login (UrlParser.s "login")
        , UrlParser.map Logout (UrlParser.s "logout")
        , UrlParser.map Register (UrlParser.s "register")
        ]


routeToString : Route -> String
routeToString route =
    case route of
        Home ->
            "/"

        Suggestions departureId arrivalId dateTime ->
            UrlBuilder.absolute [ "suggestions", Location.idToString departureId, Location.idToString arrivalId, String.fromInt dateTime ] []

        Offer id ->
            UrlBuilder.absolute [ "offer", Suggestion.idToString id ] []

        User id ->
            UrlBuilder.absolute [ "user", User.idToString id ] []

        Login ->
            UrlBuilder.absolute [ "login" ] []

        Logout ->
            UrlBuilder.absolute [ "logout" ] []

        Register ->
            UrlBuilder.absolute [ "register" ] []


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    UrlParser.parse parser url


navTo : Nav.Key -> Route -> Cmd msg
navTo navKey route =
    Nav.pushUrl navKey (routeToString route)


navToWithoutHistory : Nav.Key -> Route -> Cmd msg
navToWithoutHistory key route =
    Nav.replaceUrl key (routeToString route)
