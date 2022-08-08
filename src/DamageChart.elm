module DamageChart exposing (makeChart)

import Calculator
import Chart as C
import Chart.Attributes as CA
import Html exposing (Html)
import Message exposing (Msg, UnitFormChanged(..))
import Model exposing (Model)
import Svg as S


makeChart : Model -> Html Msg
makeChart model =
    let
        saves =
            [ 2, 3, 4, 5, 6 ]

        calculate =
            \s -> Calculator.calculateDamage model.unit s { ward = 0, elmAnalyzeBullshit = () }

        damages : List Float
        damages =
            List.map calculate saves

        xsys : List ( Float, Float )
        xsys =
            List.map2 (\s d -> Tuple.pair s d) saves damages

        chartData =
            List.map (\( s, d ) -> { x = s, y = d }) xsys
    in
    C.chart
        []
        [ C.xLabels []
        , C.yLabels [ CA.withGrid ]
        , C.xAxis []
        , C.xTicks []
        , C.yAxis []
        , C.yTicks []
        , C.series .x
            [ C.interpolated .y [] []
            ]
            chartData
        , C.labelAt .min
            CA.middle
            [ CA.moveLeft 35, CA.rotate 90 ]
            [ S.text "Damage" ]
        , C.labelAt CA.middle
            .min
            [ CA.moveDown 30 ]
            [ S.text "Save" ]
        ]
