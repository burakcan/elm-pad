module Editor.Tasks.LoadFiles exposing (loadFiles)

import Editor.Types exposing (Project, Msg(..), FetchError(..), User)
import Editor.JsonHelpers.Decode exposing (decodeGist)
import Maybe
import Http
import Task


loadFiles : ( String, Project ) -> User -> Cmd Msg
loadFiles ( projectId, project ) user =
    Task.perform
        LoadFilesError
        LoadFilesSuccess
        (Task.andThen
            (Task.mapError
                (\error -> Processed error)
                (Http.get
                    decodeGist
                    ("https://api.github.com/gists/" ++ project.gistId ++ "?access_token=" ++ user.accessToken)
                )
            )
            (\gist ->
                Task.succeed <|
                    ( projectId
                    , { project
                        | files = Just gist.files
                      }
                    )
            )
        )
