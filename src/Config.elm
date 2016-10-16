module Config exposing (..)

import Date exposing (Date)
import Time exposing (Time)
import Mouse


type alias ViewConfig event =
    { toId : event -> String
    , title : event -> String
    , start : event -> Date
    , end : event -> Date
    }


type alias TimeSlotConfig msg =
    { onClick : Date -> Maybe msg
    , onMouseEnter : Date -> Maybe msg
    , onMouseLeave : Date -> Maybe msg
    , onDragStart : Date -> Mouse.Position -> Maybe msg
    , onDragging : Date -> Mouse.Position -> Maybe msg
    , onDragEnd : Date -> Mouse.Position -> Maybe msg
    }


type alias EventConfig msg =
    { onClick : String -> Maybe msg
    , onMouseEnter : String -> Maybe msg
    , onMouseLeave : String -> Maybe msg
    , onDragStart : String -> Maybe msg
    , onDragging : String -> Time -> Maybe msg
    , onDragEnd : String -> Time -> Maybe msg
    }
