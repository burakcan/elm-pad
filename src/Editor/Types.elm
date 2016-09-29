module Editor.Types
    exposing
        ( Model
        , Msg(..)
        , FetchError(..)
        , User
        , UserMeta
        , File
        , Folder
        , FileTree
        , FileTreeNode(..)
        , Project
        , Gist
        )

import Dict exposing (Dict)
import Http


type FetchError
    = Raw Http.RawError
    | Processed Http.Error
    | DecodeError String


type Msg
    = FetchUserMetaSuccess UserMeta
    | FetchUserMetaError FetchError
    | CreateProject
    | CreateProjectSuccess Project
    | CreateProjectError FetchError
    | LoadFilesSuccess ( String, Project )
    | LoadFilesError FetchError
    | ToggleExpandProject ( String, Project )
    | OpenFile ( String, File )
    | ActivateFile ( String, File )



-- UserMeta: Firebase


type alias UserMeta =
    { projects : List ( String, Project )
    }



-- User: (Auth.User / Github User) + UserMeta


type alias User =
    { displayName : String
    , email : String
    , uid : String
    , photoUrl : String
    , accessToken : String
    , credential :
        { provider : String
        , accessToken : String
        }
    }



-- File Tree


type alias File =
    { name : String
    , fileType : String
    , size : Int
    , content : String
    , url : String
    }


type alias Folder =
    { name : String
    , children : FileTree
    }


type FileTreeNode
    = FileNode File
    | FolderNode Folder


type alias FileTree =
    Dict String FileTreeNode



-- Project: Local and Firebase


type alias Project =
    { name : String
    , gistId : String
    , files : Maybe FileTree
    , expanded : Bool
    }



-- Gist: Github gist


type alias Gist =
    { id : String
    , url : String
    , files : FileTree
    , public : Bool
    }



--


type alias Model =
    { user : User
    , projects : List ( String, Project )
    , showCreateProject : Bool
    , openFiles : List ( String, File )
    , activeFile : Maybe ( String, File )
    }
