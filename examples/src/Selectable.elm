module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Calendar
import Date exposing (Date)
import Fixtures exposing (Event)
import Dict exposing (Dict)
import Time exposing (Time)


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
    { calendarState : Calendar.State
    , events : Dict String Event
    , eventExtendAmount : Time
    }


init : ( Model, Cmd Msg )
init =
    ( { calendarState = Calendar.init Calendar.Month Fixtures.viewing
      , events =
            Fixtures.events
                |> List.map (\event -> ( event.id, event ))
                |> Dict.fromList
      , eventExtendAmount = 0
      }
    , Cmd.none
    )


type Msg
    = SetCalendarState Calendar.Msg


type CalendarMsg
    = SelectDate Date
    | ExtendingEvent String Time
    | ExtendEvent String Time


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

        ExtendingEvent _ timeDiff ->
            ( { model | eventExtendAmount = timeDiff }, Cmd.none )

        ExtendEvent eventId timeDiff ->
            let
                maybeEvent =
                    Dict.get eventId model.events

                newEnd end =
                    Date.toTime end
                        |> (+) timeDiff
                        |> Date.fromTime

                extendEvent event =
                    { event | end = newEnd event.end }

                updateEvents event =
                    Dict.insert eventId (extendEvent event) model.events
            in
                case maybeEvent of
                    Nothing ->
                        ( model, Cmd.none )

                    Just event ->
                        ( { model | events = updateEvents event }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        events =
            Dict.values model.events
    in
        div []
            [ Html.map SetCalendarState (Calendar.view viewConfig events model.calendarState) ]


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
        , onDragging = \eventId timeDiff -> Just <| ExtendingEvent eventId timeDiff
        , onDragEnd = \eventId timeDiff -> Just <| ExtendEvent eventId timeDiff
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
