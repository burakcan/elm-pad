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


type alias Model =
    { user : User
    , userData : Maybe UserData
    }
