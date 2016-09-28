module Editor.Tasks.FetchUserMeta exposing (fetchUserMeta)

import Editor.Types
    exposing
        ( Msg(..)
        , User
        , FetchError(..)
        )
import Editor.JsonHelpers.Decode exposing (decodeUserMeta)
import Task exposing (Task)
import Http


fetchUserMeta : User -> Cmd Msg
fetchUserMeta user =
    let
        url =
            "https://elm-pad.firebaseio.com/usermeta/" ++ user.uid ++ ".json"
    in
        Task.perform
            FetchUserMetaError
            FetchUserMetaSuccess
            (Task.mapError
                (\error -> Processed error)
                (Http.get decodeUserMeta url)
            )
