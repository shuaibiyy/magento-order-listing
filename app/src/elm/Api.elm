module Api exposing (..)

import Http
import RemoteData exposing (RemoteData(..))
import Json.Decode as Decode exposing (Decoder, at, list, string, float, int)
import Json.Decode.Pipeline exposing (decode, required)
import Types exposing (..)


ordersEndpoint : PageNum -> String
ordersEndpoint page =
    "http://localhost:8000/api/orders?page=" ++ (toString page)


ordersDecoder : Decoder (List CustomerOrder)
ordersDecoder =
    list orderDecoder


orderDecoder : Decoder CustomerOrder
orderDecoder =
    decode CustomerOrder
        |> required "order_id" int
        |> required "subtotal_incl_tax" float
        |> required "customer_firstname" string
        |> required "customer_lastname" string
        |> required "created_at" string


fetchOrders : PageNum -> Cmd Msg
fetchOrders page =
    Http.get (ordersEndpoint page) ordersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OrdersResponse
