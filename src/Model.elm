module Model exposing
    ( Damage
    , Model
    , Save
    , Unit
    , Warscroll
    , initialModel
    , setWarscroll
    , update
    )

import Message exposing (Msg, UnitFormChanged(..))


type alias Save =
    Int


type alias Damage =
    Int


type alias Unit =
    { modelCount : Int
    , warscroll : Warscroll
    }


setWarscroll : Model -> Warscroll -> Model
setWarscroll model warscroll =
    { model | warscroll = warscroll }


type alias Warscroll =
    { attacks : Int
    , toHit : Int
    , toWound : Int
    , rend : Int
    , damage : Int
    }


type alias Model =
    Unit


initialModel : Model
initialModel =
    { modelCount = 0
    , warscroll =
        { attacks = 0
        , toHit = 0
        , toWound = 0
        , rend = 0
        , damage = 0
        }
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        warscroll =
            model.warscroll
    in
    case msg of
        ModelCountChanged value ->
            ( { model | modelCount = value }, Cmd.none )

        AttacksChanged value ->
            ( setWarscroll model { warscroll | attacks = value }, Cmd.none )

        ToHitChanged value ->
            ( setWarscroll model { warscroll | toHit = value }, Cmd.none )

        ToWoundChanged value ->
            ( setWarscroll model { warscroll | toWound = value }, Cmd.none )

        RendChanged value ->
            ( setWarscroll model { warscroll | rend = value }, Cmd.none )

        DamageChanged value ->
            ( setWarscroll model { warscroll | damage = value }, Cmd.none )
