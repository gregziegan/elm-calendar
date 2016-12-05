module Model exposing (..)

import Calendar
import Routing exposing (Route)
import Dict exposing (Dict)
import Fixtures
import Models.Event exposing (Event, allEvents)


type alias Model =
    { route : Route
    , calendarState : Calendar.State
    , events : Dict String Event
    , maybeEventDetails : Maybe Event
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , calendarState = Calendar.init Calendar.Month Fixtures.viewing
    , events = allEvents
    , maybeEventDetails = Nothing
    }
