module Messages exposing (..)


import Models exposing (Work)


---- MESSAGES ----


type Msg
    = NoOp
    | ShowAddWork Bool
    | WorkMoved Work
    | FirebaseResponse String
    | FirebaseAuth String
