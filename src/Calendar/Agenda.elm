module Calendar.Agenda exposing (..)

import Date exposing (Date)
import Date.Extra
import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers
import Config exposing (ViewConfig, defaultConfig)


type alias EventGroup event =
    { date : Date
    , events : List event
    }


eventsGroupedByDate : ViewConfig event -> List event -> List (EventGroup event)
eventsGroupedByDate config events =
    let
        initEventGroup event =
            { date = config.start event, events = [ event ] }

        buildEventGroup event eventGroups =
            let
                restOfEventGroups groups =
                    case List.tail groups of
                        Nothing ->
                            []

                        Just restOfGroups ->
                            restOfGroups
            in
                case List.head eventGroups of
                    Nothing ->
                        [ initEventGroup event ]

                    Just eventGroup ->
                        if Date.Extra.isBetween eventGroup.date (Date.Extra.add Date.Extra.Day 1 eventGroup.date) (config.start event) then
                            { eventGroup | events = event :: eventGroup.events } :: (restOfEventGroups eventGroups)
                        else
                            initEventGroup event :: eventGroups
    in
        List.sortBy (Date.toTime << config.start) events
            |> List.foldr buildEventGroup []


view : ViewConfig event -> List event -> Date -> Html msg
view config events date =
    let
        groupedEvents =
            eventsGroupedByDate config events

        isDateInMonth eventsDate =
            Date.Extra.isBetween (Date.Extra.floor Date.Extra.Month date) (Date.Extra.ceiling Date.Extra.Month date) eventsDate

        filteredEventsByMonth =
            List.filter (isDateInMonth << .date) groupedEvents
    in
        div [ class "elm-calendar--agenda" ]
            (viewAgendaHeader :: List.map (viewAgendaDay config) filteredEventsByMonth)


viewAgendaHeader : Html msg
viewAgendaHeader =
    div [ class "elm-calendar--agenda-header" ]
        [ div [ class "elm-calendar--header-cell" ] [ text "Date" ]
        , div [ class "elm-calendar--header-cell" ] [ text "Time" ]
        , div [ class "elm-calendar--header-cell" ] [ text "Event" ]
        ]


viewAgendaDay : ViewConfig event -> EventGroup event -> Html msg
viewAgendaDay config eventGroup =
    let
        dateString =
            Date.Extra.toFormattedString "EE MM d" eventGroup.date
    in
        div [ class "elm-calendar--agenda-day" ]
            [ div [ class "elm-calendar--agenda-date-cell" ] [ text <| dateString ]
            , viewAgendaTimes config eventGroup.events
            ]


viewAgendaTimes : ViewConfig event -> List event -> Html msg
viewAgendaTimes config events =
    div []
        (List.map (viewEventAndTime config) events)


viewEventAndTime : ViewConfig event -> event -> Html msg
viewEventAndTime config event =
    let
        startTime =
            Helpers.hourString <| config.start event

        endTime =
            Helpers.hourString <| config.end event

        timeRange =
            startTime ++ " - " ++ endTime
    in
        div [ class "elm-calendar--row" ]
            [ div [ class "elm-calendar--agenda-cell" ] [ text timeRange ]
            , div [ class "elm-calendar--agenda-cell" ] [ text <| config.title event ]
            ]
