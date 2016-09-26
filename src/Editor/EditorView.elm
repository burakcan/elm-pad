module Editor.EditorView exposing (editorView)

import Editor.Types exposing (Model, Msg)
import Editor.Style exposing (editorStyles, ClassNames(..))
import Html exposing (Html, div, text, node)
import Html.Attributes exposing (classList, class, id)
import Html.CssHelpers


editorView : Model -> Html Msg
editorView model =
    div [ classNs [ Wrapper ] ]
        [ node "style" [] [ text editorStyles ]
        , div [ classNs [ Sidebar ] ]
            [ div [ classNs [ SidebarContent ] ] []
            , div [ classNs [ SidebarResizer ] ] []
            ]
        , div [ classNs [ RightBlock ] ]
            [ div [ classNs [ TabBar ] ] []
            , div [ classNs [ AceArea ], id "aceArea" ] []
            ]
        ]


( classNs, classListNs, idNs ) =
    let
        { class, classList, id } =
            Html.CssHelpers.withNamespace "Editor_"
    in
        ( class, classList, id )
