module Main.State exposing (init, update, subscriptions)

import Main.Types exposing (Model, Msg(..), Flags)
import Auth.State
import Auth.Types
import Editor.State
import Editor.Types
import Maybe exposing (withDefault)


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( authModel, authCmd ) =
            Auth.State.init
    in
        ( { auth = authModel
          , editor = Nothing
          }
        , Cmd.batch
            [ Cmd.map AuthMsg <| authCmd
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthMsg authMsg ->
            authUpdate authMsg model

        EditorMsg editorMsg ->
            editorUpdate editorMsg model


authUpdate : Auth.Types.Msg -> Model -> ( Model, Cmd Msg )
authUpdate authMsg model =
    let
        ( authModel, authCmd ) =
            Auth.State.update authMsg model.auth

        ( editorModel, editorCmd ) =
            case Auth.State.userAsMaybe authModel of
                Nothing ->
                    ( Nothing, Cmd.none )

                Just userInfo ->
                    (\( a, b ) -> ( Just a, b )) <|
                        Editor.State.init userInfo
    in
        ( { model
            | auth = authModel
            , editor = editorModel
          }
        , Cmd.batch
            [ Cmd.map AuthMsg <| authCmd
            , Cmd.map EditorMsg <| editorCmd
            ]
        )


editorUpdate : Editor.Types.Msg -> Model -> ( Model, Cmd Msg )
editorUpdate editorMsg model =
    let
        ( editorModel, editorCmd ) =
            case model.editor of
                Nothing ->
                    ( Nothing, Cmd.none )

                Just editorModel ->
                    (\( a, b ) -> ( Just a, b )) <|
                        Editor.State.update editorMsg editorModel
    in
        ( { model
            | editor = editorModel
          }
        , Cmd.map EditorMsg <| editorCmd
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map AuthMsg <| Auth.State.subscriptions model.auth
        , case model.editor of
            Nothing ->
                Sub.none

            Just editorModel ->
                Sub.map EditorMsg <| Editor.State.subscriptions editorModel
        ]
