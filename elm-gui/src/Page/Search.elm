module Page.Search exposing (..)

import Api exposing (Viewer, createRequestHeaders, handleJsonResponse)
import Html exposing (Html, div, form, input, text)
import Html.Attributes exposing (class, selected, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Iso8601
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required)
import SearchSelect
import Task exposing (Task)
import Time
import Utils exposing (Status(..), posixToIsoDate)



-- MODEL


type alias Model =
    { viewer : Viewer
    , zone : Time.Zone
    , stations : Status (List Station)
    , formModel : Form
    }


type alias Form =
    { departureSearchSelect : SearchSelect.Model
    , arrivalSearchSelect : SearchSelect.Model
    , departureDateTime : Time.Posix
    , problems : List String
    }



-- UPDATE


type Msg
    = GotDepartureSelectMsg SearchSelect.Msg
    | GotArrivalSelectMsg SearchSelect.Msg
    | DepartureDateTimeChanged Time.Posix
    | Submit
    | GotStations (Result Http.Error (List Station))
    | GotNowTime Time.Posix
    | GotHereZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotDepartureSelectMsg searchSelectMsg ->
            let
                form =
                    model.formModel

                ( updatedSearchModel, searchSelectCmd ) =
                    SearchSelect.update searchSelectMsg form.departureSearchSelect
            in
            ( { model | formModel = { form | departureSearchSelect = updatedSearchModel } }, Cmd.map GotDepartureSelectMsg searchSelectCmd )

        GotArrivalSelectMsg searchSelectMsg ->
            let
                form =
                    model.formModel

                ( updatedSearchModel, searchSelectCmd ) =
                    SearchSelect.update searchSelectMsg form.arrivalSearchSelect
            in
            ( { model | formModel = { form | arrivalSearchSelect = updatedSearchModel } }, Cmd.map GotArrivalSelectMsg searchSelectCmd )

        DepartureDateTimeChanged change ->
            let
                form =
                    model.formModel
            in
            ( { model
                | formModel = { form | departureDateTime = change }
              }
            , Cmd.none
            )

        Submit ->
            ( model, Cmd.none )

        GotStations result ->
            case result of
                Ok stations ->
                    let
                        form =
                            model.formModel

                        departureSearchSelect =
                            form.departureSearchSelect

                        arrivalSearchSelect =
                            form.arrivalSearchSelect

                        options =
                            List.map (\s -> { id = s.id, value = s.name }) stations
                    in
                    ( { model
                        | stations = Loaded stations
                        , formModel =
                            { form
                                | departureSearchSelect =
                                    { departureSearchSelect
                                        | options = options
                                    }
                                , arrivalSearchSelect =
                                    { arrivalSearchSelect
                                        | options = options
                                    }
                            }
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        GotNowTime time ->
            update (DepartureDateTimeChanged time) model

        GotHereZone zone ->
            ( { model | zone = zone }, Cmd.none )



-- View


view : Model -> Html Msg
view ({ viewer, zone, stations, formModel } as model) =
    case stations of
        Loading ->
            text "Loading Stations..."

        Loaded _ ->
            div [ class "search-page" ]
                [ form [ onSubmit Submit ]
                    [ Html.map GotDepartureSelectMsg <|
                        SearchSelect.view formModel.departureSearchSelect
                    , Html.map GotArrivalSelectMsg <|
                        SearchSelect.view formModel.arrivalSearchSelect
                    , viewDateTime DepartureDateTimeChanged zone formModel.departureDateTime
                    ]
                ]

        Failed ->
            text "Failed to load Stations!"


viewDateTime : (Time.Posix -> Msg) -> Time.Zone -> Time.Posix -> Html Msg
viewDateTime msg zone posix =
    let
        msgStringToPosix : String -> Msg
        msgStringToPosix str =
            case Iso8601.toTime str of
                Ok parsedPosix ->
                    msg parsedPosix

                Err _ ->
                    msg posix
    in
    input [ type_ "datetime-local", onInput msgStringToPosix, value <| posixToIsoDate zone posix ] []


type alias Station =
    { id : String
    , name : String
    }


getAllStations : Viewer -> Task Http.Error (List Station)
getAllStations viewer =
    Http.task
        { method = "GET"
        , url = "http://localhost:8080/stations"
        , headers = createRequestHeaders viewer
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver =
            Http.stringResolver <|
                handleJsonResponse <|
                    Decode.list
                        (Decode.succeed Station
                            |> required "id" Decode.string
                            |> required "name" Decode.string
                        )
        }



-- INIT


init : Viewer -> ( Model, Cmd Msg )
init viewer =
    ( { viewer = viewer
      , zone = Time.utc
      , stations = Loading
      , formModel =
            { departureSearchSelect =
                { search = ""
                , options = []
                , shouldShowOptions = False
                , selectedOption = Nothing
                }
            , arrivalSearchSelect =
                { search = ""
                , options = []
                , shouldShowOptions = False
                , selectedOption = Nothing
                }
            , departureDateTime = Time.millisToPosix 0
            , problems = []
            }
      }
    , Cmd.batch
        [ Task.perform GotNowTime Time.now
        , Task.perform GotHereZone Time.here
        , Task.attempt GotStations (getAllStations viewer)
        ]
    )
