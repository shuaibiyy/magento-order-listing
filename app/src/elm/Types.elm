module Types exposing (..)

import Material
import RemoteData exposing (WebData)


type alias CustomerOrder =
    { orderId : Int
    , grandTotal : Float
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
    }


type Msg
    = OrdersResponse (WebData (List CustomerOrder))
    | Mdl (Material.Msg Msg)
