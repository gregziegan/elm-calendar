module DefaultStyles exposing (..)

import Html
import Html.Attributes exposing (style)


styleToolbar =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "space-between" )
        , ( "width", "924px" )
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
    style [ ( "min-width", "70px" ) ]


styleTimeSlotGroup =
    style
        [ ( "border-bottom", "1px solid #DDD" )
        , ( "min-height", "40px" )
        , ( "display", "flex" )
        , ( "flex-flow", "column nowrap" )
        , ( "min-width", "70px" )
        , ( "border-left", "1px solid #d7d7d7" )
        ]


styleColumn =
    style [ ( "display", "flex" ), ( "flex-direction", "column" ) ]


styleWeek =
    style
        [ ( "display", "flex" )
        , ( "flex-flow", "column nowrap" )
        , ( "width", "924px" )
        , ( "border", "1px solid #DDD" )
        , ( "min-height", "0px" )
        ]


styleWeekContent =
    style
        [ ( "display", "flex" )
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
    style
        [ ( "display", "flex" )
        , ( "border-bottom", "1px solid #f7f7f7" )
        , ( "flex-flow", "row nowrap" )
        , ( "align-content", "stretch" )
        ]


styleDateHeader =
    style
        [ ( "padding", "0 5px" )
        , ( "text-align", "center" )
        , ( "min-width", "109px" )
        , ( "border-left", "1px solid #f7f7f7" )
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
        ]


styleDaySlot =
    style
        [ ( "border-bottom", "1px solid #f7f7f7" )
        , ( "width", "120px" )
        ]
