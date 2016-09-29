module Editor.EditorView exposing (editorView)

import Editor.Types exposing (Model, Msg(..))
import Editor.Views.CreateProjectForm exposing (createProjectForm)
import Html exposing (Html, div, text, i, select, option)
import Html.Attributes exposing (classList, class, id, style, value)
import Html.Events exposing (onInput)
import List


editorView : Model -> Html Msg
editorView model =
    div [ class "Wrapper" ]
        [ div [ class "Sidebar" ]
            [ div [ class "SidebarContent" ]
                []
            , div [ class "SidebarResizer" ] []
            ]
        , div [ class "RightBlock" ]
            [ div [ class "TabBar" ] []
            , div [ class "AceArea", id "aceArea" ] []
            ]
        , createProjectForm model
        ]
