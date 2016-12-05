module Routing exposing (..)

import Navigation
import UrlParser as Url exposing ((</>), (<?>), s, string, top)


type Route
    = CalendarRoute
    | EventRoute String
    | NotFoundRoute


{-| Attempt to parse a Locaton's Hash into a Route.
-}
routeParser : Navigation.Location -> Route
routeParser location =
    location |> Url.parsePath matchers |> Maybe.withDefault NotFoundRoute


routeFromResult : Result String Route -> Route
routeFromResult =
    Result.withDefault NotFoundRoute


matchers : Url.Parser (Route -> a) a
matchers =
    Url.oneOf
        [ Url.map CalendarRoute top
        , Url.map EventRoute (s "events" </> string)
        ]


{-| Turn a Route into the URL the Route represents.
-}
reverse : Route -> String
reverse route =
    let
        routeToString route =
            flip (++) "/" <|
                case route of
                    CalendarRoute ->
                        ""

                    EventRoute id ->
                        "events/" ++ id

                    NotFoundRoute ->
                        ""
    in
        routeToString route
