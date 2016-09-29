module Editor.Tasks.CreateProject exposing (createProject)

import Editor.Types exposing (Msg(..), FetchError(..), User, Project, Gist, File)
import Editor.JsonHelpers.Decode exposing (decodeGist, decodeGistFiles)
import Editor.JsonHelpers.Encode exposing (encodeGistMeta, encodeInput)
import Task exposing (Task)
import Http


type alias Input =
    { name : String
    , description : String
    , private : Bool
    , files : List ( String, String )
    }


createProject : Input -> User -> Cmd Msg
createProject input user =
    Task.perform
        CreateProjectError
        CreateProjectSuccess
    <|
        Task.andThen
            (createGist input user)
            (saveToUserMeta input user)


createGist : Input -> User -> Task FetchError Gist
createGist input user =
    (Task.mapError
        (\error -> Processed error)
        (Http.post
            decodeGist
            ("https://api.github.com/gists?access_token=" ++ user.accessToken)
            (Http.string <| encodeInput input)
        )
    )


saveToUserMeta : Input -> User -> Gist -> Task FetchError Project
saveToUserMeta input user gist =
    let
        url =
            "https://elm-pad.firebaseio.com/usermeta/"
                ++ user.uid
                ++ "/projects.json"
    in
        Task.andThen
            (Task.mapError
                (\error -> Raw error)
                (Http.send
                    Http.defaultSettings
                    { verb = "POST"
                    , headers = []
                    , body = Http.string <| encodeGistMeta input gist
                    , url = url
                    }
                )
            )
            (\result ->
                Task.succeed
                    (Project
                        input.name
                        gist.id
                        (Just gist.files)
                        False
                    )
            )
