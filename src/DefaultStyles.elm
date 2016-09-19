module DefaultStyles exposing (..)

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


styleMonthDayHeader =
    style
        [ ( "max-width", cellWidth )
        , ( "flex-basis", cellWidth )
        , ( "text-align", "center" )
        ]


styleMonthRow =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "border-top", "1px solid #DDD" )
        , ( "height", "100%" )
        , ( "position", "relative" )
        ]


cellWidth =
    (toString <| 100.0 / 7) ++ "%"


styleDateCell =
    style
        [ ( "padding-right", "5px" )
        , ( "text-align", "right" )
        , ( "flex-basis", cellWidth )
        , ( "max-width", cellWidth )
        ]


styleMonthRowBackground =
    style
        [ ( "display", "flex" )
        , ( "overflow", "hidden" )
        , ( "position", "absolute" )
        , ( "top", "0" )
        , ( "left", "0" )
        , ( "right", "0" )
        , ( "bottom", "0" )
          -- , ( "height", "100px" )
        ]


styleRow =
    style [ ( "display", "flex" ) ]


styleMonthWeek =
    style
        [ ( "position", "relative" )
        , ( "z-index", "4" )
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
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        ]


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
        , ( "position", "relative" )
        , ( "border", "1px solid #DDD" )
        ]


styleCell =
    style
        [ ( "flex-basis", cellWidth )
        , ( "max-width", cellWidth )
        , ( "border-left", "1px solid #ddd" )
          -- , ( "height", "100px" )
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


styleDay =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        ]


styleAgenda =
    style
        [ ( "display", "flex" )
        , ( "flex-flow", "column nowrap" )
        , ( "width", "924px" )
        , ( "border", "1px solid #DDD" )
        , ( "min-height", "0px" )
        ]


styleAgendaHeader =
    style
        [ ( "display", "flex" )
        , ( "border-bottom", "1px solid #DDD" )
        ]


styleHeaderCell =
    style
        [ ( "text-align", "center" )
        , ( "border-left", "1px solid #DDD" )
        ]


styleAgendaDay =
    style
        [ ( "display", "flex" )
        , ( "border-bottom", "1px solid #d7d7d7" )
        ]


styleAgendaDateCell =
    style [ ( "padding", "0 5px" ) ]


styleAgendaCell =
    style
        [ ( "padding", "0 5px" )
        , ( "border-left", "1px solid #DDD" )
        ]


styleMonthEvents =
    style
        [ ( "display", "flex" )
        , ( "flex-flow", "column nowrap" )
        , ( "justify-content", "space-between" )
        , ( "height", "75px" )
        , ( "overflow-y", "hidden" )
        ]


monthEventsMixin =
    [ ( "padding", "2px 5px" )
    , ( "background-color", "#3174ad" )
    , ( "color", "white" )
    , ( "cursor", "pointer" )
    ]


styleMonthEventContent =
    style
        [ ( "text-overflow", "ellipsis" )
        , ( "white-space", "nowrap" )
        , ( "overflow", "hidden" )
        ]


monthEventStartsAndEndsMixin =
    monthEventsMixin ++ [ ( "border-radius", "5px" ) ]


monthEventContinuesAfterMixin =
    monthEventsMixin ++ [ ( "border-radius", "0 0 5px 5px" ) ]


monthEventContinuesPriorMixin =
    monthEventsMixin ++ [ ( "border-radius", "5px 5px 0 0" ) ]


monthEventContinuesAfterAndPriorMixin =
    monthEventsMixin


styleMonthWeekRow =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "row" )
        ]
