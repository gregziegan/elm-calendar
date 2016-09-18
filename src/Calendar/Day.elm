module Calendar.Day exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import DefaultStyles exposing (..)
import Helpers


view : Date -> Html msg
view day =
    div [ styleDay ]
        [ viewDayHeader day
        , div [ style [ ( "display", "flex" ) ] ]
            [ viewTimeGutter day
            , viewDaySlot day
            ]
        ]


viewDate : Date -> Html msg
viewDate day =
    let
        title day =
            (toString <| Date.dayOfWeek day) ++ " " ++ (toString <| Date.day day) ++ "/" ++ (toString <| Date.Extra.monthNumber day)
    in
        div [ styleDateHeader ]
            [ a [ styleDate, href "#" ] [ text <| title day ] ]


viewDayHeader : Date -> Html msg
viewDayHeader day =
    div []
        [ viewTimeGutterHeader
        , viewDate day
        ]


viewTimeGutter : Date -> Html msg
viewTimeGutter date =
    Helpers.hours date
        |> List.map viewTimeSlotGroup
        |> div [ styleTimeGutter ]


viewTimeGutterHeader : Html msg
viewTimeGutterHeader =
    div [ style [ ( "min-width", "70px" ) ] ] []


viewTimeSlotGroup : Date -> Html msg
viewTimeSlotGroup date =
    div [ styleTimeSlotGroup ]
        [ viewTimeSlot date
        , div [ style [ ( "flex", "1 0 0" ) ] ] []
        ]


viewTimeSlot : Date -> Html msg
viewTimeSlot date =
    div [ style [ ( "padding", "0 5px" ), ( "flex", "1 0 0" ) ] ]
        [ span [ style [ ( "font-size", "14px" ) ] ] [ text <| Helpers.hourString date ] ]


viewDaySlot : Date -> Html msg
viewDaySlot day =
    Helpers.hours day
        |> List.map viewDaySlotGroup
        |> div [ styleDaySlot ]


viewDaySlotGroup : Date -> Html msg
viewDaySlotGroup date =
    div [ styleTimeSlotGroup ]
        [ div [ style [ ( "flex", "1 0 0" ) ] ] []
        , div [ style [ ( "flex", "1 0 0" ) ] ] []
        ]


viewAllDayCell : List Date -> Html msg
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
