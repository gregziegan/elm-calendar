module Calendar
    exposing
        ( init
        , State
        , Msg
        , update
        , page
        , changeTimespan
        , view
        , viewConfig
        , ViewConfig
        , eventConfig
        , EventConfig
        , timeSlotConfig
        , TimeSlotConfig
        )

{-|

Hey it's a calendar!

# Definition
@docs init, State

# Update
@docs Msg, update, page, changeTimespan, eventConfig, EventConfig, timeSlotConfig, TimeSlotConfig

# View
@docs view, viewConfig, ViewConfig
-}

import Html exposing (..)
import Date exposing (Date)
import Config
import Helpers
import Calendar.Calendar as Internal
import Calendar.Msg
import Html.App as Html


{-| Create the calendar
-}
init : String -> Date -> State
init timespan viewing =
    State <| Internal.init timespan viewing


{-| I won't tell you what's in here
-}
type State
    = State Internal.State


{-| Somehow update plz
-}
type Msg
    = Internal Calendar.Msg.Msg


{-| oh yes, please solve my UI update problems
-}
update : EventConfig msg event -> TimeSlotConfig msg -> Msg -> State -> ( State, Maybe msg )
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
changeTimespan : Helpers.TimeSpan -> State -> State
changeTimespan timespan (State state) =
    State <| Internal.changeTimespan timespan state


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
type EventConfig msg event
    = EventConfig (Config.EventConfig msg event)


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
    { onClick : event -> Maybe msg
    , onMouseEnter : event -> Maybe msg
    , onMouseLeave : event -> Maybe msg
    , onDragStart : event -> Maybe msg
    , onDragging : event -> Maybe msg
    , onDragEnd : event -> Maybe msg
    }
    -> EventConfig msg event
eventConfig { onClick, onMouseEnter, onMouseLeave, onDragStart, onDragging, onDragEnd } =
    EventConfig
        { onClick = onClick
        , onMouseEnter = onMouseEnter
        , onMouseLeave = onMouseLeave
        , onDragStart = onDragStart
        , onDragging = onDragging
        , onDragEnd = onDragEnd
        }
