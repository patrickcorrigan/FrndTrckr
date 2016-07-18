module Model exposing (..)
import Friend exposing (..)
import Time exposing (Time, second)


type alias Model = {time:Time, friend:Maybe Friend, commentInput :String, friendInput :String, friends : List Friend}
initialModel : Model
initialModel = Model 0 Nothing "" "" [(Friend {name = "Emily", rating = 0, moodChanges = []}),
                                      (Friend {name = "Safari", rating = 0, moodChanges = []}),
                                      (Friend {name = "Pegasus", rating = 0, moodChanges = []})]

removeFriend : String -> List Friend -> List Friend
removeFriend name list = removeFriend' name list []

removeFriend' : String -> List Friend -> List Friend -> List Friend
removeFriend' name list soFar = case list of
    (Friend data as head)::t -> if name == data.name then soFar ++ t else removeFriend' name t soFar ++ [head]
    [] -> soFar

removeMoodChangeEntry : Time -> List MoodChangeEntry -> List MoodChangeEntry
removeMoodChangeEntry time list = removeMoodChangeEntry' time list []

removeMoodChangeEntry' : Time -> List MoodChangeEntry -> List MoodChangeEntry -> List MoodChangeEntry
removeMoodChangeEntry' time list soFar = case list of
    (MoodChangeEntry data as head)::t -> if time == data.time then soFar ++ t else removeMoodChangeEntry' time t soFar ++ [head]
    [] -> soFar
