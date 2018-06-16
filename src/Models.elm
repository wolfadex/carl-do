module Models exposing (..)


import Date exposing (Date)


---- MODEL ----


type alias UserId =
    String


type Firebase e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


type UserAuth
    = SignedOut
    | SignedIn User
    | SigningIn
    | SignInFailed String


type alias User =
    { email : String
    , displayName : String
    , emailVerified : Bool
    , photoURL : String
    , uid : UserId
    }


type WorkStatus
    = ToDo
    | InProgress
    | Done


type alias Work =
    { createdBy : UserId
    , title : String
    , description : String
    , status : WorkStatus
    , createTimestamp : Date
    , updateTimestamp : Date
    , users : List UserId
    }


type alias NewWork =
    { title : String
    , description : String
    }


type alias WorkList =
    { title : String
    , work : List (Work)
    }


type alias Model =
    { allWork : List Work
    , showAddWork : Bool
    , newWork : NewWork
    , user : UserAuth
    }
