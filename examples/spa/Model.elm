module Model exposing (..)

import Calendar
import Dict exposing (Dict)
import Fixtures
import Keyboard.Extra
import Models.Event exposing (Event, allEvents)
import Routing exposing (Route)


type alias Model =
    { route : Route
    , calendarState : Calendar.State
    , events : Dict String Event
    , maybeEventDetails : Maybe Event
    , keyboardModel : Keyboard.Extra.Model
    }


initialModel : Route -> Model
initialModel route =
    let
        ( keyboardModel, _ ) =
            Keyboard.Extra.init
    in
        { route = route
        , calendarState = Calendar.init Calendar.Month Fixtures.viewing
        , events = allEvents
        , maybeEventDetails = Nothing
        , keyboardModel = keyboardModel
        }
