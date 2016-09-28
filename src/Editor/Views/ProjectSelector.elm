module Editor.Views.ProjectSelector exposing (projectSelector)

import Editor.Types exposing (Model, Msg(..))
import Editor.Selectors exposing (getProjects)
import Html exposing (Html, div, text, select, option)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput)
import List


projectSelector : Model -> Html Msg
projectSelector model =
    div [ class "ProjectSelector" ]
        [ select [ onInput ActivateProject ] <|
            List.map
                (\( id, project ) -> option [ value id ] [ text project.name ])
            <|
                getProjects model
        ]
