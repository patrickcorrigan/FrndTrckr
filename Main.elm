import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Time exposing (Time, second)
import Date exposing (Date, fromTime, day, month, year)
import Friend exposing (..)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)
import Subscriptions exposing (..)

main : Program Never
main =
  Html.program { init = init,
                 view = view,
                 update = update,
                 subscriptions = subscriptions 
               }

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)
