module Calendar.Toolbar exposing (..)


viewToolbar state =
    div [ styleToolbar ]
        [ viewPagination state
        , viewTitle state
        , viewTimespanSelection state
        ]


viewTitle { viewing } =
    let
        month =
            toString <| Date.month viewing

        year =
            toString <| Date.year viewing

        title =
            month ++ " " ++ year
    in
        div []
            [ h2 [] [ text title ] ]


viewPagination state =
    div []
        [ button [ styleButton, onClick PageBack ] [ text "back" ]
        , button [ styleButton, onClick PageForward ] [ text "next" ]
        ]


viewTimespanSelection state =
    div []
        [ button [ styleButton, onClick (ChangeTimeSpan Month) ] [ text "Month" ]
        , button [ styleButton, onClick (ChangeTimeSpan Week) ] [ text "Week" ]
        , button [ styleButton, onClick (ChangeTimeSpan Day) ] [ text "Day" ]
        , button [ styleButton, onClick (ChangeTimeSpan Agenda) ] [ text "Agenda" ]
        ]
