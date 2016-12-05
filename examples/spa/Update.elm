module Update exposing (..)

import Calendar
import Dict
import Helpers exposing ((<<<), (=>))
import Keyboard.Extra
import Messages exposing (..)
import Model exposing (Model, initialModel)
import Models.EventDialog as EventDialog
import Navigation
import Routing exposing (Route(..), reverse, routeFromResult)


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

        EventClick eventId { x, y } ->
            { model
                | eventDialog =
                    Dict.get eventId model.events
                        |> Maybe.map (EventDialog.init x y)
            }
                => []

        CloseDialog ->
            { model | eventDialog = Nothing } => []

        KeyboardExtraMsg keyMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keyboard.Extra.update keyMsg model.keyboardModel

                escapeIsPressed =
                    Keyboard.Extra.isPressed Keyboard.Extra.Escape keyboardModel
            in
                { model
                    | keyboardModel = keyboardModel
                    , eventDialog =
                        if model.eventDialog /= Nothing && escapeIsPressed then
                            Nothing
                        else
                            model.eventDialog
                }
                    => [ Cmd.map KeyboardExtraMsg keyboardCmd ]


eventConfig : Calendar.EventConfig Msg
eventConfig =
    Calendar.eventConfig
        { onClick = Just <<< EventClick
        , onMouseEnter = \_ _ -> Nothing
        , onMouseLeave = \_ _ -> Nothing
        , onDragStart = \_ _ -> Nothing
        , onDragging = \_ _ _ -> Nothing
        , onDragEnd = \_ _ _ -> Nothing
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
