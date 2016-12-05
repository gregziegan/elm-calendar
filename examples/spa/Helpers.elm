module Helpers exposing (..)

import Routing exposing (..)
import Html exposing (Html, Attribute, a, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onWithOptions, defaultOptions)
import Messages exposing (..)
import Json.Decode as Decode


(<<<) f ff x y =
    ff x y |> f


(=>) =
    (,)


px num =
    (toString num) ++ "px"


onClickNoDefault : msg -> Attribute msg
onClickNoDefault msg =
    onWithOptions "click" { defaultOptions | preventDefault = True } (Decode.succeed msg)


{-| Create a link to an internal Route using some text.
-}
navLink : Html Msg -> Route -> Html Msg
navLink html route =
    a [ href <| reverse route, onClickNoDefault <| NavigateTo route ]
        [ html ]
