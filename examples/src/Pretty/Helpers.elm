module Pretty.Helpers exposing (..)


(<<<) f ff x y =
    ff x y |> f


(=>) =
    (,)


(/>) ( a, b ) c =
    ( a, b, c )


px num =
    toString px ++ "px"
