module Editor.JsonHelpers.Decode exposing (..)

import Editor.Types exposing (Gist, File, UserMeta, Project, FileTree, FileTreeNode(..))
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


decodeGistFiles : Decode.Decoder (List FileTreeNode)
decodeGistFiles =
    Decode.map
        Dict.values
    <|
        Decode.dict
            (Decode.map (\file -> FileNode file)
                (Decode.object5 File
                    (Decode.at [ "filename" ] Decode.string)
                    (Decode.at [ "type" ] Decode.string)
                    (Decode.at [ "size" ] Decode.int)
                    (Decode.at [ "content" ] Decode.string)
                    (Decode.at [ "raw_url" ] Decode.string)
                )
            )


decodeUserMeta : Decode.Decoder UserMeta
decodeUserMeta =
    Decode.object1 UserMeta
        (Decode.map
            (\result -> [] `withDefault` result)
            (Decode.maybe
                << Decode.at [ "projects" ]
             <|
                Decode.map
                    Dict.values
                    (Decode.dict <|
                        Decode.object5 Project
                            (Decode.at [ "name" ] Decode.string)
                            (Decode.at [ "gistId" ] Decode.string)
                            (Decode.at [ "gistId" ] Decode.string)
                            (Decode.succeed Nothing)
                            (Decode.succeed False)
                    )
            )
        )
