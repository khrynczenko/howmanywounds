module Message exposing (Msg, UnitFormChanged(..))


type UnitFormChanged
    = ModelCountChanged Int
    | AttacksChanged Int
    | ToHitChanged Int
    | ToWoundChanged Int
    | RendChanged Int
    | DamageChanged Int


type alias Msg =
    UnitFormChanged
