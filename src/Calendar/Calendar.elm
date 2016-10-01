module Calendar.Calendar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Date exposing (Date)
import Date.Extra
import Config exposing (ViewConfig, defaultConfig)
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
                    Month.view config events viewing

                Week ->
                    Week.view config events viewing

                Day ->
                    Day.view config events viewing

                Agenda ->
                    Agenda.view config events viewing
    in
        div [ class "elm-calendar--calendar" ]
            [ viewToolbar viewing timespanType
            , calendarView
            ]


viewToolbar : Date -> TimeSpan -> Html Msg
viewToolbar viewing timespan =
    div [ class "elm-calendar--toolbar" ]
        [ viewPagination
        , viewTitle viewing
        , viewTimespanSelection timespan
        ]


viewTitle : Date -> Html Msg
viewTitle viewing =
    div []
        [ h2 [] [ text <| Date.Extra.toFormattedString "MMMM yyyy" viewing ] ]


viewPagination : Html Msg
viewPagination =
    div []
        [ button [ class "elm-calendar--button", onClick PageBack ] [ text "back" ]
        , button [ class "elm-calendar--button", onClick PageForward ] [ text "next" ]
        ]


viewTimespanSelection : TimeSpan -> Html Msg
viewTimespanSelection timespan =
    div []
        [ button [ class "elm-calendar--button", onClick (ChangeTimeSpan Month) ] [ text "Month" ]
        , button [ class "elm-calendar--button", onClick (ChangeTimeSpan Week) ] [ text "Week" ]
        , button [ class "elm-calendar--button", onClick (ChangeTimeSpan Day) ] [ text "Day" ]
        , button [ class "elm-calendar--button", onClick (ChangeTimeSpan Agenda) ] [ text "Agenda" ]
        ]
