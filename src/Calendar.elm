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

import Html exposing (..)
import Date exposing (Date)
import Config exposing (ViewConfig, defaultConfig)
import Helpers
import Calendar.Calendar as Internal
import Html.App as Html


type State
    = State Internal.State


init : String -> Date -> State
init timespan viewing =
    State
        { timespan = timespan
        , viewing = viewing
        }


type Msg
    = Internal Internal.Msg


update : Msg -> State -> State
update (Internal msg) (State state) =
    State <| Internal.update msg state


page : Int -> State -> State
page step (State state) =
    State <| Internal.page step state


changeTimespan : Helpers.TimeSpan -> State -> State
changeTimespan timespan (State state) =
    State <| Internal.changeTimespan timespan state


view : ViewConfig event -> List event -> State -> Html Msg
view (ViewConfig config) events (State state) =
    Html.map Internal (Internal.view config events state)


type ViewConfig event
    = ViewConfig (Config.ViewConfig event)


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
