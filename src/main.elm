module VersionApp exposing (..)

import Time exposing (now, every)
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main =
  Browser.sandbox
    { init = init
    , view = view
    , update = update
    }

type alias Model = { version: String, meta: String}
    
type Msg 
    = Update 

update : Msg -> Model -> Model
update msg model =
    case msg of
        Update -> 
           { model | version = "jaadda" }

-- MODEL


init : Model 
init =
    Model "0.0" "Nothing"

  
view : Model -> Html Msg
view model = 
    div []
    [
        div  [][
            button  [onClick Update ] [text "Update"]
        ]
    ]


    -- div [] div [] [text (String.fromInt model ) ]
    --     , button [onClick Update] [ text "Get version" ]
    -- ]

--subscriptions : Model -> Msg
--subscriptions = 0
    