module Calendar.Month exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts
import DefaultStyles exposing (..)
import Config exposing (ViewConfig)
import Helpers


view : ViewConfig event -> List event -> Date -> Html msg
view config events viewing =
    let
        weeks =
            Helpers.getMonthRange viewing
    in
        div [ styleColumn ]
            [ viewMonthHeader
            , div [ styleMonth ]
                (List.map (viewMonthRow config events) weeks)
            ]


viewMonthHeader : Html msg
viewMonthHeader =
    let
        viewDayOfWeek int =
            viewDay <| Date.Extra.Facts.dayOfWeekFromWeekdayNumber int
    in
        div [ styleRow, style [ ( "width", "1200px" ) ] ] (List.map viewDayOfWeek [0..6])


viewDay : Date.Day -> Html msg
viewDay day =
    div [ styleMonthDayHeader ]
        [ a [ styleDate, href "#" ] [ text <| toString day ] ]


viewMonthRow : ViewConfig event -> List event -> List Date -> Html msg
viewMonthRow config events week =
    div [ styleMonthRow ]
        [ viewMonthRowBackground week
        , viewMonthRowContent config events week
        ]


viewMonthRowBackground : List Date -> Html msg
viewMonthRowBackground week =
    div [ styleMonthRowBackground ]
        (List.map (\_ -> div [ styleCell ] []) week)


viewMonthRowContent : ViewConfig event -> List event -> List Date -> Html msg
viewMonthRowContent config events week =
    let
        dateCell date =
            div [ styleDateCell ] [ text <| toString <| Date.day date ]

        datesRow =
            div [ styleRow ] (List.map dateCell week)

        maybeViewEvent event =
            viewMonthWeekRow <| viewWeekEvent config week event

        eventRows =
            List.filterMap maybeViewEvent events
                |> List.take 3
    in
        div [ styleMonthWeek ]
            (datesRow :: eventRows)


viewMonthWeekRow : Maybe (List (Html msg)) -> Maybe (Html msg)
viewMonthWeekRow maybeChildren =
    let
        nest children =
            div [ styleMonthWeekRow ] children
    in
        Maybe.map nest maybeChildren


type EventWithinWeek
    = StartsAndEnds
    | ContinuesAfter
    | ContinuesPrior
    | ContinuesAfterAndPrior


eventWeekStyles : EventWithinWeek -> List ( String, String )
eventWeekStyles eventWithinWeek =
    case eventWithinWeek of
        StartsAndEnds ->
            monthEventStartsAndEndsMixin

        ContinuesAfter ->
            monthEventContinuesAfterMixin

        ContinuesPrior ->
            monthEventContinuesPriorMixin

        ContinuesAfterAndPrior ->
            monthEventContinuesAfterAndPriorMixin


viewWeekEvent : ViewConfig event -> List Date -> event -> Maybe (List (Html msg))
viewWeekEvent config week event =
    let
        cellWidth =
            (100.0 / 7)

        offsetLength =
            cellWidth * (toFloat <| (Date.Extra.weekdayNumber (config.start event)) % 7)

        offsetPercentage =
            (toString offsetLength) ++ "%"

        styleRowSegment widthPercentage =
            style
                [ ( "flex-basis", widthPercentage )
                , ( "max-width", widthPercentage )
                ]

        rowSegment widthPercentage children =
            div [ styleRowSegment widthPercentage ] children

        begWeek =
            Maybe.withDefault (config.start event) <| List.head <| week

        endWeek =
            Maybe.withDefault (config.end event) <| List.head <| List.reverse week

        startsThisWeek =
            Date.Extra.isBetween begWeek endWeek (config.start event)

        endsThisWeek =
            Date.Extra.isBetween begWeek endWeek (config.end event)

        startsWeeksPrior =
            Date.Extra.diff Date.Extra.Millisecond (config.start event) begWeek
                |> (>) 0

        endsWeeksAfter =
            Date.Extra.diff Date.Extra.Millisecond endWeek (config.end event)
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
                            Date.Extra.diff Date.Extra.Day (config.start event) (config.end event) + 1

                        ContinuesAfter ->
                            7 - (Date.Extra.weekdayNumber <| config.start event) + 1

                        ContinuesPrior ->
                            7 - (Date.Extra.weekdayNumber <| config.end event) + 1

                        ContinuesAfterAndPrior ->
                            7
                  )

        eventWidthPercentage eventWithinWeek =
            (toString <| eventWidth eventWithinWeek) ++ "%"

        eventSegment eventWithinWeek =
            div [ style (eventWeekStyles eventWithinWeek) ]
                [ div [ styleMonthEventContent ] [ text <| config.title <| Debug.log "event" event ] ]

        viewEvent eventWithinWeek =
            if offsetLength > 0 then
                [ rowSegment offsetPercentage [], rowSegment (eventWidthPercentage eventWithinWeek) [ eventSegment eventWithinWeek ] ]
            else
                [ rowSegment (eventWidthPercentage eventWithinWeek) [ eventSegment eventWithinWeek ] ]
    in
        Maybe.map viewEvent maybeEventOnDate
