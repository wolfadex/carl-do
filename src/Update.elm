module Update exposing (update)


import Debug exposing (log)
import Json.Encode as Json
import Messages exposing (..)
import Models exposing (..)
import Subscriptions exposing (firebaseAuthentication, firebaseFirestoreAdd, firebaseUnauthenticate)
-- import Task


---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        FirebaseResponse value ->
            ( model, Cmd.none )
        ShowAddWork yesNo ->
            ( { model
              | showAddWork = yesNo
              , newWork = (NewWork "" "")
              }
            , Cmd.none
            )
        WorkMoved work ->
            ( model, Cmd.none )
        FirebaseAuthentication how ->
            ( { model | user = SigningIn }, firebaseAuthentication how )
        FirebaseAuthenticationSuccess user ->
            ( { model | user = SignedIn user }, Cmd.none )
        FirebaseAuthenticationFailure err ->
            ( { model | user = SignInFailed err }, Cmd.none )
        FirebaseUnauthenticate ->
            ( { model | user = SigningIn }, firebaseUnauthenticate () )
        FirebaseUnauthenticateSuccess _ ->
            ( { model | user = SignedOut }, Cmd.none )
        FirebaseUnauthenticateFailure s ->
            -- TODO: Display some message to let the user know it failed
            ( model, Cmd.none )
        FirebaseAddWork ->
            ( model, submitNewWork model )
        FirebaseAddWorkSuccess _ ->
            ( { model | showAddWork = False }, Cmd.none )
        FirebaseGetWorkSuccess workList ->
            ( { model | allWork = workList}, Cmd.none )
        FirebaseGetWorkFailure err ->
            -- TODO: Display some message to let the user know if failed
            ( model, Cmd.none )
        UpdateNewWork newWork ->
            ( { model | newWork = newWork }, Cmd.none )
        -- DragStart position ->
        --     ( model, Cmd.none )
        _ ->
            ( model, Cmd.none )


submitNewWork : Model -> Cmd Msg
submitNewWork { user, newWork } =
    case user of
        SignedIn userData ->
            firebaseFirestoreAdd ( "work"
                                 , Json.object
                                     [ ( "title", Json.string newWork.title )
                                     , ( "description", Json.string newWork.description )
                                     , ( "createdBy", Json.string userData.uid )
                                     , ( "users", Json.object
                                                    [ ( userData.uid, Json.bool True ) ]
                                       )
                                     ]
                                 )
        other ->
            (log ("steve" ++ (toString other)) Cmd.none)
