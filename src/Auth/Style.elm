module Auth.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)


type ClassNames
    = Login
    | LoginButton
    | LoginBusy


withNs =
    (stylesheet << namespace "Auth_")


authStyles =
    (compile
        [ withNs login
        ]
    ).css


login =
    [ (.) Login
        [ width (px 300)
        , height (px 350)
        , backgroundColor <| hex "#ffffff"
        , position fixed
        , left <| pct 50
        , top <| pct 50
        , margin4 (px -175) (auto) (auto) (px -150)
        , borderRadius <| px 3
        , displayFlex
        , alignItems center
        , fontSize (px 14)
        , textAlign center
        ]
    , (.) LoginButton
        [ margin auto
        , backgroundColor <| hex "#fff"
        , border <| px 0
        , padding2 (px 14) (px 25)
        , cursor pointer
        , borderRadius <| px 3
        ]
    , (.) LoginBusy
        [ margin auto
        ]
    ]
