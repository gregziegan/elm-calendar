module Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts
import Config exposing (ViewConfig)
import Helpers
import Calendar.Msg exposing (Msg)
import Calendar.Event as Event exposing (eventWithinRange)


view : ViewConfig event -> List event -> Date -> Html Msg
view config events viewing =
    let
        weeks =
            Helpers.weekRangesFromMonth (Date.year viewing) (Date.month viewing)
    in
        div [ class "elm-calendar--column" ]
            [ viewMonthHeader
            , div [ class "elm-calendar--month" ]
                (List.map (viewMonthRow config events) weeks)
            ]


viewMonthHeader : Html Msg
viewMonthHeader =
    let
        viewDayOfWeek int =
            viewDay <| Date.Extra.Facts.dayOfWeekFromWeekdayNumber int
    in
        div [ class "elm-calendar--row" ] (List.map viewDayOfWeek [0..6])


viewDay : Date.Day -> Html Msg
viewDay day =
    div [ class "elm-calendar--month-day-header" ]
        [ a [ class "elm-calendar--date", href "#" ] [ text <| toString day ] ]


viewMonthRow : ViewConfig event -> List event -> List Date -> Html Msg
viewMonthRow config events week =
    div [ class "elm-calendar--month-row" ]
        [ viewMonthRowBackground week
        , viewMonthRowContent config events week
        ]


viewMonthRowBackground : List Date -> Html Msg
viewMonthRowBackground week =
    div [ class "elm-calendar--month-row-background" ]
        (List.map (\_ -> div [ class "elm-calendar--cell" ] []) week)


viewMonthRowContent : ViewConfig event -> List event -> List Date -> Html Msg
viewMonthRowContent config events week =
    let
        dateCell date =
            div [ class "elm-calendar--date-cell" ]
                [ Date.day date
                    |> toString
                    |> text
                ]

        datesRow =
            div [ class "elm-calendar--row" ] (List.map dateCell week)

        maybeViewEvent event =
            viewMonthWeekRow <| viewWeekEvent config week event

        eventRows =
            List.filterMap maybeViewEvent events
                |> List.take 3
    in
        div [ class "elm-calendar--month-week" ]
            (datesRow :: eventRows)


viewMonthWeekRow : Maybe (List (Html Msg)) -> Maybe (Html Msg)
viewMonthWeekRow maybeChildren =
    let
        nest children =
            div [ class "elm-calendar--row" ] children
    in
        Maybe.map nest maybeChildren


viewWeekEvent : ViewConfig event -> List Date -> event -> Maybe (List (Html Msg))
viewWeekEvent config week event =
    let
        maybeEventOnDate =
            eventWithinRange (config.start event) (config.end event) Date.Extra.Week week
    in
        Maybe.map (Event.viewMonthEvent config event) maybeEventOnDate
