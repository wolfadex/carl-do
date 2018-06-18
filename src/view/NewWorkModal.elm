module NewWorkModal exposing (newWorkModel)


import Css
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Messages exposing (..)
import Modal exposing (modal)
import Models exposing (..)


---- NEW WORK MODAL ----


newWorkModel : Bool -> NewWork -> Styled.Html Msg
newWorkModel show work =
    modal show (addWork work)


addWork : NewWork -> Styled.Html Msg
addWork newWork =
    Styled.div [ cssAddWork ]
               [ Styled.text "New Todo"
               , inputLabel "Title"
                  <| textInput newWork.title (\change ->  UpdateNewWork ({ newWork | title = change }))
               , inputLabel "Description"
                  <| textArea newWork.description (\change ->  UpdateNewWork ({ newWork | description = change }))
               , addWorkOk
               ]


cssAddWork : Styled.Attribute msg
cssAddWork =
    Attributes.css [ Css.backgroundColor (Css.rgb 255 255 255)
                   , Css.displayFlex
                   , Css.flexDirection Css.column
                   , Css.padding (Css.rem 1)
                   ]

addWorkOk : Styled.Html Msg
addWorkOk =
    Styled.button [ Events.onClick FirebaseAddWork ]
                  [ Styled.text "Add" ]


inputLabel : String -> Styled.Html msg -> Styled.Html msg
inputLabel label input =
    Styled.label [ cssInputLabel ]
                 [ Styled.text label
                 , input
                 ]


cssInputLabel : Styled.Attribute msg
cssInputLabel =
    Attributes.css [ Css.displayFlex
                   , Css.flexDirection Css.column
                   , Css.marginTop (Css.rem 1)
                   ]


textInput : String -> (String -> msg) -> Styled.Html msg
textInput value onChange =
    Styled.input [ Attributes.value value
                 , Events.onInput onChange
                 ]
                 []


textArea : String -> (String -> msg) -> Styled.Html msg
textArea value onChange =
    Styled.textarea [ Attributes.value value
                    , Events.onInput onChange
                    ]
                    []
