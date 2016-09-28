module Editor.EditorView exposing (editorView)

import Editor.Types exposing (Model, Msg(..))
import Editor.Style exposing (editorStyles, ClassNames(..), nsHelpers)
import Editor.Views.CreateProjectForm exposing (createProjectForm)
import Editor.Views.LoadingView exposing (loadingView)
import Editor.Views.ProjectSelector exposing (projectSelector)
import Editor.Selectors exposing (getActiveProject)
import Html exposing (Html, div, text, node, i, select, option)
import Html.Attributes exposing (classList, class, id, style, value)
import Html.Events exposing (onInput)
import List


editorView : Model -> Html Msg
editorView model =
    let
        _ =
            Debug.log "model" model.activeProject
    in
        div [ classNs [ Wrapper ] ]
            [ node "style" [] [ text editorStyles ]
            , div [ classNs [ Sidebar ] ]
                [ div [ classNs [ SidebarContent ] ]
                    [ projectSelector model
                    , text <| toString <| getActiveProject model
                    ]
                , div [ classNs [ SidebarResizer ] ] []
                ]
            , div [ classNs [ RightBlock ] ]
                [ div [ classNs [ TabBar ] ] []
                , div [ classNs [ AceArea ], id "aceArea" ] []
                ]
            , createProjectForm model
            , loadingView model
            ]


( classNs, classListNs, idNs ) =
    nsHelpers
