module I18n exposing (Language(..), Term(..), TransFn, languageDecoder, languageToIdValue, languagesIdValues, translate, viewFormatedDate)

import Html
import Html.Attributes
import Json.Decode as JD
import Time
import Utils


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
                    Just "en-US" ->
                        JD.succeed Eng

                    Just "sr-RS" ->
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
            ( "en-US", "English" )

        Srb ->
            ( "sr-RS", "Serbian" )



-- HTML


viewFormatedDate : Language -> Time.Zone -> Time.Posix -> Html.Html msg
viewFormatedDate lang zone posix =
    let
        langStr =
            Tuple.first <| languageToIdValue lang

        year =
            Time.toYear zone posix

        month =
            Utils.toJSMonth zone posix

        day =
            Time.toDay zone posix
    in
    Html.node "intl-date"
        [ Html.Attributes.attribute "lang" langStr
        , Html.Attributes.attribute "year" (String.fromInt year)
        , Html.Attributes.attribute "month" (String.fromInt month)
        , Html.Attributes.attribute "day" (String.fromInt day)
        ]
        []
