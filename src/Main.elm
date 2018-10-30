module Main exposing (..)

import Time exposing (now, every)
import Browser
import Html exposing (Html, button, div, text, h1, table, thead, tbody, tr, td, th)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Http exposing (get)
import Time
import Task
import Json.Decode exposing (Decoder, map2, field, int, string)

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


versionTypeDecoder : Decoder VersionJson 
versionTypeDecoder =
    map2 VersionJson 
        (field "version" string)
        (field "timestamp" string)

versionDecoder : Decoder String
versionDecoder = 
    field "version" string



-- New version
getVersionObject : Cmd Msg
getVersionObject = 
    Http.send NewResult (Http.get url versionTypeDecoder) 

-- Old version
-- getVersionString :  Cmd Msg
-- getVersionString =
--    Http.send NewResult (Http.get url versionDecoder) 

type alias VersionJson =
    {
        version: String
        , timestamp: String
    }

type alias Model = 
        { 
        version: String
        , text : String
        , meta: String  
        , timestamp: String
        , zone: Time.Zone
        , time: Time.Posix
        }
    
type Msg 
    = Update 
    | Reset
    | NewResult (Result Http.Error VersionJson)
    | Tick Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Update -> 
           ({ model | text = "Updating" }, getVersionObject)
        Tick newTime ->
            ({model | time = newTime, text = "Updating"}, getVersionObject)
        Reset -> 
            ({ model | zone = Time.utc, time =  (Time.millisToPosix 0) }, Cmd.none)
        NewResult result ->
            case result of
                Ok versionObject -> 
                    ({model | version = versionObject.version, timestamp = versionObject.timestamp, text = "Waiting"}, Cmd.none)
                Err errorMessage ->
                    ({model | version = "Failed to get version!" }, Cmd.none)



init :  () -> (Model, Cmd Msg) 
init _ =
    (Model "Version: N/A" "Initalizing" "Nothing" ""  Time.utc (Time.millisToPosix 0),  Cmd.none)

  
view : Model -> Html Msg
view model = 
    div  [classList[("container", True)]][
            h1 [][text "Version Application"]
    ,div [ class "row" ]
        [ table [ class "table table-striped"]
            [ thead []
                [ tr []
                    [ th [] [ text "Current version" ]                        
                    , th [] [ text "Updated @" ]
                    ]
                ]
            , tbody []
                [ tr []
                    [ td [] [ text model.version ]
                    , td [] [ text model.timestamp ]
                    ]
               -- , tr []
               --     [ td [ colspan 2, style "text-align"  "center" ] [ text model.text ]
               --    
               --     ]
                ]
            ]
        ]
        ,button  [onClick Update, type_ "button", classList[("btn", True), ("btn-danger", True)] ] [text "Force Update"]
        ,button [onClick Reset, type_ "button", classList[("btn", True), ("btn-primary", True)]] [text "Reset timer"]
    ]


    -- div [] div [] [text (String.fromInt model ) ]
    --     , button [onClick Update] [ text "Get version" ]
    -- ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick
    