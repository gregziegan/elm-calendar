module Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts
import Config exposing (ViewConfig)
import Helpers


view : ViewConfig event -> List event -> Date -> Html msg
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


viewMonthHeader : Html msg
viewMonthHeader =
    let
        viewDayOfWeek int =
            viewDay <| Date.Extra.Facts.dayOfWeekFromWeekdayNumber int
    in
        div [ class "elm-calendar--row" ] (List.map viewDayOfWeek [0..6])


viewDay : Date.Day -> Html msg
viewDay day =
    div [ class "elm-calendar--month-day-header" ]
        [ a [ class "elm-calendar--date", href "#" ] [ text <| toString day ] ]


viewMonthRow : ViewConfig event -> List event -> List Date -> Html msg
viewMonthRow config events week =
    div [ class "elm-calendar--month-row" ]
        [ viewMonthRowBackground week
        , viewMonthRowContent config events week
        ]


viewMonthRowBackground : List Date -> Html msg
viewMonthRowBackground week =
    div [ class "elm-calendar--month-row-background" ]
        (List.map (\_ -> div [ class "elm-calendar--cell" ] []) week)


viewMonthRowContent : ViewConfig event -> List event -> List Date -> Html msg
viewMonthRowContent config events week =
    let
        dateCell date =
            div [ class "elm-calendar--date-cell" ] [ text <| toString <| Date.day date ]

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


viewMonthWeekRow : Maybe (List (Html msg)) -> Maybe (Html msg)
viewMonthWeekRow maybeChildren =
    let
        nest children =
            div [ class "elm-calendar--row" ] children
    in
        Maybe.map nest maybeChildren


type EventWithinWeek
    = StartsAndEnds
    | ContinuesAfter
    | ContinuesPrior
    | ContinuesAfterAndPrior


eventWeekStyles : EventWithinWeek -> Html.Attribute msg
eventWeekStyles eventWithinWeek =
    case eventWithinWeek of
        StartsAndEnds ->
            class "elm-calendar--month-event elm-calendar--month-event-starts-and-ends"

        ContinuesAfter ->
            class "elm-calendar--month-event elm-calendar--month-event-continues-after"

        ContinuesPrior ->
            class "elm-calendar--month-event elm-calendar--month-event-continues-prior"

        ContinuesAfterAndPrior ->
            class "elm-calendar--month-event"


viewWeekEvent : ViewConfig event -> List Date -> event -> Maybe (List (Html msg))
viewWeekEvent config week event =
    let
        eventStart =
            config.start event

        eventEnd =
            config.end event

        begWeek =
            Maybe.withDefault eventStart <| List.head <| week

        endWeek =
            Maybe.withDefault eventEnd <| List.head <| List.reverse week

        startsThisWeek =
            Date.Extra.isBetween begWeek endWeek eventStart

        endsThisWeek =
            Date.Extra.isBetween begWeek endWeek eventEnd

        startsWeeksPrior =
            Date.Extra.diff Date.Extra.Millisecond eventStart begWeek
                |> (>) 0

        endsWeeksAfter =
            Date.Extra.diff Date.Extra.Millisecond endWeek eventEnd
                |> (>) 0

        maybeEventOnDate =
            if startsThisWeek && endsThisWeek then
                Just StartsAndEnds
            else if startsWeeksPrior && endsWeeksAfter then
                Just ContinuesAfterAndPrior
            else if startsThisWeek && endsWeeksAfter then
                Just ContinuesAfter
            else if endsThisWeek && startsWeeksPrior then
                Just ContinuesPrior
            else
                Nothing

        eventWidth eventWithinWeek =
            cellWidth
                * (toFloat
                    <| case eventWithinWeek of
                        StartsAndEnds ->
                            Date.Extra.diff Date.Extra.Day eventStart eventEnd + 1

                        ContinuesAfter ->
                            7 - (Date.Extra.weekdayNumber eventStart) + 1

                        ContinuesPrior ->
                            7 - (Date.Extra.weekdayNumber eventEnd) + 1

                        ContinuesAfterAndPrior ->
                            7
                  )

        eventWidthPercentage eventWithinWeek =
            (toString <| eventWidth eventWithinWeek) ++ "%"

        eventSegment eventWithinWeek =
            div [ eventWeekStyles eventWithinWeek ]
                [ div [ class "elm-calendar--month-event-content" ] [ text <| config.title event ] ]

        viewEvent eventWithinWeek =
            if offsetLength eventStart > 0 then
                [ rowSegment (offsetPercentage eventStart) [], rowSegment (eventWidthPercentage eventWithinWeek) [ eventSegment eventWithinWeek ] ]
            else
                [ rowSegment (eventWidthPercentage eventWithinWeek) [ eventSegment eventWithinWeek ] ]
    in
        Maybe.map viewEvent maybeEventOnDate


cellWidth : Float
cellWidth =
    (100.0 / 7)


offsetLength : Date -> Float
offsetLength date =
    cellWidth * (toFloat <| ((Date.Extra.weekdayNumber date) % 7))


offsetPercentage : Date -> String
offsetPercentage date =
    (toString <| offsetLength date) ++ "%"


styleRowSegment : String -> Html.Attribute msg
styleRowSegment widthPercentage =
    style
        [ ( "flex-basis", widthPercentage )
        , ( "max-width", widthPercentage )
        ]


rowSegment : String -> List (Html msg) -> Html msg
rowSegment widthPercentage children =
    div [ styleRowSegment widthPercentage ] children
