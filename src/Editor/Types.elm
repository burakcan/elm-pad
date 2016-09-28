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



-- UserMeta: Firebase


type alias UserMeta =
    { projects : Dict String Project
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
    { name : String
    , fileType : String
    , size : Int
    , content : String
    }



-- Project: Local and Firebase


type alias Project =
    { name : String
    , gistId : String
    , files : Maybe (Dict String File)
    }



-- Gist: Github gist


type alias Gist =
    { id : String
    , url : String
    , files : Dict String File
    , public : Bool
    }



--


type alias Model =
    { user : User
    , userMeta : Maybe UserMeta
    , activeProject : Maybe Project
    , showCreateProject : Bool
    }
