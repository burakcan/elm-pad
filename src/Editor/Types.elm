module Editor.Types exposing (Model, Msg(..), User, UserData, FetchError(..))

import Json.Decode as Decode
import Http


type FetchError
    = Raw Http.RawError
    | Processed Http.Error
    | DecodeError String


type Msg
    = FetchUserDataSuccess UserData
    | FetchUserDataError FetchError
    | CreateProject
    | CreateProjectSuccess String
    | CreateProjectError FetchError


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


type alias UserData =
    { projects : List String
    }


type alias Project =
    { name : String
    , id : String
    , files : List ( String, String )
    }


type alias Model =
    { user : User
    , userData : Maybe UserData
    , showCreateProject : Bool
    , projects : List Project
    }
