module Message exposing (Msg, UnitFormChanged(..))


type UnitFormChanged
    = ModelCountChanged Int
    | AttacksChanged Int
    | ToHitChanged Int
    | ToWoundChanged Int
    | RendChanged Int
    | DamageChanged Int
    | WardSwitched Bool
    | WardChanged Int


type alias Msg =
    UnitFormChanged
