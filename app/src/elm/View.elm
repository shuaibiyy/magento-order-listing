module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material.Table as Table
import Material.Button as Button
import Material.Layout as Layout
import Material.Progress as Loading
import Material.Options as Options exposing (css, nop)
import RemoteData exposing (RemoteData(..))
import Types exposing (..)


header : Model -> List (Html Msg)
header model =
    [ Layout.row
        [ Options.nop
        , css "transition" "height 333ms ease-in-out 0s"
        ]
        [ Layout.title [] [ text "Unu Challenge" ]
        , Layout.spacer
        , Layout.navigation [] []
        ]
    ]


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        ]
        { header = header model
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ div
                [ style
                    [ ( "padding", "2rem 2rem 2rem 2rem" ) ]
                ]
                [ div []
                    [ contentView model ]
                ]
            ]
        }


contentView : Model -> Html Msg
contentView model =
    case model.orders of
        NotAsked ->
            text "Orders not requested..."

        Loading ->
            div []
                [ h4 [] [ text "Loading orders..." ]
                , Loading.indeterminate
                ]

        Failure err ->
            text ("Error: " ++ toString err)

        Success orders ->
            ordersView orders model


ordersView : List CustomerOrder -> Model -> Html Msg
ordersView orders model =
    div []
        [ h4 [] [ text "Customer Orders:" ]
        , ordersTable orders model
        ]


reverse : comparable -> comparable -> Order
reverse x y =
    case compare x y of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


ordersTable : List CustomerOrder -> Model -> Html Msg
ordersTable orders model =
    let
        sort =
            case model.sortOrder of
                Just (Table.Ascending) ->
                    List.sortBy .orderId

                Just (Table.Descending) ->
                    List.sortWith (\x y -> reverse (.orderId x) (.orderId y))

                Nothing ->
                    identity
    in
        Table.table []
            [ Table.thead []
                [ Table.tr []
                    [ Table.th
                        [ model.sortOrder
                            |> Maybe.map Table.sorted
                            |> Maybe.withDefault nop
                        , Options.onClick SortByOrderId
                        ]
                        [ text "Order ID" ]
                    , Table.th [] [ text "Customer Name" ]
                    , Table.th [] [ text "Order Date" ]
                    , Table.th [] [ text "Grand Total" ]
                    ]
                ]
            , Table.tbody []
                (sort orders
                    |> List.map
                        (\order ->
                            Table.tr []
                                [ Table.td [ Table.numeric ] [ text (toString order.orderId) ]
                                , Table.td [] [ text (order.customerFirstName ++ " " ++ order.customerLastName) ]
                                , Table.td [ Table.numeric ] [ text order.orderDate ]
                                , Table.td [ Table.numeric ] [ text order.grandTotal ]
                                ]
                        )
                )
            ]
