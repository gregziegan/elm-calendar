module Messages exposing (..)

import Calendar
import Date exposing (Date)
import Mouse
import Routing exposing (Route)


type Msg
    = UrlUpdate Route
    | NavigateTo Route
    | SetCalendarState Calendar.Msg
    | SelectDate Date Mouse.Position
    | EventClick String
    | CloseDialog
