module Calendar exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts as DateFacts
import DefaultStyles exposing (..)
import List.Extra
import Time


type alias State =
    { timespan : String
    , viewing : Date
    }


init : String -> Date -> State
init timespan viewing =
    { timespan = timespan
    , viewing = viewing
    }


type TimeSpan
    = Month
    | Week
    | Day
    | Agenda


toTimeSpan : String -> TimeSpan
toTimeSpan timespan =
    case timespan of
        "Month" ->
            Month

        "Week" ->
            Week

        "Day" ->
            Day

        "Agenda" ->
            Agenda

        _ ->
            Month


fromTimeSpan : TimeSpan -> String
fromTimeSpan timespan =
    case timespan of
        Month ->
            "Month"

        Week ->
            "Week"

        Day ->
            "Day"

        Agenda ->
            "Agenda"


type Msg
    = PageBack
    | PageForward
    | ChangeTimeSpan TimeSpan


update msg state =
    case msg of
        PageBack ->
            state
                |> page -1

        PageForward ->
            state
                |> page 1

        ChangeTimeSpan timespan ->
            state
                |> changeTimespan timespan


page : Int -> State -> State
page step state =
    let
        { timespan, viewing } =
            state

        timespanType =
            toTimeSpan timespan
    in
        case timespanType of
            Week ->
                { state | viewing = Date.Extra.add Date.Extra.Week step viewing }

            Day ->
                { state | viewing = Date.Extra.add Date.Extra.Day step viewing }

            _ ->
                { state | viewing = Date.Extra.add Date.Extra.Month step viewing }


changeTimespan timespan state =
    { state | timespan = fromTimeSpan timespan }


view : State -> Html Msg
view state =
    let
        calendarView =
            case toTimeSpan state.timespan of
                Month ->
                    viewMonth state

                Week ->
                    viewWeek state (weekRangeFromDate state.viewing)

                Day ->
                    viewDay state.viewing

                Agenda ->
                    viewAgenda state.viewing
    in
        div [ styleCalendar ]
            [ viewToolbar state
            , calendarView
            ]


weekRangeFromDate : Date -> List Date
weekRangeFromDate date =
    let
        startOfWeek =
            Date.Extra.floor Date.Extra.Sunday date
    in
        Date.Extra.range Date.Extra.Day
            1
            startOfWeek
            (Date.Extra.add Date.Extra.Week 1 startOfWeek)


viewToolbar state =
    div [ styleToolbar ]
        [ viewPagination state
        , viewTitle state
        , viewTimespanSelection state
        ]


viewTitle { viewing } =
    div []
        [ h2 [] [ text <| Date.Extra.toFormattedString "MMMM yyyy" viewing ] ]


viewPagination state =
    div []
        [ button [ styleButton, onClick PageBack ] [ text "back" ]
        , button [ styleButton, onClick PageForward ] [ text "next" ]
        ]


viewTimespanSelection state =
    div []
        [ button [ styleButton, onClick (ChangeTimeSpan Month) ] [ text "Month" ]
        , button [ styleButton, onClick (ChangeTimeSpan Week) ] [ text "Week" ]
        , button [ styleButton, onClick (ChangeTimeSpan Day) ] [ text "Day" ]
        , button [ styleButton, onClick (ChangeTimeSpan Agenda) ] [ text "Agenda" ]
        ]


weekRangesFromMonth : Int -> Date.Month -> List (List Date)
weekRangesFromMonth year month =
    let
        firstOfMonth =
            Date.Extra.fromCalendarDate year month 1

        firstOfNextMonth =
            Date.Extra.add Date.Extra.Month 1 firstOfMonth
    in
        Date.Extra.range Date.Extra.Day 1
            (Date.Extra.floor Date.Extra.Sunday firstOfMonth)
            (Date.Extra.ceiling Date.Extra.Sunday firstOfNextMonth)
        |> List.Extra.groupsOf 7


viewMonth : State -> Html Msg
viewMonth state =
    let
        weeks =
            weekRangesFromMonth (Date.year state.viewing) (Date.month state.viewing)

        styleWeek =
            style
                [ ( "display", "flex" )
                ]

        viewWeek week =
            div [ styleWeek ]
                (List.map (viewCell state) week)
    in
        div [ styleMonth ]
            (List.map viewWeek weeks)


viewCell : State -> Date -> Html Msg
viewCell state date =
    div [ styleCell ]
        [ text <| toString <| Date.day date ]


viewWeek state days =
    div [ styleWeek ]
        [ viewWeekHeader days
        , viewWeekContent state days
        ]


viewWeekHeader days =
    div [ styleWeekHeader ]
        [ viewDates days
        , viewAllDayCell days
        ]


viewDate day =
    div [ styleDateHeader ]
        [ a [ styleDate, href "#" ] [ text <| Date.Extra.toFormattedString "EEE d" day ] ]


viewTimeGutterHeader =
    div [ style [ ( "min-width", "70px" ) ] ] []


viewDates days =
    div [ styleDates ]
        (viewTimeGutterHeader :: List.map viewDate days)


