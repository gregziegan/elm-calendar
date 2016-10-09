module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Calendar
import Date exposing (Date)
import Time
import Fixtures exposing (Event)


main : Program Never
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
    { calendarState = Calendar.init Calendar.Month Fixtures.viewing }


type Msg
    = SetCalendarState Calendar.Msg
    | SelectDate Date


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCalendarState calendarMsg ->
            let
                ( updatedCalendar, maybeMsg ) =
                    Calendar.update eventConfig timeSlotConfig calendarMsg model.calendarState

                newModel =
                    { model | calendarState = updatedCalendar }
            in
                case maybeMsg of
                    Nothing ->
                        newModel

                    Just updateMsg ->
                        update updateMsg newModel

        SelectDate date ->
            let
                whatDate =
                    Debug.log "date" date
            in
                model


view : Model -> Html Msg
view model =
    div []
        [ Html.map SetCalendarState (Calendar.view viewConfig Fixtures.events model.calendarState) ]


viewConfig : Calendar.ViewConfig Event
viewConfig =
    Calendar.viewConfig Fixtures.viewConfig


eventConfig : Calendar.EventConfig Msg
eventConfig =
    Calendar.eventConfig
        { onClick = \_ -> Nothing
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \_ -> Nothing
        , onDragEnd = \_ -> Nothing
        }


timeSlotConfig : Calendar.TimeSlotConfig Msg
timeSlotConfig =
    Calendar.timeSlotConfig
        { onClick = \date -> Just <| SelectDate date
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \_ -> Nothing
        , onDragEnd = \_ -> Nothing
        }
