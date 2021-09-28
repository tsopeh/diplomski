module Route exposing (..)

import Browser.Navigation as Nav
import Location exposing (LocationId)
import Suggestion
import Url
import Url.Builder as UrlBuilder
import Url.Parser as UrlParser exposing ((</>))
import Viewer exposing (Viewer)


type Route
    = Home
    | Suggestions LocationId LocationId Int
    | Offer Suggestion.SuggestionId


parser : UrlParser.Parser (Route -> a) a
parser =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map Suggestions (UrlParser.s "suggestions" </> (UrlParser.string |> UrlParser.map Location.stringToId) </> (UrlParser.string |> UrlParser.map Location.stringToId) </> UrlParser.int)
        , UrlParser.map Offer (UrlParser.s "offer" </> (UrlParser.string |> UrlParser.map Suggestion.stringToId))
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


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    UrlParser.parse parser url


navTo : Viewer -> Route -> Cmd msg
navTo viewer route =
    Nav.pushUrl (Viewer.toNavKey viewer) (routeToString route)


navToWithoutHistory : Nav.Key -> Route -> Cmd msg
navToWithoutHistory key route =
    Nav.replaceUrl key (routeToString route)
