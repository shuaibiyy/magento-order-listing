module Api exposing (..)

import Http
import RemoteData exposing (RemoteData(..))
import Json.Decode as Decode exposing (Decoder, at, list, string, float, int, oneOf, succeed, fail, andThen)
import Json.Decode.Pipeline exposing (decode, required)
import Types exposing (..)


ordersEndpoint : PageNum -> String
ordersEndpoint page =
    "http://localhost:8000/api/orders?page=" ++ (toString page)


ordersDecoder : Decoder (List CustomerOrder)
ordersDecoder =
    at [ "results" ] (list orderDecoder)


customDecoder : Decoder b -> (b -> Result String a) -> Decoder a
customDecoder decoder toResult =
    andThen
        (\a ->
            case toResult a of
                Ok b ->
                    succeed b

                Err err ->
                    fail err
        )
        decoder


number : Decoder Int
number =
    oneOf
        [ int
        , customDecoder string String.toInt
        ]


orderDecoder : Decoder CustomerOrder
orderDecoder =
    let
        number =
            oneOf [ int, customDecoder string String.toInt ]
    in
        decode CustomerOrder
            |> required "order_id" number
            |> required "subtotal_incl_tax" string
            |> required "customer_firstname" string
            |> required "customer_lastname" string
            |> required "created_at" string


fetchOrders : PageNum -> Cmd Msg
fetchOrders page =
    Http.get (ordersEndpoint page) ordersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OrdersResponse
