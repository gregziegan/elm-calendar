module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Calendar
import Date exposing (Date)
import Time


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map SetCalendarState (Calendar.subscriptions model.calendarState)


type alias Model =
    { calendarState : Calendar.State }


init : ( Model, Cmd Msg )
init =
    { calendarState = Calendar.init Calendar.Month (Date.fromTime someUnixTime) } ! []


type Msg
    = SetCalendarState Calendar.Msg
    | SelectDate Date


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
                        newModel ! []

                    Just updateMsg ->
                        update updateMsg newModel

        SelectDate date ->
            let
                whatDate =
                    Debug.log "date" date
            in
                model ! []


view : Model -> Html Msg
view model =
    div []
        [ Html.map SetCalendarState (Calendar.view viewConfig events model.calendarState) ]


viewConfig : Calendar.ViewConfig Event
viewConfig =
    Calendar.viewConfig
        { toId = .id
        , title = .title
        , start = .start
        , end = .end
        }


eventConfig : Calendar.EventConfig Msg
eventConfig =
    Calendar.eventConfig
        { onClick = \_ -> Nothing
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \_ -> Nothing
        , onDragEnd = \_ -> Nothing
        }


timeSlotConfig : Calendar.TimeSlotConfig Msg
timeSlotConfig =
    Calendar.timeSlotConfig
        { onClick = \date -> Just <| SelectDate date
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onDragStart = \_ -> Nothing
        , onDragging = \_ -> Nothing
        , onDragEnd = \_ -> Nothing
        }


someUnixTime : Float
someUnixTime =
    1473652025106


type alias Event =
    { id : String
    , title : String
    , start : Date
    , end : Date
    }


events : List Event
events =
    [ { id = "brunch1", title = "Brunch w/ Friends", start = Date.fromTime someUnixTime, end = Date.fromTime <| (someUnixTime + 2 * Time.hour) }
    , { id = "brunch2", title = "Brunch w/o Friends :(", start = Date.fromTime <| someUnixTime + (24 * Time.hour), end = Date.fromTime <| someUnixTime + (25 * Time.hour) }
    , { id = "conference", title = "Strangeloop", start = Date.fromTime <| someUnixTime + (200 * Time.hour), end = Date.fromTime <| someUnixTime + (258 * Time.hour) }
    ]
