module Calendar
    exposing
        ( init
        , State
        , TimeSpan(..)
        , Msg
        , update
        , page
        , changeTimeSpan
        , view
        , viewConfig
        , ViewConfig
        , eventConfig
        , EventConfig
        , timeSlotConfig
        , TimeSlotConfig
        , subscriptions
        )

{-|

Hey it's a calendar!

# Definition
@docs init, State, TimeSpan

# Update
@docs Msg, update, page, changeTimeSpan, eventConfig, EventConfig, timeSlotConfig, TimeSlotConfig, subscriptions

# View
@docs view, viewConfig, ViewConfig
-}

import Html exposing (..)
import Date exposing (Date)
import Config
import Calendar.Calendar as Internal
import Calendar.Msg
import Html.App as Html
import Calendar.Msg as InternalMsg


{-| Create the calendar
-}
init : TimeSpan -> Date -> State
init timeSpan viewing =
    State <| Internal.init (toInternalTimespan timeSpan) viewing


{-| I won't tell you what's in here
-}
type State
    = State Internal.State


{-| All the time spans
-}
type TimeSpan
    = Month
    | Week
    | Day
    | Agenda


{-| Somehow update plz
-}
type Msg
    = Internal Calendar.Msg.Msg


{-| oh yes, please solve my UI update problems
-}
update : EventConfig msg -> TimeSlotConfig msg -> Msg -> State -> ( State, Maybe msg )
update (EventConfig eventConfig) (TimeSlotConfig timeSlotConfig) (Internal msg) (State state) =
    let
        ( updatedCalendar, calendarMsg ) =
            Internal.update eventConfig timeSlotConfig msg state
    in
        ( State updatedCalendar, calendarMsg )


{-| Page by some interval based on the current view: Month, Week, Day
-}
page : Int -> State -> State
page step (State state) =
    State <| Internal.page step state


{-| Change between views like Month, Week, Day, etc.
-}
changeTimeSpan : TimeSpan -> State -> State
changeTimeSpan timeSpan (State state) =
    State <| Internal.changeTimeSpan (toInternalTimespan timeSpan) state


{-| Show me the money
-}
view : ViewConfig event -> List event -> State -> Html Msg
view (ViewConfig config) events (State state) =
    Html.map Internal (Internal.view config events state)


{-| configure view definition
-}
type ViewConfig event
    = ViewConfig (Config.ViewConfig event)


{-| configure time slot interactions
-}
type TimeSlotConfig msg
    = TimeSlotConfig (Config.TimeSlotConfig msg)


{-| configure event interactions
-}
type EventConfig msg
    = EventConfig (Config.EventConfig msg)


{-| configure the view
-}
viewConfig :
    { toId : event -> String
    , title : event -> String
    , start : event -> Date
    , end : event -> Date
    }
    -> ViewConfig event
viewConfig { toId, title, start, end } =
    ViewConfig
        { toId = toId
        , title = title
        , start = start
        , end = end
        }


{-| configure time slot interactions
-}
timeSlotConfig :
    { onClick : Date -> Maybe msg
    , onMouseEnter : Date -> Maybe msg
    , onMouseLeave : Date -> Maybe msg
    , onDragStart : Date -> Maybe msg
    , onDragging : Date -> Maybe msg
    , onDragEnd : Date -> Maybe msg
    }
    -> TimeSlotConfig msg
timeSlotConfig { onClick, onMouseEnter, onMouseLeave, onDragStart, onDragging, onDragEnd } =
    TimeSlotConfig
        { onClick = onClick
        , onMouseEnter = onMouseEnter
        , onMouseLeave = onMouseLeave
        , onDragStart = onDragStart
        , onDragging = onDragging
        , onDragEnd = onDragEnd
        }


{-| configure event interactions
-}
eventConfig :
    { onClick : String -> Maybe msg
    , onMouseEnter : String -> Maybe msg
    , onMouseLeave : String -> Maybe msg
    , onDragStart : String -> Maybe msg
    , onDragging : String -> Maybe msg
    , onDragEnd : String -> Maybe msg
    }
    -> EventConfig msg
eventConfig { onClick, onMouseEnter, onMouseLeave, onDragStart, onDragging, onDragEnd } =
    EventConfig
        { onClick = onClick
        , onMouseEnter = onMouseEnter
        , onMouseLeave = onMouseLeave
        , onDragStart = onDragStart
        , onDragging = onDragging
        , onDragEnd = onDragEnd
        }


{-| drag event subscriptions
-}
subscriptions : State -> Sub Msg
subscriptions (State state) =
    Sub.map Internal (Internal.subscriptions state)


toInternalTimespan : TimeSpan -> InternalMsg.TimeSpan
toInternalTimespan timeSpan =
    case timeSpan of
        Month ->
            InternalMsg.Month

        Week ->
            InternalMsg.Week

        Day ->
            InternalMsg.Day

        Agenda ->
            InternalMsg.Agenda
