module Page.Register exposing (..)

import Api
import Form as F
import Html exposing (Html, a, button, div, form, h1, option, select, text)
import Html.Attributes exposing (class, disabled, hidden, href, name, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Route
import State
import Task exposing (Task)
import User



-- MODEL


type alias Model =
    { state : State.Model
    , firstName : String
    , lastName : String
    , gender : Maybe User.Gender
    , dateOfBirth :
        { day : Maybe Int
        , month : Maybe Int
        , year : Maybe Int
        }
    , phone : String
    , email : String
    , password : String
    , problems : List String
    }



-- UPDATE


type Msg
    = FirstNameChanged String
    | LastNameChanged String
    | GenderChanged User.Gender
    | DayChanged Int
    | MonthChanged Int
    | YearChanged Int
    | PhoneChanged String
    | EmailChanged String
    | PasswordChanged String
    | Submit
    | GotToken (Result Http.Error Api.Token)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FirstNameChanged firstName ->
            ( { model | firstName = firstName }, Cmd.none )

        LastNameChanged lastName ->
            ( { model | lastName = lastName }, Cmd.none )

        GenderChanged gender ->
            ( { model | gender = Just gender }, Cmd.none )

        DayChanged day ->
            let
                dateOfBirth =
                    model.dateOfBirth
            in
            ( { model | dateOfBirth = { dateOfBirth | day = Just day } }, Cmd.none )

        MonthChanged month ->
            let
                dateOfBirth =
                    model.dateOfBirth
            in
            ( { model | dateOfBirth = { dateOfBirth | month = Just month } }, Cmd.none )

        YearChanged year ->
            let
                dateOfBirth =
                    model.dateOfBirth
            in
            ( { model | dateOfBirth = { dateOfBirth | year = Just year } }, Cmd.none )

        PhoneChanged phone ->
            ( { model | phone = phone }, Cmd.none )

        EmailChanged email ->
            ( { model | email = email }, Cmd.none )

        PasswordChanged password ->
            ( { model | password = password }, Cmd.none )

        Submit ->
            ( model, Task.attempt GotToken <| Api.login { email = model.email, password = model.password } )

        GotToken res ->
            case res of
                Ok token ->
                    ( model, Route.navTo model.state.navKey Route.Login )

                Err err ->
                    case err of
                        _ ->
                            let
                                _ =
                                    Debug.log "Failed to retrieve the token" err
                            in
                            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "register-page" ]
        [ h1 [] [ {- i18n -} text "Create a new account" ]
        , form [ onSubmit Submit ]
            [ F.viewInput
                { type_ = "text"
                , name = "firstName"
                , placeholder = {- i18n -} "First name"
                , label = {- i18n -} "First name"
                , value = model.firstName
                , onInput = FirstNameChanged
                }
            , F.viewInput
                { type_ = "text"
                , name = "lastName"
                , placeholder = {- i18n -} "Last name"
                , label = {- i18n -} "Last name"
                , value = model.lastName
                , onInput = LastNameChanged
                }
            , viewGender model.gender
            , viewDateOfBirth model
            , F.viewInput
                { type_ = "text"
                , name = "phone"
                , placeholder = {- i18n -} "Phone number"
                , label = {- i18n -} "Phone number"
                , value = model.phone
                , onInput = PhoneChanged
                }
            , F.viewInput
                { type_ = "email"
                , name = "email"
                , placeholder = {- i18n -} "E-mail"
                , label = {- i18n -} "E-mail"
                , value = model.email
                , onInput = EmailChanged
                }
            , F.viewInput
                { type_ = "password"
                , name = "password"
                , placeholder = {- i18n -} "Password"
                , label = {- i18n -} "Password"
                , value = model.password
                , onInput = PasswordChanged
                }
            , button [ type_ "submit", disabled True ] [ {- i18n -} text "Create account" ]
            ]
        , a [ class "alternative", href (Route.routeToString Route.Login) ] [ {- i18n -} text "Already have an account? Log in here." ]
        , a [ class "alternative", href "" ] [ {- i18n -} text "Did you forget your password? Let's reset it." ]
        ]


viewGender : Maybe User.Gender -> Html Msg
viewGender maybeGender =
    F.viewSelect
        { name = "gender"
        , placeholder = {- i18n -} "Gender"
        , label = {- i18n -} "Gender"
        , options =
            [ ( "male", {- i18n -} "Male" )
            , ( "female", {- i18n -} "Female" )
            , ( "other", {- i18n -} "Other" )
            ]
        , selected =
            case maybeGender of
                Nothing ->
                    Nothing

                Just User.Male ->
                    Just "male"

                Just User.Female ->
                    Just "female"

                Just User.Other ->
                    Just "other"
        , onInput =
            \str ->
                case str of
                    "male" ->
                        GenderChanged User.Male

                    "female" ->
                        GenderChanged User.Female

                    _ ->
                        GenderChanged User.Other
        }


viewDateOfBirth : Model -> Html Msg
viewDateOfBirth model =
    let
        segmentChanged : (Int -> Msg) -> String -> Msg
        segmentChanged msg value =
            case String.toInt value of
                Just num ->
                    msg num

                Nothing ->
                    msg 1

        viewSelect : (Int -> Msg) -> String -> String -> List Int -> Html Msg
        viewSelect msg name_ placeholder xs =
            select [ name name_, onInput <| segmentChanged msg ]
                (option
                    [ hidden True, value "" ]
                    [ {- i18n -} text placeholder ]
                    :: List.map
                        (\x ->
                            option [ value <| String.fromInt x ] [ text <| String.fromInt x ]
                        )
                        xs
                )
    in
    div [ class "date-of-birth" ]
        [ viewSelect DayChanged "day" "Day" (List.range 1 31)
        , viewSelect MonthChanged "month" "Month" (List.range 1 12)
        , viewSelect YearChanged "year" "Year" (List.range 1900 2021 |> List.reverse)
        ]



-- INIT


init : State.Model -> ( Model, Cmd Msg )
init state =
    ( { state = state
      , firstName = ""
      , lastName = ""
      , gender = Nothing
      , dateOfBirth =
            { day = Nothing
            , month = Nothing
            , year = Nothing
            }
      , phone = ""
      , email = ""
      , password = ""
      , problems = []
      }
    , Cmd.none
    )



-- HTTP


type alias PostLoginModel =
    { email : String
    , password : String
    }
