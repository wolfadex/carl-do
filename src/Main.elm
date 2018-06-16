port module Main exposing (main)

import Html
import Html.Styled as Styled
-- import Uuid.Barebones as Uuid


import Messages exposing (..)
import Models exposing (..)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import Views exposing (view)


---- TEST ----


-- tempCarl : Work
-- tempCarl = { id = toString Uuid.uuidStringGenerator
--            , title = "A Title"
--            , description = "A Description"
--            -- , createTimestamp = Task.perform Date.now
--            }


---- MAIN ----


main : Program Never Model Msg
main =
    Html.program
        { view = view >> Styled.toUnstyled
        , init = init
        , update = update
        , subscriptions = subscriptions
        }

init : ( Model, Cmd Msg )
init =
     ( { allWork = []
       , showAddWork = False
       , newWork = NewWork "" ""
       , user = SignedOut
       }
     -- , firebaseAuthentication "google"
     , Cmd.none
     )
