module Models exposing (..)


-- import Css
-- import Date exposing (Date)
-- import Html
-- import Html.Styled as Styled
-- import Html.Styled.Attributes as Attributes
-- import Task
-- import Uuid.Barebones as Uuid
-- import Html.Styled.Events as Events
-- import Json.Decode as Decode
-- import Mouse exposing (Position)
-- import Uuid.Barebones as Uuid


---- MODEL ----


type Firebase e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


type alias Work =
    { id : String
    , title : String
    , description : String
    -- , createTimestamp : Date
    }

type alias WorkList =
    { title : String
    , work : List (Work)
    }


type alias Model =
    { todo : WorkList
    , inProgress : WorkList
    , showAddWork : Bool
    }
