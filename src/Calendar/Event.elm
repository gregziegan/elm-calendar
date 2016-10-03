module Calendar.Event exposing (..)

import Date exposing (Date)
import Date.Extra
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (..)
import Calendar.Msg exposing (Msg(..), TimeSpan(..))
import Config exposing (ViewConfig)
import Json.Decode as Json
import Mouse


type EventRange
    = StartsAndEnds
    | ContinuesAfter
    | ContinuesPrior
    | ContinuesAfterAndPrior


eventWithinRange : Date -> Date -> Date.Extra.Interval -> List Date -> Maybe EventRange
eventWithinRange start end interval dates =
    let
        begInterval =
            Maybe.withDefault start <| List.head <| dates

        endInterval =
            Maybe.withDefault end <| List.head <| List.reverse dates

        startsThisInterval =
            Date.Extra.isBetween begInterval endInterval start

        endsThisInterval =
            Date.Extra.isBetween begInterval endInterval end

        startsIntervalPrior =
            Date.Extra.diff Date.Extra.Millisecond start begInterval
                |> (>) 0

        endsIntervalAfter =
            Date.Extra.diff Date.Extra.Millisecond endInterval end
                |> (>) 0
    in
        if startsThisInterval && endsThisInterval then
            Just StartsAndEnds
        else if startsIntervalPrior && endsIntervalAfter then
            Just ContinuesAfterAndPrior
        else if startsThisInterval && endsIntervalAfter then
            Just ContinuesAfter
        else if endsThisInterval && startsIntervalPrior then
            Just ContinuesPrior
        else
            Nothing


eventStyling : ViewConfig event -> event -> EventRange -> TimeSpan -> List (Html.Attribute Msg)
eventStyling config event eventRange timeSpan =
    let
        eventStart =
            config.start event

        eventEnd =
            config.end event

        classes =
            case eventRange of
                StartsAndEnds ->
                    class "elm-calendar--event elm-calendar--event-starts-and-ends"

                ContinuesAfter ->
                    class "elm-calendar--event elm-calendar--event-continues-after"

                ContinuesPrior ->
                    class "elm-calendar--event elm-calendar--event-continues-prior"

                ContinuesAfterAndPrior ->
                    class "elm-calendar--event"

        styles =
            case timeSpan of
                Month ->
                    style []

                Week ->
                    style []

                Day ->
                    styleDayEvent eventStart eventEnd

                Agenda ->
                    style []
    in
        [ classes, styles ]


viewMonthEvent : ViewConfig event -> event -> EventRange -> List (Html Msg)
viewMonthEvent config event eventRange =
    let
        eventStart =
            config.start event

        eventEnd =
            config.end event

        numDaysThisWeek =
            case eventRange of
                StartsAndEnds ->
                    Date.Extra.diff Date.Extra.Day eventStart eventEnd + 1

                ContinuesAfter ->
                    7 - (Date.Extra.weekdayNumber eventStart) + 1

                ContinuesPrior ->
                    7 - (Date.Extra.weekdayNumber eventEnd) + 1

                ContinuesAfterAndPrior ->
                    7

        eventWidthPercentage eventRange =
            (numDaysThisWeek
                |> toFloat
                |> (*) cellWidth
                |> toString
            )
                ++ "%"
    in
        if offsetLength eventStart > 0 then
            [ rowSegment (offsetPercentage eventStart) []
            , rowSegment (eventWidthPercentage eventRange) [ eventSegment config event eventRange Month ]
            ]
        else
            [ rowSegment (eventWidthPercentage eventRange) [ eventSegment config event eventRange Month ] ]


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


styleDayEvent : Date -> Date -> Html.Attribute Msg
styleDayEvent start end =
    let
        startPercent =
            100 * (Date.Extra.fractionalDay start)

        endPercent =
            100 * (Date.Extra.fractionalDay end)

        height =
            (toString <| endPercent - startPercent) ++ "%"

        startPercentage =
            (toString startPercent) ++ "%"
    in
        style
            [ "top" => startPercentage
            , "height" => height
            , "left" => "0%"
            , "width" => "90%"
            , "position" => "absolute"
            ]


viewDayEvent : ViewConfig event -> event -> EventRange -> Html Msg
viewDayEvent config event eventRange =
    eventSegment config event eventRange Day


eventSegment : ViewConfig event -> event -> EventRange -> TimeSpan -> Html Msg
eventSegment config event eventRange timeSpan =
    let
        eventId =
            config.toId event
    in
        div
            ([ onClick <| EventClick eventId
             , onMouseEnter <| EventMouseEnter eventId
             , onMouseLeave <| EventMouseLeave eventId
             , on "mousedown" <| Json.map (EventDragStart eventId) Mouse.position
             ]
                ++ eventStyling config event eventRange timeSpan
            )
            [ div [ class "elm-calendar--event-content" ]
                [ text <| config.title event ]
            ]


cellWidth : Float
cellWidth =
    100.0 / 7


offsetLength : Date -> Float
offsetLength date =
    (Date.Extra.weekdayNumber date)
        % 7
        |> toFloat
        |> (*) cellWidth


offsetPercentage : Date -> String
offsetPercentage date =
    (offsetLength date
        |> toString
    )
        ++ "%"


styleRowSegment : String -> Html.Attribute Msg
styleRowSegment widthPercentage =
    style
        [ ( "flex-basis", widthPercentage )
        , ( "max-width", widthPercentage )
        ]


rowSegment : String -> List (Html Msg) -> Html Msg
rowSegment widthPercentage children =
    div [ styleRowSegment widthPercentage ] children
