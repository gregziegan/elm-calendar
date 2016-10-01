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
        , div [ class "elm-calendar--day-content" ]
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
        div [ class "elm-calendar--date-header" ]
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
    div [ class "elm-calendar--time-gutter-header" ] []


viewTimeSlotGroup : Date -> Html msg
viewTimeSlotGroup date =
    div [ class "elm-calendar--time-slot-group" ]
        [ viewTimeSlot date
        , div [ class "elm-calendar--time-slot" ] []
        ]


viewTimeSlot : Date -> Html msg
viewTimeSlot date =
    div [ class "elm-calendar--hour-slot" ]
        [ span [ class "elm-calendar--time-slot-text" ] [ text <| Helpers.hourString date ] ]


viewDaySlot : Date -> Html msg
viewDaySlot day =
    Helpers.hours day
        |> List.map viewDaySlotGroup
        |> div [ class "elm-calendar--day-slot" ]


viewDaySlotGroup : Date -> Html msg
viewDaySlotGroup date =
    div [ class "elm-calendar--time-slot-group" ]
        [ div [ class "elm-calendar--time-slot" ] []
        , div [ class "elm-calendar--time-slot" ] []
        ]


viewAllDayCell : List Date -> Html msg
viewAllDayCell days =
    let
        viewAllDayText =
            div [ class "elm-calendar--all-day-text" ] [ text "All day" ]

        viewAllDay day =
            div [ class "elm-calendar--all-day" ]
                []
    in
        div [ class "elm-calendar--all-day-cell" ]
            (viewAllDayText :: List.map viewAllDay days)
