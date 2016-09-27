module Editor.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Html.CssHelpers


nsHelpers =
    let
        { class, classList, id } =
            Html.CssHelpers.withNamespace "Editor_"
    in
        ( class, classList, id )


type ClassNames
    = Wrapper
    | Sidebar
    | SidebarContent
    | SidebarResizer
    | RightBlock
    | TabBar
    | AceArea
    | Overlay


withNs =
    (stylesheet << namespace "Editor_")


editorStyles =
    (compile
        [ withNs wrapper
        ]
    ).css


wrapper =
    [ (.) Wrapper
        [ position fixed
        , width (vw 100)
        , height (vh 100)
        , overflow hidden
        , displayFlex
        ]
    , (.) Sidebar
        [ flex none
        , displayFlex
        , width (px 250)
        , children
            [ (.) SidebarContent
                [ flex auto
                ]
            , (.) SidebarResizer
                [ width (px 5)
                , cursor colResize
                ]
            ]
        ]
    , (.) RightBlock
        [ flex (int 1)
        , displayFlex
        , flexDirection column
        , children
            [ (.) TabBar
                [ flex none
                , height (px 40)
                ]
            , (.) AceArea
                [ flex (int 1)
                , border3 (px 1) solid (hex "#455A64")
                , marginRight (px 10)
                , marginBottom (px 10)
                ]
            ]
        ]
    , (.) Overlay
        [ position fixed
        , left (px 0)
        , top (px 0)
        , width (vw 100)
        , height (vh 100)
        , displayFlex
        , alignItems center
        , textAlign center
        ]
    ]
