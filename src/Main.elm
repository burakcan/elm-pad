module Main exposing (..)

import Main.State exposing (init, update, subscriptions)
import Main.View exposing (mainView)
import Html.App exposing (programWithFlags)


main =
    programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = mainView
        }
