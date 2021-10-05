module SearchSelect exposing (..)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (class, classList, title, value)
import Html.Events exposing (onBlur, onFocus, onInput, onMouseDown)
import String.Normalize exposing (removeDiacritics)
import Utils exposing (find, viewIf)


type alias Model =
    { search : String
    , options : List Option
    , selectedOption : Maybe String
    , isFocused : Bool
    , placeholder : String
    }


type alias Option =
    { id : String
    , value : String
    }



-- UPDATE


type Msg
    = SearchChanged String
    | SelectedOptionChanged String
    | FocusSearchSelect
    | BlurSearchSelect



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchChanged newSearch ->
            ( { model | search = newSearch }, Cmd.none )

        SelectedOptionChanged id ->
            let
                ( selected, search ) =
                    case find .id id model.options of
                        Nothing ->
                            ( Nothing, model.placeholder )

                        Just option ->
                            ( Just option.id, option.value )

                updatedModel =
                    { model | selectedOption = selected, search = search }
            in
            ( updatedModel, Cmd.none )

        FocusSearchSelect ->
            ( { model | search = "", isFocused = True }, Cmd.none )

        BlurSearchSelect ->
            ( { model | isFocused = False }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        normalizeString str =
            str |> String.toLower |> removeDiacritics

        visibleOptions : List Option
        visibleOptions =
            List.filter
                (\op ->
                    String.contains (normalizeString model.search) (normalizeString op.value)
                )
                model.options
                |> List.take 5

        search =
            case model.isFocused of
                True ->
                    model.search

                False ->
                    case model.selectedOption of
                        Nothing ->
                            model.placeholder

                        Just id ->
                            let
                                found =
                                    find .id id model.options
                            in
                            case found of
                                Just option ->
                                    option.value

                                -- This should never happen in practice.
                                Nothing ->
                                    model.placeholder
    in
    div [ classList [ ( "search-select", True ), ( "onTop", model.isFocused ) ] ]
        [ viewIf model.isFocused <| div [ class "underlay" ] []
        , input
            [ value search
            , onInput SearchChanged
            , onFocus FocusSearchSelect
            , onBlur BlurSearchSelect
            ]
            []
        , viewIf model.isFocused <|
            div [ class "options" ] <|
                List.map
                    (\op ->
                        div
                            [ classList [ ( "option", True ) ]
                            , onMouseDown (SelectedOptionChanged op.id)
                            , title op.value
                            ]
                            [ text op.value ]
                    )
                    visibleOptions
        ]
