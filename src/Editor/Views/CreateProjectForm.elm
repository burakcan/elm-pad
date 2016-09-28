module Editor.Views.CreateProjectForm exposing (createProjectForm)

import Editor.Types exposing (Model, Msg(..))
import Editor.Style exposing (ClassNames(..), nsHelpers)
import List
import Html exposing (Html, div, text, i, button)
import Html.Attributes exposing (classList)
import Html.Events exposing (onClick)


createProjectForm : Model -> Html Msg
createProjectForm model =
    case model.userMeta of
        Nothing ->
            text ""

        Just userMeta ->
            if model.showCreateProject || List.length userMeta.projects == 0 then
                div [ classNs [ Overlay ] ]
                    [ text "create project"
                    , button [ onClick CreateProject ] [ text "create now" ]
                    ]
            else
                text ""


( classNs, classListNs, idNs ) =
    nsHelpers
