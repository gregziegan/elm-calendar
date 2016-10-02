module Calendar.Msg exposing (..)

import Date exposing (Date)
import Helpers exposing (TimeSpan)
import Mouse


type Msg
    = PageBack
    | PageForward
    | ChangeTimeSpan TimeSpan
    | TimeSlotClick Date
    | TimeSlotMouseEnter Date
    | TimeSlotMouseLeave Date
    | TimeSlotDragStart Mouse.Position
    | TimeSlotDragging Mouse.Position
    | TimeSlotDragEnd Mouse.Position
