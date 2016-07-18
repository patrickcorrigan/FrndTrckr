module Update exposing (..)
import Friend exposing (..)
import Model exposing (..)
import Time exposing (Time, second)

type Msg = AddFriend | RemoveFriend String |
           ViewFriend (Maybe Friend) | UpdateAddFriendField String | UpdateCommentField String |
           AddMoodChangeEntry MoodChange String | RemoveMoodChangeEntry String Time |
           Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AddFriend ->
     ({ model | friends = model.friends ++ [Friend {name = model.friendInput, rating = 0, moodChanges =  []}], friendInput = "" }, Cmd.none)

    RemoveFriend name ->
     ({ model | friends = removeFriend name model.friends, friendInput = "", friend = Nothing }, Cmd.none)

    ViewFriend friend ->
     ({model | friend = friend}, Cmd.none)

    UpdateAddFriendField name ->
     ({ model | friendInput = name }, Cmd.none)

    UpdateCommentField comment ->
     ({ model | commentInput = comment }, Cmd.none)

    AddMoodChangeEntry moodChange name ->
     ({ model | friends = updateListElement name (MoodChangeEntry {moodChange=moodChange, comment=model.commentInput, time=model.time}) model.friends, commentInput = ""}, Cmd.none)

    RemoveMoodChangeEntry name time ->
     ({ model | friends = removeListElement name time model.friends}, Cmd.none)

    Tick newTime ->
      ({model | time = newTime}, Cmd.none)

removeMoodChange : Int -> List MoodChangeEntry -> List MoodChangeEntry
removeMoodChange index list = removeMoodChange' index list [] 0

removeMoodChange' : Int -> List MoodChangeEntry -> List MoodChangeEntry -> Int -> List MoodChangeEntry
removeMoodChange' index list soFar currentIndex = 
    case list of
    [] -> soFar
    h::t -> 
        if index == currentIndex
        then soFar ++ t
        else removeMoodChange' index t (soFar ++ [h]) (currentIndex + 1)

updateListElement' : String -> MoodChangeEntry -> List Friend ->  List Friend -> List Friend
updateListElement' friendName mood list soFar = 
    case list of
    [] -> soFar
    (Friend friend)::t -> 
    if friendName == friend.name
    then soFar ++ [Friend {friend |moodChanges = (mood::friend.moodChanges)} ] ++ t
    else updateListElement' friendName mood t (soFar ++ [Friend friend])

updateListElement : String -> MoodChangeEntry -> List Friend -> List Friend
updateListElement friendName mood list = updateListElement' friendName mood list []

removeListElement' : String -> Time -> List Friend ->  List Friend -> List Friend
removeListElement' friendName mood list soFar = 
    case list of
    [] -> soFar
    (Friend friend)::t -> 
    if friendName == friend.name
    then soFar ++ t
    else removeListElement' friendName mood t (soFar ++ [Friend friend])

removeListElement : String -> Time -> List Friend -> List Friend
removeListElement friendName time list = removeListElement' friendName time list []


