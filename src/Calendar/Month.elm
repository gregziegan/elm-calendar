module Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts
import Config exposing (ViewConfig)
import Helpers
import Calendar.Msg exposing (Msg)
import Calendar.Event as Event exposing (rangeDescription)


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

        eventRows =
            List.filterMap (viewWeekEvent config week) events
                |> List.take 3
    in
        div [ class "elm-calendar--month-week" ]
            (datesRow :: eventRows)


maybeAndThen : (a -> Maybe b) -> Maybe a -> Maybe b
maybeAndThen =
    flip Maybe.andThen


viewWeekEvent : ViewConfig event -> List Date -> event -> Maybe (Html Msg)
viewWeekEvent config week event =
    let
        eventRange sunday =
            rangeDescription (config.start event) (config.end event) Date.Extra.Sunday sunday
    in
        Maybe.map eventRange (List.head week)
            |> maybeAndThen (Event.maybeViewMonthEvent config event)
