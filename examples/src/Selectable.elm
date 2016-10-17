module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.App as Html
import Calendar
import Date exposing (Date)
import Date.Extra
import Fixtures
import Dict exposing (Dict)
import Time exposing (Time)
import Mouse
import String


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
    , eventPreview : Maybe EventPreview
    , curEventId : String
    }


type alias Event =
    { id : String
    , title : String
    , start : Date
    , end : Date
    }


type alias EventPreview =
    { event : Event
    , position : Mouse.Position
    }


init : ( Model, Cmd Msg )
init =
    ( { calendarState = Calendar.init Calendar.Week Fixtures.viewing
      , events =
            Fixtures.events
                |> List.map (\event -> ( event.id, event ))
                |> Dict.fromList
      , eventExtendAmount = 0
      , eventPreview = Nothing
      , curEventId =
            Fixtures.events
                |> List.map (Result.withDefault 0 << String.toInt << .id)
                |> List.sortWith flippedComparison
                |> List.head
                |> Maybe.withDefault (List.length Fixtures.events)
                |> toString
                |> Debug.log "first?"
      }
    , Cmd.none
    )


type Msg
    = SetCalendarState Calendar.Msg


type CalendarMsg
    = SelectDate Date
    | ExtendingEvent String Time
    | ExtendEvent String Time
    | CreateEventPreview Date Mouse.Position
    | ExtendEventPreview Date Mouse.Position
    | AddEventPreviewToEvents Date Mouse.Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( pureUpdate msg model, Cmd.none )


pureUpdate : Msg -> Model -> Model
pureUpdate msg model =
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
                        updateCalendar updateMsg newModel


updateCalendar : CalendarMsg -> Model -> Model
updateCalendar msg model =
    case Debug.log "calendarMsg" msg of
        SelectDate date ->
            model

        ExtendingEvent _ timeDiff ->
            { model | eventExtendAmount = timeDiff }

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
                        model

                    Just event ->
                        { model | events = updateEvents event }

        CreateEventPreview date xy ->
            let
                newEvent =
                    Event (newEventId model.curEventId) "untitled" date (Date.Extra.add Date.Extra.Minute 30 date)

                eventPreview =
                    { event = newEvent
                    , position = xy
                    }
            in
                { model | eventPreview = Just eventPreview }

        ExtendEventPreview date xy ->
            model
                |> extendEventPreview date xy

        AddEventPreviewToEvents date xy ->
            model
                |> extendEventPreview date xy
                |> addEventPreviewToEvents
                |> removeEventPreview


extendEventPreview : Date -> Mouse.Position -> Model -> Model
extendEventPreview date xy model =
    let
        extend ({ event, position } as eventPreview) =
            { eventPreview | event = { event | end = date } }
    in
        { model | eventPreview = Maybe.map extend model.eventPreview }


addEventPreviewToEvents : Model -> Model
addEventPreviewToEvents model =
    let
        addToEvents event =
            Dict.insert event.id event model.events
    in
        { model
            | events =
                Maybe.map (addToEvents << .event) model.eventPreview
                    |> Maybe.withDefault model.events
            , curEventId = (newEventId model.curEventId)
        }


removeEventPreview : Model -> Model
removeEventPreview model =
    { model | eventPreview = Nothing }


newEventId : String -> String
newEventId eventId =
    String.toInt eventId
        |> Result.withDefault 0
        |> (+) 1
        |> toString
        |> Debug.log "newEventId"


view : Model -> Html Msg
view model =
    let
        events =
            Dict.values model.events
    in
        div []
            [ case model.eventPreview of
                Just preview ->
                    viewCreateEvent preview

                Nothing ->
                    text ""
            , Html.map SetCalendarState (Calendar.view viewConfig events model.calendarState)
            ]


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


viewCreateEvent : EventPreview -> Html Msg
viewCreateEvent { event, position } =
    let
        duration =
            Date.Extra.diff Date.Extra.Minute event.start event.end

        height =
            duration
                // 30
                |> (*) 20
                |> toString

        px str =
            str ++ "px"
    in
        div
            [ class "event-preview"
            , style
                [ "position" => "absolute"
                , "top" => px (toString position.y)
                , "left" => px (toString position.x)
                , "height" => px height
                , "z-index" => "2"
                ]
            ]
            [ text "New Event" ]


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
        , onDragStart = \date xy -> Just <| CreateEventPreview date xy
        , onDragging = \date xy -> Just <| ExtendEventPreview date xy
        , onDragEnd = \date xy -> Just <| AddEventPreviewToEvents date xy
        }


flippedComparison a b =
    case compare a b of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT
