port module Subscriptions exposing ( subscriptions
                                   , firebaseAuthentication
                                   , firebaseUnauthenticate
                                   , firebaseFirestoreAdd
                                   )


import Date exposing (Date)
import Debug exposing (log)
import Json.Decode as Json
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
port firebaseAuthenticationSuccess : (Json.Value -> msg) -> Sub msg
port firebaseAuthenticationFailure : (String -> msg) -> Sub msg
port firebaseUnauthenticate : () -> Cmd msg
port firebaseUnauthenticateSuccess : (String -> msg) -> Sub msg
port firebaseUnauthenticateFailure : (String -> msg) -> Sub msg
port firebaseFirestoreGetWorkSuccess : (Json.Value -> msg) -> Sub msg
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


userUpdated : Json.Value -> Msg
userUpdated userJson =
    case (Json.decodeValue decodeUser userJson) of
        Ok user ->
            FirebaseAuthenticationSuccess user
        Err err ->
            FirebaseAuthenticationFailure err


decodeUser : Json.Decoder User
decodeUser =
    Pipeline.decode User
      |> Pipeline.required "email" Json.string
      |> Pipeline.required "displayName" Json.string
      |> Pipeline.required "emailVerified" Json.bool
      |> Pipeline.required "photoURL" Json.string
      |> Pipeline.required "uid" Json.string


updateWorkList : Json.Value -> Msg
updateWorkList workListJson =
    case (Json.decodeValue decodeWorkList workListJson) of
        Ok workList ->
            (log "carl" FirebaseGetWorkSuccess workList)
        Err err ->
            (log ("steve" ++ err) FirebaseGetWorkFailure err)


decodeWorkList : Json.Decoder (List Work)
decodeWorkList =
    Json.list decodeWork



decodeWork : Json.Decoder Work
decodeWork =
    Pipeline.decode Work
      |> Pipeline.required "createdBy" Json.string
      |> Pipeline.required "title" Json.string
      |> Pipeline.required "description" Json.string
      |> Pipeline.required "status" decodeWorkStatus
      |> Pipeline.required "createTimestamp" decodeDate
      |> Pipeline.required "updateTimestamp" decodeDate
      |> Pipeline.required "users" decodeUserList


decodeWorkStatus : Json.Decoder WorkStatus
decodeWorkStatus =
    Json.string
      |> Json.andThen (\str ->
          case str of
            "todo" ->
              Json.succeed ToDo
            "inProgress" ->
              Json.succeed InProgress
            "done" ->
              Json.succeed Done
            other ->
              Json.fail <| "Unkown Work Status: " ++ other
      )


decodeDate : Json.Decoder Date
decodeDate =
    Json.string
      |> Json.andThen (\val ->
          case Date.fromString val of
            Err err ->
              Json.fail <| "Unkown Date: " ++ err
            Ok date ->
              Json.succeed <| date
      )


decodeUserList : Json.Decoder (List UserId)
decodeUserList =
    Json.list decodeUserId


decodeUserId : Json.Decoder UserId
decodeUserId =
    Json.string
