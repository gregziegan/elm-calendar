module Messages exposing (..)

import Calendar
import Date exposing (Date)
import Keyboard.Extra
import Mouse
import Routing exposing (Route)


type Msg
    = UrlUpdate Route
    | NavigateTo Route
    | SetCalendarState Calendar.Msg
    | SelectDate Date Mouse.Position
    | EventClick String Mouse.Position
    | CloseDialog
    | KeyboardExtraMsg Keyboard.Extra.Msg
