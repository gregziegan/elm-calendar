module View.Event exposing (..)

import Html exposing (Html, div, text)
import Messages exposing (Msg)
import Models.Event exposing (Event)


view : Event -> Html Msg
view event =
    div []
        [ text <| "Viewing " ++ event.title ]
