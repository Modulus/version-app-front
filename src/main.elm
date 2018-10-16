module VersionApp exposing (..)

import Time exposing (now, every)
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http exposing (get)

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

type alias Model = { version: String, meta: String}
    
type Msg 
    = Update 

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Update -> 
           ({ model | version = "jaadda" }, Cmd.none)

-- MODEL

url : String
url = "http://localhost:5000"

init :  () -> (Model, Cmd Msg) 
init _ =
    (Model "0.0" "Nothing", Cmd.none)

  
view : Model -> Html Msg
view model = 

    div  [][
             div [][ text model.version ] 
            ,button  [onClick Update ] [text "Update"]
    ]


    -- div [] div [] [text (String.fromInt model ) ]
    --     , button [onClick Update] [ text "Get version" ]
    -- ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
    