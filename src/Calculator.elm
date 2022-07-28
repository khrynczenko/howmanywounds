module Calculator exposing (calculateDamage)

import Model exposing (Save, Unit)


convertStatToProbability : Int -> Float
convertStatToProbability stat =
    case stat of
        1 ->
            1.0

        2 ->
            0.8333

        3 ->
            0.6666

        4 ->
            0.5

        5 ->
            0.3333

        6 ->
            0.1666

        _ ->
            0.0


calculateDamage : Unit -> Save -> Float
calculateDamage unit enemySave =
    let
        attacks =
            toFloat unit.warscroll.attacks

        toHit =
            convertStatToProbability unit.warscroll.toHit

        toWound =
            convertStatToProbability unit.warscroll.toWound

        rend =
            unit.warscroll.rend

        damage =
            toFloat unit.warscroll.damage

        enemySaveProb =
            convertStatToProbability (enemySave + rend)
    in
    toFloat unit.modelCount * attacks * ((toHit * toWound * damage) * (1 - enemySaveProb))
