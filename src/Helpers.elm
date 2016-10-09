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
        workingDate =
            Date.Extra.add Date.Extra.Day -1 date

        midnight =
            Date.Extra.floor Date.Extra.Day workingDate

        lastHour =
            Date.Extra.ceiling Date.Extra.Day workingDate
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
    Date.Extra.range Date.Extra.Day
        1
        (Date.Extra.floor Date.Extra.Sunday date)
        (Date.Extra.ceiling Date.Extra.Sunday date)
