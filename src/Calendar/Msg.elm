module Calendar.Msg exposing (..)

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
    | TimeSlotClick Date
    | TimeSlotMouseEnter Date
    | TimeSlotMouseLeave Date
    | TimeSlotDragStart Date Mouse.Position
    | TimeSlotDragging Date Mouse.Position
    | TimeSlotDragEnd Date Mouse.Position
    | EventClick String
    | EventMouseEnter String
    | EventMouseLeave String
    | EventDragStart String Mouse.Position
    | EventDragging String Mouse.Position
    | EventDragEnd String Mouse.Position
