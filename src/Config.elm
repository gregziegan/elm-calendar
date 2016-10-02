module Config exposing (..)

import Date exposing (Date)


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
    , onDragStart : Date -> Maybe msg
    , onDragging : Date -> Maybe msg
    , onDragEnd : Date -> Maybe msg
    }


type alias EventConfig msg event =
    { onClick : event -> Maybe msg
    , onMouseEnter : event -> Maybe msg
    , onMouseLeave : event -> Maybe msg
    , onDragStart : event -> Maybe msg
    , onDragging : event -> Maybe msg
    , onDragEnd : event -> Maybe msg
    }
