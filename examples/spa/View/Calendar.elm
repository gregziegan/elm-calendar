module View.Calendar exposing (..)

import Calendar
import Dict exposing (Dict)
import Helpers exposing ((=>), px)
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (Model)
import Models.Event exposing (Event, allEvents)
import Models.EventDialog exposing (EventDialog)
import Routing exposing (..)


view : Model -> Html Msg
view model =
    let
        events =
            Dict.values model.events
    in
        div []
            [ Html.map SetCalendarState (Calendar.view (viewConfig model) events model.calendarState)
            , model.eventDialog
                |> Maybe.map viewEventDialog
                |> Maybe.withDefault (text "")
            ]


viewEventDialog : EventDialog -> Html Msg
viewEventDialog ({ event } as dialog) =
    let
        timeRangeText =
            toString event.start ++ " - " ++ toString event.end

        isFull =
            event.id == "1"
    in
        div
            [ class "event-dialog-mask"
            , onClick CloseDialog
            ]
            [ div
                [ class "event-dialog"
                , style
                    [ "top" => px dialog.top
                    , "left" => px dialog.left
                    ]
                ]
                [ p [] [ text event.title ]
                , p [] [ text timeRangeText ]
                , div
                    [ class "event-dialog__buttons" ]
                    [ Helpers.navLink
                        (button
                            [ class "event-dialog__details"
                            ]
                            [ text "Details" ]
                        )
                        (EventRoute event.id)
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
            ]


viewConfig : Model -> Calendar.ViewConfig Event
viewConfig model =
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
                        ]
                    }
        }
