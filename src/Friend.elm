module Friend exposing (..)

import Time exposing (Time, second)

type MoodChange = Worse String Time | Same String Time | Better String Time
type Friend = Friend String Int (List MoodChange) | None
