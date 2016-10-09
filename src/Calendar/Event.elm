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
    | ExistsOutside


rangeDescription : Date -> Date -> Date.Extra.Interval -> Date -> EventRange
rangeDescription start end interval date =
    let
        begInterval =
            Date.Extra.floor interval date

        endInterval =
            Date.Extra.add interval 1 date
                |> Date.Extra.ceiling interval
                |> Date.Extra.add Date.Extra.Millisecond -1

        startsThisInterval =
            Date.Extra.isBetween begInterval endInterval start

        endsThisInterval =
            Date.Extra.isBetween begInterval endInterval end

        startsBeforeInterval =
            Date.Extra.diff Date.Extra.Millisecond begInterval start
                |> (>) 0

        endsAfterInterval =
            Date.Extra.diff Date.Extra.Millisecond end endInterval
                |> (>) 0
    in
        if startsThisInterval && endsThisInterval then
            StartsAndEnds
        else if startsBeforeInterval && endsAfterInterval then
            ContinuesAfterAndPrior
        else if startsThisInterval && endsAfterInterval then
            ContinuesAfter
        else if endsThisInterval && startsBeforeInterval then
            ContinuesPrior
        else
            ExistsOutside


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

                ExistsOutside ->
                    class ""

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


maybeViewMonthEvent : ViewConfig event -> event -> EventRange -> Maybe (Html Msg)
maybeViewMonthEvent config event eventRange =
    case eventRange of
        ExistsOutside ->
            Nothing

        _ ->
            Just <| viewMonthEvent config event eventRange


viewMonthEvent : ViewConfig event -> event -> EventRange -> Html Msg
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

                ExistsOutside ->
                    0

        eventWidthPercentage eventRange =
            (numDaysThisWeek
                |> toFloat
                |> (*) cellWidth
                |> toString
            )
                ++ "%"
    in
        if offsetLength eventStart > 0 then
            div [ class "elm-calendar--row" ]
                [ rowSegment (offsetPercentage eventStart) []
                , rowSegment (eventWidthPercentage eventRange) [ eventSegment config event eventRange Month ]
                ]
        else
            div [ class "elm-calendar--row" ]
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


maybeViewDayEvent : ViewConfig event -> event -> EventRange -> Maybe (Html Msg)
maybeViewDayEvent config event eventRange =
    case eventRange of
        ExistsOutside ->
            Nothing

        _ ->
            Just <| eventSegment config event eventRange Day


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
