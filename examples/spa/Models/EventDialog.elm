module Models.EventDialog exposing (..)

import Models.Event exposing (Event)


type alias EventDialog =
    { event : Event
    , left : Int
    , top : Int
    }


init : Int -> Int -> Event -> EventDialog
init left top event =
    { event = event
    , left = left
    , top = top
    }
