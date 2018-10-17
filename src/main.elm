module VersionApp exposing (..)

import Time exposing (now, every)
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http exposing (get)
import Time
import Task
import Json.Decode exposing (Decoder, field, int, string)

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


    -- MODEL

url : String
url = "http://localhost:5000"

versionDecoder : Decoder String
versionDecoder = 
    field "version" string

-- getVersionString :   Cmd Msg
-- getVersionString =
--     Http.send Update (Http.get url versionDecoder)

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
    