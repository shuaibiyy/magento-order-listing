module Types exposing (..)

import Material
import Material.Table as Table
import RemoteData exposing (WebData)


type alias Mdl =
    Material.Model


type alias CustomerOrder =
    { orderId : Int
    , grandTotal : String
    , customerFirstName : String
    , customerLastName : String
    , shippingDescription : String
    , storeName : String
    , orderDate : String
    , postcode : String
    , transactionStatus : String
    }


type alias PageNum =
    Int


type alias CustomerOrders =
    { orders : List CustomerOrder
    , pageCount : Int
    }


type alias Model =
    { customerOrders : WebData CustomerOrders
    , page : PageNum
    , mdl : Material.Model
    , sortOrder : Maybe Table.Order
    }


type Msg
    = OrdersResponse (WebData CustomerOrders)
    | Mdl (Material.Msg Msg)
    | FlipPage Int
    | SortByOrderId
    | SortByDate
