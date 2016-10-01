module Calendar.Week exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Calendar.Day exposing (..)
import Config exposing (ViewConfig)
import Helpers


viewWeekContent : ViewConfig event -> List event -> Date -> List Date -> Html msg
viewWeekContent config events viewing days =
    div [ class "elm-calendar--week-content" ]
        ([ viewTimeGutter viewing ] ++ (List.map viewWeekDay days))


viewWeekDay : Date -> Html msg
viewWeekDay day =
    div [ class "elm-calendar--day" ]
        [ viewDaySlot day
        ]


view : ViewConfig event -> List event -> Date -> Html msg
view config events viewing =
    let
        weekRange =
            Helpers.dayRangeOfWeek viewing
    in
        div [ class "elm-calendar--week" ]
            [ viewWeekHeader weekRange
            , viewWeekContent config events viewing weekRange
            ]


viewWeekHeader : List Date -> Html msg
viewWeekHeader days =
    div [ class "elm-calendar--week-header" ]
        [ viewDates days
        , viewAllDayCell days
        ]


viewDates : List Date -> Html msg
viewDates days =
    div [ class "elm-calendar--dates" ]
        (viewTimeGutterHeader :: List.map viewDate days)
