module Calendar.Month exposing (..)

import Html exposing (..)
import Date exposing (Date)
import DefaultStyles exposing (..)
import Config exposing (ViewConfig)
import Helpers


view : ViewConfig event -> List event -> Date -> Html msg
view config events viewing =
    let
        weeks =
            Helpers.getMonthRange viewing

        viewWeek week =
            div [ styleMonthWeek ]
                (List.map (viewCell config events viewing) week)
    in
        div [ styleMonth ]
            (List.map viewWeek weeks)


viewCell : ViewConfig event -> List event -> Date -> Date -> Html msg
viewCell config events viewing date =
    div [ styleCell ]
        [ text <| toString <| Date.day date ]
