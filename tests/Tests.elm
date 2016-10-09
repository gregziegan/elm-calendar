module Tests exposing (..)

import Test exposing (..)
import Expect
import Calendar.Event as Event exposing (EventRange(..))
import Date exposing (..)
import Date.Extra as Date exposing (..)
import Helpers
import Fixtures exposing (start, end, viewing, dayPrior, dayAfter, weekPrior, weekAfter)
import Calendar.Agenda as Agenda


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
                Expect.equal StartsAndEnds (Event.rangeDescription start end Sunday viewing)
        , test "event that starts on date and continues after the day described as ContinuesAfter"
            <| \() ->
                Expect.equal ContinuesAfter (Event.rangeDescription start weekAfter Sunday viewing)
        , test "event that ends on date and beings prior to the day described as ContinuesPrior"
            <| \() ->
                Expect.equal ContinuesPrior (Event.rangeDescription weekPrior end Sunday viewing)
        , test "event that continues prior and after the day described as ContinuesAfterAndPrior"
            <| \() ->
                Expect.equal ContinuesAfterAndPrior (Event.rangeDescription weekPrior weekAfter Sunday viewing)
        ]


rangeDescriptionTests : Test
rangeDescriptionTests =
    describe "range descriptions accurately describe how the event spans an interval"
        [ dayRangeDescriptionTests
        , weekRangeDescriptionTests
        ]


helperTests : Test
helperTests =
    describe "test helper functions"
        [ test "dayRangeOfWeek returns the correct day range from Sunday"
            <| \() ->
                Expect.equal Fixtures.fullWeekStartSunday (Helpers.dayRangeOfWeek start)
        , test "weekRangesFromMonth returns month dates in weeks w/ days before/prior"
            <| \() ->
                Expect.equal Fixtures.octoberDatesByWeek (Helpers.weekRangesFromMonth 2016 Oct)
        , test "hours in a day"
            <| \() ->
                Expect.equal Fixtures.hoursInADay (Helpers.hours start)
        ]


agendaTests : Test
agendaTests =
    describe "test agenda display logic"
        [ test "events are grouped properly"
            <| \() ->
                Expect.equal Fixtures.eventGroups (Agenda.eventsGroupedByDate Fixtures.viewConfig Fixtures.events)
        ]


all : Test
all =
    describe "all tests"
        [ rangeDescriptionTests
        , helperTests
        , agendaTests
        ]
