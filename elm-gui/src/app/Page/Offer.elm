module Page.Offer exposing (..)

import Html exposing (Html, a, button, div, hr, text)
import Html.Attributes exposing (class, href, title)
import Html.Events exposing (onClick)
import Http
import I18n
import Image
import Offer
import Suggestion
import Svg exposing (Svg)
import SvgIcons
import Task
import Utils exposing (Status(..))
import Vehicle
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { viewer : Viewer
    , offer : Status Offer.Model
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = GotOffer (Result Http.Error Offer.Model)
    | AcceptOffer


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotOffer (Ok offer) ->
            ( { model | offer = Loaded offer }, Cmd.none )

        GotOffer (Err e) ->
            let
                _ =
                    Debug.log "Failed to load offer" e
            in
            ( { model | offer = Failed }, Cmd.none )

        AcceptOffer ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    case model.offer of
        Loading ->
            text "Loading..."

        Failed ->
            text "Failed."

        Loaded offer ->
            let
                lang =
                    Viewer.toLanguage model.viewer

                zone =
                    Viewer.toZone model.viewer

                t =
                    Viewer.toI18n model.viewer

                areThereFreeSeats =
                    (offer.numberOfSeats - List.length offer.passengers) > 0
            in
            div [ class "offer-page" ]
                ([ div [ class "departure-date" ] [ I18n.viewFormatedDate lang zone offer.departureDateTime ]
                 , Utils.viewIf (not areThereFreeSeats) <| div [ class "notice" ] [ SvgIcons.notice, div [] [ {- i18n -} text "No seats available" ] ]
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
                    [ div [] [ {- i18n -} text "Price for one person." ]
                    , div [] [ text offer.price ]
                    ]
                 , viewThickHorizontalSeparator
                 , viewUser offer.driver.id offer.driver.firstName {- i18n -} "Your driver." offer.driver.avatar
                 , viewContact
                 , viewThinHorizontalSeparator
                 , viewCondition (SvgIcons.smoking offer.smokingAllowed) <|
                    if offer.smokingAllowed then
                        {- i18n -}
                        "Smoking is allowed."

                    else
                        {- i18n -}
                        "Smoking is not allowed"
                 , viewCondition (SvgIcons.pets offer.petsAllowed) <|
                    if offer.smokingAllowed then
                        {- i18n -}
                        "Pets are allowed."

                    else
                        {- i18n -}
                        "Pets are not allowed"
                 , viewVehicle offer.vehicle
                 , viewThickHorizontalSeparator
                 , {- i18n -} viewSubtitle "Passengers"
                 ]
                    ++ viewPassengers offer.passengers
                    ++ [ Utils.viewIf areThereFreeSeats viewConfirmation
                       ]
                )


viewThickHorizontalSeparator : Html Msg
viewThickHorizontalSeparator =
    div [ class "thick-horizontal-separator" ] [ hr [] [] ]


viewThinHorizontalSeparator : Html Msg
viewThinHorizontalSeparator =
    div [ class "thin-horizontal-separator" ] [ hr [] [] ]


viewUser : String -> String -> String -> Image.Avatar -> Html Msg
viewUser id name tagline avatar =
    a [ class "driver", href ("/user/" ++ id) ]
        [ div [ class "name" ] [ text name ]
        , div [ class "tagline" ] [ text tagline ]
        , div [ class "avatar" ] [ Image.avatarToImg avatar ]
        , div [ class "arrow" ] [ SvgIcons.rightArrowTip ]
        ]


viewContact : Html Msg
viewContact =
    div [ class "icon-and-text", class "contact" ]
        [ SvgIcons.speechBubble
        , div [] [ {- i18n -} text "Contact the driver." ]
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


viewPassengers : List Offer.Passenger -> List (Html Msg)
viewPassengers maybePassengers =
    let
        areTherePassengers =
            List.length maybePassengers > 0

        viewPassengersRecursive passengers =
            case passengers of
                [] ->
                    []

                x :: xs ->
                    viewUser x.id x.firstName "" x.avatar :: viewPassengersRecursive xs
    in
    if areTherePassengers then
        viewPassengersRecursive maybePassengers

    else
        [ div [ class "notice" ] [ SvgIcons.notice, div [] [ {- i18n -} text "Be the first passenger." ] ] ]


viewConfirmation : Html Msg
viewConfirmation =
    div [ class "confirmation" ] [ button [ onClick AcceptOffer ] [ text "Confirm" ] ]



-- INIT


init : Viewer -> Suggestion.SuggestionId -> ( Model, Cmd Msg )
init viewer id =
    ( { viewer = viewer
      , offer = Loading
      }
    , Task.attempt GotOffer (Offer.getOffer viewer id)
    )
