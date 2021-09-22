module Page.Home exposing (..)

import Api exposing (Viewer, toZone)
import Html exposing (Html, button, div, form, input, text)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Iso8601
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Json.Encode as JE
import Ports
import Route
import SearchSelect
import Station exposing (Station, StationId, getAllStations)
import Svg
import Svg.Attributes as SvgAttr
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
                    (case model.formModel.departureSearchSelect.selectedOption of
                        Nothing ->
                            "N/A"

                        Just id ->
                            id
                    )
                        |> Station.stringToId

                arrivalId =
                    (case model.formModel.arrivalSearchSelect.selectedOption of
                        Nothing ->
                            "N/A"

                        Just id ->
                            id
                    )
                        |> Station.stringToId

                dateTime =
                    Time.posixToMillis model.formModel.departureDateTime
            in
            ( model
            , Cmd.batch
                [ Ports.persistSearchForm <| encodeForm model.formModel
                , Route.navTo model.viewer (Route.SearchResults departureId arrivalId dateTime)
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
                            List.map (\s -> { id = Station.idToString s.id, value = s.name }) stations
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
                                _ =
                                    Debug.log "err" err
                            in
                            ( model, Cmd.none )
            in
            updatedModel



-- View


view : Model -> Html Msg
view { viewer, stations, formModel } =
    case stations of
        Loading ->
            text "Loading Stations..."

        Loaded _ ->
            div [ class "home-page" ]
                [ form [ onSubmit Submit ]
                    [ div [ class "fields" ]
                        [ Html.map GotDepartureSelectMsg <|
                            SearchSelect.view formModel.departureSearchSelect
                        , Html.map GotArrivalSelectMsg <|
                            SearchSelect.view formModel.arrivalSearchSelect
                        , viewDateTime DepartureDateTimeChanged (toZone viewer) formModel.departureDateTime
                        ]
                    , button [ type_ "submit" ] [ searchIcon ]
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



-- SVG


searchIcon : Svg.Svg Msg
searchIcon =
    Svg.svg [ SvgAttr.class "search-icon", SvgAttr.version "1.1", SvgAttr.x "0px", SvgAttr.y "0px", SvgAttr.viewBox "0 0 512 512" ]
        [ Svg.path [ SvgAttr.d "M141.367,116.518c-7.384-7.39-19.364-7.39-26.748,0c-27.416,27.416-40.891,65.608-36.975,104.79 c0.977,9.761,9.2,17.037,18.803,17.037c0.631,0,1.267-0.032,1.898-0.095c10.398-1.04,17.983-10.316,16.943-20.707 c-2.787-27.845,6.722-54.92,26.079-74.278C148.757,135.882,148.757,123.901,141.367,116.518z" ]
            []
        , Svg.path [ SvgAttr.d "M216.276,0C97.021,0,0,97.021,0,216.276s97.021,216.276,216.276,216.276s216.276-97.021,216.276-216.276 S335.53,0,216.276,0z M216.276,394.719c-98.396,0-178.443-80.047-178.443-178.443S117.88,37.833,216.276,37.833 c98.39,0,178.443,80.047,178.443,178.443S314.672,394.719,216.276,394.719z" ]
            []
        , Svg.path [ SvgAttr.d "M506.458,479.71L368.999,342.252c-7.39-7.39-19.358-7.39-26.748,0c-7.39,7.384-7.39,19.364,0,26.748L479.71,506.458 c3.695,3.695,8.531,5.542,13.374,5.542c4.843,0,9.679-1.847,13.374-5.542C513.847,499.074,513.847,487.094,506.458,479.71z" ]
            []
        ]
