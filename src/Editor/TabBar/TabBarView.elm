module Editor.TabBar.TabBarView exposing (tabBarView)

import Editor.Types exposing (Model, Msg(..), File)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import List


tabBarView : Model -> Html Msg
tabBarView model =
    div [ class "TabBar" ] <| List.map (tabView model) model.openFiles


tabView : Model -> ( String, File ) -> Html Msg
tabView model ( name, file ) =
    div
        [ classList
            [ ( "TabBar-Tab", True )
            , ( "active", model.activeFile == Just ( name, file ) )
            ]
        , onClick <| ActivateFile ( name, file )
        ]
        [ text name
        ]
