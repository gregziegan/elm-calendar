module Calendar.Internal exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Date exposing (Date)
import Date.Extra
import Config exposing (ViewConfig, EventConfig, TimeSlotConfig)
import Calendar.Agenda as Agenda
import Calendar.Day as Day
import Calendar.Month as Month
import Calendar.Week as Week
import Calendar.Msg exposing (Msg(..), TimeSpan(..))
import Mouse
import Time exposing (Time)


type alias State =
    { timeSpan : TimeSpan
    , viewing : Date
    , dragState : Maybe Drag
    , selected : Maybe String
    }


type alias Drag =
    { start : Mouse.Position
    , current : Mouse.Position
    , kind : DragKind
    }


type DragKind
    = Event String
    | TimeSlot Date


init : TimeSpan -> Date -> State
init timeSpan viewing =
    { timeSpan = timeSpan
    , viewing = viewing
    , dragState = Nothing
    , selected = Nothing
    }


update : EventConfig msg -> TimeSlotConfig msg -> Msg -> State -> ( State, Maybe msg )
update eventConfig timeSlotConfig msg state =
    case msg of
        PageBack ->
            ( state
                |> page -1
            , Nothing
            )

        PageForward ->
            ( state
                |> page 1
            , Nothing
            )

        ChangeTimeSpan timeSpan ->
            ( state
                |> changeTimeSpan timeSpan
            , Nothing
            )

        TimeSlotClick date xy ->
            ( state
            , timeSlotConfig.onClick date xy
            )

        TimeSlotMouseEnter date xy ->
            ( state
            , timeSlotConfig.onMouseEnter date xy
            )

        TimeSlotMouseLeave date xy ->
            ( state
            , timeSlotConfig.onMouseLeave date xy
            )

        TimeSlotDragStart date xy ->
            ( { state | dragState = Just { start = xy, current = xy, kind = TimeSlot date } }
            , timeSlotConfig.onDragStart date xy
            )

        TimeSlotDragging date xy ->
            ( { state | dragState = (Maybe.map (\{ start, kind } -> Drag start xy kind) state.dragState) }
            , timeSlotConfig.onDragging (getNewDateBasedOnPosition date xy state) xy
            )

        TimeSlotDragEnd date xy ->
            ( { state | dragState = Nothing }
            , timeSlotConfig.onDragEnd (getNewDateBasedOnPosition date xy state) xy
            )

        EventClick eventId ->
            ( { state | selected = Just eventId }
            , eventConfig.onClick eventId
            )

        EventMouseEnter eventId ->
            ( state
            , eventConfig.onMouseEnter eventId
            )

        EventMouseLeave eventId ->
            ( state
            , eventConfig.onMouseLeave eventId
            )

        EventDragStart eventId xy ->
            ( { state | dragState = Just { start = xy, current = xy, kind = Event eventId } }
            , eventConfig.onDragStart eventId
            )

        EventDragging eventId xy ->
            ( { state | dragState = (Maybe.map (\{ start, kind } -> Drag start xy kind) state.dragState) }
            , eventConfig.onDragging eventId (getTimeDiffForPosition xy state)
            )

        EventDragEnd eventId xy ->
            ( { state | dragState = Nothing }
            , eventConfig.onDragEnd eventId (getTimeDiffForPosition xy state)
            )


getNewDateBasedOnPosition : Date -> Mouse.Position -> State -> Date
getNewDateBasedOnPosition date xy state =
    let
        timeDiff =
            getTimeDiffForPosition xy state
                |> floor
    in
        Date.Extra.add Date.Extra.Millisecond timeDiff date


getTimeDiffForPosition : Mouse.Position -> State -> Time
getTimeDiffForPosition xy state =
    let
        timeDiff { start, current } =
            (current.y - start.y)
                // 20
                |> toFloat
                |> (*) Time.minute
                |> (*) 30
    in
        case state.timeSpan of
            Month ->
                0

            _ ->
                case state.dragState of
                    Just drag ->
                        timeDiff drag

                    Nothing ->
                        0


page : Int -> State -> State
page step state =
    let
        { timeSpan, viewing } =
            state
    in
        case timeSpan of
            Week ->
                { state | viewing = Date.Extra.add Date.Extra.Week step viewing }

            Day ->
                { state | viewing = Date.Extra.add Date.Extra.Day step viewing }

            _ ->
                { state | viewing = Date.Extra.add Date.Extra.Month step viewing }


changeTimeSpan : TimeSpan -> State -> State
changeTimeSpan timeSpan state =
    { state | timeSpan = timeSpan }


view : ViewConfig event -> List event -> State -> Html Msg
view config events { viewing, timeSpan, selected } =
    let
        calendarView =
            case timeSpan of
                Month ->
                    Month.view config events selected viewing

                Week ->
                    Week.view config events selected viewing

                Day ->
                    Day.view config events selected viewing

                Agenda ->
                    Agenda.view config events viewing
    in
        div
            [ class "elm-calendar--container"
            , Html.Attributes.draggable "false"
            ]
            [ div [ class "elm-calendar--calendar" ]
                [ viewToolbar viewing timeSpan
                , calendarView
                ]
            ]


viewToolbar : Date -> TimeSpan -> Html Msg
viewToolbar viewing timeSpan =
    div [ class "elm-calendar--toolbar" ]
        [ viewPagination
        , viewTitle viewing
        , viewTimeSpanSelection timeSpan
        ]


viewTitle : Date -> Html Msg
viewTitle viewing =
    div [ class "elm-calendar--month-title" ]
        [ h2 [] [ text <| Date.Extra.toFormattedString "MMMM yyyy" viewing ] ]


viewPagination : Html Msg
viewPagination =
    div [ class "elm-calendar--paginators" ]
        [ button [ class "elm-calendar--button", onClick PageBack ] [ text "back" ]
        , button [ class "elm-calendar--button", onClick PageForward ] [ text "next" ]
        ]


viewTimeSpanSelection : TimeSpan -> Html Msg
viewTimeSpanSelection timeSpan =
    div [ class "elm-calendar--time-spans" ]
        [ button [ class "elm-calendar--button", onClick (ChangeTimeSpan Month) ] [ text "Month" ]
        , button [ class "elm-calendar--button", onClick (ChangeTimeSpan Week) ] [ text "Week" ]
        , button [ class "elm-calendar--button", onClick (ChangeTimeSpan Day) ] [ text "Day" ]
        , button [ class "elm-calendar--button", onClick (ChangeTimeSpan Agenda) ] [ text "Agenda" ]
        ]


subscriptions : State -> Sub Msg
subscriptions state =
    case state.dragState of
        Just dragState ->
            case dragState.kind of
                TimeSlot date ->
                    Sub.batch
                        [ Mouse.moves (TimeSlotDragging date)
                        , Mouse.ups (TimeSlotDragEnd date)
                        ]

                Event eventId ->
                    Sub.batch
                        [ Mouse.moves (EventDragging eventId)
                        , Mouse.ups (EventDragEnd eventId)
                        ]

        _ ->
            Sub.none
