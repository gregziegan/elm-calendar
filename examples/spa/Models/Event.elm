module Models.Event exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Fixtures


type alias Event =
    { id : String
    , title : String
    , start : Date
    , end : Date
    }


defaultEvent =
    { id = "test"
    , title = "test"
    , start = Date.fromTime 13242341234
    , end = Date.fromTime 13242541234
    }


allEvents : Dict String Event
allEvents =
    Fixtures.events
        |> List.map (\event -> ( event.id, event ))
        |> Dict.fromList
