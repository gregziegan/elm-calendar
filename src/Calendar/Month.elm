module Calendar.Month exposing (..)

import Html exposing (..)
import Date exposing (Date)
import DefaultStyles exposing (..)
import Helpers


view : Date -> Html msg
view viewing =
    let
        weeks =
            Helpers.getMonthRange viewing

        viewWeek week =
            div [ styleMonthWeek ]
                (List.map (viewCell viewing) week)
    in
        div [ styleMonth ]
            (List.map viewWeek weeks)


viewCell : Date -> Date -> Html msg
viewCell viewing date =
    div [ styleCell ]
        [ text <| toString <| Date.day date ]
