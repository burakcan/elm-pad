module Editor.FetchUserData exposing (fetchUserData)

import Editor.Types exposing (Msg(..), User, FetchError(..), UserData)
import Task exposing (Task)
import Json.Encode as Encode
import Json.Decode as Decode
import Http


fetchUserData : User -> Cmd Msg
fetchUserData user =
    Task.perform
        FetchUserDataError
        FetchUserDataSuccess
        (Task.andThen
            (tryFetchSavedData user)
            (\result ->
                case result of
                    Just projects ->
                        Task.succeed projects

                    Nothing ->
                        initUserData user
            )
        )


tryFetchSavedData : User -> Task FetchError (Maybe UserData)
tryFetchSavedData user =
    let
        url =
            "https://elm-pad.firebaseio.com/userdata/" ++ user.uid ++ ".json"
    in
        Task.mapError
            (\error -> Processed error)
            (Http.get (Decode.maybe decodeUserData) url)


initUserData : User -> Task FetchError UserData
initUserData user =
    let
        url =
            "https://elm-pad.firebaseio.com/userdata.json"
    in
        Task.andThen
            (Task.mapError
                (\error -> Raw error)
                (Http.send
                    Http.defaultSettings
                    { verb = "PUT"
                    , headers = []
                    , body = Http.string <| encodeUserData user.uid
                    , url = url
                    }
                )
            )
            (\result ->
                let
                    decoded =
                        Decode.decodeString
                            (Decode.at [ user.uid ] decodeUserData)
                            (case result.value of
                                Http.Blob _ ->
                                    ""

                                Http.Text text ->
                                    text
                            )
                in
                    case decoded of
                        Ok userData ->
                            Task.succeed userData

                        Err err ->
                            Task.fail <| DecodeError err
            )


decodeUserData : Decode.Decoder UserData
decodeUserData =
    Decode.object1 UserData
        (Decode.at [ "projects" ] <| Decode.list Decode.string)


encodeUserData : String -> String
encodeUserData uid =
    Encode.encode 0 <|
        Encode.object
            [ ( uid
              , Encode.object
                    [ ( "projects", Encode.list [ Encode.string "" ] )
                    ]
              )
            ]
