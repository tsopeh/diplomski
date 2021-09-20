module Route exposing (..)

import Api exposing (Viewer)
import Browser.Navigation as Nav
import Url
import Url.Builder as UrlBuilder
import Url.Parser as UrlParser exposing ((</>))


type Route
    = Search
    | Result String String Int


parser : UrlParser.Parser (Route -> a) a
parser =
    UrlParser.oneOf
        [ UrlParser.map Search UrlParser.top
        , UrlParser.map Result (UrlParser.s "search" </> UrlParser.string </> UrlParser.string </> UrlParser.int)
        ]


routeToString : Route -> String
routeToString route =
    case route of
        Search ->
            "/"

        Result departureId arrivalId dateTime ->
            UrlBuilder.relative [ "search", departureId, arrivalId, String.fromInt dateTime ] []


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    UrlParser.parse parser url


navTo : Viewer -> Route -> Cmd msg
navTo viewer route =
    Nav.pushUrl (Api.toNavKey viewer) (routeToString route)


navToWithoutHistory : Nav.Key -> Route -> Cmd msg
navToWithoutHistory key route =
    Nav.replaceUrl key (routeToString route)
