module Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts
import Config exposing (ViewConfig)
import Helpers
import Calendar.Msg exposing (Msg(..))
import Json.Decode as Json
import Mouse


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


type EventWithinWeek
    = StartsAndEnds
    | ContinuesAfter
    | ContinuesPrior
    | ContinuesAfterAndPrior


eventWeekStyles : EventWithinWeek -> Html.Attribute Msg
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


viewWeekEvent : ViewConfig event -> List Date -> event -> Maybe (List (Html Msg))
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
    in
        Maybe.map (viewEvent config event) maybeEventOnDate


viewEvent : ViewConfig event -> event -> EventWithinWeek -> List (Html Msg)
viewEvent config event eventWithinWeek =
    let
        eventStart =
            config.start event

        eventEnd =
            config.end event

        numDaysThisWeek =
            case eventWithinWeek of
                StartsAndEnds ->
                    Date.Extra.diff Date.Extra.Day eventStart eventEnd + 1

                ContinuesAfter ->
                    7 - (Date.Extra.weekdayNumber eventStart) + 1

                ContinuesPrior ->
                    7 - (Date.Extra.weekdayNumber eventEnd) + 1

                ContinuesAfterAndPrior ->
                    7

        eventWidthPercentage eventWithinWeek =
            numDaysThisWeek
                |> toFloat
                |> (*) cellWidth
                |> toString
                |> (++) "%"
    in
        if offsetLength eventStart > 0 then
            [ rowSegment (offsetPercentage eventStart) []
            , rowSegment (eventWidthPercentage eventWithinWeek) [ eventSegment config event eventWithinWeek ]
            ]
        else
            [ rowSegment (eventWidthPercentage eventWithinWeek) [ eventSegment config event eventWithinWeek ] ]


eventSegment : ViewConfig event -> event -> EventWithinWeek -> Html Msg
eventSegment config event eventWithinWeek =
    let
        eventId =
            config.toId event
    in
        div
            [ eventWeekStyles eventWithinWeek
            , onClick <| EventClick eventId
            , onMouseEnter <| EventMouseEnter eventId
            , onMouseLeave <| EventMouseLeave eventId
            , on "mousedown" <| Json.map (EventDragStart eventId) Mouse.position
            ]
            [ div [ class "elm-calendar--month-event-content" ]
                [ text <| config.title event ]
            ]


cellWidth : Float
cellWidth =
    100.0 / 7


offsetLength : Date -> Float
offsetLength date =
    Date.Extra.weekdayNumber date
        |> (%) 7
        |> toFloat
        |> (*) cellWidth


offsetPercentage : Date -> String
offsetPercentage date =
    offsetLength date
        |> toString
        |> (++) "%"


styleRowSegment : String -> Html.Attribute Msg
styleRowSegment widthPercentage =
    style
        [ ( "flex-basis", widthPercentage )
        , ( "max-width", widthPercentage )
        ]


rowSegment : String -> List (Html Msg) -> Html Msg
rowSegment widthPercentage children =
    div [ styleRowSegment widthPercentage ] children
