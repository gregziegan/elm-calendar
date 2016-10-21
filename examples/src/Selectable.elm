module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, style, value)
import Html.Events exposing (onInput, onClick)
import Html.App as Html
import Calendar
import Date exposing (Date)
import Date.Extra
import Fixtures
import Dict exposing (Dict)
import Time exposing (Time)
import Mouse
import String
import Keyboard


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
    Sub.batch
        [ Sub.map SetCalendarState (Calendar.subscriptions model.calendarState)
        , Keyboard.downs CancelEventPreview
        ]


type alias Model =
    { calendarState : Calendar.State
    , events : Dict String Event
    , eventExtendAmount : Time
    , eventPreview : Maybe EventPreview
    , curEventId : String
    , selectedEvent : Maybe Event
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
    , showDialog : Bool
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
      , selectedEvent = Nothing
      }
    , Cmd.none
    )


type Msg
    = SetCalendarState Calendar.Msg
    | CreateEventTitle String
    | AddEventPreviewToEvents
    | CancelEventPreview Int


type CalendarMsg
    = SelectDate Date Mouse.Position
    | CreateEventPreview Date Mouse.Position
    | ExtendEventPreview Date Mouse.Position
    | ShowCreateEventDialog Date Mouse.Position
    | SelectEvent String
    | ExtendingEvent String Time
    | ExtendEvent String Time


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

        CreateEventTitle title ->
            model
                |> changeEventPreviewTitle title

        AddEventPreviewToEvents ->
            model
                |> addEventPreviewToEvents
                |> removeEventPreview

        CancelEventPreview keyCode ->
            case keyCode of
                27 ->
                    model
                        |> removeEventPreview

                _ ->
                    model


updateCalendar : CalendarMsg -> Model -> Model
updateCalendar msg model =
    case Debug.log "calendarMsg" msg of
        SelectDate date xy ->
            model
                |> createEventPreview date xy 30
                |> showCreateEventDialog

        CreateEventPreview date xy ->
            model
                |> createEventPreview date xy 30

        ExtendEventPreview date xy ->
            model
                |> extendEventPreview date xy

        ShowCreateEventDialog date xy ->
            model
                |> extendEventPreview date xy
                |> showCreateEventDialog

        SelectEvent eventId ->
            model
                |> selectEvent eventId

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


createEventPreview : Date -> Mouse.Position -> Int -> Model -> Model
createEventPreview date xy minutes model =
    let
        newEvent =
            Event (newEventId model.curEventId) "" date (Date.Extra.add Date.Extra.Minute minutes date)

        eventPreview =
            { event = newEvent
            , position = xy
            , showDialog = False
            }
    in
        { model | eventPreview = Just eventPreview }


selectEvent : String -> Model -> Model
selectEvent eventId model =
    { model | selectedEvent = Dict.get eventId model.events }


showCreateEventDialog : Model -> Model
showCreateEventDialog model =
    { model | eventPreview = Maybe.map toggleEventPreviewDialog model.eventPreview }


toggleEventPreviewDialog : EventPreview -> EventPreview
toggleEventPreviewDialog eventPreview =
    { eventPreview | showDialog = not eventPreview.showDialog }


changeEventPreviewTitle : String -> Model -> Model
changeEventPreviewTitle title model =
    let
        changeEventTitle event =
            { event | title = title }

        changePreviewTitle preview =
            { preview | event = changeEventTitle preview.event }
    in
        { model | eventPreview = Maybe.map changePreviewTitle model.eventPreview }


extendEventPreview : Date -> Mouse.Position -> Model -> Model
extendEventPreview date xy model =
    let
        extend ({ event, position } as eventPreview) =
            { eventPreview | event = { event | end = Debug.log "finalEnd" date } }
    in
        { model | eventPreview = Maybe.map extend model.eventPreview }


addEventPreviewToEvents : Model -> Model
addEventPreviewToEvents model =
    let
        defaultEmptyTitle event =
            { event
                | title =
                    if event.title == "" then
                        "(No Title)"
                    else
                        event.title
            }

        addToEvents event =
            Dict.insert event.id (Debug.log "newEvent" (defaultEmptyTitle event)) model.events
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


px : String -> String
px str =
    str ++ "px"


viewCreateEvent : EventPreview -> Html Msg
viewCreateEvent ({ event, position, showDialog } as preview) =
    let
        duration =
            Date.Extra.diff Date.Extra.Minute event.start event.end

        height =
            duration
                // 30
                |> (*) 20
                |> toString
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
            [ if showDialog then
                viewCreateEventDialog preview
              else
                text ""
            , text "New Event"
            ]


viewCreateEventDialog : EventPreview -> Html Msg
viewCreateEventDialog { event, position } =
    div
        [ class "create-event-dialog"
        ]
        [ h3 [ class "create-event-title" ] [ text "Create event" ]
        , input
            [ onInput CreateEventTitle
            , value event.title
            , class "create-event-input"
            ]
            []
        , button
            [ onClick AddEventPreviewToEvents
            , class "create-event-button"
            ]
            [ text "Create Event" ]
        ]


viewConfig : Calendar.ViewConfig Event
viewConfig =
    Calendar.viewConfig
        { toId = .id
        , title = .title
        , start = .start
        , end = .end
        , event =
            \event isSelected ->
                Calendar.eventView
                    { nodeName = "div"
                    , classes =
                        [ ( "elm-calendar--event-content", True )
                        , ( "elm-calendar--event-content--is-selected", isSelected )
                        ]
                    , children =
                        [ div []
                            [ text <| event.title ]
                        ]
                    }
        }


eventConfig : Calendar.EventConfig CalendarMsg
eventConfig =
    Calendar.eventConfig
        { onClick = \eventId -> Just <| SelectEvent eventId
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \eventId timeDiff -> Just <| ExtendingEvent eventId timeDiff
        , onDragEnd = \eventId timeDiff -> Just <| ExtendEvent eventId timeDiff
        }


timeSlotConfig : Calendar.TimeSlotConfig CalendarMsg
timeSlotConfig =
    Calendar.timeSlotConfig
        { onClick = \date xy -> Just <| SelectDate date xy
        , onMouseEnter = \_ _ -> Nothing
        , onMouseLeave = \_ _ -> Nothing
        , onDragStart = \date xy -> Just <| CreateEventPreview date xy
        , onDragging = \date xy -> Just <| ExtendEventPreview date xy
        , onDragEnd = \date xy -> Just <| ShowCreateEventDialog date xy
        }


flippedComparison : comparable -> comparable -> Order
flippedComparison a b =
    case compare a b of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT
