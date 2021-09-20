module Page.Search exposing (..)

import Api exposing (Viewer, viewerToZone)
import Html exposing (Html, button, div, form, input, text)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Json.Encode as JE
import Ports
import Route exposing (navTo)
import SearchSelect
import Station exposing (Station, getAllStations)
import Task exposing (Task)
import Time
import Utils exposing (Status(..), posixToIsoDate)



-- MODEL


type alias Model =
    { viewer : Viewer
    , stations : Status (List Station)
    , formModel : FormModel
    }


type alias FormModel =
    { departureSearchSelect : SearchSelect.Model
    , arrivalSearchSelect : SearchSelect.Model
    , departureDateTime : Time.Posix
    , problems : List String
    }


toViewer : Model -> Viewer
toViewer model =
    model.viewer


updateViewer : Model -> Viewer -> Model
updateViewer model viewer =
    { model | viewer = viewer }



-- UPDATE


type Msg
    = GotDepartureSelectMsg SearchSelect.Msg
    | GotArrivalSelectMsg SearchSelect.Msg
    | DepartureDateTimeChanged Time.Posix
    | Submit
    | GotStations (Result Http.Error (List Station))
    | GotNowTime Time.Posix
    | GotFormFromStorage JE.Value


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
            let
                departureId =
                    case model.formModel.departureSearchSelect.selectedOption of
                        Nothing ->
                            "N/A"

                        Just id ->
                            id

                arrivalId =
                    case model.formModel.arrivalSearchSelect.selectedOption of
                        Nothing ->
                            "N/A"

                        Just id ->
                            id

                dateTime =
                    Time.posixToMillis model.formModel.departureDateTime
            in
            ( model
            , Cmd.batch
                [ Ports.persistSearchForm <| encodeForm model.formModel
                , Route.navTo model.viewer (Route.Result departureId arrivalId dateTime)
                ]
            )

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
            case Time.posixToMillis time > Time.posixToMillis model.formModel.departureDateTime of
                True ->
                    update (DepartureDateTimeChanged time) model

                False ->
                    ( model, Cmd.none )

        GotFormFromStorage raw ->
            let
                updatedModel =
                    case JD.decodeValue formStorageModelDecoder raw of
                        Ok formStorageModel ->
                            let
                                newFormModel =
                                    updateFormModelWithFormPersistenceModel model.formModel formStorageModel
                            in
                            ( { model | formModel = newFormModel }, Cmd.none )

                        Err err ->
                            let
                                e =
                                    Debug.log "err" err
                            in
                            ( model, Cmd.none )
            in
            updatedModel



-- View


view : Model -> Html Msg
view ({ viewer, stations, formModel } as model) =
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
                    , viewDateTime DepartureDateTimeChanged (viewerToZone viewer) formModel.departureDateTime
                    , button [ type_ "submit" ] [ text "Submit" ]
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
    input [ type_ "date", class "date-input", onInput msgStringToPosix, value <| posixToIsoDate zone posix ] []



-- INIT


init : Viewer -> ( Model, Cmd Msg )
init viewer =
    ( { viewer = viewer
      , stations = Loading
      , formModel = initForm
      }
    , Cmd.batch
        [ Task.perform GotNowTime Time.now
        , Ports.requestSearchFormFromStorage ()
        , Task.attempt GotStations (getAllStations viewer)
        ]
    )


initForm : FormModel
initForm =
    { departureSearchSelect =
        { search = ""
        , options = []
        , selectedOption = Nothing
        , isFocused = False
        , placeholder = "From..."
        }
    , arrivalSearchSelect =
        { search = ""
        , options = []
        , selectedOption = Nothing
        , isFocused = False
        , placeholder = "To..."
        }
    , departureDateTime = Time.millisToPosix 0
    , problems = []
    }



-- ENCODE


encodeForm : FormModel -> JE.Value
encodeForm formModel =
    JE.object
        [ ( "departureStationId"
          , formModel.departureSearchSelect.selectedOption
                |> Maybe.map JE.string
                |> Maybe.withDefault JE.null
          )
        , ( "arrivalStationId"
          , formModel.arrivalSearchSelect.selectedOption
                |> Maybe.map JE.string
                |> Maybe.withDefault JE.null
          )
        , ( "departureDateTime", JE.int <| Time.posixToMillis formModel.departureDateTime )
        ]


type alias FormStorageModel =
    { departureStationId : Maybe String
    , arrivalStationId : Maybe String
    , departureDateTime : Int
    }


formStorageModelDecoder : JD.Decoder FormStorageModel
formStorageModelDecoder =
    JD.succeed FormStorageModel
        |> JDP.optional "departureStationId" (JD.map Just JD.string) Nothing
        |> JDP.optional "arrivalStationId" (JD.map Just JD.string) Nothing
        |> JDP.required "departureDateTime" JD.int


updateFormModelWithFormPersistenceModel : FormModel -> FormStorageModel -> FormModel
updateFormModelWithFormPersistenceModel formModel formPersistenceModel =
    let
        departureSearchSelect =
            formModel.departureSearchSelect

        arrivalSearchSelect =
            formModel.arrivalSearchSelect
    in
    { formModel
        | departureSearchSelect = { departureSearchSelect | selectedOption = formPersistenceModel.departureStationId }
        , arrivalSearchSelect = { arrivalSearchSelect | selectedOption = formPersistenceModel.arrivalStationId }
        , departureDateTime = Time.millisToPosix formPersistenceModel.departureDateTime
    }
