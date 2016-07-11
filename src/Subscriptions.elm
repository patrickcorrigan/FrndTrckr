module Subscriptions exposing (..)
import Update exposing (..)
import Model exposing (..)
import Time exposing (every, second)

subscriptions : Model -> Sub Msg
subscriptions model = Time.every second Tick
