module Editor.Views.CreateProjectForm exposing (createProjectForm)

import Editor.Types exposing (Model, Msg(..))
import Html exposing (Html, div, text, i, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List


createProjectForm : Model -> Html Msg
createProjectForm model =
    if model.showCreateProject || List.length model.projects == 0 then
        div [ class "Overlay" ]
            [ text "create project"
            , button [ onClick CreateProject ] [ text "create now" ]
            ]
    else
        text ""
