module Config exposing (..)

import Date exposing (Date)
import Time exposing (Time)
import Mouse
import Html exposing (Html, Attribute)
import Calendar.Msg as InternalMsg


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
