port module Border exposing (unitPort, stringPort)


port unitPort : ( String, () ) -> Cmd msg


port stringPort : ( String, String ) -> Cmd msg
