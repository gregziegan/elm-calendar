module View exposing (..)

import Dict
import Html exposing (Html, div, h1, text)
import Model exposing (Model)
import Models.Event exposing (allEvents)
import Messages exposing (Msg)
import Routing exposing (..)
import View.Calendar as Calendar
import View.Event as Event


view model =
    div [] [ page model ]


{-| Render the Page Content using the current Route.
-}
page : Model -> Html Msg
page ({ route } as model) =
    case route of
        CalendarRoute ->
            Calendar.view model

        EventRoute id ->
            Maybe.map Event.view (Dict.get id allEvents)
                |> Maybe.withDefault notFoundPage

        NotFoundRoute ->
            notFoundPage


notFoundPage : Html msg
notFoundPage =
    h1 [] [ text "404 - Not Found" ]
