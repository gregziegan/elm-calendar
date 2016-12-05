module Calendar.Messages exposing (..)

import Date exposing (Date)
import Mouse


type TimeSpan
    = Month
    | Week
    | Day
    | Agenda


type Msg
    = PageBack
    | PageForward
    | ChangeTimeSpan TimeSpan
    | TimeSlotClick Date Mouse.Position
    | TimeSlotMouseEnter Date Mouse.Position
    | TimeSlotMouseLeave Date Mouse.Position
    | TimeSlotDragStart Date Mouse.Position
    | TimeSlotDragging Date Mouse.Position
    | TimeSlotDragEnd Date Mouse.Position
    | EventClick String Mouse.Position
    | EventMouseEnter String Mouse.Position
    | EventMouseLeave String Mouse.Position
    | EventDragStart String Mouse.Position
    | EventDragging String Mouse.Position
    | EventDragEnd String Mouse.Position
