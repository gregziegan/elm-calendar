module Basic exposing (..)

import Html exposing (..)
import Html.App as Html
import Calendar
import Date


main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view
        }


type alias Model =
    { calendarState : Calendar.State }


model : Model
model =
    { calendarState = Calendar.init "Month" (Date.fromTime 1473649550) }


type Msg
    = SetCalendarState Calendar.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCalendarState calendarMsg ->
            { model | calendarState = Calendar.update calendarMsg model.calendarState }


view : Model -> Html Msg
view model =
    div []
        [ Html.map SetCalendarState (Calendar.view model.calendarState) ]
