module View exposing (view)

import Calculator
import Html as Html exposing (Attribute, Html, br, div, form, h1, label, table, td, text, th, tr)
import Html.Attributes as Attr exposing (class, for)
import Html.Events exposing (on)
import Json.Decode as Decode
import Json.Encode as Encode
import Message exposing (Msg, UnitFormChanged(..))
import Model exposing (Model)


type UnitStat
    = Models
    | Attacks
    | ToHit
    | ToWound
    | Rend
    | Damage


digitsAfterComma : Int
digitsAfterComma =
    2


changeStat : UnitStat -> Int -> Msg
changeStat stat value =
    case stat of
        Models ->
            ModelCountChanged value

        Attacks ->
            AttacksChanged value

        ToHit ->
            ToHitChanged value

        ToWound ->
            ToWoundChanged value

        Rend ->
            RendChanged value

        Damage ->
            DamageChanged value


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
    div [ class "filter-slider" ]
        [ label [ for name ] [ text description ]
        , viewRangeSlider
            [ Attr.max maxValue
            , Attr.property "val" (Encode.int magnitude)
            , onSlide message
            ]
            []
        ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ viewForm model, viewDamageTable model ]


viewForm : Model -> Html Msg
viewForm model =
    div []
        [ h1 [] [ text "How Many Wounds" ]
        , div []
            [ form []
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
                , viewSlider "rend" "Rend:" "6" (changeStat Rend) model.unit.warscroll.rend
                , viewSlider "damage"
                    "Damage:"
                    "10"
                    DamageChanged
                    model.unit.warscroll.damage
                , br [] []
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
            div []
                [ label [ for "wardOption" ] [ text "Enable ward?" ]
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
                div [ class "filter-slider" ]
                    [ wardOption
                    , wardSlider
                    ]

            else
                div [ class "filter-slider" ] [ wardOption ]
    in
    wardPair


viewDamageTable : Model -> Html Msg
viewDamageTable model =
    div []
        [ table []
            [ tr []
                [ th [] [ text "Save" ]
                , th [] [ text "Damage" ]
                ]
            , tr []
                [ td [] [ text "2+" ]
                , td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            2
                            model.enemyModifiers
                    ]
                ]
            , tr []
                [ td [] [ text "3+" ]
                , td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            3
                            model.enemyModifiers
                    ]
                ]
            , tr []
                [ td [] [ text "4+" ]
                , td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            4
                            model.enemyModifiers
                    ]
                ]
            , tr []
                [ td [] [ text "5+" ]
                , td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            5
                            model.enemyModifiers
                    ]
                ]
            , tr []
                [ td [] [ text "6+" ]
                , td []
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
    text <| padLeft partBeforeComma ++ "." ++ padRight partAfterComma
