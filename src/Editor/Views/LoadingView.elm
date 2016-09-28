module Editor.Views.LoadingView exposing (loadingView)

import Editor.Types exposing (Model, Msg)
import Editor.Style exposing (ClassNames(..), nsHelpers)
import List
import Html exposing (Html, div, text, i)
import Html.Attributes exposing (classList, class, style)
import Html.CssHelpers


loadingView : Model -> Html Msg
loadingView model =
    case model.userMeta of
        Nothing ->
            div [ classNs [ Overlay ] ]
                [ i
                    [ class "material-icons spin"
                    , style
                        [ ( "margin", "auto" )
                        , ( "color", "#fff" )
                        ]
                    ]
                    [ text "cached" ]
                ]

        Just _ ->
            text ""


( classNs, classListNs, idNs ) =
    nsHelpers
