port module I18n exposing (Language(..), Term(..), TranslationFn, languageChanged, languageDecoder, languageToIdValue, languagesIdValues, persistLanguage, translate, viewFormatedDate)

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
    | Trademark
    | Redirecting
      -- HOME
    | LoadingLocations
    | FailedToLoadLocations
    | LeavingFrom
    | GoingTo
      -- SUGGESTIONS
    | LoadingSuggestions
    | FailedToLoadSuggestions
      -- LOGIN
    | Login
    | Email
    | Password
    | RegisterHere
    | ResetPassword
      -- REGISTER
    | Register
    | FirstName
    | LastName
    | Phone
    | Gender
    | Male
    | Female
    | Other
    | Day
    | Month
    | Year
    | CreateAccount
    | LoginHere
      -- User
    | LoadingUser
    | FailedToLoadUser
    | CompletedDrives Int
    | MemberSince String
      -- NOT FOUND
    | TakeMeToHomePage
      -- OFFER
    | LoadingOffer
    | FailedLoadingOffer
    | NoSeatsAvailable
    | PriceForSinglePerson
    | SmokingIsAllowed
    | SmokingIsNotAllowed
    | PetsAreAllowed
    | PetsAreNotAllowed
    | PassengersSubtitle
    | You
    | DriverTagline
    | ContactYourDriver
    | BeTheFirstPassenger
    | ContactThePassenger
    | Reserve
    | Cancel
    | TripDuration



-- OFFER


type alias TranslationFn =
    Term -> String


translate : Language -> TranslationFn
translate lang term =
    case lang of
        Eng ->
            case term of
                -- MAIN
                DefaultAppTitle ->
                    "TruchCar"

                Trademark ->
                    "TruchCar©"

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

                -- LOGIN
                Login ->
                    "Log in"

                Email ->
                    "Email"

                Password ->
                    "Password"

                RegisterHere ->
                    "Don't have an account? Register here."

                ResetPassword ->
                    "Did you forget your password? Let's reset it."

                -- REGISTER
                Register ->
                    "Create a new account"

                FirstName ->
                    "First name"

                LastName ->
                    "Last name"

                Phone ->
                    "Phone number"

                Gender ->
                    "Gender"

                Male ->
                    "Male"

                Female ->
                    "Female"

                Other ->
                    "Other"

                Day ->
                    "Day"

                Month ->
                    "Month"

                Year ->
                    "Year"

                CreateAccount ->
                    "Create account"

                LoginHere ->
                    "Already have an account? Log in here."

                -- User
                LoadingUser ->
                    "Loading user..."

                FailedToLoadUser ->
                    "Failed to load user."

                CompletedDrives count ->
                    "Completed " ++ String.fromInt count ++ " drives."

                MemberSince date ->
                    "Member since " ++ date

                -- NOT FOUND
                TakeMeToHomePage ->
                    "Take me to the home page."

                -- OFFER
                LoadingOffer ->
                    "Loading offer..."

                FailedLoadingOffer ->
                    "Failed to load offer."

                NoSeatsAvailable ->
                    "No seats are available."

                PriceForSinglePerson ->
                    "Price for a single person."

                SmokingIsAllowed ->
                    "Smoking is allowed."

                SmokingIsNotAllowed ->
                    "Smoking is not allowed."

                PetsAreAllowed ->
                    "Pets are allowed."

                PetsAreNotAllowed ->
                    "Pets are not allowed."

                PassengersSubtitle ->
                    "Passengers"

                You ->
                    "You"

                DriverTagline ->
                    "Driver"

                ContactYourDriver ->
                    "Contact your driver"

                BeTheFirstPassenger ->
                    "Be the first passenger."

                ContactThePassenger ->
                    "Contact the passenger"

                Reserve ->
                    "Reserve a seat"

                Cancel ->
                    "Cancel the reservation"

                TripDuration ->
                    "Trip duration"

        Srb ->
            case term of
                -- MAIN
                DefaultAppTitle ->
                    "Truć Kar"

                Trademark ->
                    "Truć Kar©"

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

                -- LOGIN
                Login ->
                    "Prijavite se"

                Email ->
                    "Email"

                Password ->
                    "Šifra"

                RegisterHere ->
                    "Nemate nalog? Registrujte se ovde."

                ResetPassword ->
                    "Da li ste zaboravili Vašu šifru? Restartujte je ovde."

                -- REGISTER
                Register ->
                    "Napravite novi profil"

                FirstName ->
                    "Ime"

                LastName ->
                    "Prezime"

                Phone ->
                    "Broj telefona"

                Gender ->
                    "Pol"

                Male ->
                    "Muški"

                Female ->
                    "Ženski"

                Other ->
                    "Drugo"

                Day ->
                    "Dan"

                Month ->
                    "Mesec"

                Year ->
                    "Godina"

                CreateAccount ->
                    "Napravite profil"

                LoginHere ->
                    "Već imate profil? Prijavite se ovde."

                -- User
                LoadingUser ->
                    "Učitavanje profila korisnika..."

                FailedToLoadUser ->
                    "Neuspešno učitavanje profila korisnika..."

                CompletedDrives count ->
                    "Učestvovao u " ++ String.fromInt count ++ " vožnji."

                MemberSince date ->
                    "Član od " ++ date

                -- NOT FOUND
                TakeMeToHomePage ->
                    "Odvedi me na početnu stranicu."

                -- OFFER
                LoadingOffer ->
                    "Učitavanje ponude..."

                FailedLoadingOffer ->
                    "Učitavanje ponude nije uspelo."

                NoSeatsAvailable ->
                    "Nema slobodnih mesta."

                PriceForSinglePerson ->
                    "Cena vožnje za jednu osobu."

                SmokingIsAllowed ->
                    "Pušenje je dozvoljeno."

                SmokingIsNotAllowed ->
                    "Pušenje nije dozvoljeno."

                PetsAreAllowed ->
                    "Kućni ljubimci su dozvoljeni."

                PetsAreNotAllowed ->
                    "Kućni ljubimci nisu dozvoljeni."

                PassengersSubtitle ->
                    "Putnici"

                You ->
                    "Vi."

                DriverTagline ->
                    "Vozač"

                ContactYourDriver ->
                    "Kontaktirajte vozača"

                BeTheFirstPassenger ->
                    "Budite prvi putnik."

                ContactThePassenger ->
                    "Kontaktirajte putnika"

                Reserve ->
                    "Rezervišite vožnju"

                Cancel ->
                    "Otkažite rezervaciju"

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

                    Just "sr-RS-Latin" ->
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
            ( "sr-RS-Latin", "Serbian" )



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



-- PORTS


port persistLanguage : String -> Cmd msg


port languageChanged : (JD.Value -> msg) -> Sub msg
