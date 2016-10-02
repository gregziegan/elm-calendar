module Calendar.Day exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Date exposing (Date)
import Date.Extra
import Config exposing (ViewConfig)
import Helpers
import Calendar.Msg exposing (Msg(..))
import Json.Decode as Json
import Mouse
import Calendar.Event as Event exposing (eventWithinRange)


view : ViewConfig event -> List event -> Date -> Html Msg
view config events day =
    div [ class "elm-calendar--day" ]
        [ viewDayHeader day
        , div [ class "elm-calendar--day-content" ]
            ([ viewTimeGutter day
             , viewDaySlot day
             ]
                ++ viewDayEvents config events day
            )
        ]


viewDate : Date -> Html Msg
viewDate day =
    let
        title day =
            Date.Extra.toFormattedString "EE d/M" day
    in
        div [ class "elm-calendar--date-header" ]
            [ a [ class "elm-calendar--date", href "#" ] [ text <| title day ] ]


viewDayHeader : Date -> Html Msg
viewDayHeader day =
    div []
        [ viewTimeGutterHeader
        , viewDate day
        ]


viewTimeGutter : Date -> Html Msg
viewTimeGutter date =
    Helpers.hours date
        |> List.map viewTimeSlotGroup
        |> div [ class "elm-calendar--time-gutter" ]


viewTimeGutterHeader : Html Msg
viewTimeGutterHeader =
    div [ class "elm-calendar--time-gutter-header" ] []


viewTimeSlotGroup : Date -> Html Msg
viewTimeSlotGroup date =
    div [ class "elm-calendar--time-slot-group" ]
        [ viewHourSlot date
        , div [ class "elm-calendar--time-slot" ] []
        ]


viewHourSlot : Date -> Html Msg
viewHourSlot date =
    div [ class "elm-calendar--hour-slot" ]
        [ span [ class "elm-calendar--time-slot-text" ] [ text <| Helpers.hourString date ] ]


viewDaySlot : Date -> Html Msg
viewDaySlot day =
    Helpers.hours day
        |> List.map viewDaySlotGroup
        |> div [ class "elm-calendar--day-slot" ]


viewDaySlotGroup : Date -> Html Msg
viewDaySlotGroup date =
    div [ class "elm-calendar--time-slot-group" ]
        [ viewTimeSlot date
        , viewTimeSlot date
        ]


viewTimeSlot : Date -> Html Msg
viewTimeSlot date =
    div
        [ class "elm-calendar--time-slot"
        , onClick (TimeSlotClick date)
        , onMouseEnter (TimeSlotMouseEnter date)
        , onMouseLeave (TimeSlotMouseLeave date)
        , on "mousedown" (Json.map (TimeSlotDragStart date) Mouse.position)
        ]
        []


viewDayEvents : ViewConfig event -> List event -> Date -> List (Html Msg)
viewDayEvents config events day =
    let
        maybeViewEvent event =
            viewDayEvent config day event
    in
        List.filterMap maybeViewEvent events


viewDayEvent : ViewConfig event -> Date -> event -> Maybe (Html Msg)
viewDayEvent config day event =
    let
        maybeEventOnDate =
            eventWithinRange (config.start event) (config.end event) Date.Extra.Day (Helpers.hours day)
    in
        Maybe.map (Event.viewDayEvent config event) maybeEventOnDate


viewAllDayCell : List Date -> Html Msg
viewAllDayCell days =
    let
        viewAllDayText =
            div [ class "elm-calendar--all-day-text" ] [ text "All day" ]

        viewAllDay day =
            div [ class "elm-calendar--all-day" ]
                []
    in
        div [ class "elm-calendar--all-day-cell" ]
            (viewAllDayText :: List.map viewAllDay days)
