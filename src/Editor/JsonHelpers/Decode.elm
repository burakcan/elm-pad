module Editor.JsonHelpers.Decode exposing (..)

import Editor.Types exposing (Gist, File, UserMeta, Project)
import Json.Decode as Decode
import Dict exposing (Dict)
import Maybe exposing (withDefault)
import Http


decodeGist : Decode.Decoder Gist
decodeGist =
    Decode.object4 Gist
        (Decode.at [ "id" ] Decode.string)
        (Decode.at [ "url" ] Decode.string)
        (Decode.at [ "files" ] decodeGistFiles)
        (Decode.at [ "public" ] Decode.bool)


decodeGistFiles : Decode.Decoder (Dict String File)
decodeGistFiles =
    Decode.dict
        (Decode.object4 File
            (Decode.at [ "filename" ] Decode.string)
            (Decode.at [ "type" ] Decode.string)
            (Decode.at [ "size" ] Decode.int)
            (Decode.at [ "content" ] Decode.string)
        )


decodeUserMeta : Decode.Decoder UserMeta
decodeUserMeta =
    Decode.object1 UserMeta
        (Decode.map
            (\result -> Dict.empty `withDefault` result)
            (Decode.maybe
                << Decode.at [ "projects" ]
             <|
                Decode.map
                    (\result -> result)
                    (Decode.dict <|
                        Decode.object3 Project
                            (Decode.at [ "name" ] Decode.string)
                            (Decode.at [ "gistId" ] Decode.string)
                            (Decode.succeed Nothing)
                    )
            )
        )


idFromMetaSave : Http.Value -> String
idFromMetaSave result =
    case result of
        Http.Blob _ ->
            ""

        Http.Text text ->
            Result.withDefault "" <|
                Decode.decodeString (Decode.at [ "name" ] Decode.string) text
