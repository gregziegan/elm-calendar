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


octoberDatesByWeek : List (List Date)
octoberDatesByWeek =
    [ [ Date.fromCalendarDate 2016 Sep 25
      , Date.fromCalendarDate 2016 Sep 26
      , Date.fromCalendarDate 2016 Sep 27
      , Date.fromCalendarDate 2016 Sep 28
      , Date.fromCalendarDate 2016 Sep 29
      , Date.fromCalendarDate 2016 Sep 30
      , Date.fromCalendarDate 2016 Oct 1
      ]
    , [ Date.fromCalendarDate 2016 Oct 2
      , Date.fromCalendarDate 2016 Oct 3
      , Date.fromCalendarDate 2016 Oct 4
      , Date.fromCalendarDate 2016 Oct 5
      , Date.fromCalendarDate 2016 Oct 6
      , Date.fromCalendarDate 2016 Oct 7
      , Date.fromCalendarDate 2016 Oct 8
      ]
    , [ Date.fromCalendarDate 2016 Oct 9
      , Date.fromCalendarDate 2016 Oct 10
      , Date.fromCalendarDate 2016 Oct 11
      , Date.fromCalendarDate 2016 Oct 12
      , Date.fromCalendarDate 2016 Oct 13
      , Date.fromCalendarDate 2016 Oct 14
      , Date.fromCalendarDate 2016 Oct 15
      ]
    , [ Date.fromCalendarDate 2016 Oct 16
      , Date.fromCalendarDate 2016 Oct 17
      , Date.fromCalendarDate 2016 Oct 18
      , Date.fromCalendarDate 2016 Oct 19
      , Date.fromCalendarDate 2016 Oct 20
      , Date.fromCalendarDate 2016 Oct 21
      , Date.fromCalendarDate 2016 Oct 22
      ]
    , [ Date.fromCalendarDate 2016 Oct 23
      , Date.fromCalendarDate 2016 Oct 24
      , Date.fromCalendarDate 2016 Oct 25
      , Date.fromCalendarDate 2016 Oct 26
      , Date.fromCalendarDate 2016 Oct 27
      , Date.fromCalendarDate 2016 Oct 28
      , Date.fromCalendarDate 2016 Oct 29
      ]
    , [ Date.fromCalendarDate 2016 Oct 30
      , Date.fromCalendarDate 2016 Oct 31
      , Date.fromCalendarDate 2016 Nov 1
      , Date.fromCalendarDate 2016 Nov 2
      , Date.fromCalendarDate 2016 Nov 3
      , Date.fromCalendarDate 2016 Nov 4
      , Date.fromCalendarDate 2016 Nov 5
      ]
    ]


hoursInADay : List Date
hoursInADay =
    [ Date.fromParts 2016 Oct 4 0 0 0 0
    , Date.fromParts 2016 Oct 4 1 0 0 0
    , Date.fromParts 2016 Oct 4 2 0 0 0
    , Date.fromParts 2016 Oct 4 3 0 0 0
    , Date.fromParts 2016 Oct 4 4 0 0 0
    , Date.fromParts 2016 Oct 4 5 0 0 0
    , Date.fromParts 2016 Oct 4 6 0 0 0
    , Date.fromParts 2016 Oct 4 7 0 0 0
    , Date.fromParts 2016 Oct 4 8 0 0 0
    , Date.fromParts 2016 Oct 4 9 0 0 0
    , Date.fromParts 2016 Oct 4 10 0 0 0
    , Date.fromParts 2016 Oct 4 11 0 0 0
    , Date.fromParts 2016 Oct 4 12 0 0 0
    , Date.fromParts 2016 Oct 4 13 0 0 0
    , Date.fromParts 2016 Oct 4 14 0 0 0
    , Date.fromParts 2016 Oct 4 15 0 0 0
    , Date.fromParts 2016 Oct 4 16 0 0 0
    , Date.fromParts 2016 Oct 4 17 0 0 0
    , Date.fromParts 2016 Oct 4 18 0 0 0
    , Date.fromParts 2016 Oct 4 19 0 0 0
    , Date.fromParts 2016 Oct 4 20 0 0 0
    , Date.fromParts 2016 Oct 4 21 0 0 0
    , Date.fromParts 2016 Oct 4 22 0 0 0
    , Date.fromParts 2016 Oct 4 23 0 0 0
    ]


helperTests : Test
helperTests =
    describe "test helper functions"
        [ test "dayRangeOfWeek returns the correct day range from Sunday"
            <| \() ->
                Expect.equal fullWeekStartSunday (Helpers.dayRangeOfWeek start)
        , test "weekRangesFromMonth returns month dates in weeks w/ days before/prior"
            <| \() ->
                Expect.equal octoberDatesByWeek (Helpers.weekRangesFromMonth 2016 Oct)
        , test "hours in a day"
            <| \() ->
                Expect.equal hoursInADay (Helpers.hours start)
        ]


all : Test
all =
    describe "all tests"
        [ rangeDescriptionTests
        , helperTests
        ]
