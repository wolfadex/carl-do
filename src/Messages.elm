module Messages exposing (..)


import Models exposing (..)


---- MESSAGES ----


type Msg
    = NoOp
    | ShowAddWork Bool
    | WorkMoved Work
    | FirebaseResponse String
    | FirebaseAuthentication String
    | FirebaseAuthenticationSuccess User
    | FirebaseAuthenticationFailure String
    | FirebaseUnauthenticate
    | FirebaseUnauthenticateSuccess String
    | FirebaseUnauthenticateFailure String
    | FirebaseGetWorkSuccess (List Work)
    | FirebaseGetWorkFailure String
    | FirebaseAddWork
    | FirebaseAddWorkSuccess String
    | FirebaseAddWorkFailure String
    | FirebaseAddWorkResult
    | UpdateNewWork NewWork
