module Main exposing (..)

import Messages exposing (Msg(UrlUpdate))
import Model exposing (Model, initialModel)
import Navigation
import Routing exposing (Route, routeFromResult, routeParser)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    Navigation.program parser
        { init = init
        , update = batchCmds
        , subscriptions = always Sub.none
        , view = view
        }


batchCmds : Msg -> Model -> ( Model, Cmd Msg )
batchCmds msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
        ( newModel, Cmd.batch cmds )


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            routeParser location
    in
        ( initialModel route, Cmd.none )


parser : Navigation.Location -> Msg
parser location =
    UrlUpdate <| routeParser location
