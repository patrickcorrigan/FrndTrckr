module View exposing (..)
import Html exposing (..)
import Friend exposing (..)
import Model exposing (..)
import Update exposing (..)
import Time exposing (Time, second)
import Date exposing (Date, fromTime, day, month, year)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

css path = node "link" [ rel "stylesheet", href path ] []

toHtmlListStrings : List MoodChangeEntry -> Html Msg
toHtmlListStrings moodChanges =
 div [ class "collection with-header"] ((div [class "collection-header"] [text "History"]) :: (List.map toLiString moodChanges))

toLiString : MoodChangeEntry -> Html Msg
toLiString moodChange = case moodChange of 
       MoodChangeEntry data ->
           div [class "collection-item purple-text"] [text ((dateString (fromTime data.time)) ++ " : " ++
           moodChangeToString data.moodChange ++ ". " ++ data.comment)]


toHtmlList : List Friend -> Html Msg
toHtmlList strings =
   div [ class "collection with-header"] ((div [class "collection-header"] [text "Friends"]) ::(List.map toLi strings))

toLi : Friend -> Html Msg
toLi (Friend data as friend) = a [onClick (ViewFriend (Just friend)), class "collection-item purple-text" ]
                                 [text data.name]

getFriend : String -> List Friend -> Maybe Friend
getFriend getName friends = case friends of
     (Friend data as friend)::t -> if getName == data.name then Just friend else getFriend getName t
     [] -> Nothing

getMoods : (Maybe Friend) -> List MoodChangeEntry
getMoods friend = case friend of
     Just (Friend data) -> data.moodChanges
     Nothing -> []

myButton x y = button (class "btn purple darken-1"::x) y

dateString : Date -> String
dateString date = toString (day(date)) ++ " " ++ toString (month(date)) ++ " " ++ toString (year(date))

navHeader = 
   nav []
   [
     div[class "nav-wrapper"]
     [
         a [class "brand-logo center"][text "FrndTrckr"]
     ]
   ]

navBack = 

   nav []
   [
     div[class "nav-wrapper"]
     [
         ul [class "left"] 
         [
          li [] [ a [onClick (ViewFriend Nothing)] [text "Back"] ]
         ],
 
         a [class "brand-logo center"][text "FrndTrckr"]
     ]
   ]


friendList : Model -> Html Msg
friendList model =
   div [class "container"]
     [
      css "bower_components/Materialize/dist/css/materialize.css",
      css "styles/styles.css",
      toHtmlList model.friends,
       myButton [ onClick AddFriend ] [ text "Add Friend" ]
      ,input [ onInput UpdateAddFriendField, placeholder "Friend's name", value model.friendInput] []
     ]


view : Model -> Html Msg

view model = case model.friend of
  Nothing -> div [] [navHeader, friendList model]
  Just (Friend friend) -> div [] [navBack,
   div [class "container"]
     [
      css "bower_components/Materialize/dist/css/materialize.css",
      css "styles/styles.css",

         button [ onClick (RemoveFriend friend.name), class "btn red darken-1"] [ text "Remove" ]
         ,h3 [] [text ("After being with " ++ friend.name ++ " today I felt :")] 
         , input [ onInput UpdateCommentField, placeholder "Comment", value model.commentInput] []
         , myButton [ onClick (AddMoodChangeEntry Better friend.name)] [ text "Better" ]
         , myButton [ onClick (AddMoodChangeEntry Same friend.name)] [ text "The Same" ]
         , myButton [ onClick (AddMoodChangeEntry Worse friend.name)] [ text "Worse" ]
         , toHtmlListStrings (getMoods (getFriend friend.name model.friends))
     ]
  ]
