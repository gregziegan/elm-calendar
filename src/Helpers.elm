module Helpers exposing (..)

import Date.Extra


hourString date =
    Date.Extra.toFormattedString "h:mm a" date


hours date =
    let
        midnight =
            Date.Extra.floor Date.Extra.Day date

        lastHour =
            Date.Extra.ceiling Date.Extra.Day date
    in
        Date.Extra.range Date.Extra.Hour 1 midnight lastHour


eventsGroupedByDate events =
    let
        initEventGroup event =
            { date = event.start, events = [ event ] }

        buildEventGroup event eventGroups =
            let
                restOfEventGroups groups =
                    case List.tail groups of
                        Nothing ->
                            Debug.crash "There should never be Nothing for this list."

                        Just restOfGroups ->
                            restOfGroups
            in
                case List.head eventGroups of
                    Nothing ->
                        [ initEventGroup event ]

                    Just eventGroup ->
                        if Date.Extra.isBetween eventGroup.date (Date.Extra.add Date.Extra.Day 1 eventGroup.date) event.start then
                            { eventGroup | events = event :: eventGroup.events } :: (restOfEventGroups eventGroups)
                        else
                            initEventGroup event :: eventGroups
    in
        List.sortBy (Date.toTime << .start) events
            |> List.foldr buildEventGroup []


getMonthRange : Date -> List (List Date)
getMonthRange date =
    let
        begMonth =
            Date.Extra.floor Date.Extra.Month date

        endMonth =
            Date.Extra.ceiling Date.Extra.Month date

        begOfMonthWeekdayNum =
            Date.Extra.weekdayNumber begMonth

        monthRange =
            Date.Extra.range Date.Extra.Day 1 begMonth endMonth

        previousMonthFirstDate =
            Date.Extra.add Date.Extra.Day (-1 * begOfMonthWeekdayNum) begMonth

        previousMonthRange =
            Date.Extra.range Date.Extra.Day 1 previousMonthFirstDate begMonth

        endOfMonthWeekdayNum =
            Date.Extra.weekdayNumber endMonth

        nextMonthLastDate =
            Date.Extra.add Date.Extra.Day (7 - endOfMonthWeekdayNum) endMonth

        nextMonthRange =
            Date.Extra.range Date.Extra.Day 1 endMonth nextMonthLastDate

        fullRange =
            List.concat [ previousMonthRange, monthRange, nextMonthRange ]
    in
        [ List.take 7 fullRange
        , List.drop 7 <| List.take 14 fullRange
        , List.drop 14 <| List.take 21 fullRange
        , List.drop 21 <| List.take 28 fullRange
        , List.drop 28 <| List.take 35 fullRange
        ]
            ++ if List.length fullRange > 35 then
                [ List.drop 35 <| List.take 42 fullRange ]
               else
                []


dayRangeOfWeek date =
    let
        firstOfWeek =
            Date.Extra.floor Date.Extra.Week date
    in
        Date.Extra.range Date.Extra.Day
            1
            (Date.Extra.floor Date.Extra.Sunday firstOfWeek)
            (Date.Extra.ceiling Date.Extra.Sunday firstOfWeek)
