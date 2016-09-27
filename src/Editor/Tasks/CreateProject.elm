module Editor.Tasks.CreateProject exposing (createProject)

import Editor.Types exposing (Msg(..), FetchError(..), User)
import Task exposing (Task)
import Json.Encode as Encode
import Json.Decode as Decode
import List
import Http


type alias Input =
    { description : String
    , private : Bool
    , files : List ( String, String )
    }


createProject : Input -> User -> Cmd Msg
createProject input user =
    Task.perform
        CreateProjectError
        CreateProjectSuccess
        (createGist input user)


createGist : Input -> User -> Task FetchError String
createGist input user =
    (Task.mapError
        (\error -> Processed error)
        (Http.post
            decodeGistResponse
            ("https://api.github.com/gists?access_token=" ++ user.accessToken)
            (Http.string <| encodeInput input)
        )
    )


encodeInput : Input -> String
encodeInput { description, private, files } =
    Encode.encode 0 <|
        Encode.object
            [ ( "description", Encode.string description )
            , ( "private", Encode.bool private )
            , ( "files", encodeFiles files )
            ]


encodeFiles : List ( String, String ) -> Encode.Value
encodeFiles files =
    Encode.object <|
        List.map
            (\( name, content ) ->
                ( name
                , Encode.object
                    [ ( "content", Encode.string content )
                    ]
                )
            )
            files


decodeGistResponse : Decode.Decoder String
decodeGistResponse =
    Decode.succeed "created yes"
