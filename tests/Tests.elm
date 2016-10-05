module Tests exposing (..)

import Test exposing (..)
import Expect
import Calendar.Event as Event exposing (EventRange(..))
import Date exposing (..)
import Date.Extra as Date exposing (..)


dayPrior : Date
dayPrior =
    start
        |> Date.add Day -1


start : Date
start =
    Date.fromParts 2016 Oct 4 14 30 0 0
        |> Date.add Day 1
        |> Debug.log "start"


end : Date
end =
    start
        |> Date.add Hour 5


dayAfter : Date
dayAfter =
    Date.add Day 1 start
        |> Date.add Hour 2


viewing : Date
viewing =
    start
        |> Date.add Hour 1


all : Test
all =
    describe "range descriptions accurately describe how the event spans an interval"
        [ test "event that falls within an interval of date is described as StartsAndEnds"
            <| \() ->
                Expect.equal StartsAndEnds (Event.rangeDescription start end Day viewing)
        , test "event that starts on date and continues after the interval described as ContinuesAfter"
            <| \() ->
                Expect.equal ContinuesAfter (Event.rangeDescription start dayAfter Day viewing)
        , test "event that ends on date and beings prior to the interval described as ContinuesPrior"
            <| \() ->
                Expect.equal ContinuesPrior (Event.rangeDescription dayPrior end Day viewing)
        , test "event that continues prior and after the date and interval described as ContinuesAfterAndPrior"
            <| \() ->
                Expect.equal ContinuesAfterAndPrior (Event.rangeDescription dayPrior dayAfter Day viewing)
        ]
