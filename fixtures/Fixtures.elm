module Fixtures exposing (..)

import Date exposing (..)
import Date.Extra as Date exposing (..)


start : Date
start =
    fromParts 2016 Oct 4 14 30 0 0


end : Date
end =
    fromParts 2016 Oct 4 20 30 0 0


dayPrior : Date
dayPrior =
    fromParts 2016 Oct 3 14 30 0 0


dayAfter : Date
dayAfter =
    fromParts 2016 Oct 5 14 30 0 0


weekPrior : Date
weekPrior =
    fromParts 2016 Sep 27 14 30 0 0


weekAfter : Date
weekAfter =
    fromParts 2016 Oct 11 14 30 0 0


viewing : Date
viewing =
    fromParts 2016 Oct 4 16 0 0 0


fullWeekStartSunday : List Date
fullWeekStartSunday =
    [ fromCalendarDate 2016 Oct 2
    , fromCalendarDate 2016 Oct 3
    , fromCalendarDate 2016 Oct 4
    , fromCalendarDate 2016 Oct 5
    , fromCalendarDate 2016 Oct 6
    , fromCalendarDate 2016 Oct 7
    , fromCalendarDate 2016 Oct 8
    ]


octoberDatesByWeek : List (List Date)
octoberDatesByWeek =
    [ [ fromCalendarDate 2016 Sep 25
      , fromCalendarDate 2016 Sep 26
      , fromCalendarDate 2016 Sep 27
      , fromCalendarDate 2016 Sep 28
      , fromCalendarDate 2016 Sep 29
      , fromCalendarDate 2016 Sep 30
      , fromCalendarDate 2016 Oct 1
      ]
    , [ fromCalendarDate 2016 Oct 2
      , fromCalendarDate 2016 Oct 3
      , fromCalendarDate 2016 Oct 4
      , fromCalendarDate 2016 Oct 5
      , fromCalendarDate 2016 Oct 6
      , fromCalendarDate 2016 Oct 7
      , fromCalendarDate 2016 Oct 8
      ]
    , [ fromCalendarDate 2016 Oct 9
      , fromCalendarDate 2016 Oct 10
      , fromCalendarDate 2016 Oct 11
      , fromCalendarDate 2016 Oct 12
      , fromCalendarDate 2016 Oct 13
      , fromCalendarDate 2016 Oct 14
      , fromCalendarDate 2016 Oct 15
      ]
    , [ fromCalendarDate 2016 Oct 16
      , fromCalendarDate 2016 Oct 17
      , fromCalendarDate 2016 Oct 18
      , fromCalendarDate 2016 Oct 19
      , fromCalendarDate 2016 Oct 20
      , fromCalendarDate 2016 Oct 21
      , fromCalendarDate 2016 Oct 22
      ]
    , [ fromCalendarDate 2016 Oct 23
      , fromCalendarDate 2016 Oct 24
      , fromCalendarDate 2016 Oct 25
      , fromCalendarDate 2016 Oct 26
      , fromCalendarDate 2016 Oct 27
      , fromCalendarDate 2016 Oct 28
      , fromCalendarDate 2016 Oct 29
      ]
    , [ fromCalendarDate 2016 Oct 30
      , fromCalendarDate 2016 Oct 31
      , fromCalendarDate 2016 Nov 1
      , fromCalendarDate 2016 Nov 2
      , fromCalendarDate 2016 Nov 3
      , fromCalendarDate 2016 Nov 4
      , fromCalendarDate 2016 Nov 5
      ]
    ]


hoursInADay : List Date
hoursInADay =
    [ fromParts 2016 Oct 4 0 0 0 0
    , fromParts 2016 Oct 4 1 0 0 0
    , fromParts 2016 Oct 4 2 0 0 0
    , fromParts 2016 Oct 4 3 0 0 0
    , fromParts 2016 Oct 4 4 0 0 0
    , fromParts 2016 Oct 4 5 0 0 0
    , fromParts 2016 Oct 4 6 0 0 0
    , fromParts 2016 Oct 4 7 0 0 0
    , fromParts 2016 Oct 4 8 0 0 0
    , fromParts 2016 Oct 4 9 0 0 0
    , fromParts 2016 Oct 4 10 0 0 0
    , fromParts 2016 Oct 4 11 0 0 0
    , fromParts 2016 Oct 4 12 0 0 0
    , fromParts 2016 Oct 4 13 0 0 0
    , fromParts 2016 Oct 4 14 0 0 0
    , fromParts 2016 Oct 4 15 0 0 0
    , fromParts 2016 Oct 4 16 0 0 0
    , fromParts 2016 Oct 4 17 0 0 0
    , fromParts 2016 Oct 4 18 0 0 0
    , fromParts 2016 Oct 4 19 0 0 0
    , fromParts 2016 Oct 4 20 0 0 0
    , fromParts 2016 Oct 4 21 0 0 0
    , fromParts 2016 Oct 4 22 0 0 0
    , fromParts 2016 Oct 4 23 0 0 0
    ]


viewConfig =
    { toId = .id
    , title = .title
    , start = .start
    , end = .end
    }


type alias Event =
    { id : String
    , title : String
    , start : Date
    , end : Date
    }


eventOne =
    { id = "brunch1", title = "Brunch w/ Friends", start = fromParts 2016 Oct 4 13 30 0 0, end = fromParts 2016 Oct 4 15 0 0 0 }


eventTwo =
    { id = "brunch2", title = "Brunch w/o Friends :(", start = fromParts 2016 Oct 5 13 30 0 0, end = fromParts 2016 Oct 5 14 10 0 0 }


eventThree =
    { id = "payingbills", title = "Paying Bills Alone", start = fromParts 2016 Oct 5 15 15 0 0, end = fromParts 2016 Oct 5 15 45 0 0 }


eventFour =
    { id = "conference", title = "A Tech Conference", start = fromParts 2016 Oct 18 9 0 0 0, end = fromParts 2016 Oct 21 4 0 0 0 }


eventGroups =
    [ { date = fromParts 2016 Oct 4 0 0 0 0
      , events = [ eventOne ]
      }
    , { date = fromParts 2016 Oct 5 0 0 0 0
      , events = [ eventTwo, eventThree ]
      }
    , { date = fromParts 2016 Oct 18 0 0 0 0
      , events = [ eventFour ]
      }
    ]


events =
    [ eventOne
    , eventTwo
    , eventThree
    , eventFour
    ]
