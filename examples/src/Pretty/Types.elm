module Pretty.Types exposing (..)

import Date exposing (Date)


type alias Event =
    { id : String
    , title : String
    , start : Date
    , end : Date
    }


type Route
    = CalendarRoute
    | EventRoute String
