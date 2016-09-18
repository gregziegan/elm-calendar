module Calendar.Day exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date
import DefaultStyles exposing (..)


viewDay day =
    div [ styleDay ]
        [ viewDayHeader day
        , div [ style [ ( "display", "flex" ) ] ]
            [ viewTimeGutter day
            , viewDaySlot day
            ]
        ]


viewDate day =
    let
        title day =
            (toString <| Date.dayOfWeek day) ++ " " ++ (toString <| Date.day day) ++ "/" ++ (toString <| Date.Extra.monthNumber day)
    in
        div [ styleDateHeader ]
            [ a [ styleDate, href "#" ] [ text <| title day ] ]


viewDayHeader day =
    div []
        [ viewTimeGutterHeader
        , viewDate day
        ]


viewTimeGutter date =
    hours date
        |> List.map viewTimeSlotGroup
        |> div [ styleTimeGutter ]


viewTimeGutterHeader =
    div [ style [ ( "min-width", "70px" ) ] ] []


viewTimeSlotGroup date =
    div [ styleTimeSlotGroup ]
        [ viewTimeSlot date
        , div [ style [ ( "flex", "1 0 0" ) ] ] []
        ]


viewTimeSlot date =
    div [ style [ ( "padding", "0 5px" ), ( "flex", "1 0 0" ) ] ]
        [ span [ style [ ( "font-size", "14px" ) ] ] [ text <| hourString date ] ]


viewDaySlot day =
    hours day
        |> List.map viewDaySlotGroup
        |> div [ styleDaySlot ]


viewDaySlotGroup hourString =
    div [ styleTimeSlotGroup ]
        [ div [ style [ ( "flex", "1 0 0" ) ] ] []
        , div [ style [ ( "flex", "1 0 0" ) ] ] []
        ]


viewAllDayCell days =
    let
        viewAllDayText =
            div [ style [ ( "min-width", "70px" ), ( "padding", "0 5px" ) ] ] [ text "All day" ]

        viewAllDay day =
            div [ styleAllDay ]
                []
    in
        div [ styleAllDayCell ]
            (viewAllDayText :: List.map viewAllDay days)
