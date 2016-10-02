module Config exposing (..)

import Date exposing (Date)


type alias ViewConfig event =
    { toId : event -> String
    , title : event -> String
    , start : event -> Date
    , end : event -> Date
    }



-- type alias UpdateConfig msg event =
--     { onClickTimeSlot : Date -> Maybe msg
--     , onMouseEnterTimeSlot : Date -> Maybe msg
--     , onMouseLeaveTimeSlot : Date -> Maybe msg
--     , onDragStartTimeSlot : Date -> Maybe msg
--     , onDraggingTimeSlot : Date -> Maybe msg
--     , onDragEndTimeSlot : Date -> Maybe msg
--     , onClickEvent : event -> Maybe msg
--     , onMouseEnterEvent : event -> Maybe msg
--     , onMouseLeaveEvent : event -> Maybe msg
--     , onDragStartEvent : event -> Maybe msg
--     , onDraggingTimeSlot : event -> Maybe msg
--     , onDragEndTimeSlot : event -> Maybe msg
--     }
-- type alias UpdateConfig msg event =
--     { timeSlots : TimeSlotUpdates msg
--     , eventSlots : EventSlotUpdates msg event
--     }


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


defaultViewConfig =
    { toId = .id
    , title = .title
    , start = .start
    , end = .end
    , onTimeSlotClick = Nothing
    }
