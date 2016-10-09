module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Calendar
import Date exposing (Date)
import Fixtures exposing (Event)


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map SetCalendarState (Calendar.subscriptions model.calendarState)


type alias Model =
    { calendarState : Calendar.State }


init : ( Model, Cmd Msg )
init =
    ( { calendarState = Calendar.init Calendar.Month Fixtures.viewing }, Cmd.none )


type Msg
    = SetCalendarState Calendar.Msg


type CalendarMsg
    = SelectDate Date


update : Msg -> Model -> ( Model, Cmd Msg )
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
                        ( newModel, Cmd.none )

                    Just updateMsg ->
                        updateCalendar updateMsg newModel


updateCalendar : CalendarMsg -> Model -> ( Model, Cmd Msg )
updateCalendar msg model =
    case msg of
        SelectDate date ->
            let
                whatDate =
                    Debug.log "date" date
            in
                model ! []


view : Model -> Html Msg
view model =
    div []
        [ Html.map SetCalendarState (Calendar.view viewConfig Fixtures.events model.calendarState) ]


viewConfig : Calendar.ViewConfig Event
viewConfig =
    Calendar.viewConfig Fixtures.viewConfig


eventConfig : Calendar.EventConfig CalendarMsg
eventConfig =
    Calendar.eventConfig
        { onClick = \_ -> Nothing
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \_ -> Nothing
        , onDragEnd = \_ -> Nothing
        }


timeSlotConfig : Calendar.TimeSlotConfig CalendarMsg
timeSlotConfig =
    Calendar.timeSlotConfig
        { onClick = \date -> Just <| SelectDate date
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \_ -> Nothing
        , onDragEnd = \_ -> Nothing
        }
