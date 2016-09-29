module Editor.FileTree.FileTreeView exposing (fileTreeView)

import Editor.Types
    exposing
        ( Model
        , Msg(..)
        , FileTree
        , File
        , Folder
        , FileTreeNode(..)
        , Project
        )
import Html exposing (Html, div, text, i, span)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick, onDoubleClick)
import List
import Dict


fileTreeView : Model -> Html Msg
fileTreeView model =
    div [ class "FileTree" ] <| List.map projectView model.projects


projectView : Project -> Html Msg
projectView project =
    div []
        [ div
            [ classList
                [ ( "FileTree-Project", True )
                , ( "expanded", project.expanded )
                ]
            , onClick <| ToggleExpandProject project
            ]
            [ i [ class "material-icons project-chevron" ] [ text "chevron_right" ]
            , span [ class "project-title" ] [ text project.name ]
            ]
        , div []
            [ if project.expanded then
                walkTree project.files
              else
                text ""
            ]
        ]


walkTree : Maybe FileTree -> Html Msg
walkTree files =
    case files of
        Nothing ->
            text "nothing"

        Just nodes ->
            div [] <| List.map nodeView nodes


nodeView : FileTreeNode -> Html Msg
nodeView node =
    case node of
        FileNode node ->
            fileNodeView node

        FolderNode node ->
            text "Folders are not supported yet."


fileNodeView : File -> Html Msg
fileNodeView file =
    div
        [ classList
            [ ( "FileTree-File", True )
            ]
        , onDoubleClick <| OpenFile file
        ]
        [ text file.name ]
