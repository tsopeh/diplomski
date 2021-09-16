module SearchSelect exposing (..)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (classList, title, value)
import Html.Events exposing (onClick, onFocus, onInput)


type alias Model =
    { search : String
    , options : List Option
    , shouldShowOptions : Bool
    , selectedOption : Maybe Option
    }


type alias Option =
    { id : String
    , value : String
    }



-- UPDATE


type Msg
    = SearchChanged String
    | SelectedOptionChanged Option
    | FocusSearchSelect
    | BlurSearchSelect



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchChanged newSearch ->
            ( { model | search = newSearch }, Cmd.none )

        SelectedOptionChanged option ->
            let
                updatedModel =
                    { model | selectedOption = Just option, search = Debug.log "ad" option.value }

                ( afterBlurModel, cmd ) =
                    update BlurSearchSelect updatedModel
            in
            ( afterBlurModel, cmd )

        FocusSearchSelect ->
            ( { model | search = "", shouldShowOptions = True }, Cmd.none )

        BlurSearchSelect ->
            let
                search =
                    case Debug.log "model.selectedOption" model.selectedOption of
                        Nothing ->
                            ""

                        Just option ->
                            option.value
            in
            ( { model | search = search, shouldShowOptions = False }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        visibleOptions =
            List.filter
                (\op ->
                    String.contains (String.toLower model.search) (String.toLower op.value)
                )
                model.options
    in
    div [ classList [ ( "search-select", True ), ( "onTop", model.shouldShowOptions ) ] ]
        [ div
            [ classList [ ( "underlay", True ), ( "hidden", not model.shouldShowOptions ) ]
            , onClick BlurSearchSelect
            ]
            []
        , input
            [ value model.search
            , onInput SearchChanged
            , onFocus FocusSearchSelect
            ]
            []
        , div [ classList [ ( "options", True ), ( "hidden", not model.shouldShowOptions ) ] ] <|
            List.map
                (\op ->
                    div
                        [ classList [ ( "option", True ) ]
                        , onClick (SelectedOptionChanged op)
                        , title op.value
                        ]
                        [ text op.value ]
                )
                visibleOptions
        ]
