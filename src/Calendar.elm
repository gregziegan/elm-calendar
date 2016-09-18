module Calendar exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Date exposing (Date)
import Date.Extra
import DefaultStyles exposing (..)
import Calendar.Config exposing (ViewConfig, defaultConfig)
import Calendar.Agenda as Agenda
import Calendar.Day as Day
import Calendar.Month as Month
import Calendar.Week as Week
import Helpers exposing (TimeSpan(..))


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
    = PageBack
    | PageForward
    | ChangeTimeSpan TimeSpan


update : Msg -> State -> State
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
            Helpers.toTimeSpan timespan
    in
        case timespanType of
            Week ->
                { state | viewing = Date.Extra.add Date.Extra.Week step viewing }

            Day ->
                { state | viewing = Date.Extra.add Date.Extra.Day step viewing }

            _ ->
                { state | viewing = Date.Extra.add Date.Extra.Month step viewing }


changeTimespan : Helpers.TimeSpan -> State -> State
changeTimespan timespan state =
    { state | timespan = Helpers.fromTimeSpan timespan }


view : ViewConfig event -> List event -> State -> Html Msg
view config events { viewing, timespan } =
    let
        timespanType =
            Helpers.toTimeSpan timespan

        calendarView =
            case timespanType of
                Month ->
                    Month.view viewing

                Week ->
                    Week.view viewing

                Day ->
                    Day.view viewing

                Agenda ->
                    Agenda.view config events viewing
    in
        div [ styleCalendar ]
            [ viewToolbar viewing timespanType
            , calendarView
            ]


viewToolbar : Date -> TimeSpan -> Html Msg
viewToolbar viewing timespan =
    div [ styleToolbar ]
        [ viewPagination
        , viewTitle viewing
        , viewTimespanSelection timespan
        ]


viewTitle : Date -> Html msg
viewTitle viewing =
    let
        title =
            Date.Extra.toFormattedString "MMMM y" viewing
    in
        div []
            [ h2 [] [ text title ] ]


viewPagination : Html Msg
viewPagination =
    div []
        [ button [ styleButton, onClick PageBack ] [ text "back" ]
        , button [ styleButton, onClick PageForward ] [ text "next" ]
        ]


viewTimespanSelection : TimeSpan -> Html Msg
viewTimespanSelection timespan =
    div []
        [ button [ styleButton, onClick (ChangeTimeSpan Month) ] [ text "Month" ]
        , button [ styleButton, onClick (ChangeTimeSpan Week) ] [ text "Week" ]
        , button [ styleButton, onClick (ChangeTimeSpan Day) ] [ text "Day" ]
        , button [ styleButton, onClick (ChangeTimeSpan Agenda) ] [ text "Agenda" ]
        ]
