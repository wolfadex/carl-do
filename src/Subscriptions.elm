port module Subscriptions exposing (subscriptions)


import Keyboard
import Messages exposing (..)
import Models exposing (..)


---- SUBSCRIPTIONS ----


port toFirebase : String -> Cmd msg
port fromFirebase : (String -> msg) -> Sub msg


port firebaseAuth : String -> Cmd msg
port firebaseAuthSuccess : (String -> msg) -> Sub msg
port firebaseAuthFailure : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ firebaseAuthSuccess FirebaseAuth
        , firebaseAuthFailure FirebaseAuth
        , fromFirebase FirebaseResponse
        , Keyboard.downs (\code -> case code of
                                      escape ->
                                          ShowAddWork False
                         )
        ]
