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
import Task
import Time
import Utils exposing (Status(..), posixToHoursMinutes)
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
                , div [ class "date" ] [ text "date time" ]
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



-- SVG


searchIcon : Svg.Svg Msg
searchIcon =
    Svg.svg [ SvgAttr.class "search-icon", SvgAttr.version "1.1", SvgAttr.x "0px", SvgAttr.y "0px", SvgAttr.viewBox "0 0 512 512" ]
        [ Svg.path [ SvgAttr.d "M141.367,116.518c-7.384-7.39-19.364-7.39-26.748,0c-27.416,27.416-40.891,65.608-36.975,104.79 c0.977,9.761,9.2,17.037,18.803,17.037c0.631,0,1.267-0.032,1.898-0.095c10.398-1.04,17.983-10.316,16.943-20.707 c-2.787-27.845,6.722-54.92,26.079-74.278C148.757,135.882,148.757,123.901,141.367,116.518z" ]
            []
        , Svg.path [ SvgAttr.d "M216.276,0C97.021,0,0,97.021,0,216.276s97.021,216.276,216.276,216.276s216.276-97.021,216.276-216.276 S335.53,0,216.276,0z M216.276,394.719c-98.396,0-178.443-80.047-178.443-178.443S117.88,37.833,216.276,37.833 c98.39,0,178.443,80.047,178.443,178.443S314.672,394.719,216.276,394.719z" ]
            []
        , Svg.path [ SvgAttr.d "M506.458,479.71L368.999,342.252c-7.39-7.39-19.358-7.39-26.748,0c-7.39,7.384-7.39,19.364,0,26.748L479.71,506.458 c3.695,3.695,8.531,5.542,13.374,5.542c4.843,0,9.679-1.847,13.374-5.542C513.847,499.074,513.847,487.094,506.458,479.71z" ]
            []
        ]



--Svg.svg [] []


arrowIcon : Svg.Svg Msg
arrowIcon =
    Svg.svg [ SvgAttr.class "arrow", SvgAttr.version "1.1", SvgAttr.x "0px", SvgAttr.y "0px", SvgAttr.viewBox "0 0 268.832 268.832" ]
        [ Svg.g []
            [ Svg.path [ SvgAttr.d "M265.171,125.577l-80-80c-4.881-4.881-12.797-4.881-17.678,0c-4.882,4.882-4.882,12.796,0,17.678l58.661,58.661H12.5 c-6.903,0-12.5,5.597-12.5,12.5c0,6.902,5.597,12.5,12.5,12.5h213.654l-58.659,58.661c-4.882,4.882-4.882,12.796,0,17.678 c2.44,2.439,5.64,3.661,8.839,3.661s6.398-1.222,8.839-3.661l79.998-80C270.053,138.373,270.053,130.459,265.171,125.577z" ]
                []
            ]
        ]
