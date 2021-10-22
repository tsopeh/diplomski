module Page.Offer exposing (..)

import Html exposing (Html, a, button, div, hr, span, text)
import Html.Attributes exposing (class, href, title)
import Html.Events exposing (onClick)
import Http
import I18n
import Image
import Offer
import Route
import State
import Suggestion
import Svg exposing (Svg)
import SvgIcons
import Task
import Utils exposing (Status(..))
import Vehicle
import Viewer



-- MODEL


type alias Model =
    { state : State.Model
    , offer : Status Offer.Model
    }



-- UPDATE


type Msg
    = GotOffer (Result Http.Error Offer.Model)
    | ToggleOffer


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotOffer (Ok offer) ->
            ( { model | offer = Loaded offer }, Cmd.none )

        GotOffer (Err e) ->
            let
                _ =
                    Debug.log "Failed to load offer" e

                cmd =
                    case e of
                        Http.BadStatus status ->
                            if status == 401 then
                                Route.navToWithoutHistory model.state.navKey Route.Logout

                            else
                                Cmd.none

                        _ ->
                            Cmd.none
            in
            ( { model | offer = Failed }, cmd )

        ToggleOffer ->
            case model.offer of
                Loaded offer ->
                    ( model, Task.attempt GotOffer (Offer.postToggleOffer model.state.viewer offer.id) )

                _ ->
                    ( model, Cmd.none )



-- VIEW


type AvailableUserAction
    = CanAccept
    | CanCancel
    | NoActionAvailable


view : Model -> Html Msg
view model =
    let
        t =
            State.toI18n model.state
    in
    case model.offer of
        Loading ->
            text <| t I18n.LoadingOffer

        Failed ->
            text <| t I18n.FailedLoadingOffer

        Loaded offer ->
            let
                lang =
                    model.state.language

                zone =
                    model.state.timeZone

                areThereFreeSeats =
                    Offer.hasFreeSeats offer

                maybeUserId =
                    Viewer.toUserId model.state.viewer

                availableUserAction : AvailableUserAction
                availableUserAction =
                    case maybeUserId of
                        Nothing ->
                            NoActionAvailable

                        Just userId ->
                            if userId == offer.driver.id then
                                NoActionAvailable

                            else if not <| List.isEmpty (List.filter (\passenger -> passenger.id == userId) offer.passengers) then
                                CanCancel

                            else if areThereFreeSeats then
                                CanAccept

                            else
                                NoActionAvailable
            in
            div [ class "offer-page" ]
                ([ div [ class "departure-date" ] [ I18n.viewFormatedDate lang zone offer.departureDateTime ]
                 , Utils.viewIf (not areThereFreeSeats) <| div [ class "notice" ] [ SvgIcons.notice, div [] [ text <| t I18n.NoSeatsAvailable ] ]
                 , viewThickHorizontalSeparator
                 , div [ class "timeline" ]
                    [ div [ class "dep-time" ] [ text <| Utils.posixToHoursMinutes zone offer.departureDateTime ]
                    , div [ class "start-name" ] [ text offer.startLocationName ]
                    , div [ class "length", title <| t I18n.TripDuration ] [ text <| offer.duration ]
                    , div [ class "arr-time" ] [ text <| Utils.posixToHoursMinutes zone offer.arrivalDateTime ]
                    , div [ class "arr-name" ] [ text offer.finishLocationName ]
                    , div [ class "pin", class "dep-pin" ] []
                    , div [ class "pipe" ] []
                    , div [ class "pin", class "arr-pin" ] []
                    ]
                 , viewThickHorizontalSeparator
                 , div [ class "price" ]
                    [ div [] [ text <| t I18n.PriceForSinglePerson ]
                    , div [] [ text offer.price ]
                    ]
                 , viewThickHorizontalSeparator
                 , viewDriver model.state t offer.driver
                 , viewThinHorizontalSeparator
                 , viewCondition (SvgIcons.smoking offer.smokingAllowed) <|
                    if offer.smokingAllowed then
                        t I18n.SmokingIsAllowed

                    else
                        t I18n.SmokingIsNotAllowed
                 , viewCondition (SvgIcons.pets offer.petsAllowed) <|
                    if offer.petsAllowed then
                        t I18n.PetsAreAllowed

                    else
                        t I18n.PetsAreNotAllowed
                 , viewVehicle offer.vehicle
                 , viewThickHorizontalSeparator
                 , viewSubtitle <| t I18n.PassengersSubtitle
                 ]
                    ++ viewPassengers t model.state.viewer offer.driver offer.passengers
                    ++ [ viewUserAction t availableUserAction
                       ]
                )


