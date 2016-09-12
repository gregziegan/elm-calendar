module Calendar exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra
import Date.Extra.Facts
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


type Msg
    = ChangeTimespan String
    | PageBack
    | PageForward


update msg state =
    case msg of
        ChangeTimespan newTimespan ->
            state
                |> changeTimespan newTimespan

        PageBack ->
            state
                |> page -1

        PageForward ->
            state
                |> page 1


page : Int -> State -> State
page step state =
    let
        { timespan, viewing } =
            state

        timespanType =
            toTimeSpan timespan
    in
        case timespanType of
            Month ->
                { state | viewing = Date.Extra.add Date.Extra.Month step viewing }

            _ ->
                state


changeTimespan timespan model =
    { model | timespan = timespan }


view : State -> Html Msg
view state =
    div [ styleCalendar ]
        [ viewToolbar state
        , viewMonth state
        ]


viewToolbar state =
    div [ styleToolbar ]
        [ viewPagination state
        , viewTitle state
        , viewTimespanSelection state
        ]


styleToolbar =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "space-between" )
        , ( "width", "1000px" )
        ]


styleCalendar =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        ]


viewTitle { viewing } =
    let
        month =
            toString <| Date.month viewing

        year =
            toString <| Date.year viewing

        title =
            month ++ " " ++ year
    in
        div []
            [ h2 [] [ text title ] ]


viewPagination state =
    div []
        [ button [ styleButton, onClick PageBack ] [ text "back" ]
        , button [ styleButton, onClick PageForward ] [ text "next" ]
        ]


viewTimespanSelection state =
    div []
        [ button [ styleButton ] [ text "Month" ]
        , button [ styleButton ] [ text "Week" ]
        , button [ styleButton ] [ text "Day" ]
        , button [ styleButton ] [ text "Agenda" ]
        ]


styleButton =
    style
        [ ( "border", "1px solid #ccc" )
        , ( "padding", "5px" )
        , ( "background-color", "white" )
        ]


getMonthRange : Date -> List (List Date)
getMonthRange date =
    let
        curMonth =
            Date.month date

        begMonth =
            Date.Extra.floor Date.Extra.Month date

        endMonth =
            Date.Extra.ceiling Date.Extra.Month date

        monthRange =
            Date.Extra.range Date.Extra.Day 1 begMonth endMonth

        previousMonthFirstDate =
            Date.Extra.add Date.Extra.Day (-1 * (7 - endOfMonthWeekdayNum)) endMonth

        previousMonthRange =
            Date.Extra.range Date.Extra.Day 1 previousMonthFirstDate begMonth

        endOfMonthWeekdayNum =
            Date.Extra.weekdayNumber endMonth

        nextMonthLastDate =
            Date.Extra.add Date.Extra.Day (7 - endOfMonthWeekdayNum) endMonth

        nextMonthRange =
            Date.Extra.range Date.Extra.Day 1 endMonth nextMonthLastDate

        fullRange =
            List.concat [ previousMonthRange, monthRange, nextMonthRange ]
    in
        [ List.take 7 fullRange
        , List.drop 7 <| List.take 14 fullRange
        , List.drop 14 <| List.take 21 fullRange
        , List.drop 21 <| List.take 28 fullRange
        , List.drop 28 <| List.take 35 fullRange
        ]
            ++ if List.length fullRange > 35 then
                [ List.drop 35 <| List.take 42 fullRange ]
               else
                []


viewMonth : State -> Html Msg
viewMonth state =
    let
        weeks =
            getMonthRange state.viewing

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


styleMonth : Html.Attribute Msg
styleMonth =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "width", "1200px" )
        , ( "height", "800px" )
        ]


viewCell : State -> Date -> Html Msg
viewCell state date =
    div [ styleCell ]
        [ text <| toString <| Date.day date ]


styleCell : Html.Attribute Msg
styleCell =
    style
        [ ( "border", "2px solid #ccc" )
        , ( "padding", "10px" )
        , ( "width", "120px" )
        , ( "height", "100px" )
        ]
