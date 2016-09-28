module Editor.Types
    exposing
        ( Model
        , Msg(..)
        , FetchError(..)
        , User
        , UserMeta
        , File
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
    | ActivateProject ProjectId
    | LoadFilesSuccess (Maybe ( ProjectId, Project ))
    | LoadFilesError FetchError


type alias ProjectId =
    String


type alias GistId =
    String


type alias FileName =
    String



-- UserMeta: Firebase


type alias UserMeta =
    { projects : List ( ProjectId, Project )
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



-- File: Github Gist File


type alias File =
    { name : FileName
    , fileType : String
    , size : Int
    , content : String
    }



-- Project: Local and Firebase


type alias Project =
    { name : String
    , gistId : GistId
    , files : Maybe (Dict FileName File)
    }



-- Gist: Github gist


type alias Gist =
    { id : GistId
    , url : String
    , files : Dict FileName File
    , public : Bool
    }



--


type alias Model =
    { user : User
    , userMeta : Maybe UserMeta
    , activeProject : Maybe ( ProjectId, Project )
    , showCreateProject : Bool
    }
