module Helpers exposing (..)

import Date exposing (Date)
import Date.Extra


hourString : Date -> String
hourString date =
    Date.Extra.toFormattedString "h:mm a" date


hours : Date -> List Date
hours date =
    let
        midnight =
            Date.Extra.floor Date.Extra.Day date

        lastHour =
            Date.Extra.ceiling Date.Extra.Day date
    in
        Date.Extra.range Date.Extra.Hour 1 midnight lastHour


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


type TimeSpan
    = Month
    | Week
    | Day
    | Agenda


toTimeSpan : String -> TimeSpan
toTimeSpan timespan =
    case timespan of
        "Month" ->
            Month

        "Week" ->
            Week

        "Day" ->
            Day

        "Agenda" ->
            Agenda

        _ ->
            Month


fromTimeSpan : TimeSpan -> String
fromTimeSpan timespan =
    case timespan of
        Month ->
            "Month"

        Week ->
            "Week"

        Day ->
            "Day"

        Agenda ->
            "Agenda"
