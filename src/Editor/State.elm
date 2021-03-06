module Editor.State exposing (init, update, subscriptions)

import Border exposing (stringPort)
import Editor.Border exposing (filePort)
import Editor.Types exposing (Model, Msg(..), User, Project)
import Editor.Tasks.FetchUserMeta exposing (fetchUserMeta)
import Editor.Tasks.CreateProject exposing (createProject)
import Editor.Tasks.LoadFiles exposing (loadFiles)
import Maybe exposing (withDefault)
import Task
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
        [ stringPort ( "MOUNT_EDITOR", "aceArea" )
        , fetchUserMeta user
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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

        LoadFilesSuccess project ->
            let
                projects =
                    changeProjectWithId
                        model.projects
                        project.id
                        (\item ->
                            { item
                                | files = project.files
                            }
                        )
            in
                ( { model
                    | projects = projects
                  }
                , Cmd.none
                )

        LoadFilesError err ->
            ( model, Cmd.none )

        ToggleExpandProject project ->
            let
                projects =
                    changeProjectWithId
                        model.projects
                        project.id
                        (\item ->
                            { item
                                | expanded = not item.expanded
                            }
                        )
            in
                ( { model
                    | projects = projects
                  }
                , loadFiles project model.user
                )

        OpenFile file ->
            let
                ( openFiles, cmd ) =
                    if List.member file model.openFiles then
                        ( model.openFiles, Cmd.none )
                    else
                        ( model.openFiles ++ [ file ]
                        , filePort ( "OPEN_FILE", ( "aceArea", file ) )
                        )
            in
                ( { model
                    | openFiles = openFiles
                    , activeFile = Just file
                  }
                , cmd
                )

        ActivateFile file ->
            ( { model
                | activeFile = Just file
              }
            , filePort ( "ACTIVATE_FILE", ( "aceArea", file ) )
            )

        CloseFile file ->
            let
                newModel =
                    { model
                        | openFiles = List.filter ((/=) file) model.openFiles
                    }

                ( activateModel, activateCmd ) =
                    case List.head newModel.openFiles of
                        Nothing ->
                            ( newModel, Cmd.none )

                        Just file ->
                            update (ActivateFile file) (newModel)
            in
                ( activateModel
                , Cmd.batch
                    [ filePort ( "CLOSE_FILE", ( "aceArea", file ) )
                    , activateCmd
                    ]
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


changeProjectWithId : List Project -> String -> (Project -> Project) -> List Project
changeProjectWithId projects targetId fn =
    List.map
        (\project ->
            if project.id == targetId then
                fn project
            else
                project
        )
        projects
