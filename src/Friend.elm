module Friend exposing (..)
import Time exposing (Time, second)

type MoodChange = Better | Same | Worse
type MoodChangeEntry = MoodChangeEntry {moodChange:MoodChange, comment:String, time:Time}
type Friend = Friend {name:String, rating:Int, moodChanges:List MoodChangeEntry}

moodChangeToString : MoodChange -> String
moodChangeToString moodChange = case moodChange of
    Better -> "Felt better"
    Same -> "Felt the same"
    Worse -> "Felt worse"
