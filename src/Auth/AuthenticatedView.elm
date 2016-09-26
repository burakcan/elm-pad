module Auth.AuthenticatedView exposing (authenticatedView)

import Auth.Types exposing (Msg, Model, User(Busy, Idle, LoggedIn))
import Auth.LoginView exposing (loginView)
import Html exposing (Html)
import Html.App as App


authenticatedView : Model -> (Msg -> parentMsg) -> Html parentMsg -> Html parentMsg
authenticatedView model parentMsg view =
    case model.user of
        Idle ->
            App.map parentMsg <| loginView model

        Busy ->
            App.map parentMsg <| loginView model

        LoggedIn user ->
            view
