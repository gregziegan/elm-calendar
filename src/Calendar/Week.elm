module Calendar.Week exposing (..)


viewWeekContent { viewing } days =
    div [ styleWeekContent ]
        ([ viewTimeGutter viewing ] ++ (List.map viewWeekDay days))


viewWeekDay day =
    div [ styleDay ]
        [ viewDaySlot day
        ]


viewWeek state days =
    div [ styleWeek ]
        [ viewWeekHeader days
        , viewWeekContent state days
        ]


viewWeekHeader days =
    div [ styleWeekHeader ]
        [ viewDates days
        , viewAllDayCell days
        ]


viewDates days =
    div [ styleDates ]
        (viewTimeGutterHeader :: List.map viewDate days)
