module Page.SearchResults exposing (..)

import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (class, href, title)
import Http
import I18n
import Route
import Schedule exposing (ScheduleBrief)
import Station exposing (Station, StationId)
import Svg
import Svg.Attributes as SvgAttr
import SvgIcons exposing (arrowIcon, searchIcon)
import Task
import Time
import Utils exposing (Status(..), posixToDate, posixToHoursMinutes)
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { viewer : Viewer
    , departureStation : Status Station
    , arrivalStation : Status Station
    , departureDateTime : Time.Posix
    , schedules : Status (List ScheduleBrief)
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = GotSchedules (Result Http.Error (List ScheduleBrief))
    | GotDepartureStation (Result Http.Error Station)
    | GotArrivalStation (Result Http.Error Station)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSchedules result ->
            case result of
                Ok newSchedules ->
                    ( { model | schedules = Loaded newSchedules }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "Error while loading schedules" error
                    in
                    ( { model | schedules = Failed }, Cmd.none )

        GotDepartureStation result ->
            case result of
                Ok station ->
                    ( { model | departureStation = Loaded station }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "Error while loading departure station" error
                    in
                    ( { model | departureStation = Failed }, Cmd.none )

        GotArrivalStation result ->
            case result of
                Ok station ->
                    ( { model | arrivalStation = Loaded station }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "Error while loading arrival station" error
                    in
                    ( { model | arrivalStation = Failed }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        t =
            Viewer.toI18n model.viewer

        departureStation : Maybe Station
        departureStation =
            case model.departureStation of
                Loaded station ->
                    Just station

                _ ->
                    Nothing

        arrivalStation : Maybe Station
        arrivalStation =
            case model.arrivalStation of
                Loaded station ->
                    Just station

                _ ->
                    Nothing

        schedulesHtml : List (Html Msg)
        schedulesHtml =
            case model.schedules of
                Loading ->
                    [ text <| t I18n.LoadingBriefSchedules ]

                Loaded schedules ->
                    List.map
                        (\entry -> viewBrief (Viewer.toZone model.viewer) t entry)
                        schedules

                Failed ->
                    [ text <| t I18n.FailedToLoadBriefSchedules ]
    in
    div [ class "search-results-page" ]
        [ viewHeader model.viewer ( departureStation, arrivalStation ) model.departureDateTime
        , div [ class "schedules" ] schedulesHtml
        ]


viewHeader : Viewer -> ( Maybe Station, Maybe Station ) -> Time.Posix -> Html Msg
viewHeader viewer ( departure, arrival ) dateTime =
    let
        departureHtml : Html Msg
        departureHtml =
            case departure of
                Nothing ->
                    text "..."

                Just station ->
                    text station.name

        arrivalHtml : Html Msg
        arrivalHtml =
            case arrival of
                Nothing ->
                    text "..."

                Just station ->
                    text station.name
    in
    div [ class "header" ]
        [ a [ href "../" ]
            [ div [ class "icon-container" ] [ searchIcon ]
            , div [ class "info" ]
                [ div [ class "route" ]
                    [ span [] [ departureHtml ]
                    , arrowIcon
                    , span [] [ arrivalHtml ]
                    ]
                , div [ class "date" ] [ text <| posixToDate (Viewer.toZone viewer) dateTime ]
                ]
            ]
        ]


viewBrief : Time.Zone -> I18n.TransFn -> ScheduleBrief -> Html Msg
viewBrief zone t entry =
    a [ class "entry", href <| Route.routeToString (Route.Schedule entry.id) ]
        [ div [ class "timeline" ]
            [ div [ class "dep-time" ] [ text <| posixToHoursMinutes zone entry.departure.dateTime ]
            , div [ class "dep-name" ] [ text entry.departure.station.name ]
            , div [ class "length", title <| t I18n.TripDuration ] [ text <| "123:45" ]
            , div [ class "arr-time" ] [ text <| posixToHoursMinutes zone entry.arrival.dateTime ]
            , div [ class "arr-name" ] [ text entry.arrival.station.name ]
            , div [ class "pin", class "dep-pin" ] []
            , div [ class "pipe" ] []
            , div [ class "pin", class "arr-pin" ] []
            ]
        , div [ class "train-info" ]
            [ div [] [ text <| t <| I18n.SearchResults_Train entry.train.trainNumber ]
            , div [] [ text <| t <| I18n.SearchResults_StartingPrice entry.ticketStartingPrice ]
            , div [] [ text <| t <| I18n.Latency entry.latency ]
            ]
        ]



-- INIT


init : Viewer -> StationId -> StationId -> Time.Posix -> ( Model, Cmd Msg )
init viewer depStationId arrStationId depDateTime =
    ( Model viewer Loading Loading depDateTime Loading
    , Cmd.batch
        [ Task.attempt GotDepartureStation <| Station.getStation viewer depStationId
        , Task.attempt GotArrivalStation <| Station.getStation viewer arrStationId
        , Task.attempt GotSchedules
            (Schedule.getBriefSchedules viewer
                { depStationId = depStationId
                , arrStationId = arrStationId
                , depDateTime = depDateTime
                }
            )
        ]
    )
