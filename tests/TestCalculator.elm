module TestCalculator exposing (..)

import Calculator
import Expect as Expect
import Test exposing (..)


testCalculateDamage : Test
testCalculateDamage =
    describe "damage is calculated correctly"
        [ Test.test "0 on 0 attacks" <|
            let
                warscroll =
                    { attacks = 0, toHit = 1, toWound = 1, rend = 1, damage = 1 }

                unit =
                    { modelCount = 1, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 0.0 calculatedDamage
        , Test.test "0 on 0 toHit" <|
            let
                warscroll =
                    { attacks = 1, toHit = 0, toWound = 1, rend = 1, damage = 1 }

                unit =
                    { modelCount = 1, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 0.0 calculatedDamage
        , Test.test "0 on 0 toWound" <|
            let
                warscroll =
                    { attacks = 1, toHit = 1, toWound = 0, rend = 1, damage = 1 }

                unit =
                    { modelCount = 1, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 0.0 calculatedDamage
        , Test.test "0 on 0 damage" <|
            let
                warscroll =
                    { attacks = 1, toHit = 1, toWound = 1, rend = 1, damage = 0 }

                unit =
                    { modelCount = 1, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 0.0 calculatedDamage
        , Test.test "full damage on 100% chance to hit" <|
            let
                warscroll =
                    { attacks = 1, toHit = 1, toWound = 1, rend = 0, damage = 5 }

                unit =
                    { modelCount = 1, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 5 calculatedDamage
        , Test.test "attack count multiplies output damage" <|
            let
                warscroll =
                    { attacks = 2, toHit = 1, toWound = 1, rend = 0, damage = 5 }

                unit =
                    { modelCount = 1, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 10.0 calculatedDamage
        , Test.test "model count multiplies output damage" <|
            let
                warscroll =
                    { attacks = 2, toHit = 1, toWound = 1, rend = 0, damage = 5 }

                unit =
                    { modelCount = 2, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 20.0 calculatedDamage
        , Test.test "toHit changes attack output accordingly" <|
            let
                warscroll =
                    { attacks = 2, toHit = 4, toWound = 1, rend = 0, damage = 5 }

                unit =
                    { modelCount = 2, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 10.0 calculatedDamage
        , Test.test "toWound changes attack output accordingly" <|
            let
                warscroll =
                    { attacks = 2, toHit = 4, toWound = 4, rend = 0, damage = 5 }

                unit =
                    { modelCount = 2, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 0 enemyModifiers
            in
            \_ -> Expect.equal 5.0 calculatedDamage
        , Test.test "rend negates save" <|
            let
                warscroll =
                    { attacks = 2, toHit = 4, toWound = 4, rend = 1, damage = 5 }

                unit =
                    { modelCount = 2, warscroll = warscroll }

                enemyModifiers =
                    { ward = 0 }

                calculatedDamage =
                    Calculator.calculateDamage unit 6 enemyModifiers
            in
            \_ -> Expect.within (Expect.Absolute 0.01) 5.0 calculatedDamage
        , Test.test "ward lessens damage" <|
            let
                warscroll =
                    { attacks = 2, toHit = 4, toWound = 4, rend = 1, damage = 5 }

                unit =
                    { modelCount = 2, warscroll = warscroll }

                enemyModifiers =
                    { ward = 4 }

                calculatedDamage =
                    Calculator.calculateDamage unit 6 enemyModifiers
            in
            \_ -> Expect.within (Expect.Absolute 0.01) 2.5 calculatedDamage
        , Test.test "1+ ward removes damage" <|
            let
                warscroll =
                    { attacks = 2, toHit = 4, toWound = 4, rend = 1, damage = 5 }

                unit =
                    { modelCount = 2, warscroll = warscroll }

                enemyModifiers =
                    { ward = 1 }

                calculatedDamage =
                    Calculator.calculateDamage unit 6 enemyModifiers
            in
            \_ -> Expect.within (Expect.Absolute 0.01) 0.0 calculatedDamage
        ]
