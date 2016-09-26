module Auth.State
    exposing
        ( init
        , update
        , subscriptions
        , isLoggedInMsg
        , userAsMaybe
        , isLoggedIn
        )

import Auth.Types exposing (Model, Msg(..), User(Idle, Busy, LoggedIn), UserInfo)
import Auth.Border exposing (loginSuccess, loginError)
import Border exposing (unitPort)


init : ( Model, Cmd Msg )
init =
    ( { user = Busy
      }
    , unitPort ( "TRY_LOGIN", () )
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            ( { model | user = Busy }, unitPort ( "LOGIN", () ) )

        LoginSuccess user ->
            ( { model | user = LoggedIn user }, Cmd.none )

        LoginError error ->
            ( { model | user = Idle }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ loginSuccess LoginSuccess
        , loginError LoginError
        ]


isLoggedIn : Model -> Bool
isLoggedIn model =
    case userAsMaybe model of
        Nothing ->
            False

        Just _ ->
            True


userAsMaybe : Model -> Maybe UserInfo
userAsMaybe model =
    case model.user of
        Idle ->
            Nothing

        Busy ->
            Nothing

        LoggedIn userInfo ->
            Just userInfo


isLoggedInMsg : Msg -> Bool
isLoggedInMsg msg =
    case msg of
        Login ->
            False

        LoginError _ ->
            False

        LoginSuccess _ ->
            True
