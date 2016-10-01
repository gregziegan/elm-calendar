module Calendar.Day exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Config exposing (ViewConfig)
import Helpers


view : ViewConfig event -> List event -> Date -> Html msg
view config events day =
    div [ class "elm-calendar--day" ]
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
        div [ class "elm-calendar--day-header" ]
            [ a [ class "elm-calendar--date", href "#" ] [ text <| title day ] ]


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
        |> div [ class "elm-calendar--time-gutter" ]


viewTimeGutterHeader : Html msg
viewTimeGutterHeader =
    div [ style [ ( "min-width", "70px" ) ] ] []


viewTimeSlotGroup : Date -> Html msg
viewTimeSlotGroup date =
    div [ class "elm-calendar--time-slot-group" ]
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
        |> div [ class "elm-calendar--day-slot" ]


viewDaySlotGroup : Date -> Html msg
viewDaySlotGroup date =
    div [ class "elm-calendar--time-slot-group" ]
        [ div [ style [ ( "flex", "1 0 0" ) ] ] []
        , div [ style [ ( "flex", "1 0 0" ) ] ] []
        ]


viewAllDayCell : List Date -> Html msg
viewAllDayCell days =
    let
        viewAllDayText =
            div [ style [ ( "min-width", "70px" ), ( "padding", "0 5px" ) ] ] [ text "All day" ]

        viewAllDay day =
            div [ class "elm-calendar--all-day" ]
                []
    in
        div [ class "elm-calendar--all-day-cell" ]
            (viewAllDayText :: List.map viewAllDay days)
