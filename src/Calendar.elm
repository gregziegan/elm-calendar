module Calendar exposing (..)

import Html exposing (..)
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


type Msg
    = ChangeTimespan String


update msg model =
    case msg of
        ChangeTimespan newTimespan ->
            model
                |> changeTimespan newTimespan


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


viewTitle state =
    div []
        [ h2 [] [ text "September 2016" ] ]


viewPagination state =
    div []
        [ button [ styleButton ] [ text "back" ]
        , button [ styleButton ] [ text "next" ]
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



-- 28 -> 1
-- 5 weeks


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
            Date.Extra.weekdayNumber begMonth
                |> toFloat
                |> (*) (24 * Time.hour)
                |> (-) (Date.toTime begMonth)
                |> Date.fromTime

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
        , List.drop 28 fullRange
        ]


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