viewThickHorizontalSeparator : Html Msg
viewThickHorizontalSeparator =
    div [ class "thick-horizontal-separator" ] [ hr [] [] ]


viewThinHorizontalSeparator : Html Msg
viewThinHorizontalSeparator =
    div [ class "thin-horizontal-separator" ] [ hr [] [] ]


viewDriver : State.Model -> I18n.TranslationFn -> Offer.Driver -> Html Msg
viewDriver state t driver =
    let
        maybeUserId =
            Viewer.toUserId state.viewer

        ( tagline, amIDriver ) =
            case maybeUserId of
                Just userId ->
                    if userId == driver.id then
                        ( t I18n.You, True )

                    else
                        ( t I18n.DriverTagline, False )

                Nothing ->
                    ( "", False )
    in
    div []
        [ a [ class "driver", href ("/user/" ++ driver.id) ]
            [ div [ class "name" ] [ text driver.firstName ]
            , div [ class "tagline" ] [ text tagline ]
            , div [ class "avatar" ] [ Image.avatarToImg driver.avatar ]
            , div [ class "arrow" ] [ SvgIcons.rightArrowTip ]
            ]
        , Utils.viewIf (not amIDriver) (viewDriverContact t)
        ]


viewDriverContact : I18n.TranslationFn -> Html Msg
viewDriverContact t =
    div [ class "icon-and-text", class "contact" ]
        [ SvgIcons.speechBubble
        , div [] [ text <| t I18n.ContactYourDriver ]
        ]


viewCondition : Svg Msg -> String -> Html Msg
viewCondition icon message =
    div [ class "icon-and-text", class "condition" ] [ icon, div [] [ text message ] ]


viewVehicle : Vehicle.Model -> Html Msg
viewVehicle vehicle =
    div [ class "vehicle" ]
        [ div [ class "name" ] [ text vehicle.name ]
        , div [ class "description" ] [ text vehicle.description ]
        , div [ class "avatar" ] [ Image.avatarToImg vehicle.avatar ]
        ]


viewSubtitle : String -> Html Msg
viewSubtitle content =
    div [ class "subtitle" ] [ text content ]


viewPassengers : I18n.TranslationFn -> Viewer.Model -> Offer.Driver -> List Offer.Passenger -> List (Html Msg)
viewPassengers t viewer driver maybePassengers =
    let
        areTherePassengers =
            List.length maybePassengers > 0

        viewPassengersRecursive passengers =
            case passengers of
                [] ->
                    []

                x :: xs ->
                    viewPassenger t viewer driver x :: viewPassengersRecursive xs
    in
    if areTherePassengers then
        viewPassengersRecursive maybePassengers

    else
        [ div [ class "notice" ] [ SvgIcons.notice, div [] [ text <| t I18n.BeTheFirstPassenger ] ] ]


viewPassenger : I18n.TranslationFn -> Viewer.Model -> Offer.Driver -> Offer.Passenger -> Html Msg
viewPassenger t viewer driver passenger =
    let
        emptyContact =
            div [ class "contact" ] []

        contact =
            case ( Viewer.toUserId viewer, passenger.contact ) of
                ( Just userId, _ ) ->
                    if userId == driver.id then
                        a [ class "contact" ]
                            [ SvgIcons.speechBubble
                            , span [] [ text <| t I18n.ContactThePassenger ]
                            ]

                    else
                        emptyContact

                _ ->
                    emptyContact
    in
    div [ class "passenger" ]
        [ div [ class "name" ] [ text passenger.firstName ]
        , contact
        , a [ class "profile", href ("/user/" ++ passenger.id) ]
            [ div [ class "avatar" ] [ Image.avatarToImg passenger.avatar ]
            , SvgIcons.rightArrowTip
            ]
        ]


viewUserAction : I18n.TranslationFn -> AvailableUserAction -> Html Msg
viewUserAction t availableUserAction =
    case availableUserAction of
        CanAccept ->
            div [ class "user-action" ] [ button [ class "confirm", onClick ToggleOffer ] [ text <| t I18n.Reserve ] ]

        CanCancel ->
            div [ class "user-action" ] [ button [ class "cancel", onClick ToggleOffer ] [ text <| t I18n.Cancel ] ]

        NoActionAvailable ->
            Utils.emptyHtml



-- INIT


init : State.Model -> Suggestion.SuggestionId -> ( Model, Cmd Msg )
init state id =
    ( { state = state
      , offer = Loading
      }
    , Task.attempt GotOffer (Offer.getOffer state.viewer id)
    )
