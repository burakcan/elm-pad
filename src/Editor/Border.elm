port module Editor.Border exposing (..)

import Editor.Types exposing (File)


port editorUnitPort : ( String, () ) -> Cmd msg


port filePort : ( String, File ) -> Cmd msg
