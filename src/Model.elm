module Model exposing (..)
import Friend exposing (..)
import Time exposing (Time, second)

-- MODEL

type alias Model = {time:Time, friend:Friend, commentInput :String, friendInput :String, friends : List Friend}
initialModel : Model
initialModel = Model 0 None "" "" [(Friend "Emily" 0 []), (Friend "Safari" 0 []), (Friend "Pegasus" 0 [])]
