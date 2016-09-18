module Calendar.Week exposing (..)

import Html exposing (..)
import Date exposing (Date)
import Calendar.Day exposing (..)
import Config exposing (ViewConfig)
import DefaultStyles exposing (..)
import Helpers


viewWeekContent : ViewConfig event -> List event -> Date -> List Date -> Html msg
viewWeekContent config events viewing days =
    div [ styleWeekContent ]
        ([ viewTimeGutter viewing ] ++ (List.map viewWeekDay days))


viewWeekDay : Date -> Html msg
viewWeekDay day =
    div [ styleDay ]
        [ viewDaySlot day
        ]


view : ViewConfig event -> List event -> Date -> Html msg
view config events viewing =
    let
        weekRange =
            Helpers.dayRangeOfWeek viewing
    in
        div [ styleWeek ]
            [ viewWeekHeader weekRange
            , viewWeekContent config events viewing weekRange
            ]


viewWeekHeader : List Date -> Html msg
viewWeekHeader days =
    div [ styleWeekHeader ]
        [ viewDates days
        , viewAllDayCell days
        ]


viewDates : List Date -> Html msg
viewDates days =
    div [ styleDates ]
        (viewTimeGutterHeader :: List.map viewDate days)
