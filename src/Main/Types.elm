module Main.Types exposing (Model, Msg(..), Flags)

import Auth.Types as Auth
import Editor.Types as Editor


type Msg
    = AuthMsg Auth.Msg
    | EditorMsg Editor.Msg


type alias Flags =
    {}


type alias Model =
    { auth : Auth.Model
    , editor : Maybe Editor.Model
    }
