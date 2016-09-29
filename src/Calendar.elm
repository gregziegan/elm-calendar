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
        )

{-|

Hey it's a calendar!

# Definition
@docs init, State

# Update
@docs Msg, update, page, changeTimespan

# View
@docs view, viewConfig, ViewConfig
-}

import Html exposing (..)
import Date exposing (Date)
import Config exposing (ViewConfig, defaultConfig)
import Helpers
import Calendar.Calendar as Internal
import Html.App as Html


{-| Create the calendar
-}
init : String -> Date -> State
init timespan viewing =
    State
        { timespan = timespan
        , viewing = viewing
        }


{-| I won't tell you what's in here
-}
type State
    = State Internal.State


{-| Somehow update plz
-}
type Msg
    = Internal Internal.Msg


{-| oh yes, please solve my UI update problems
-}
update : Msg -> State -> State
update (Internal msg) (State state) =
    State <| Internal.update msg state


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


{-| Configure definition
-}
type ViewConfig event
    = ViewConfig (Config.ViewConfig event)


{-| configure it
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
