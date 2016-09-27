module Editor.State exposing (init, update, subscriptions)

import Editor.Types exposing (Model, Msg(..), User)
import Editor.Tasks.FetchUserData exposing (fetchUserData)
import Editor.Tasks.CreateProject exposing (createProject)
import List
import String
import Border exposing (stringPort)


init : User -> ( Model, Cmd Msg )
init user =
    ( { user = user
      , userData = Nothing
      , showCreateProject = False
      , projects = []
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
            let
                userData_ =
                    { userData
                        | projects = List.filter (\a -> String.length a > 0) userData.projects
                    }
            in
                ( { model
                    | userData = Just userData_
                  }
                , Cmd.none
                )

        FetchUserDataError _ ->
            ( model, Cmd.none )

        CreateProject ->
            ( model
            , createProject
                { description = "description deneme"
                , private = True
                , files =
                    [ ( "Main.elm", "deneme deneme main.elm" )
                    , ( "elm-package.json", "two file deneme" )
                    ]
                }
                model.user
            )

        CreateProjectSuccess result ->
            ( model, Cmd.none )

        CreateProjectError err ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
