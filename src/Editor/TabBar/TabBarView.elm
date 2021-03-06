module Editor.TabBar.TabBarView exposing (tabBarView)

import Editor.Types exposing (Model, Msg(..), File)
import Html exposing (Html, div, text, button)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import List


tabBarView : Model -> Html Msg
tabBarView model =
    div [ class "TabBar" ] <| List.map (tabView model) model.openFiles


tabView : Model -> File -> Html Msg
tabView model file =
    div
        [ classList
            [ ( "TabBar-Tab", True )
            , ( "active", model.activeFile == Just file )
            ]
        ]
        [ button [ onClick <| ActivateFile file ] [ text file.name ]
        , button [ onClick <| CloseFile file ] [ text "X" ]
        ]
