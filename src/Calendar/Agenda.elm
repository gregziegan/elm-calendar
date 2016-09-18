module Calendar.Agenda exposing (..)

import Date.Extra


viewAgenda date =
    let
        groupedEvents =
            eventsGroupedByDate events

        isDateInMonth eventsDate =
            Date.Extra.isBetween (Date.Extra.floor Date.Extra.Month date) (Date.Extra.ceiling Date.Extra.Month date) eventsDate

        filteredEventsByMonth =
            List.filter (isDateInMonth << .date) groupedEvents
    in
        div [ styleAgenda ]
            (viewAgendaHeader :: List.map viewAgendaDay filteredEventsByMonth)



-- Date | Time | Event


viewAgendaHeader =
    div [ styleAgendaHeader ]
        [ div [ styleHeaderCell ] [ text "Date" ]
        , div [ styleHeaderCell ] [ text "Time" ]
        , div [ styleHeaderCell ] [ text "Event" ]
        ]


viewAgendaDay eventGroup =
    let
        dateString =
            Date.Extra.toFormattedString "EE MM d" eventGroup.date
    in
        div [ styleAgendaDay ]
            [ div [ styleAgendaDateCell ] [ text <| dateString ]
            , viewAgendaTimes eventGroup.events
            ]


viewAgendaTimes events =
    div []
        (List.map viewEventAndTime events)



-- type alias EventGroup =
--   { date : Date
--   , events : List Event
--   }


viewEventAndTime event =
    let
        startTime =
            Helpers.hourString event.start

        endTime =
            Helpers.hourString event.end

        timeRange =
            startTime ++ " - " ++ endTime
    in
        div [ style [ ( "display", "flex" ) ] ]
            [ div [ styleAgendaCell ] [ text timeRange ]
            , div [ styleAgendaCell ] [ text event.title ]
            ]
