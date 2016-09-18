module Calendar.Month exposing (..)


viewMonth : State -> Html Msg
viewMonth state =
    let
        weeks =
            getMonthRange state.viewing

        styleWeek =
            style
                [ ( "display", "flex" )
                ]

        viewWeek week =
            div [ styleWeek ]
                (List.map (viewCell state) week)
    in
        div [ styleMonth ]
            (List.map viewWeek weeks)


viewCell : State -> Date -> Html Msg
viewCell state date =
    div [ styleCell ]
        [ text <| toString <| Date.day date ]
