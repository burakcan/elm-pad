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
    | LoadFilesSuccess Project
    | LoadFilesError FetchError
    | ToggleExpandProject Project
    | OpenFile File
    | ActivateFile File



-- UserMeta: Firebase


type alias UserMeta =
    { projects : List Project
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
    List FileTreeNode



-- Project: Local and Firebase


type alias Project =
    { name : String
    , gistId : String
    , id : String
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
    , projects : List Project
    , showCreateProject : Bool
    , openFiles : List File
    , activeFile : Maybe File
    }
