module Editor.State exposing (init, update, subscriptions)

import Editor.Types exposing (Model, Msg(..), User)
import Editor.FetchUserData exposing (fetchUserData)
import Border exposing (stringPort)


init : User -> ( Model, Cmd Msg )
init user =
    ( { user = user
      , userData = Nothing
      }
    , Cmd.batch
        [ stringPort ( "INIT_EDITOR", "aceArea" )
        , fetchUserData user
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchUserDataSuccess userData ->
            ( { model | userData = Just userData }, Cmd.none )

        FetchUserDataError _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
