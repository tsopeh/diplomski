module Page.Search exposing (..)

import Api exposing (Viewer, createRequestHeaders, handleJsonResponse, viewerToZone)
import Html exposing (Html, button, div, form, input, text)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Json.Encode as JE
import Ports exposing (Flags)
import SearchSelect
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
            ( model, Ports.persistSearchForm <| encodeForm model.formModel )

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
                    JD.list
                        (JD.succeed Station
                            |> JDP.required "id" JD.string
                            |> JDP.required "name" JD.string
                        )
        }



-- INIT


init : Flags -> Viewer -> ( Model, Cmd Msg )
init flags viewer =
    let
        initFormModel =
            case JD.decodeValue (JD.field "searchForm" formModelDecoder) flags of
                Ok formModel ->
                    formModel

                Err _ ->
                    initForm
    in
    ( { viewer = viewer
      , stations = Loading
      , formModel = initFormModel
      }
    , Cmd.batch
        [ Task.perform GotNowTime Time.now
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


type alias FormPersistenceModel =
    { departureStationId : Maybe String
    , arrivalStationId : Maybe String
    , departureDateTime : Int
    }


formModelDecoder : JD.Decoder FormModel
formModelDecoder =
    JD.succeed FormPersistenceModel
        |> JDP.optional "departureStationId" (JD.map Just JD.string) Nothing
        |> JDP.optional "arrivalStationId" (JD.map Just JD.string) Nothing
        |> JDP.required "departureDateTime" JD.int
        |> JD.map formPersistenceModelToFormModel


formPersistenceModelToFormModel : FormPersistenceModel -> FormModel
formPersistenceModelToFormModel formPersistenceModel =
    let
        departureSearchSelect =
            initForm.departureSearchSelect

        arrivalSearchSelect =
            initForm.arrivalSearchSelect
    in
    { initForm
        | departureSearchSelect = { departureSearchSelect | selectedOption = formPersistenceModel.departureStationId }
        , arrivalSearchSelect = { arrivalSearchSelect | selectedOption = formPersistenceModel.arrivalStationId }
        , departureDateTime = Time.millisToPosix formPersistenceModel.departureDateTime
    }
