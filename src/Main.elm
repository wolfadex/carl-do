port module Main exposing (main)

import Html
import Html.Styled as Styled
import Messages exposing (..)
import Models exposing (..)
import Subscriptions exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


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
       -- , dragModel = { Nothing Nothing Mouse. }
       }
     , Cmd.none
     )
