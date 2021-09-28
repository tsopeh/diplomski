module I18n exposing (Language(..), Term(..), TransFn, languageDecoder, languageToIdValue, languagesIdValues, translate)

import Json.Decode as JD


type Language
    = Eng
    | Srb


type Term
    = -- MAIN
      DefaultAppTitle
    | Redirecting
      -- HOME
    | LoadingLocations
    | FailedToLoadLocations
    | LeavingFrom
    | GoingTo
      -- SEARCH RESULTS
    | LoadingBriefSchedules
    | FailedToLoadBriefSchedules
    | TripDuration
    | SearchResults_Train String
    | SearchResults_StartingPrice Float
    | Latency Int
      -- SCHEDULE
    | LoadingSchedule
    | FailedToLoadSchedule
    | Schedule_Train
    | StationName
    | TimeOfArrival
    | TimeOfDeparture


type alias TransFn =
    Term -> String


translate : Language -> TransFn
translate lang term =
    case lang of
        Eng ->
            case term of
                -- MAIN
                DefaultAppTitle ->
                    "Truch Car"

                Redirecting ->
                    "Redirecting..."

                -- HOME
                LoadingLocations ->
                    "Loading locations..."

                FailedToLoadLocations ->
                    "Failed to load locations."

                LeavingFrom ->
                    "Leaving from..."

                GoingTo ->
                    "Going to..."

                -- SEARCH RESULTS
                LoadingBriefSchedules ->
                    "Loading schedules..."

                FailedToLoadBriefSchedules ->
                    "Failed to load schedules."

                TripDuration ->
                    "Trip duration"

                SearchResults_Train trainNumber ->
                    "Train: " ++ trainNumber

                SearchResults_StartingPrice price ->
                    "Ticket starting price: " ++ String.fromFloat price

                Latency latency ->
                    "Latency: " ++ String.fromInt latency

                -- SCHEDULE
                LoadingSchedule ->
                    "Loading schedule..."

                FailedToLoadSchedule ->
                    "Failed to load schedule"

                Schedule_Train ->
                    "Train"

                StationName ->
                    "Location"

                TimeOfArrival ->
                    "Arrival"

                TimeOfDeparture ->
                    "Departure"

        Srb ->
            case term of
                -- MAIN
                DefaultAppTitle ->
                    "Truć Kar"

                Redirecting ->
                    "Učitavanje stranice..."

                -- HOME
                LoadingLocations ->
                    "Ućitavanje lokacija..."

                FailedToLoadLocations ->
                    "Neuspešno učitavanje lokacija."

                LeavingFrom ->
                    "Polazim iz..."

                GoingTo ->
                    "Idem u..."

                -- SEARCH RESULTS
                LoadingBriefSchedules ->
                    "Učitavanje rasporeda..."

                FailedToLoadBriefSchedules ->
                    "Neuspešno učitavanje rasporeda."

                TripDuration ->
                    "Dužina puta"

                SearchResults_Train trainNumber ->
                    "Voz: " ++ trainNumber

                SearchResults_StartingPrice price ->
                    "Početna cena karte: " ++ String.fromFloat price

                Latency latency ->
                    "Kasni: " ++ String.fromInt latency

                -- SCHEDULE
                LoadingSchedule ->
                    "Učitavanje rasporeda..."

                FailedToLoadSchedule ->
                    "Neuspešno učitavanje rasporeda."

                Schedule_Train ->
                    "Voz"

                StationName ->
                    "Stanica"

                TimeOfArrival ->
                    "Dolazak"

                TimeOfDeparture ->
                    "Polazak"


languageDecoder : JD.Decoder Language
languageDecoder =
    JD.maybe JD.string
        |> JD.andThen
            (\str ->
                case str of
                    Just "eng" ->
                        JD.succeed Eng

                    Just "srb-latin" ->
                        JD.succeed Srb

                    _ ->
                        JD.fail "Failed to decode language."
            )



-- ID & VALUE


languagesIdValues : List ( String, String )
languagesIdValues =
    [ languageToIdValue Eng
    , languageToIdValue Srb
    ]


languageToIdValue : Language -> ( String, String )
languageToIdValue language =
    case language of
        Eng ->
            ( "eng", "English" )

        Srb ->
            ( "srb-latin", "Serbian" )
