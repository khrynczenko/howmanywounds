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


viewFilter : String -> String -> String -> (Int -> Msg) -> Int -> Html Msg
viewFilter name description maxValue message magnitude =
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


viewForm : Model.Unit -> Html Msg
viewForm unit =
    div []
        [ h1 [] [ text "How Many Wounds" ]
        , div []
            [ form []
                [ viewFilter "models" "Models:" "100" (changeStat Models) unit.modelCount
                , viewFilter "attacks" "Attacks:" "6" (changeStat Attacks) unit.warscroll.attacks
                , viewFilter "toHit" "To hit:" "6" (changeStat ToHit) unit.warscroll.toHit
                , viewFilter "toWound" "To wound:" "6" (changeStat ToWound) unit.warscroll.toWound
                , viewFilter "rend" "Rend:" "6" (changeStat Rend) unit.warscroll.rend
                , viewFilter "damage" "Damage:" "10" (changeStat Damage) unit.warscroll.damage
                , br [] []
                ]
            ]
        ]


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
                , td [] [ formatDamage <| Calculator.calculateDamage model 2 ]
                ]
            , tr []
                [ td [] [ text "3+" ]
                , td [] [ formatDamage <| Calculator.calculateDamage model 3 ]
                ]
            , tr []
                [ td [] [ text "4+" ]
                , td [] [ formatDamage <| Calculator.calculateDamage model 4 ]
                ]
            , tr []
                [ td [] [ text "5+" ]
                , td [] [ formatDamage <| Calculator.calculateDamage model 5 ]
                ]
            , tr []
                [ td [] [ text "6+" ]
                , td [] [ formatDamage <| Calculator.calculateDamage model 6 ]
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

        partBeforeComma =
            case List.head splitted of
                Just value ->
                    value

                Nothing ->
                    "NOT POSSIBLE!"

        partAfterComma =
            case splitted |> List.reverse |> List.head of
                Just value ->
                    String.left digitsAfterComma value

                Nothing ->
                    ""
    in
    text <| padLeft partBeforeComma ++ "." ++ padRight partAfterComma
