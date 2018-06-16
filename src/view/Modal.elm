module Modal exposing (modal)


import Css
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Messages exposing (Msg)


---- MODAL ----


modal : Bool -> Styled.Html Msg -> Styled.Html Msg
modal show content =
    case show of
        True ->
            Styled.div [ cssModal ] [ content ]
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
