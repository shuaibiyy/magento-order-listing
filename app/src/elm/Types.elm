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
    , orderDate : String
    }


type alias PageNum =
    Int


type alias Model =
    { orders : WebData (List CustomerOrder)
    , page : PageNum
    , mdl : Material.Model
    , sortOrder : Maybe Table.Order
    }


type Msg
    = OrdersResponse (WebData (List CustomerOrder))
    | Mdl (Material.Msg Msg)
    | SortByOrderId
    | SortByDate
