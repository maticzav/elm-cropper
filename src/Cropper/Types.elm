module Cropper.Types exposing (..)

import DOM
import Mouse exposing (Position)
import SingleTouch exposing (SingleTouch)
import Json.Decode exposing (Decoder)


type alias Drag =
    { start : Position
    , current : Position
    }


type Msg
    = ImageLoaded Image
    | Measure DOM.Rectangle
    | Zoom Float
    | DragStart Position
    | DragAt Position
    | DragEnd Position
    | OnTouchStart SingleTouch
    | OnTouchMove SingleTouch
    | OnTouchEnd SingleTouch


type alias Model =
    { url : String
    , crop : Rect
    , image : Maybe Image
    , boundingClientRect : DOM.Rectangle
    , pivot : Vector
    , zoom : Float
    , drag : Maybe Drag
    }


type alias Vector =
    { x : Float
    , y : Float
    }


type alias Rect =
    { width : Int
    , height : Int
    }


type alias Image =
    { src : String
    , width : Int
    , height : Int
    }


decodeImage : Json.Decode.Decoder Image
decodeImage =
    Json.Decode.map3 Image
        (Json.Decode.at [ "target", "src" ] Json.Decode.string)
        (Json.Decode.at [ "target", "width" ] Json.Decode.int)
        (Json.Decode.at [ "target", "height" ] Json.Decode.int)


type alias Point =
    { x : Int
    , y : Int
    }


type alias ImageData =
    { url : String
    , crop : Rect
    }


type alias CropData =
    { url : String
    , size : Rect
    , crop : Rect
    , resized : Rect
    , origin : Point
    }
