module Helpers exposing (..)

import Date exposing (Date)
import Date.Extra
import List.Extra


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


weekRangesFromMonth : Int -> Date.Month -> List (List Date)
weekRangesFromMonth year month =
    let
        firstOfMonth =
            Date.Extra.fromCalendarDate year month 1

        firstOfNextMonth =
            Date.Extra.add Date.Extra.Month 1 firstOfMonth
    in
        Date.Extra.range Date.Extra.Day
            1
            (Date.Extra.floor Date.Extra.Sunday firstOfMonth)
            (Date.Extra.ceiling Date.Extra.Sunday firstOfNextMonth)
            |> List.Extra.groupsOf 7


dayRangeOfWeek : Date -> List Date
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
