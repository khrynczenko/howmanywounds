module Main exposing (main)

import Browser exposing (element)
import Message exposing (Msg, UnitFormChanged(..))
import Model exposing (Model)
import View


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    element
        { init = \_ -> ( Model.initialModel, Cmd.none )
        , view = View.view
        , update = Model.update
        , subscriptions = subscriptions
        }
