module View exposing (view)


import Css
import Date.Extra.Compare as DateCompare
import Header exposing (header)
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Messages exposing (..)
import NewWorkModal exposing (newWorkModel)
import Models exposing (..)


---- VIEW ----


view : Model -> Styled.Html Msg
view { user, allWork, showAddWork, newWork } =
    Styled.div [ cssView ]
               [ header user
               , body allWork
               , newWorkModel showAddWork newWork
               ]


cssView : Styled.Attribute msg
cssView =
    Attributes.css [ Css.displayFlex
                   , Css.flexDirection Css.column
                   , Css.alignItems Css.center
                   , Css.position Css.absolute
                   , Css.left (Css.px 0)
                   , Css.right (Css.px 0)
                   , Css.top (Css.px 0)
                   , Css.bottom (Css.px 0)
                   ]


body : List Work -> Styled.Html Msg
body work =
    let
      todo = getWorkByStatus work ToDo
      inProgress = getWorkByStatus work InProgress
      done = getWorkByStatus work Done
    in
      Styled.div [ cssBody ]
                 [ workColumn (List.sortWith sortDateOldest todo) "ToDo"
                 , workColumn (List.sortWith sortDateOldest inProgress) "In Progress"
                 , workColumn (List.sortWith sortDateNewest done) "Done"
                 ]


getWorkByStatus : List Work -> WorkStatus -> (List Work)
getWorkByStatus list filterStatus =
    List.filter (\{ status } -> status == filterStatus) list


sortDateNewest : Work -> Work -> Order
sortDateNewest a b =
    if DateCompare.is DateCompare.After a.createTimestamp b.createTimestamp then
        LT
    else
        GT


sortDateOldest : Work -> Work -> Order
sortDateOldest a b =
    if DateCompare.is DateCompare.After a.createTimestamp b.createTimestamp then
        GT
    else
        LT

cssBody : Styled.Attribute msg
cssBody =
    Attributes.css [ Css.displayFlex
                   , Css.flex (Css.num 1)
                   ]


workColumn : List Work -> String -> Styled.Html Msg
workColumn work title =
    Styled.div [ cssWorkColumn ]
               [ workColumnHeader title
               , workList work
               ]


cssWorkColumn : Styled.Attribute msg
cssWorkColumn =
    Attributes.css [ Css.margin (Css.rem 1)
                   , Css.backgroundColor (Css.rgb 190 190 190)
                   ]


workColumnHeader : String -> Styled.Html Msg
workColumnHeader title =
    Styled.div [ cssWorkColumnHeader ]
               [ workColumnTitle title
               , addWorkButton
               ]


cssWorkColumnHeader : Styled.Attribute msg
cssWorkColumnHeader =
    Attributes.css [ Css.width (Css.rem 20)
                   , Css.height (Css.rem 2)
                   , Css.fontSize (Css.rem 1.3)
                   , Css.displayFlex
                   , Css.justifyContent Css.flexStart
                   , Css.borderBottom2 (Css.rem 0.1) Css.solid
                   , Css.padding (Css.rem 0.5)
                   ]


workColumnTitle : String -> Styled.Html Msg
workColumnTitle title =
    Styled.div [ cssWorkColumnTitle ]
               [ Styled.text title ]


cssWorkColumnTitle : Styled.Attribute msg
cssWorkColumnTitle =
    Attributes.css [ Css.flex (Css.num 1)
                   , Css.displayFlex
                   , Css.alignItems Css.center
                   ]


addWorkButton : Styled.Html Msg
addWorkButton =
    Styled.button [ cssAddWorkButton
                  , Events.onClick (ShowAddWork True)
                  ]
                  [ Styled.text "Add Work" ]


cssAddWorkButton : Styled.Attribute msg
cssAddWorkButton =
    Attributes.css [ Css.cursor Css.pointer
                   ]


workList : List (Work) -> Styled.Html Msg
workList work =
    Styled.ul [ cssWorkList
              -- , Attributes.dropzone ""
              ]
              <| List.map workItem work


cssWorkList : Styled.Attribute msg
cssWorkList =
    Attributes.css [ Css.flex (Css.num 1)
                   ]


workItem : Work -> Styled.Html Msg
workItem { title, description } =
    Styled.li [ cssWorkItem
              -- , Events.on "mousedown" (Decode.map DragStart Mouse.position)
              ]
              [ Styled.div [ cssWorkItemTitle ] [ Styled.text title ]
              , Styled.div [] [ Styled.text description ]
              ]

cssWorkItem : Styled.Attribute msg
cssWorkItem =
    Attributes.css [ Css.backgroundColor (Css.rgb 230 230 230)
                   , Css.margin (Css.rem 1)
                   , Css.padding (Css.rem 1)
                   , Css.displayFlex
                   , Css.flexDirection Css.column
                   , Css.cursor Css.move
                   ]


cssWorkItemTitle : Styled.Attribute msg
cssWorkItemTitle =
    Attributes.css []
