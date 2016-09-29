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
    let
        _ =
            Debug.log "open: " model.openFiles
    in
        div [ class "FileTree" ] <| List.map projectView model.projects


projectView : ( String, Project ) -> Html Msg
projectView ( id, project ) =
    div []
        [ div
            [ classList
                [ ( "FileTree-Project", True )
                , ( "expanded", project.expanded )
                ]
            , onClick <| ToggleExpandProject ( id, project )
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
            div [] <| List.map nodeView <| Dict.toList nodes


nodeView : ( String, FileTreeNode ) -> Html Msg
nodeView ( name, node ) =
    case node of
        FileNode node ->
            fileNodeView ( name, node )

        FolderNode node ->
            text "Folders are not supported yet."


fileNodeView : ( String, File ) -> Html Msg
fileNodeView ( name, file ) =
    div
        [ classList
            [ ( "FileTree-File", True )
            ]
        , onDoubleClick <| OpenFile ( name, file )
        ]
        [ text name ]
