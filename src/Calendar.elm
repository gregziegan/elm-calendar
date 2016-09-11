module Calendar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)


type alias State =
    { timespan : String
    , viewing : Int
    }


init : String -> Int -> State
init timespan viewing =
    { timespan = timespan
    , viewing = viewing
    }


type Msg
    = ChangeTimespan String


update msg model =
    case msg of
        ChangeTimespan newTimespan ->
            model
                |> changeTimespan newTimespan


changeTimespan timespan model =
    { model | timespan = timespan }


view : State -> Html Msg
view state =
    div [ styleCalendar ]
        [ viewToolbar state
        , viewMonth state
        ]


viewToolbar state =
    div [ styleToolbar ]
        [ viewPagination state
        , viewTitle state
        , viewTimespanSelection state
        ]


styleToolbar =
    style
        [ ( "display", "flex" )
        , ( "justify-content", "space-between" )
        , ( "width", "1000px" )
        ]


styleCalendar =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        ]


viewTitle state =
    div []
        [ h2 [] [ text "September 2016" ] ]


viewPagination state =
    div []
        [ button [ styleButton ] [ text "back" ]
        , button [ styleButton ] [ text "next" ]
        ]


viewTimespanSelection state =
    div []
        [ button [ styleButton ] [ text "Month" ]
        , button [ styleButton ] [ text "Week" ]
        , button [ styleButton ] [ text "Day" ]
        , button [ styleButton ] [ text "Agenda" ]
        ]


styleButton =
    style
        [ ( "border", "1px solid #ccc" )
        , ( "padding", "5px" )
        , ( "background-color", "white" )
        ]



-- 28 -> 1
-- 5 weeks


september2016 =
    [ [ 28, 29, 30, 31, 1, 2, 3 ]
    , [ 4, 5, 6, 7, 8, 9, 10 ]
    , [ 11, 12, 13, 14, 15, 16, 17 ]
    , [ 18, 19, 20, 21, 22, 23, 24 ]
    , [ 25, 26, 27, 28, 29, 30, 1 ]
    ]


viewMonth : State -> Html Msg
viewMonth state =
    let
        styleWeek =
            style
                [ ( "display", "flex" )
                ]

        viewWeek week =
            div [ styleWeek ]
                (List.map (viewCell state) week)
    in
        div [ styleMonth ]
            (List.map viewWeek september2016)


styleMonth : Html.Attribute Msg
styleMonth =
    style
        [ ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "width", "1200px" )
        , ( "height", "800px" )
        ]


viewCell : State -> Int -> Html Msg
viewCell state date =
    div [ styleCell ]
        [ text <| toString <| date ]


styleCell : Html.Attribute Msg
styleCell =
    style
        [ ( "border", "2px solid #ccc" )
        , ( "padding", "10px" )
        , ( "width", "120px" )
        , ( "height", "100px" )
        ]
