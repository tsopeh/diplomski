module Route exposing (..)

import Api exposing (Viewer)
import Browser.Navigation as Nav
import Schedule exposing (ScheduleId)
import Station exposing (StationId)
import Url
import Url.Builder as UrlBuilder
import Url.Parser as UrlParser exposing ((</>))


type Route
    = Home
    | SearchResults StationId StationId Int
    | Schedule ScheduleId


parser : UrlParser.Parser (Route -> a) a
parser =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map SearchResults (UrlParser.s "search" </> (UrlParser.string |> UrlParser.map Station.stringToId) </> (UrlParser.string |> UrlParser.map Station.stringToId) </> UrlParser.int)
        , UrlParser.map Schedule (UrlParser.s "schedule" </> (UrlParser.string |> UrlParser.map Schedule.stringToId))
        ]


routeToString : Route -> String
routeToString route =
    case route of
        Home ->
            "/"

        SearchResults departureId arrivalId dateTime ->
            UrlBuilder.absolute [ "search", Station.idToString departureId, Station.idToString arrivalId, String.fromInt dateTime ] []

        Schedule id ->
            UrlBuilder.absolute [ "schedule", Schedule.idToString id ] []


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    UrlParser.parse parser url


navTo : Viewer -> Route -> Cmd msg
navTo viewer route =
    Nav.pushUrl (Api.toNavKey viewer) (routeToString route)


navToWithoutHistory : Nav.Key -> Route -> Cmd msg
navToWithoutHistory key route =
    Nav.replaceUrl key (routeToString route)
