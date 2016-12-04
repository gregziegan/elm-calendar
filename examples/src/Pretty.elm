module Main exposing (..)

import Date
import Dict exposing (Dict)
import Fixtures
import Html exposing (Html, button, div, p, text)
import Navigation
import Pretty.CalendarPage as CalendarPage
import Pretty.EventPage as EventPage
import Pretty.Helpers exposing ((=>))
import Pretty.Types exposing (Event, Route(CalendarRoute, EventRoute))
import UrlParser as Url exposing ((</>), (<?>), s, string, top)


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = batchCmds
        , subscriptions = (\_ -> Sub.none)
        }



-- MODEL


type alias Model =
    { history : List (Maybe Route)
    , calendarPage : CalendarPage.Model
    , eventPage : EventPage.Model
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        maybeRoute =
            Url.parsePath route location
    in
        ( { history = [ maybeRoute ]
          , calendarPage = Tuple.first CalendarPage.init
          , eventPage = Tuple.first <| EventPage.init defaultEvent
          }
        , Cmd.none
        )


defaultEvent =
    { id = "test"
    , title = "test"
    , start = Date.fromTime 13242341234
    , end = Date.fromTime 13242541234
    }



-- URL PARSING


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map CalendarRoute top
        , Url.map EventRoute (s "event" </> string)
        ]


type Msg
    = SetCalendarPage CalendarPage.Msg
    | SetEventPage EventPage.Msg
    | NewUrl String
    | UrlChange Navigation.Location


update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    case msg of
        SetCalendarPage calendarPageMsg ->
            let
                ( page, cmds, maybeRoute ) =
                    CalendarPage.update calendarPageMsg model.calendarPage

                newModel =
                    { model | calendarPage = page }
            in
                updateRoute maybeRoute newModel

        SetEventPage eventPageMsg ->
            let
                ( page, cmds, maybeRoute ) =
                    EventPage.update eventPageMsg model.eventPage

                newModel =
                    { model | eventPage = page }
            in
                updateRoute maybeRoute newModel

        NewUrl url ->
            model
                => [ Navigation.newUrl url ]

        UrlChange location ->
            let
                maybeRoute =
                    Url.parsePath route location

                maybeNewEventPage route =
                    case route of
                        EventRoute eventId ->
                            Maybe.andThen (Just << Tuple.first << EventPage.init) (Dict.get eventId allEvents)

                        _ ->
                            Nothing

                maybeEventPage =
                    maybeRoute
                        |> Maybe.andThen maybeNewEventPage
                        |> Maybe.withDefault model.eventPage
            in
                { model
                    | history = maybeRoute :: model.history
                    , eventPage = maybeEventPage
                }
                    => []


updateRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            model => []

        Just route ->
            update (NewUrl <| routeToString route) model


view : Model -> Html Msg
view { history, calendarPage, eventPage } =
    let
        viewRoute : Route -> Maybe (Html Msg)
        viewRoute route =
            case route of
                CalendarRoute ->
                    Just <| Html.map SetCalendarPage (CalendarPage.view calendarPage)

                EventRoute eventId ->
                    Just <| Html.map SetEventPage (EventPage.view eventPage)

        maybeViewRoute : Maybe Route -> Maybe (Html Msg)
        maybeViewRoute maybeRoute =
            Maybe.andThen viewRoute maybeRoute
    in
        div []
            [ history
                |> List.head
                |> Maybe.andThen maybeViewRoute
                |> Maybe.withDefault viewInvalidRoute
            ]


viewInvalidRoute =
    (text "Invalid Route")



-- HELPERS


allEvents : Dict String Event
allEvents =
    Fixtures.events
        |> List.map (\event -> ( event.id, event ))
        |> Dict.fromList


routeToString route =
    case route of
        CalendarRoute ->
            ""

        EventRoute eventId ->
            "event/" ++ eventId


batchCmds msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
        ( newModel, Cmd.batch cmds )
