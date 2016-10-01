module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Calendar
import Date exposing (Date)
import Time


main : Program Never
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view
        }


type alias Model =
    { calendarState : Calendar.State }


model : Model
model =
    { calendarState = Calendar.init "Month" (Date.fromTime someUnixTime) }


type Msg
    = SetCalendarState Calendar.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCalendarState calendarMsg ->
            { model | calendarState = Calendar.update calendarMsg model.calendarState }


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
