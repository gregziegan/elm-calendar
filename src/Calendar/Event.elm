module Calendar.Event exposing (..)

import Date exposing (Date)
import Date.Extra
import Html exposing (..)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (..)
import Calendar.Msg exposing (Msg(..), TimeSpan(..))
import Config exposing (ViewConfig)
import Json.Decode as Json
import Mouse
import Helpers


type EventRange
    = StartsAndEnds
    | ContinuesAfter
    | ContinuesPrior
    | ContinuesAfterAndPrior
    | ExistsOutside


rangeDescription : Date -> Date -> Date.Extra.Interval -> Date -> EventRange
rangeDescription start end interval date =
    let
        day =
            Helpers.bumpMidnightBoundary date

        begInterval =
            Date.Extra.floor interval day

        endInterval =
            Date.Extra.ceiling interval day
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


eventStyling :
    ViewConfig event
    -> event
    -> EventRange
    -> TimeSpan
    -> List ( String, Bool )
    -> List (Html.Attribute msg)
eventStyling config event eventRange timeSpan customClasses =
    let
        eventStart =
            config.start event

        eventEnd =
            config.end event

        classes =
            case eventRange of
                StartsAndEnds ->
                    "elm-calendar--event elm-calendar--event-starts-and-ends"

                ContinuesAfter ->
                    "elm-calendar--event elm-calendar--event-continues-after"

                ContinuesPrior ->
                    "elm-calendar--event elm-calendar--event-continues-prior"

                ContinuesAfterAndPrior ->
                    "elm-calendar--event"

                ExistsOutside ->
                    ""

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
        [ classList (( classes, True ) :: customClasses), styles ]


maybeViewMonthEvent : ViewConfig event -> event -> Maybe String -> EventRange -> Maybe (Html Msg)
maybeViewMonthEvent config event selectedId eventRange =
    case eventRange of
        ExistsOutside ->
            Nothing

        _ ->
            Just <| viewMonthEvent config event selectedId eventRange


viewMonthEvent : ViewConfig event -> event -> Maybe String -> EventRange -> Html Msg
viewMonthEvent config event selectedId eventRange =
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
                , rowSegment (eventWidthPercentage eventRange) [ eventSegment config event selectedId eventRange Month ]
                ]
        else
            div [ class "elm-calendar--row" ]
                [ rowSegment (eventWidthPercentage eventRange) [ eventSegment config event selectedId eventRange Month ] ]


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


styleDayEvent : Date -> Date -> Html.Attribute msg
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


maybeViewDayEvent : ViewConfig event -> event -> Maybe String -> EventRange -> Maybe (Html Msg)
maybeViewDayEvent config event selectedId eventRange =
    case eventRange of
        ExistsOutside ->
            Nothing

        _ ->
            Just <| eventSegment config event selectedId eventRange Day


eventSegment : ViewConfig event -> event -> Maybe String -> EventRange -> TimeSpan -> Html Msg
eventSegment config event selectedId eventRange timeSpan =
    let
        eventId =
            config.toId event

        isSelected =
            Maybe.map ((==) eventId) selectedId
                |> Maybe.withDefault False

        { nodeName, classes, children } =
            config.event event isSelected
    in
        node nodeName
            ([ onClick <| EventClick eventId
             , onMouseEnter <| EventMouseEnter eventId
             , onMouseLeave <| EventMouseLeave eventId
             , on "mousedown" <| Json.map (EventDragStart eventId) Mouse.position
             ]
                ++ eventStyling config event eventRange timeSpan classes
            )
            children


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


styleRowSegment : String -> Html.Attribute msg
styleRowSegment widthPercentage =
    style
        [ ( "flex-basis", widthPercentage )
        , ( "max-width", widthPercentage )
        ]


rowSegment : String -> List (Html Msg) -> Html Msg
rowSegment widthPercentage children =
    div [ styleRowSegment widthPercentage ] children
