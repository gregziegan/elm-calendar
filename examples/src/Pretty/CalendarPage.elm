module Pretty.CalendarPage exposing (..)

import Calendar
import Date exposing (Date)
import Dict exposing (Dict)
import Fixtures
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (onClick)
import Mouse
import Pretty.Helpers exposing ((=>), (<<<), px)
import Pretty.Types exposing (Event, Route(EventRoute))


type alias Model =
    { calendarState : Calendar.State
    , events : Dict String Event
    , maybeEventDetails : Maybe Event
    }


init =
    ( { calendarState = Calendar.init Calendar.Month Fixtures.viewing
      , events = allEvents
      , maybeEventDetails = Nothing
      }
    , Cmd.none
    )


type Msg
    = SetCalendarState Calendar.Msg
    | SelectDate Date Mouse.Position
    | EventClick String
    | RouteTo Route


update : Msg -> Model -> ( Model, List (Cmd Msg), Maybe Route )
update msg model =
    updateRouting msg <| updateModel msg model


updateModel msg model =
    case msg of
        SetCalendarState calendarMsg ->
            let
                ( updatedCalendar, maybeMsg ) =
                    Calendar.update eventConfig timeSlotConfig calendarMsg model.calendarState

                newModel =
                    { model | calendarState = updatedCalendar }
            in
                case maybeMsg of
                    Nothing ->
                        newModel => []

                    Just updateMsg ->
                        updateModel updateMsg newModel

        SelectDate date pos ->
            model
                => []

        EventClick eventId ->
            { model | maybeEventDetails = Dict.get eventId model.events }
                => []

        RouteTo route ->
            model => []


updateRouting msg ( model, cmds ) =
    case msg of
        RouteTo route ->
            ( model, cmds, Just route )

        _ ->
            ( model, cmds, Nothing )


view : Model -> Html Msg
view model =
    let
        events =
            Dict.values model.events
    in
        div []
            [ Html.map SetCalendarState (Calendar.view (viewConfig model) events model.calendarState)
            ]


viewEventDialog : Event -> Html msg
viewEventDialog event =
    let
        timeRangeText =
            toString event.start ++ " - " ++ toString event.end

        isFull =
            event.id == "1"
    in
        div
            [ class "event-dialog"
              -- , style
              -- [ "top" => px 10
              -- , "left" => px 10
              -- ]
            ]
            [ p [] [ text event.title ]
            , p [] [ text timeRangeText ]
            , div
                [ class "event-dialog__buttons" ]
                [ button
                    [ class "event-dialog__details"
                    , onClick <| RouteTo <| EventRoute event.id
                    ]
                    [ text "Details" ]
                , button
                    [ classList
                        [ ( "event-dialog__signup", True )
                        , ( "event-dialog__signup--disabled", isFull )
                        ]
                      -- , onClick (SignUp event.id)
                    ]
                    [ text "Sign up" ]
                ]
            ]


viewConfig : Model -> Calendar.ViewConfig Event
viewConfig model =
    let
        isDialogEvent event1 event2 =
            if event1.id == event2.id then
                Just <| viewEventDialog event1
            else
                Nothing
    in
        Calendar.viewConfig
            { toId = .id
            , title = .title
            , start = .start
            , end = .end
            , event =
                \event isSelected ->
                    Calendar.eventView
                        { nodeName = "div"
                        , classes = []
                        , children =
                            [ div
                                [ classList
                                    [ ( "elm-calendar--event-content", True )
                                    , ( "elm-calendar--event-content--is-selected", isSelected )
                                    ]
                                ]
                                [ text <| event.title ]
                            , model.maybeEventDetails
                                |> Maybe.andThen (isDialogEvent event)
                                |> Maybe.withDefault (text "")
                            ]
                        }
            }


eventConfig : Calendar.EventConfig Msg
eventConfig =
    Calendar.eventConfig
        { onClick = Just << EventClick
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \_ _ -> Nothing
        , onDragEnd = \_ _ -> Nothing
        }


timeSlotConfig : Calendar.TimeSlotConfig Msg
timeSlotConfig =
    Calendar.timeSlotConfig
        { onClick = Just <<< SelectDate
        , onMouseEnter = \_ _ -> Nothing
        , onMouseLeave = \_ _ -> Nothing
        , onDragStart = \_ _ -> Nothing
        , onDragging = \_ _ -> Nothing
        , onDragEnd = \_ _ -> Nothing
        }



-- HELPERS


allEvents =
    Fixtures.events
        |> List.map (\event -> ( event.id, event ))
        |> Dict.fromList


batchCmds msg model =
    let
        ( newModel, cmds, route ) =
            update msg model
    in
        ( newModel, Cmd.batch cmds, route )
