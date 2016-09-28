module Editor.State exposing (init, update, subscriptions)

import Editor.Types exposing (Model, Msg(..), User)
import Editor.Tasks.FetchUserMeta exposing (fetchUserMeta)
import Editor.Tasks.CreateProject exposing (createProject)
import Editor.Tasks.LoadFiles exposing (loadFiles)
import Editor.Selectors exposing (getProjectById)
import Maybe exposing (withDefault)
import Dict
import String
import Border exposing (stringPort)


init : User -> ( Model, Cmd Msg )
init user =
    ( { user = user
      , userMeta = Nothing
      , activeProject = Nothing
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
                let
                    newModel =
                        { model
                            | userMeta = Just userMeta
                        }

                    firstProjectId =
                        case List.head userMeta.projects of
                            Nothing ->
                                ""

                            Just ( id, _ ) ->
                                id
                in
                    update (ActivateProject firstProjectId) newModel

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

            ActivateProject id ->
                let
                    project =
                        getProjectById model id

                    cmd =
                        case project of
                            Nothing ->
                                Cmd.none

                            Just project_ ->
                                loadFiles project_ model.user
                in
                    ( { model
                        | activeProject = project
                      }
                    , cmd
                    )

            LoadFilesSuccess result ->
                let
                    activeProject =
                        Maybe.andThen
                            result
                            (\( newId, new ) ->
                                Maybe.andThen
                                    model.activeProject
                                    (\( oldId, _ ) ->
                                        if oldId == newId then
                                            Just ( newId, new )
                                        else
                                            Nothing
                                    )
                            )
                in
                    ( { model
                        | activeProject = activeProject
                      }
                    , Cmd.none
                    )

            LoadFilesError _ ->
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
