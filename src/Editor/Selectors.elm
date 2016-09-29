module Editor.Selectors exposing (..)

import Editor.Types exposing (Model, Project, FileTree)
import Dict exposing (Dict)
import Maybe
import List


getProjectById : Model -> String -> Maybe ( String, Project )
getProjectById model id =
    let
        projects =
            model.projects

        project =
            List.filter (\( id_, _ ) -> id_ == id) projects
    in
        List.head project
