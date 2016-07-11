module Update exposing (..)
import Friend exposing (..)
import Model exposing (..)
import Time exposing (Time, second)

type Msg = AddFriend | RemoveFriend  |
           UpdateField String        |
           UpdateCommentField String |
           ViewFriend Friend         |
           FeltBetter String         | FeltWorse String | FeltSame String |
           RemoveMoodChange Int      |
           Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AddFriend ->
     ({ model | friends = model.friends ++ [Friend model.friendInput 0 []], friendInput = "" }, Cmd.none)

    UpdateField name ->
     ({ model | friendInput = name }, Cmd.none)

    UpdateCommentField comment ->
     ({ model | commentInput = comment }, Cmd.none)

    RemoveFriend ->
     ({ model | friendInput = "" }, Cmd.none)

    ViewFriend friend ->
     ({ model | friend = friend }, Cmd.none)

    FeltBetter name ->
     ({ model | friends = updateListElement name (Better model.commentInput model.time) model.friends, commentInput = ""}, Cmd.none)

    FeltSame name ->
     ({ model | friends = updateListElement name (Same model.commentInput model.time) model.friends, commentInput = ""}, Cmd.none)

    FeltWorse name ->
     ({ model | friends = updateListElement name (Worse model.commentInput model.time) model.friends, commentInput = ""}, Cmd.none)

    Tick newTime ->
      ({model | time = newTime}, Cmd.none)

    RemoveMoodChange index ->
      (model, Cmd.none)

removeMoodChange : Int -> List MoodChange -> List MoodChange
removeMoodChange index list = removeMoodChange' index list [] 0

removeMoodChange' : Int -> List MoodChange -> List MoodChange -> Int -> List MoodChange
removeMoodChange' index list soFar currentIndex = 
    case list of
    [] -> soFar
    h::t -> 
        if index == currentIndex
        then soFar ++ t
        else removeMoodChange' index t (soFar ++ [h]) (currentIndex + 1)

updateListElement' : String -> MoodChange -> List Friend ->  List Friend -> List Friend
updateListElement' friendName mood list soFar = 
    case list of
    [] -> soFar
    (Friend name rating moodChangeList)::t -> 
    if friendName == name
    then soFar ++ [Friend name rating (mood::moodChangeList) ] ++ t
    else updateListElement' friendName mood t (soFar ++ [(Friend name rating moodChangeList)])
    None::t -> list

updateListElement : String -> MoodChange -> List Friend -> List Friend
updateListElement friendName mood list = updateListElement' friendName mood list []

