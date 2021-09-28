module Page.Suggestions exposing (..)

import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (class, classList, href, title)
import Http
import I18n
import Location exposing (Location, LocationId)
import Route
import Suggestion
import SvgIcons exposing (arrowIcon, searchIcon)
import Task
import Time
import Utils exposing (Status(..), posixToDate, posixToHoursMinutes)
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { viewer : Viewer
    , startLocation : Status Location
    , finishLocation : Status Location
    , departureDateTime : Time.Posix
    , suggestions : Status (List Suggestion.Model)
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = GotSuggestions (Result Http.Error (List Suggestion.Model))
    | GotDepartureStation (Result Http.Error Location)
    | GotArrivalStation (Result Http.Error Location)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSuggestions result ->
            case result of
                Ok suggestions ->
                    ( { model | suggestions = Loaded suggestions }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "Error while loading suggestions" error
                    in
                    ( { model | suggestions = Failed }, Cmd.none )

        GotDepartureStation result ->
            case result of
                Ok station ->
                    ( { model | startLocation = Loaded station }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "Error while loading start location" error
                    in
                    ( { model | startLocation = Failed }, Cmd.none )

        GotArrivalStation result ->
            case result of
                Ok station ->
                    ( { model | finishLocation = Loaded station }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "Error while loading finish location" error
                    in
                    ( { model | finishLocation = Failed }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        t =
            Viewer.toI18n model.viewer

        departureStation : Maybe Location
        departureStation =
            case model.startLocation of
                Loaded station ->
                    Just station

                _ ->
                    Nothing

        arrivalStation : Maybe Location
        arrivalStation =
            case model.finishLocation of
                Loaded station ->
                    Just station

                _ ->
                    Nothing

        suggestionsHtml : List (Html Msg)
        suggestionsHtml =
            case model.suggestions of
                Loading ->
                    [ text <| t I18n.LoadingBriefSchedules ]

                Loaded suggestions ->
                    List.map
                        (\entry -> viewSuggestion (Viewer.toZone model.viewer) t entry)
                        suggestions

                Failed ->
                    [ text <| t I18n.FailedToLoadBriefSchedules ]
    in
    div [ class "suggestions-page" ]
        [ viewHeader model.viewer ( departureStation, arrivalStation ) model.departureDateTime
        , div [ class "schedules" ] suggestionsHtml
        ]


viewHeader : Viewer -> ( Maybe Location, Maybe Location ) -> Time.Posix -> Html Msg
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


viewSuggestion : Time.Zone -> I18n.TransFn -> Suggestion.Model -> Html Msg
viewSuggestion zone t entry =
    a [ class "entry", href <| Route.routeToString (Route.Offer entry.id) ]
        [ div [ class "timeline" ]
            [ div [ class "dep-time" ] [ text <| posixToHoursMinutes zone entry.departureDateTime ]
            , div [ class "start-name" ] [ text entry.startLocationName ]
            , div [ class "length", title <| t I18n.TripDuration ] [ text <| entry.duration ]
            , div [ class "arr-time" ] [ text <| posixToHoursMinutes zone entry.arrivalDateTime ]
            , div [ class "arr-name" ] [ text entry.finishLocationName ]
            , div [ class "pin", class "dep-pin" ] []
            , div [ class "pipe" ] []
            , div [ class "pin", class "arr-pin" ] []
            ]
        , div [ class "info" ]
            [ div [ class "driver-avatar" ] []
            , div [ class "driver-info" ] [ text entry.driverName ]
            , div [ class "vehicle-info" ] [ text <| entry.vehicle.name ++ " (" ++ entry.vehicle.description ++ ")" ]
            , div [ class "conditions" ] <| viewConditions entry.smokingAllowed entry.petsAllowed entry.childrenAllowed
            , div [ class "seats" ] <| viewSeats entry.numberOfSeats entry.numberOfFreeSeats
            , div [ class "price" ] [ text <| entry.price ]
            ]
        ]


viewConditions : Bool -> Bool -> Bool -> List (Html Msg)
viewConditions smoking pets children =
    [ div [ class "condition" ] [ SvgIcons.smoking smoking ]
    , div [ class "condition" ] [ SvgIcons.pets pets ]
    ]


viewSeats : Int -> Int -> List (Html Msg)
viewSeats seats freeSeats =
    let
        viewSeat : Bool -> Int -> List (Html Msg)
        viewSeat isFree count =
            case count of
                0 ->
                    []

                _ ->
                    div [ class "seat" ] [ SvgIcons.seat isFree ] :: viewSeat isFree (count - 1)
    in
    viewSeat False (seats - freeSeats) ++ viewSeat True freeSeats



-- INIT


init : Viewer -> LocationId -> LocationId -> Time.Posix -> ( Model, Cmd Msg )
init viewer depStationId arrStationId depDateTime =
    ( Model viewer Loading Loading depDateTime Loading
    , Cmd.batch
        [ Task.attempt GotDepartureStation <| Location.getLocation viewer depStationId
        , Task.attempt GotArrivalStation <| Location.getLocation viewer arrStationId
        , Task.attempt GotSuggestions
            (Suggestion.getSuggestions viewer
                { startStation = depStationId
                , finishStationId = arrStationId
                , departureDateTime = depDateTime
                }
            )
        ]
    )
