module Calendar.Calendar exposing (..)

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


type alias State =
    { timeSpan : TimeSpan
    , viewing : Date
    , dragState : Maybe Drag
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
    }


update : EventConfig msg -> TimeSlotConfig msg -> Msg -> State -> ( State, Maybe msg )
update eventConfig timeSlotConfig msg state =
    -- case Debug.log "msg" msg of
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

        TimeSlotClick date ->
            ( state
            , timeSlotConfig.onClick date
            )

        TimeSlotMouseEnter date ->
            ( state
            , timeSlotConfig.onMouseEnter date
            )

        TimeSlotMouseLeave date ->
            ( state
            , timeSlotConfig.onMouseLeave date
            )

        TimeSlotDragStart date xy ->
            ( { state | dragState = Just { start = xy, current = xy, kind = TimeSlot date } }
            , timeSlotConfig.onDragStart date
            )

        TimeSlotDragging date xy ->
            ( { state | dragState = (Maybe.map (\{ start, kind } -> Drag start xy kind) state.dragState) }
            , timeSlotConfig.onDragging date
            )

        TimeSlotDragEnd date xy ->
            ( { state | dragState = Nothing }
            , timeSlotConfig.onDragEnd date
            )

        EventClick eventId ->
            ( state
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
            , eventConfig.onDragging eventId
            )

        EventDragEnd eventId xy ->
            ( { state | dragState = Nothing }
            , eventConfig.onDragEnd eventId
            )


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
view config events { viewing, timeSpan } =
    let
        calendarView =
            case timeSpan of
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
            [ viewToolbar viewing timeSpan
            , calendarView
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
    div []
        [ h2 [] [ text <| Date.Extra.toFormattedString "MMMM yyyy" viewing ] ]


viewPagination : Html Msg
viewPagination =
    div []
        [ button [ class "elm-calendar--button", onClick PageBack ] [ text "back" ]
        , button [ class "elm-calendar--button", onClick PageForward ] [ text "next" ]
        ]


viewTimeSpanSelection : TimeSpan -> Html Msg
viewTimeSpanSelection timeSpan =
    div []
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
