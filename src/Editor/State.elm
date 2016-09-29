module Editor.State exposing (init, update, subscriptions)

import Border exposing (stringPort)
import Editor.Border exposing (filePort)
import Editor.Types exposing (Model, Msg(..), User)
import Editor.Tasks.FetchUserMeta exposing (fetchUserMeta)
import Editor.Tasks.CreateProject exposing (createProject)
import Editor.Tasks.LoadFiles exposing (loadFiles)
import Editor.Selectors exposing (getProjectById)
import Maybe exposing (withDefault)
import List


init : User -> ( Model, Cmd Msg )
init user =
    ( { user = user
      , projects = []
      , showCreateProject = False
      , openFiles = []
      , activeFile = Nothing
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

            LoadFilesSuccess ( id, project ) ->
                let
                    projects =
                        List.map
                            (\( id_, project_ ) ->
                                if id == id_ then
                                    ( id_, { project_ | files = project.files } )
                                else
                                    ( id_, project_ )
                            )
                            model.projects
                in
                    ( { model
                        | projects = projects
                      }
                    , Cmd.none
                    )

            LoadFilesError err ->
                ( model, Cmd.none )

            ToggleExpandProject ( id, project ) ->
                let
                    projects =
                        List.map
                            (\( id_, project_ ) ->
                                if id == id_ then
                                    ( id, { project | expanded = not project.expanded } )
                                else
                                    ( id_, project_ )
                            )
                            model.projects
                in
                    ( { model
                        | projects = projects
                      }
                    , loadFiles ( id, project ) model.user
                    )

            OpenFile file ->
                let
                    openFiles =
                        if List.member file model.openFiles then
                            model.openFiles
                        else
                            file :: model.openFiles
                in
                    ( { model
                        | openFiles = openFiles
                      }
                    , filePort ( "OPEN_FILE", file )
                    )

            ActivateFile file ->
                ( { model
                    | activeFile = Just file
                  }
                , filePort ( "ACTIVATE_FILE", file )
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
