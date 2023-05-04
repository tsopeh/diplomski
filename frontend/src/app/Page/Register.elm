module Page.Register exposing (..)

import Api
import Form as F
import Html exposing (Html, a, button, div, form, h1, option, select, text)
import Html.Attributes exposing (class, hidden, href, name, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import I18n
import Route
import State
import Task exposing (Task)
import User



-- MODEL


type alias Model =
    { state : State.Model
    , form : User.RegisterUser
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
update msg ({ form } as model) =
    case msg of
        FirstNameChanged firstName ->
            ( { model | form = { form | firstName = firstName } }, Cmd.none )

        LastNameChanged lastName ->
            ( { model | form = { form | lastName = lastName } }, Cmd.none )

        GenderChanged gender ->
            ( { model | form = { form | gender = Just gender } }, Cmd.none )

        DayChanged day ->
            let
                dateOfBirth =
                    form.dateOfBirth
            in
            ( { model | form = { form | dateOfBirth = { dateOfBirth | day = Just day } } }, Cmd.none )

        MonthChanged month ->
            let
                dateOfBirth =
                    form.dateOfBirth
            in
            ( { model | form = { form | dateOfBirth = { dateOfBirth | month = Just month } } }, Cmd.none )

        YearChanged year ->
            let
                dateOfBirth =
                    form.dateOfBirth
            in
            ( { model | form = { form | dateOfBirth = { dateOfBirth | year = Just year } } }, Cmd.none )

        PhoneChanged phone ->
            ( { model | form = { form | phone = phone } }, Cmd.none )

        EmailChanged email ->
            ( { model | form = { form | email = email } }, Cmd.none )

        PasswordChanged password ->
            ( { model | form = { form | password = password } }, Cmd.none )

        Submit ->
            ( model, Task.attempt GotToken <| User.register form )

        GotToken res ->
            case res of
                Ok token ->
                    ( model, Api.persistToken (Just <| Api.tokenToString token) )

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
    let
        t =
            State.toI18n model.state
    in
    div [ class "register-page" ]
        [ h1 [] [ text <| t I18n.Register ]
        , form [ onSubmit Submit ]
            [ F.viewInput
                { type_ = "text"
                , name = "firstName"
                , placeholder = t I18n.FirstName
                , label = t I18n.FirstName
                , value = model.form.firstName
                , onInput = FirstNameChanged
                , shouldAutocomplete = False
                }
            , F.viewInput
                { type_ = "text"
                , name = "lastName"
                , placeholder = t I18n.LastName
                , label = t I18n.LastName
                , value = model.form.lastName
                , onInput = LastNameChanged
                , shouldAutocomplete = False
                }
            , viewGender t model.form.gender
            , viewDateOfBirth t model
            , F.viewInput
                { type_ = "text"
                , name = "phone"
                , placeholder = t I18n.Phone
                , label = t I18n.Phone
                , value = model.form.phone
                , onInput = PhoneChanged
                , shouldAutocomplete = False
                }
            , F.viewInput
                { type_ = "email"
                , name = "email"
                , placeholder = t I18n.Email
                , label = t I18n.Email
                , value = model.form.email
                , onInput = EmailChanged
                , shouldAutocomplete = False
                }
            , F.viewInput
                { type_ = "password"
                , name = "password"
                , placeholder = t I18n.Password
                , label = t I18n.Password
                , value = model.form.password
                , onInput = PasswordChanged
                , shouldAutocomplete = False
                }
            , button [ type_ "submit" ] [ text <| t I18n.CreateAccount ]
            ]
        , a [ class "alternative", href (Route.routeToString Route.Login) ] [ text <| t I18n.LoginHere ]
        , a [ class "alternative", href "" ] [ text <| t I18n.ResetPassword ]
        ]


viewGender : I18n.TranslationFn -> Maybe User.Gender -> Html Msg
viewGender t maybeGender =
    F.viewSelect
        { name = "gender"
        , placeholder = t I18n.Gender
        , label = t I18n.Gender
        , options =
            [ ( User.genderToString User.Male, t I18n.Male )
            , ( User.genderToString User.Female, t I18n.Female )
            , ( User.genderToString User.Other, t I18n.Other )
            ]
        , selected =
            case maybeGender of
                Nothing ->
                    Nothing

                Just User.Male ->
                    Just <| User.genderToString User.Male

                Just User.Female ->
                    Just <| User.genderToString User.Female

                Just User.Other ->
                    Just <| User.genderToString User.Other
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


viewDateOfBirth : I18n.TranslationFn -> Model -> Html Msg
viewDateOfBirth t model =
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
                    [ text placeholder ]
                    :: List.map
                        (\x ->
                            option [ value <| String.fromInt x ] [ text <| String.fromInt x ]
                        )
                        xs
                )
    in
    div [ class "date-of-birth" ]
        [ viewSelect DayChanged "day" (t I18n.Day) (List.range 1 31)
        , viewSelect MonthChanged "month" (t I18n.Month) (List.range 1 12)
        , viewSelect YearChanged "year" (t I18n.Year) (List.range 1900 2021 |> List.reverse)
        ]



-- INIT


init : State.Model -> ( Model, Cmd Msg )
init state =
    ( { state = state
      , form =
            { firstName = ""
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
            }
      , problems = []
      }
    , Cmd.none
    )



-- HTTP


type alias PostLoginModel =
    { email : String
    , password : String
    }
