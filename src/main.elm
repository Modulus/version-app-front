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

getVersionString :  Cmd Msg
getVersionString =
    Http.send NewResult (Http.get url versionDecoder) 

type alias Model = 
        { 
        version: String
        , text : String
        , meta: String  
        , zone: Time.Zone
        , time: Time.Posix
        }
    
type Msg 
    = Update 
    | Reset
    | NewResult (Result Http.Error String)
    | Tick Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Update -> 
           ({ model | text = "Updating" }, getVersionString)
        Tick newTime ->
            ({model | time = newTime, text = "Updating"}, getVersionString)
        Reset -> 
            ({ model | zone = Time.utc, time =  (Time.millisToPosix 0) }, Cmd.none)
        NewResult result ->
            case result of
                Ok versionString -> 
                    ({model | version = versionString, text = "Waiting"}, Cmd.none)
                Err errorMessage ->
                    ({model | version = "Failed to get version!" }, Cmd.none)



init :  () -> (Model, Cmd Msg) 
init _ =
    (Model "Version: N/A" "Initalizing" "Nothing"  Time.utc (Time.millisToPosix 0),  Cmd.none)

  
view : Model -> Html Msg
view model = 

    div  [][
            -- div [ ][ text (String.fromInt ( Time.toSecond model.zone model.time)) ] 
            div [][ text model.version ] 
            ,button  [onClick Update ] [text "Force"]
            ,button [onClick Reset] [text "Reset"]
            ,div [][ text model.text ] 
    ]


    -- div [] div [] [text (String.fromInt model ) ]
    --     , button [onClick Update] [ text "Get version" ]
    -- ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick
    