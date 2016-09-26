port module Auth.Border exposing (..)

import Auth.Types exposing (UserInfo, AuthError)


port loginSuccess : (UserInfo -> msg) -> Sub msg


port loginError : (AuthError -> msg) -> Sub msg