viewAllDayCell days =
    let
        viewAllDayText =
            div [ style [ ( "min-width", "70px" ), ( "padding", "0 5px" ) ] ] [ text "All day" ]

        viewAllDay day =
            div [ styleAllDay ]
                []
    in
        div [ styleAllDayCell ]
            (viewAllDayText :: List.map viewAllDay days)


viewWeekContent { viewing } days =
    div [ styleWeekContent ]
        ([ viewTimeGutter viewing ] ++ (List.map viewWeekDay days))


hours date =
    let
        midnight =
            Date.Extra.floor Date.Extra.Day date

        nextMidnight =
            Date.Extra.add Date.Extra.Day 1 midnight
    in
        Date.Extra.range Date.Extra.Hour 1 midnight nextMidnight


viewTimeGutter date =
    hours date
        |> List.map viewTimeSlotGroup
        |> div [ styleTimeGutter ]


viewTimeSlotGroup date =
    div [ styleTimeSlotGroup ]
        [ viewTimeSlot date
        , div [ style [ ( "flex", "1 0 0" ) ] ] []
        ]


viewTimeSlot date =
    div [ style [ ( "padding", "0 5px" ), ( "flex", "1 0 0" ) ] ]
        [ span [ style [ ( "font-size", "14px" ) ] ] [ text <| hourString date ] ]


viewDaySlot day =
    hours day
        |> List.map viewDaySlotGroup
        |> div [ styleDaySlot ]


viewDaySlotGroup hourString =
    div [ styleTimeSlotGroup ]
        [ div [ style [ ( "flex", "1 0 0" ) ] ] []
        , div [ style [ ( "flex", "1 0 0" ) ] ] []
        ]


viewWeekDay day =
    div [ styleDay ]
        [ viewDaySlot day
        ]


viewDay day =
    div [ styleDay ]
        [ viewDayHeader day
        , div [ style [ ( "display", "flex" ) ] ]
            [ viewTimeGutter day
            , viewDaySlot day
            ]
        ]


viewDayHeader day =
    div []
        [ viewTimeGutterHeader
        , viewDate day
        ]



-- type alias EventGroup =
--   { date : Date
--   , events : List Event
--   }


eventsGroupedByDate events =
    let
        initEventGroup event =
            { date = event.start, events = [ event ] }

        buildEventGroup event eventGroups =
            let
                restOfEventGroups groups =
                    case List.tail groups of
                        Nothing ->
                            Debug.crash "There should never be Nothing for this list."

                        Just restOfGroups ->
                            restOfGroups
            in
                case List.head eventGroups of
                    Nothing ->
                        [ initEventGroup event ]

                    Just eventGroup ->
                        if Date.Extra.isBetween eventGroup.date (Date.Extra.add Date.Extra.Day 1 eventGroup.date) event.start then
                            { eventGroup | events = event :: eventGroup.events } :: (restOfEventGroups eventGroups)
                        else
                            initEventGroup event :: eventGroups
    in
        List.sortBy (Date.toTime << .start) events
            |> List.foldr buildEventGroup []


viewAgenda date =
    let
        groupedEvents =
            eventsGroupedByDate events

        isDateInMonth =
            Date.Extra.equalBy Date.Extra.Month date

        filteredEventsByMonth =
            List.filter (isDateInMonth << .date) groupedEvents
    in
        div [ styleAgenda ]
            (viewAgendaHeader :: List.map viewAgendaDay filteredEventsByMonth)



-- Date | Time | Event


viewAgendaHeader =
    div [ styleAgendaHeader ]
        [ div [ styleHeaderCell ] [ text "Date" ]
        , div [ styleHeaderCell ] [ text "Time" ]
        , div [ styleHeaderCell ] [ text "Event" ]
        ]


viewAgendaDay eventGroup =
    let
        dateString =
            Date.Extra.toFormattedString "EEE MMM d" eventGroup.date
    in
        div [ styleAgendaDay ]
            [ div [ styleAgendaDateCell ] [ text <| dateString ]
            , viewAgendaTimes eventGroup.events
            ]


viewAgendaTimes events =
    div []
        (List.map viewEventAndTime events)


hourString date =
    Date.Extra.toFormattedString "h:mm a" date


viewEventAndTime event =
    let
        startTime =
            hourString event.start

        endTime =
            hourString event.end

        timeRange =
            startTime ++ " - " ++ endTime
    in
        div [ style [ ( "display", "flex" ) ] ]
            [ div [ styleAgendaCell ] [ text timeRange ]
            , div [ styleAgendaCell ] [ text event.title ]
            ]


someUnixTime =
    1473652025106


events =
    [ { id = "brunch1", title = "Brunch w/ Friends", start = Date.fromTime someUnixTime, end = Date.fromTime <| (someUnixTime + 2 * Time.hour) }
    , { id = "brunch2", title = "Brunch w/o Friends :(", start = Date.fromTime <| someUnixTime + (24 * Time.hour), end = Date.fromTime <| someUnixTime + (25 * Time.hour) }
    , { id = "conference", title = "Strangeloop", start = Date.fromTime <| someUnixTime + (200 * Time.hour), end = Date.fromTime <| someUnixTime + (258 * Time.hour) }
    ]
