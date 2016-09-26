module Auth.Types exposing (Model, Msg(..), UserInfo, User(..), AuthError)


type Msg
    = Login
    | LoginSuccess UserInfo
    | LoginError AuthError


type alias UserInfo =
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


type alias AuthError =
    { error : { code : String }
    , silent : Bool
    }


type User
    = Idle
    | Busy
    | LoggedIn UserInfo


type alias Model =
    { user : User
    }
