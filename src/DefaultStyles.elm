module DefaultStyles exposing (..)

import Html
import Html.Attributes exposing (style)


styleToolbar =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "space-between" )
        , ( "width", "1000px" )
        ]


styleCalendar =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        ]


styleButton =
    style
        [ ( "border", "1px solid #ccc" )
        , ( "padding", "5px" )
        , ( "background-color", "white" )
        ]


styleTimeGutter =
    style [ ( "width", "70px" ) ]


styleTimeSlotGroup =
    style
        [ ( "border-bottom", "1px solid #DDD" )
        , ( "min-height", "40px" )
        , ( "display", "flex" )
        , ( "flex-flow", "column nowrap" )
        ]


styleColumn =
    style [ ( "display", "flex" ), ( "flex-direction", "column" ) ]


styleWeek =
    style
        [ ( "display", "flex" )
        , ( "flex-flow", "column nowrap" )
        , ( "width", "1000px" )
        , ( "border", "1px solid #DDD" )
        , ( "min-height", "0px" )
        ]


styleWeekContent =
    style
        [ ( "display", "flex" )
        , ( "width", "100%" )
        , ( "border-top", "2px solid #DDD" )
        , ( "height", "600px" )
        , ( "overflow-y", "auto" )
        ]


styleMonth =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "width", "1200px" )
        , ( "height", "800px" )
        ]


styleCell =
    style
        [ ( "border", "2px solid #ccc" )
        , ( "padding", "10px" )
        , ( "width", "120px" )
        , ( "height", "100px" )
        ]


styleWeekHeader =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        ]


styleDates =
    style [ ( "display", "flex" ) ]


styleDateHeader =
    style
        [ ( "padding", "10px" )
        ]


styleDate =
    style
        [ ( "color", "black" )
        , ( "text-decoration", "none" )
        ]


styleAllDay =
    style
        [ ( "width", "120px" )
        , ( "height", "48px" )
        ]


styleAllDayCell =
    style
        [ ( "display", "flex" )
        , ( "flex-flow", "nowrap" )
        , ( "width", "100%" )
        ]


styleDaySlot =
    style
        [ ( "border-bottom", "1px solid #f7f7f7" )
        , ( "width", "120px" )
        ]
