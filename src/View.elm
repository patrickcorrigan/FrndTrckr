module View exposing (..)
import Html exposing (..)
import Friend exposing (..)
import Model exposing (..)
import Update exposing (..)
import Time exposing (Time, second)
import Date exposing (Date, fromTime, day, month, year)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

css path =
  node "link" [ rel "stylesheet", href path ] []

-- toHtmlListStrings : List MoodChange -> Html Msg
toHtmlListStrings moodChanges =
  div [ class "collection with-header"] ((div [class "collection-header"] [text "History"]) :: (List.map toLiString moodChanges))

-- toLiString : MoodChange -> Html Msg
toLiString moodChange = case moodChange of 
    Better comment time as moodChange -> a [class "collection-item purple-text"] [text ((dateString (fromTime time)) ++ " : Felt better. " ++ comment), a[class "secondary-content"][text "Remove"]]
    Same comment time as moodChange -> a [class "collection-item purple-text"] [text ((dateString (fromTime time)) ++ " : Felt the same. " ++ comment), a[class "secondary-content"][text "Remove"]]
    Worse comment time as moodChange -> a [class "collection-item purple-text"] [text ((dateString (fromTime time)) ++ " : Felt worse. " ++ comment), a[class "secondary-content"][text "Remove"]]


toHtmlList strings =
  div [ class "collection with-header"] ((div [class "collection-header"] [text "Friends"]) ::(List.map toLi strings))

toLi : Friend -> Html Msg
toLi friend = case friend of
    Friend name rating moodChangeList as friend ->  a [class "collection-item purple-text", onClick (ViewFriend (friend))] [text name]
    None -> li [] []

getFriend : String -> List Friend -> Friend
getFriend getName friends = case friends of
    [] -> None
    ((Friend name rating moodChangeList) as friend)::t -> if getName == name then friend else getFriend getName t
    None::t -> getFriend getName t

getMoods : Friend -> List MoodChange
getMoods friend = case friend of
    Friend _ _ moodChanges  -> moodChanges
    None -> []

myButton x y = button (class "btn purple darken-1"::x) y

dateString : Date -> String
dateString date = toString (day(date)) ++ " " ++ toString (month(date)) ++ " " ++ toString (year(date))


view : Model -> Html Msg
view model = case model.friend of
 None ->
  div [] [
  nav []
  [
    div[class "nav-wrapper"]
    [
        a [class "brand-logo center"][text "Friend Tracker"]
    ]
  ],

  div [class "container"]
    [
     css "bower_components/Materialize/dist/css/materialize.css",
     css "styles.css",
     toHtmlList model.friends
     , myButton [ onClick AddFriend ] [ text "Add Friend" ]
     , input [ placeholder "Friend's name", onInput UpdateField, onSubmit AddFriend, value model.friendInput] []



    ]
    ]

 Friend name rating moodChangeList as friend ->
  div [] [
  nav []
  [
    div[class "nav-wrapper"]
    [
        ul [class "left"] 
        [
         li [] [ a [onClick (ViewFriend None)] [text "Back"] ]
        ],

        a [class "brand-logo center"][text "Friend Tracker"]
    ]
  ],
  div [class "container"]
    [
     css "bower_components/Materialize/dist/css/materialize.css",
     css "styles.css",

        h3 [] [text ("After being with " ++ name ++ " today I felt :")] 
        , input [ placeholder "Comment", onInput UpdateCommentField, value model.commentInput] []
        , myButton [ onClick (FeltBetter name) ] [ text "Better" ]
        , myButton [ onClick (FeltSame name) ]   [ text "The same" ]
        , myButton [ onClick (FeltWorse name) ] [ text "Worse" ]
        ,toHtmlListStrings ((getMoods (getFriend name model.friends)))
    ]
    ]
