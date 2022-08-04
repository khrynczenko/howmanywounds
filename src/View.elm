module View exposing (view)

import Calculator
import Html as Html exposing (Attribute, Html)
import Html.Attributes as Attr exposing (class, for)
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode
import Message exposing (Msg, UnitFormChanged(..))
import Model exposing (Model)


digitsAfterComma : Int
digitsAfterComma =
    2


onSlide : (Int -> msg) -> Attribute msg
onSlide toMsg =
    Decode.at [ "detail", "userSlidTo" ] Decode.int
        |> Decode.map toMsg
        |> on "slide"


viewRangeSlider : List (Attribute msg) -> List (Html msg) -> Html msg
viewRangeSlider attributes children =
    Html.node "range-slider" attributes children


viewSlider : String -> String -> String -> (Int -> Msg) -> Int -> Html Msg
viewSlider name description maxValue message magnitude =
    Html.div [ Attr.class "field" ]
        [ Html.label [ for name, Attr.class "label" ] [ Html.text description ]
        , Html.div [ class "control" ]
            [ viewRangeSlider
                [ Attr.max maxValue
                , Attr.property "val" (Encode.int magnitude)
                , onSlide message
                ]
                []
            ]
        ]


view : Model -> Html Msg
view model =
    Html.section [ class "section" ]
        [ Html.div [ class "container" ]
            [ Html.h1 [ class "title" ] [ Html.text "How many wounds" ]
            , Html.div [ class "columns" ]
                [ Html.div [ class "column is-half" ]
                    [ viewForm model
                    ]
                , Html.div [ class "column" ]
                    [ viewDamageTable model
                    ]
                ]
            ]
        ]


viewForm : Model -> Html Msg
viewForm model =
    Html.div []
        [ Html.div []
            [ Html.form []
                [ viewSlider "models"
                    "Models:"
                    "100"
                    ModelCountChanged
                    model.unit.modelCount
                , viewSlider "attacks"
                    "Attacks:"
                    "6"
                    AttacksChanged
                    model.unit.warscroll.attacks
                , viewSlider "toHit"
                    "To hit:"
                    "6"
                    ToHitChanged
                    model.unit.warscroll.toHit
                , viewSlider "toWound"
                    "To wound:"
                    "6"
                    ToWoundChanged
                    model.unit.warscroll.toWound
                , viewSlider "rend" "Rend:" "6" RendChanged model.unit.warscroll.rend
                , viewSlider "damage"
                    "Damage:"
                    "10"
                    DamageChanged
                    model.unit.warscroll.damage
                , Html.br [] []
                , viewEnemyOptionsForm model
                ]
            ]
        ]


viewEnemyOptionsForm : Model -> Html Msg
viewEnemyOptionsForm model =
    let
        wardSlider =
            viewSlider "enemyWard"
                "Ward:"
                "6"
                WardChanged
                model.enemyModifiers.ward

        wardOption =
            Html.div []
                [ Html.label [ for "wardOption" ] [ Html.text "Enable ward?" ]
                , Html.input
                    [ Html.Events.onCheck WardSwitched
                    , Attr.id
                        "wardOption"
                    , Attr.type_ "checkbox"
                    ]
                    []
                ]

        wardPair =
            if model.wardEnabled then
                Html.div [ class "filter-slider" ]
                    [ wardOption
                    , wardSlider
                    ]

            else
                Html.div [ class "filter-slider" ] [ wardOption ]
    in
    wardPair


viewDamageTable : Model -> Html Msg
viewDamageTable model =
    Html.div []
        [ Html.table []
            [ Html.tr []
                [ Html.th [] [ Html.text "Save" ]
                , Html.th [] [ Html.text "Damage" ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "2+" ]
                , Html.td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            2
                            model.enemyModifiers
                    ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "3+" ]
                , Html.td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            3
                            model.enemyModifiers
                    ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "4+" ]
                , Html.td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            4
                            model.enemyModifiers
                    ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "5+" ]
                , Html.td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            5
                            model.enemyModifiers
                    ]
                ]
            , Html.tr []
                [ Html.td [] [ Html.text "6+" ]
                , Html.td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            6
                            model.enemyModifiers
                    ]
                ]
            ]
        ]


formatDamage : Float -> Html Msg
formatDamage damage =
    let
        padLeft =
            String.padLeft digitsAfterComma '0'

        padRight =
            String.padRight digitsAfterComma '0'

        splitted =
            String.split "." <| String.fromFloat damage

        tail =
            List.tail splitted

        partBeforeComma =
            case List.head splitted of
                Just value ->
                    value

                Nothing ->
                    "NOT POSSIBLE!"

        partAfterComma =
            case tail of
                Just (value :: _) ->
                    String.left digitsAfterComma value

                Just [] ->
                    ""

                Nothing ->
                    ""
    in
    Html.text <| padLeft partBeforeComma ++ "." ++ padRight partAfterComma
