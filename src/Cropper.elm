module Cropper
    exposing
        ( view
        , update
        , subscriptions
        , Model
        , Msg
        , init
        , zoom
        , pivotX
        , pivotY
        , crop
        , imageSize
        , cropOrigin
        )

{-| Elm Cropper

# Tea
@docs view, update, subscriptions

# Types
@docs Model, Msg

# Helpers
@docs init, zoom, pivotX, pivotY, crop, imageSize, cropOrigin
-}

import Html exposing (..)
import Cropper.Types as Types exposing (..)
import Cropper.Helper as Helper exposing (..)
import Cropper.View as View exposing (..)
import DOM
import Mouse exposing (Position)


{-| TODO: Doc
-}
type alias Model =
    Types.Model


{-| TODO: Doc
-}
type alias Msg =
    Types.Msg


{-| TODO: Doc
-}
view : Model -> Html Msg
view =
    View.view


{-| TODO: Doc
-}
init : { url : String, crop : { width : Int, height : Int } } -> Model
init { url, crop } =
    { url = url
    , crop = crop
    , image = Nothing
    , boundingClientRect = DOM.Rectangle 0 0 0 0
    , pivot = Vector 0.5 0.5
    , zoom = 0.0
    , drag = Nothing
    }


{-| TODO: Doc
-}
zoom : Model -> Float -> Model
zoom =
    Helper.zoom


{-| TODO: Doc
-}
pivotX : Model -> Float -> Model
pivotX =
    Helper.pivotX


{-| TODO: Doc
-}
pivotY : Model -> Float -> Model
pivotY =
    Helper.pivotY


{-| TODO: Doc
-}
crop : Model -> { width : Int, height : Int } -> Model
crop =
    Helper.crop


{-| TODO: Doc
-}
imageSize : Model -> Vector
imageSize model =
    case model.image of
        Nothing ->
            Vector 0 0

        Just image ->
            Helper.imageSize { image = image, crop = model.crop, zoom = model.zoom }


{-| TODO: Doc
-}
cropOrigin : Model -> Vector
cropOrigin model =
    case model.image of
        Nothing ->
            Vector 0 0

        Just image ->
            Helper.cropOrigin { image = image, crop = model.crop, pivot = model.pivot, zoom = model.zoom }



-- SUBSCRIPTIONS


{-| TODO: Doc
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]



-- UPDATE


{-| TODO: Doc
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ImageLoaded image ->
            ( crop { model | image = Just image } model.crop, Cmd.none )

        Measure rect ->
            ( { model | boundingClientRect = rect }, Cmd.none )

        Zoom zoom ->
            ( { model | zoom = zoom }, Cmd.none )

        DragStart xy ->
            ( { model | drag = (Just (Drag xy xy)) }, Cmd.none )

        DragEnd xy ->
            ( { model | pivot = getPivot model, drag = Nothing }, Cmd.none )

        DragAt xy ->
            let
                drag =
                    (Maybe.map (\{ start } -> Drag start xy) model.drag)
            in
                ( { model | drag = drag }, Cmd.none )



-- VIEW
