module Update exposing (..)


import Messages exposing (..)
import Models exposing (..)


---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        FirebaseResponse value ->
            ( model, Cmd.none )
        ShowAddWork yesNo ->
            ( { model | showAddWork = yesNo }, Cmd.none )
        WorkMoved work ->
            ( model, Cmd.none )
        FirebaseAuth a ->
            ( model, Cmd.none )
        -- DragStart position ->
        --     ( model, Cmd.none )
