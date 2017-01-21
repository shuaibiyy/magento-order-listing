module State exposing (..)

import Material
import Material.Table as Table
import RemoteData exposing (RemoteData(..))
import Types exposing (..)


-- MODEL


model : Model
model =
    { orders = Loading
    , page = 1
    , mdl = Material.model
    , sortOrder = Just Table.Ascending
    }



-- ACTION, UPDATE


rotate : Maybe Table.Order -> Maybe Table.Order
rotate order =
    case order of
        Just (Table.Ascending) ->
            Just Table.Descending

        Just (Table.Descending) ->
            Nothing

        Nothing ->
            Just Table.Ascending


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OrdersResponse response ->
            { model | orders = response } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model

        SortByOrderId ->
            { model | sortOrder = rotate model.sortOrder } ! []

        SortByDate ->
            model ! []
