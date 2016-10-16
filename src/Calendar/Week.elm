module Calendar.Week exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Calendar.Day exposing (viewTimeGutter, viewTimeGutterHeader, viewDate, viewDaySlotGroup, viewAllDayCell, viewDayEvents)
import Calendar.Msg exposing (Msg)
import Config exposing (ViewConfig)
import Helpers


viewWeekContent : ViewConfig event -> List event -> Date -> List Date -> Html Msg
viewWeekContent config events viewing days =
    let
        timeGutter =
            viewTimeGutter viewing

        weekDays =
            List.map (viewWeekDay config events) days
    in
        div [ class "elm-calendar--week-content" ]
            (timeGutter :: weekDays)


viewWeekDay : ViewConfig event -> List event -> Date -> Html Msg
viewWeekDay config events day =
    let
        viewDaySlots =
            Helpers.hours day
                |> List.map viewDaySlotGroup

        dayEvents =
            viewDayEvents config events day
    in
        div [ class "elm-calendar--day" ]
            (viewDaySlots ++ dayEvents)


view : ViewConfig event -> List event -> Date -> Html Msg
view config events viewing =
    let
        weekRange =
            Helpers.dayRangeOfWeek viewing
    in
        div [ class "elm-calendar--week" ]
            [ viewWeekHeader weekRange
            , viewWeekContent config events viewing weekRange
            ]


viewWeekHeader : List Date -> Html Msg
viewWeekHeader days =
    div [ class "elm-calendar--week-header" ]
        [ viewDates days
        , viewAllDayCell days
        ]


viewDates : List Date -> Html Msg
viewDates days =
    div [ class "elm-calendar--dates" ]
        (viewTimeGutterHeader :: List.map viewDate days)
