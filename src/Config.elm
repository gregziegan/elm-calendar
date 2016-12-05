module Config exposing (..)

import Date exposing (Date)
import Time exposing (Time)
import Mouse
import Html exposing (Html, Attribute)
import Calendar.Messages as InternalMsg


type alias EventView =
    { nodeName : String
    , classes : List ( String, Bool )
    , children : List (Html InternalMsg.Msg)
    }


type alias ViewConfig event =
    { toId : event -> String
    , title : event -> String
    , start : event -> Date
    , end : event -> Date
    , event : event -> Bool -> EventView
    }


type alias TimeSlotConfig msg =
    { onClick : Date -> Mouse.Position -> Maybe msg
    , onMouseEnter : Date -> Mouse.Position -> Maybe msg
    , onMouseLeave : Date -> Mouse.Position -> Maybe msg
    , onDragStart : Date -> Mouse.Position -> Maybe msg
    , onDragging : Date -> Mouse.Position -> Maybe msg
    , onDragEnd : Date -> Mouse.Position -> Maybe msg
    }


type alias EventConfig msg =
    { onClick : String -> Mouse.Position -> Maybe msg
    , onMouseEnter : String -> Mouse.Position -> Maybe msg
    , onMouseLeave : String -> Mouse.Position -> Maybe msg
    , onDragStart : String -> Mouse.Position -> Maybe msg
    , onDragging : String -> Mouse.Position -> Time -> Maybe msg
    , onDragEnd : String -> Mouse.Position -> Time -> Maybe msg
    }
