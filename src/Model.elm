module Model exposing
    ( Damage
    , EnemyModifiers
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


type alias EnemyModifiers =
    { ward : Int
    , elmAnalyzeBullshit : ()
    }


setEnemyModifiers : Model -> EnemyModifiers -> Model
setEnemyModifiers model newModifiers =
    { model | enemyModifiers = newModifiers }


setWarscroll : Model -> Warscroll -> Model
setWarscroll model warscroll =
    let
        unit =
            model.unit

        newUnit =
            { unit | warscroll = warscroll }
    in
    { model | unit = newUnit }


type alias Warscroll =
    { attacks : Int
    , toHit : Int
    , toWound : Int
    , rend : Int
    , damage : Int
    }


type alias Model =
    { unit : Unit
    , enemyModifiers : EnemyModifiers
    , wardEnabled : Bool
    }


initialModel : Model
initialModel =
    { unit =
        { modelCount = 0
        , warscroll =
            { attacks = 0
            , toHit = 0
            , toWound = 0
            , rend = 0
            , damage = 0
            }
        }
    , enemyModifiers = { ward = 0, elmAnalyzeBullshit = () }
    , wardEnabled = False
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        warscroll =
            model.unit.warscroll

        unit =
            model.unit
    in
    case msg of
        ModelCountChanged value ->
            ( { model | unit = { unit | modelCount = value } }, Cmd.none )

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

        WardChanged value ->
            ( setEnemyModifiers model { ward = value, elmAnalyzeBullshit = () }, Cmd.none )

        WardSwitched state ->
            let
                withZeroWard =
                    setEnemyModifiers model { ward = 0, elmAnalyzeBullshit = () }
            in
            ( { withZeroWard | wardEnabled = state }, Cmd.none )
