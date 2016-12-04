module Pretty.EventPage exposing (..)

import Html exposing (Html, div, text)
import Pretty.Helpers exposing ((=>), (/>))
import Pretty.Types exposing (Event, Route)


type alias Model =
    { event : Event }


init : Event -> ( Model, Cmd Msg )
init event =
    ( { event = event }, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, List (Cmd Msg), Maybe Route )
update msg model =
    model
        => []
        /> Nothing


view : Model -> Html Msg
view model =
    div []
        [ text <| "Viewing " ++ model.event.title ]
