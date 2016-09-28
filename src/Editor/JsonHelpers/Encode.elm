module Editor.JsonHelpers.Encode exposing (..)

import Editor.Types exposing (Gist, File)
import Json.Encode as Encode
import Dict exposing (Dict)


type alias Input =
    { name : String
    , description : String
    , private : Bool
    , files : List ( String, String )
    }


encodeInput : Input -> String
encodeInput { description, private, files } =
    Encode.encode 0 <|
        Encode.object
            [ ( "description", Encode.string description )
            , ( "private", Encode.bool private )
            , ( "files", encodeInputFiles files )
            ]


encodeInputFiles : List ( String, String ) -> Encode.Value
encodeInputFiles files =
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


encodeGistMeta : Input -> Gist -> String
encodeGistMeta input gist =
    Encode.encode 0 <|
        Encode.object
            [ ( "gistId", Encode.string gist.id )
            , ( "name", Encode.string input.name )
            ]
