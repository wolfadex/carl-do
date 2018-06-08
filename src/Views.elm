module Views exposing (view)


import Css
-- import Date exposing (Date)
-- import Html
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
-- import Task
import Html.Styled.Events as Events
-- import Json.Decode as Decode
-- import Mouse exposing (Position)
-- import Uuid.Barebones as Uuid


import Messages exposing (..)
import Models exposing (..)


---- VIEW ----


view : Model -> Styled.Html Msg
view model =
    Styled.div [ cssView ]
               [ header
               , body model
               , modal model.showAddWork (addWork model)
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


modal : Bool -> Styled.Html Msg -> Styled.Html Msg
modal show content =
    case show of
        True ->
            Styled.div [ cssModal ]
                       [ content ]
        False ->
            Styled.text ""


cssModal : Styled.Attribute msg
cssModal =
    Attributes.css [ Css.position Css.absolute
                   , Css.left (Css.px 0)
                   , Css.right (Css.px 0)
                   , Css.top (Css.px 0)
                   , Css.bottom (Css.px 0)
                   , Css.backgroundColor (Css.rgba 140 140 140 0.75)
                   , Css.displayFlex
                   , Css.alignItems Css.center
                   , Css.justifyContent Css.center
                   ]


addWork : Model -> Styled.Html Msg
addWork model =
    Styled.div [ cssAddWork ]
               [ Styled.text "Carl" ]


cssAddWork : Styled.Attribute msg
cssAddWork =
    Attributes.css [ Css.backgroundColor (Css.rgb 255 255 255) ]


header : Styled.Html Msg
header =
    Styled.div [ cssHeader ]
               [ Styled.text "Carl is here to \"help\"!" ]


body : Model -> Styled.Html Msg
body model =
    Styled.div [ cssBody ]
               [ workColumn model.todo
               , workColumn model.inProgress
               ]


cssBody : Styled.Attribute msg
cssBody =
    Attributes.css [ Css.displayFlex
                   , Css.flex (Css.num 1)
                   ]


cssHeader : Styled.Attribute msg
cssHeader =
    Attributes.css [ Css.height (Css.rem 4)
                   , Css.fontSize (Css.rem 2)
                   , Css.borderBottom3 (Css.rem 0.2) Css.solid (Css.rgb 0 0 0)
                   , Css.width (Css.vw 100)
                   , Css.textAlign Css.center
                   ]


workColumn : WorkList -> Styled.Html Msg
workColumn { work, title } =
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
