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
      -- SUGGESTIONS
    | LoadingSuggestions
    | FailedToLoadSuggestions
    | TripDuration


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
                LoadingSuggestions ->
                    "Loading schedules..."

                FailedToLoadSuggestions ->
                    "Failed to load schedules."

                TripDuration ->
                    "Trip duration"

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
                LoadingSuggestions ->
                    "Učitavanje rasporeda..."

                FailedToLoadSuggestions ->
                    "Neuspešno učitavanje rasporeda."

                TripDuration ->
                    "Dužina puta"


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
