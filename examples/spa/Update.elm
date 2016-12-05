module Update exposing (..)

import Calendar
import Dict
import Messages exposing (..)
import Model exposing (Model, initialModel)
import Navigation
import Routing exposing (Route(..), routeFromResult, reverse)
import Helpers exposing ((=>), (<<<))


urlUpdate : Route -> Model -> ( Model, List (Cmd Msg) )
urlUpdate route model =
    let
        updatedModel =
            case route of
                _ ->
                    model
    in
        { updatedModel | route = route } => []


update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    case msg of
        UrlUpdate route ->
            urlUpdate route model

        NavigateTo route ->
            model => [ Navigation.newUrl <| reverse route ]

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
                        update updateMsg newModel

        SelectDate date pos ->
            model
                => []

        EventClick eventId ->
            { model | maybeEventDetails = Dict.get eventId model.events }
                => []

        CloseDialog ->
            { model | maybeEventDetails = Nothing } => []


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
