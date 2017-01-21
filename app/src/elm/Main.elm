module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Layout as Layout
import Material.Options as Options exposing (css)
import RemoteData exposing (RemoteData(..))
import Types exposing (..)
import Api exposing (fetchOrders)


-- MODEL


model : Model
model =
    { orders = Loading
    , page = 1
    , mdl = Material.model
    }



-- ACTION, UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OrdersResponse response ->
            { model | orders = response } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


type alias Mdl =
    Material.Model


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
        , main = [ div [] [] ]
        }


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
