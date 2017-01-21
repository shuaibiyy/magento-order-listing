module Main exposing (..)

import Html exposing (..)
import Types exposing (..)
import State exposing (..)
import View exposing (..)
import Api exposing (fetchOrders)


init : ( Model, Cmd Msg )
init =
    model ! [ fetchOrders model.page ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
