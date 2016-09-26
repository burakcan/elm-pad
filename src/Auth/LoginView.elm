module Auth.LoginView exposing (loginView)

import Auth.Types exposing (Msg(..), Model, User(..))
import Auth.Style as Style
import Html exposing (Html, div, text, node, button, i)
import Html.Events exposing (onClick)
import Html.Attributes exposing (classList, class)


loginView : Model -> Html Msg
loginView model =
    let
        buttonView =
            case model.user of
                Idle ->
                    button
                        [ onClick Login
                        , classList
                            [ ( "Auth_LoginButton", True )
                            , ( "shadow-2dp", True )
                            ]
                        ]
                        [ text "Login with Github" ]

                Busy ->
                    div [ class "Auth_LoginBusy" ]
                        [ i [ class "material-icons spin" ] [ text "cached" ]
                        , div [] [ text "Logging in..." ]
                        ]

                LoggedIn user ->
                    text <| "Logged in " ++ user.displayName
    in
        div
            [ classList
                [ ( "Auth_Login", True )
                , ( "shadow-2dp", True )
                ]
            ]
            [ node "style" [] [ text Style.authStyles ]
            , buttonView
            ]
