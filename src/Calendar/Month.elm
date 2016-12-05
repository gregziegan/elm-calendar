module Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts
import Config exposing (ViewConfig)
import Calendar.Helpers as Helpers
import Calendar.Msg exposing (Msg)
import Calendar.Event as Event exposing (rangeDescription)


view : ViewConfig event -> List event -> Maybe String -> Date -> Html Msg
view config events selectedId viewing =
    let
        weeks =
            Helpers.weekRangesFromMonth (Date.year viewing) (Date.month viewing)
    in
        div [ class "elm-calendar--column" ]
            [ viewMonthHeader
            , div [ class "elm-calendar--month" ]
                (List.map (viewMonthRow config events selectedId) weeks)
            ]


viewMonthHeader : Html Msg
viewMonthHeader =
    let
        viewDayOfWeek int =
            viewDay <| Date.Extra.Facts.dayOfWeekFromWeekdayNumber int
    in
        div [ class "elm-calendar--row" ] (List.map viewDayOfWeek (List.range 0 6))


viewDay : Date.Day -> Html Msg
viewDay day =
    div [ class "elm-calendar--month-day-header" ]
        [ a [ class "elm-calendar--date", href "#" ] [ text <| toString day ] ]


viewMonthRow : ViewConfig event -> List event -> Maybe String -> List Date -> Html Msg
viewMonthRow config events selectedId week =
    div [ class "elm-calendar--month-row" ]
        [ viewMonthRowBackground week
        , viewMonthRowContent config events selectedId week
        ]


viewMonthRowBackground : List Date -> Html Msg
viewMonthRowBackground week =
    div [ class "elm-calendar--month-row-background" ]
        (List.map (\_ -> div [ class "elm-calendar--cell" ] []) week)


viewMonthRowContent : ViewConfig event -> List event -> Maybe String -> List Date -> Html Msg
viewMonthRowContent config events selectedId week =
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
            List.filterMap (viewWeekEvent config week selectedId) events
                |> List.take 3
    in
        div [ class "elm-calendar--month-week" ]
            (datesRow :: eventRows)


viewWeekEvent : ViewConfig event -> List Date -> Maybe String -> event -> Maybe (Html Msg)
viewWeekEvent config week selectedId event =
    let
        eventRange sunday =
            rangeDescription (config.start event) (config.end event) Date.Extra.Sunday sunday
    in
        Maybe.map eventRange (List.head week)
            |> Maybe.andThen (Event.maybeViewMonthEvent config event selectedId)
