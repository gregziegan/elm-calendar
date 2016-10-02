module Calendar.Msg exposing (..)

import Date exposing (Date)
import Helpers exposing (TimeSpan)


type Msg
    = PageBack
    | PageForward
    | ChangeTimeSpan TimeSpan
    | TimeSlotClick Date
