port module Subscriptions exposing ( subscriptions
                                   , firebaseAuthentication
                                   , firebaseUnauthenticate
                                   , firebaseFirestoreAdd
                                   )


import Date exposing (Date)
import Debug exposing (log)
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Json.Encode as Encode
import Keyboard
import Keyboard.Extra as Keys
import Messages exposing (..)
import Models exposing (..)


---- SUBSCRIPTIONS ----


port toFirebase : String -> Cmd msg
port fromFirebase : (String -> msg) -> Sub msg


port firebaseAuthentication : String -> Cmd msg
port firebaseAuthenticationSuccess : (Decode.Value -> msg) -> Sub msg
port firebaseAuthenticationFailure : (String -> msg) -> Sub msg
port firebaseUnauthenticate : () -> Cmd msg
port firebaseUnauthenticateSuccess : (String -> msg) -> Sub msg
port firebaseUnauthenticateFailure : (String -> msg) -> Sub msg
port firebaseFirestoreGetWorkSuccess : (Decode.Value -> msg) -> Sub msg
port firebaseFirestoreGetWorkFailure : (String -> msg) -> Sub msg


port firebaseFirestoreAdd : (String, Encode.Value) -> Cmd msg
port firebaseFirestoreAddSuccess : (String -> msg) -> Sub msg
port firebaseFirestoreAddFailure : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ firebaseAuthenticationSuccess userUpdated
        , firebaseAuthenticationFailure FirebaseAuthenticationFailure
        , firebaseUnauthenticateSuccess FirebaseUnauthenticateSuccess
        , firebaseUnauthenticateFailure FirebaseUnauthenticateFailure
        , firebaseFirestoreGetWorkSuccess updateWorkList
        , firebaseFirestoreGetWorkFailure FirebaseGetWorkFailure
        , firebaseFirestoreAddSuccess FirebaseAddWorkSuccess
        , firebaseFirestoreAddFailure FirebaseAddWorkFailure
        , fromFirebase FirebaseResponse
        , Keyboard.downs (\code -> case (Keys.fromCode code) of
                                      Keys.Escape ->
                                          ShowAddWork False
                                      _ ->
                                          NoOp
                         )
        ]


userUpdated : Decode.Value -> Msg
userUpdated userJson =
    case (Decode.decodeValue decodeUser userJson) of
        Ok user ->
            FirebaseAuthenticationSuccess user
        Err err ->
            FirebaseAuthenticationFailure err


decodeUser : Decode.Decoder User
decodeUser =
    Pipeline.decode User
      |> Pipeline.required "email" Decode.string
      |> Pipeline.required "displayName" Decode.string
      |> Pipeline.required "emailVerified" Decode.bool
      |> Pipeline.required "photoURL" Decode.string
      |> Pipeline.required "uid" Decode.string


updateWorkList : Decode.Value -> Msg
updateWorkList workListJson =
    case (Decode.decodeValue decodeWorkList workListJson) of
        Ok workList ->
            (log "carl" FirebaseGetWorkSuccess workList)
        Err err ->
            (log ("steve" ++ err) FirebaseGetWorkFailure err)


decodeWorkList : Decode.Decoder (List Work)
decodeWorkList =
    Decode.list decodeWork



decodeWork : Decode.Decoder Work
decodeWork =
    Pipeline.decode Work
      |> Pipeline.required "createdBy" Decode.string
      |> Pipeline.required "title" Decode.string
      |> Pipeline.required "description" Decode.string
      |> Pipeline.required "status" decodeWorkStatus
      |> Pipeline.required "createTimestamp" decodeDate
      |> Pipeline.required "updateTimestamp" decodeDate
      |> Pipeline.required "users" decodeUserList
      |> Pipeline.required "uid" Decode.string


decodeWorkStatus : Decode.Decoder WorkStatus
decodeWorkStatus =
    Decode.string
      |> Decode.andThen (\str ->
          case str of
            "todo" ->
              Decode.succeed ToDo
            "inProgress" ->
              Decode.succeed InProgress
            "done" ->
              Decode.succeed Done
            other ->
              Decode.fail <| "Unkown Work Status: " ++ other
      )


decodeDate : Decode.Decoder Date
decodeDate =
    Decode.string
      |> Decode.andThen (\val ->
          case Date.fromString val of
            Err err ->
              Decode.fail <| "Unkown Date: " ++ err
            Ok date ->
              Decode.succeed <| date
      )


decodeUserList : Decode.Decoder (List UserId)
decodeUserList =
    Decode.list decodeUserId


decodeUserId : Decode.Decoder UserId
decodeUserId =
    Decode.string
