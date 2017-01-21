module State exposing (..)

import Material
import Material.Table as Table
import RemoteData exposing (RemoteData(..))
import Types exposing (..)
import Api exposing (fetchOrders)


-- MODEL


model : Model
model =
    { customerOrders = Loading
    , page = 1
    , mdl = Material.model
    , sortOrder = Just Table.Ascending
    }




rotate : Maybe Table.Order -> Maybe Table.Order
rotate order =
    case order of
        Just (Table.Ascending) ->
            Just Table.Descending

        Just (Table.Descending) ->
            Nothing

        Nothing ->
            Just Table.Ascending


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OrdersResponse response ->
            { model | customerOrders = response } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model

        FlipPage page ->
            model ! [ fetchOrders page ]

        SortByOrderId ->
            { model | sortOrder = rotate model.sortOrder } ! []

        SortByDate ->
            model ! []
