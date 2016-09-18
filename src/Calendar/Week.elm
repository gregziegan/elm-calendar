module Calendar.Week exposing (..)

import Html exposing (..)
import Date exposing (Date)
import Calendar.Day exposing (..)
import DefaultStyles exposing (..)
import Helpers


viewWeekContent : Date -> List Date -> Html msg
viewWeekContent viewing days =
    div [ styleWeekContent ]
        ([ viewTimeGutter viewing ] ++ (List.map viewWeekDay days))


viewWeekDay : Date -> Html msg
viewWeekDay day =
    div [ styleDay ]
        [ viewDaySlot day
        ]


view : Date -> Html msg
view viewing =
    let
        weekRange =
            Helpers.dayRangeOfWeek viewing
    in
        div [ styleWeek ]
            [ viewWeekHeader weekRange
            , viewWeekContent viewing weekRange
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
