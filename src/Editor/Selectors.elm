module Editor.Selectors exposing (..)

import Editor.Types exposing (Model, Project, FileTree)
import Dict exposing (Dict)
import Maybe
import List


getProjects : Model -> List ( String, Project )
getProjects model =
    case model.userMeta of
        Nothing ->
            []

        Just meta ->
            meta.projects


getProjectById : Model -> String -> Maybe ( String, Project )
getProjectById model id =
    let
        projects =
            getProjects model

        project =
            List.filter (\( id_, _ ) -> id_ == id) projects
    in
        List.head project
