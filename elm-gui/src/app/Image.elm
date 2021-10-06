module Image exposing (Avatar, avatarToImg, avatarToSrc, decoder, guestAvatar)

import Api
import Html
import Html.Attributes
import Json.Decode as JD


type Avatar
    = Avatar String


avatarToSrc : Avatar -> Html.Attribute msg
avatarToSrc (Avatar src) =
    Html.Attributes.src <| Api.getApiUrl [ src ] []


avatarToImg : Avatar -> Html.Html msg
avatarToImg avatar =
    Html.img [ Html.Attributes.class "avatar-img", avatarToSrc avatar ] []


decoder : JD.Decoder Avatar
decoder =
    JD.string |> JD.map Avatar



-- AVATARS


guestAvatar : Avatar
guestAvatar =
    Avatar "avatars/guest-avatar-512.png"
