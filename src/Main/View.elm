module Main.View exposing (mainView)

import Main.Types exposing (Model, Msg(..))
import Main.Style exposing (mainStyle)
import Auth.AuthenticatedView exposing (authenticatedView)
import Editor.EditorView exposing (editorView)
import Html exposing (Html, div, text, node)
import Html.App as App


mainView : Model -> Html Msg
mainView model =
    let
        loggedInView =
            case model.editor of
                Nothing ->
                    text ""

                Just editorModel ->
                    App.map EditorMsg <| editorView editorModel
    in
        div []
            [ node "style" [] [ text mainStyle ]
            , (authenticatedView model.auth AuthMsg loggedInView)
            ]
