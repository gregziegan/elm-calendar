module Tests exposing (..)

import Test exposing (..)
import Expect
import Calendar.Event as Event exposing (EventRange(..))
import Date exposing (..)
import Date.Extra as Date exposing (..)
import Helpers


start : Date
start =
    Date.fromParts 2016 Oct 4 14 30 0 0
        |> Date.add Day 1


end : Date
end =
    start
        |> Date.add Hour 5


dayPrior : Date
dayPrior =
    start
        |> Date.add Day -1


dayAfter : Date
dayAfter =
    Date.add Day 1 start
        |> Date.add Hour 2


weekPrior : Date
weekPrior =
    Date.add Week -1 start
        |> Date.add Hour -2


weekAfter : Date
weekAfter =
    Date.add Week 1 start
        |> Date.add Hour 2


viewing : Date
viewing =
    start
        |> Date.add Hour 1


dayRangeDescriptionTests : Test
dayRangeDescriptionTests =
    describe "describe how the event spans a day view"
        [ test "event that falls within a day of date is described as StartsAndEnds"
            <| \() ->
                Expect.equal StartsAndEnds (Event.rangeDescription start end Day viewing)
        , test "event that starts on date and continues after the day described as ContinuesAfter"
            <| \() ->
                Expect.equal ContinuesAfter (Event.rangeDescription start dayAfter Day viewing)
        , test "event that ends on date and beings prior to the day described as ContinuesPrior"
            <| \() ->
                Expect.equal ContinuesPrior (Event.rangeDescription dayPrior end Day viewing)
        , test "event that continues prior and after the day described as ContinuesAfterAndPrior"
            <| \() ->
                Expect.equal ContinuesAfterAndPrior (Event.rangeDescription dayPrior dayAfter Day viewing)
        ]


weekRangeDescriptionTests : Test
weekRangeDescriptionTests =
    describe "describe how the event spans a month's week view"
        [ test "event that falls within a week of date is described as StartsAndEnds"
            <| \() ->
                Expect.equal StartsAndEnds (Event.rangeDescription start end Week viewing)
        , test "event that starts on date and continues after the day described as ContinuesAfter"
            <| \() ->
                Expect.equal ContinuesAfter (Event.rangeDescription start weekAfter Week viewing)
        , test "event that ends on date and beings prior to the day described as ContinuesPrior"
            <| \() ->
                Expect.equal ContinuesPrior (Event.rangeDescription weekPrior end Week viewing)
        , test "event that continues prior and after the day described as ContinuesAfterAndPrior"
            <| \() ->
                Expect.equal ContinuesAfterAndPrior (Event.rangeDescription weekPrior weekAfter Week viewing)
        ]


rangeDescriptionTests : Test
rangeDescriptionTests =
    describe "range descriptions accurately describe how the event spans an interval"
        [ dayRangeDescriptionTests
        , weekRangeDescriptionTests
        ]


fullWeekStartSunday : List Date
fullWeekStartSunday =
    [ Date.fromCalendarDate 2016 Oct 2
    , Date.fromCalendarDate 2016 Oct 3
    , Date.fromCalendarDate 2016 Oct 4
    , Date.fromCalendarDate 2016 Oct 5
    , Date.fromCalendarDate 2016 Oct 6
    , Date.fromCalendarDate 2016 Oct 7
    , Date.fromCalendarDate 2016 Oct 8
    ]


helperTests : Test
helperTests =
    describe "test helper functions"
        [ test "dayRangeOfWeek returns the correct day range from Sunday"
            <| \() ->
                Expect.equal fullWeekStartSunday (Helpers.dayRangeOfWeek start)
        ]


all : Test
all =
    describe "all tests"
        [ rangeDescriptionTests
        , helperTests
        ]
