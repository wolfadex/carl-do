module Header exposing (header)


import Css
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Messages exposing (..)
import Models exposing (..)


---- HEADER ----


header : UserAuth -> Styled.Html Msg
header user =
    Styled.div [ cssHeader ]
               [ Styled.text "Carl is here to \"help\": "
               , userStateEl user
               ]


cssHeader : Styled.Attribute msg
cssHeader =
    Attributes.css [ Css.height (Css.rem 4)
                   , Css.fontSize (Css.rem 2)
                   , Css.borderBottom3 (Css.rem 0.2) Css.solid (Css.rgb 0 0 0)
                   , Css.width (Css.vw 100)
                   , Css.textAlign Css.center
                   ]


userStateEl : UserAuth -> Styled.Html Msg
userStateEl user =
   case user of
      SignedOut ->
          signInButton
      SignedIn { displayName } ->
          signOutButton displayName
      SigningIn ->
          Styled.text "User Loading . . ."
      SignInFailed string ->
          Styled.text <| "User Error: " ++ string


signInButton : Styled.Html Msg
signInButton =
   Styled.button [ Events.onClick (FirebaseAuthentication "google") ]
                 [ Styled.text "Sign In" ]


signOutButton : String -> Styled.Html Msg
signOutButton displayName =
   Styled.button [ Events.onClick FirebaseUnauthenticate ]
                 [ Styled.text <| "Sign Out " ++ displayName ]
