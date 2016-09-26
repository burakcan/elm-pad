module Main.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)


mainStyle : String
mainStyle =
    (compile <|
        [ bodyStyle
        ]
    ).css


bodyStyle : Stylesheet
bodyStyle =
    stylesheet
        [ body
            [ backgroundColor <| hex "#263238"
            , boxSizing borderBox
            , descendants
                [ everything [ boxSizing inherit ]
                ]
            ]
        ]
