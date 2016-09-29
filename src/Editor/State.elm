module Editor.State exposing (init, update, subscriptions)

import Editor.Types exposing (Model, Msg(..), User)
import Editor.Tasks.FetchUserMeta exposing (fetchUserMeta)
import Editor.Tasks.CreateProject exposing (createProject)
import Editor.Selectors exposing (getProjectById)
import Maybe exposing (withDefault)
import Dict
import String
import Border exposing (stringPort)


init : User -> ( Model, Cmd Msg )
init user =
    ( { user = user
      , projects = []
      , showCreateProject = False
      }
    , Cmd.batch
        [ stringPort ( "INIT_EDITOR", "aceArea" )
        , fetchUserMeta user
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "msg" msg
    in
        case msg of
            FetchUserMetaSuccess userMeta ->
                ( { model
                    | projects = userMeta.projects
                  }
                , Cmd.none
                )

            FetchUserMetaError _ ->
                ( model, Cmd.none )

            CreateProject ->
                ( model
                , createProject
                    { name = "Deneme"
                    , description = "description deneme"
                    , private = True
                    , files =
                        [ ( "Main.elm", "deneme deneme main.elm" )
                        , ( "elm-package.json", "two file deneme" )
                        ]
                    }
                    model.user
                )

            CreateProjectSuccess result ->
                ( model, fetchUserMeta model.user )

            CreateProjectError err ->
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
