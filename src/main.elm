module VersionApp exposing (..)

import Time exposing (now, every)
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http exposing (get)
import Time
import Task

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

type alias Model = 
        { 
        version: String
        , meta: String  
        , zone: Time.Zone
        , time: Time.Posix
        }
    
type Msg 
    = Update 
    | Reset
    | Tick Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Update -> 
           ({ model | version = "jaadda" }, Cmd.none)
        Tick newTime ->
            ({model | time = newTime }, Cmd.none)
        Reset -> 
            ({ model | zone = Time.utc, time =  (Time.millisToPosix 0) }, Cmd.none)

-- MODEL

url : String
url = "http://localhost:5000"

init :  () -> (Model, Cmd Msg) 
init _ =
    (Model "Version: N/A" "Nothing" Time.utc (Time.millisToPosix 0),  Cmd.none)

  
view : Model -> Html Msg
view model = 

    div  [][
            div [][ text (String.fromInt ( Time.toSecond model.zone model.time)) ] 
            ,div [][ text model.version ] 
            ,button  [onClick Update ] [text "Update"]
            ,button [onClick Reset] [text "Reset"]
    ]


    -- div [] div [] [text (String.fromInt model ) ]
    --     , button [onClick Update] [ text "Get version" ]
    -- ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick
    