module Config exposing (..)

import Date exposing (Date)


type alias ViewConfig event =
    { toId : event -> String
    , title : event -> String
    , start : event -> Date
    , end : event -> Date
    }


defaultConfig =
    { toId = .id
    , title = .title
    , start = .start
    , end = .end
    }
