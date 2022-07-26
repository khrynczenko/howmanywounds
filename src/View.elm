module View exposing (view)

import Calculator
import Html exposing (Html, br, div, form, h1, input, label, table, td, text, th, tr)
import Html.Attributes exposing (class, for, id, name, type_)
import Html.Events exposing (onInput)
import Message exposing (Msg, UnitFormChanged(..))
import Model exposing (Model)


type UnitStat
    = Models
    | Attacks
    | ToHit
    | ToWound
    | Rend
    | Damage


changeStat : UnitStat -> String -> Msg
changeStat stat formText =
    case stat of
        Models ->
            ModelCountChanged (Maybe.withDefault 0 (String.toInt formText))

        Attacks ->
            AttacksChanged (Maybe.withDefault 0 (String.toInt formText))

        ToHit ->
            ToHitChanged (Maybe.withDefault 0 <| String.toInt formText)

        ToWound ->
            ToWoundChanged (Maybe.withDefault 0 <| String.toInt formText)

        Rend ->
            RendChanged (Maybe.withDefault 0 <| String.toInt formText)

        Damage ->
            DamageChanged (Maybe.withDefault 0 <| String.toInt formText)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ viewForm, viewDamageTable model ]


viewForm : Html Msg
viewForm =
    div []
        [ h1 [] [ text "How Many Wounds" ]
        , div []
            [ form []
                [ label [ for "models" ] [ text "Models:", br [] [] ]
                , input
                    [ type_ "number"
                    , id "models"
                    , name "models"
                    , onInput
                        (changeStat Models)
                    ]
                    []
                , br [] []
                , label [ for "attacks" ] [ text "Attacks:", br [] [] ]
                , input
                    [ type_ "number"
                    , id "attacks"
                    , name "attacks"
                    , onInput
                        (changeStat Attacks)
                    ]
                    []
                , br [] []
                , label [ for "toHit" ] [ text "To hit:", br [] [] ]
                , input
                    [ type_ "number"
                    , id "toHit"
                    , name "toHit"
                    , onInput
                        (changeStat ToHit)
                    ]
                    []
                , br [] []
                , label [ for "toWound" ] [ text "To wound:", br [] [] ]
                , input
                    [ type_ "number"
                    , id "toWound"
                    , name "toWound"
                    , onInput
                        (changeStat ToWound)
                    ]
                    []
                , br [] []
                , label [ for "rend" ] [ text "Rend:", br [] [] ]
                , input
                    [ type_ "number"
                    , id "rend"
                    , name "rend"
                    , onInput
                        (changeStat Rend)
                    ]
                    []
                , br [] []
                , label [ for "damage" ] [ text "Damage:", br [] [] ]
                , input [ type_ "number", id "damage", name "damage", onInput (changeStat Damage) ] []
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
                , td [] [ text <| String.fromFloat <| Calculator.calculateDamage model 2 ]
                ]
            , tr []
                [ td [] [ text "3+" ]
                , td [] [ text <| String.fromFloat <| Calculator.calculateDamage model 3 ]
                ]
            , tr []
                [ td [] [ text "4+" ]
                , td [] [ text <| String.fromFloat <| Calculator.calculateDamage model 4 ]
                ]
            , tr []
                [ td [] [ text "5+" ]
                , td [] [ text <| String.fromFloat <| Calculator.calculateDamage model 5 ]
                ]
            , tr []
                [ td [] [ text "6+" ]
                , td [] [ text <| String.fromFloat <| Calculator.calculateDamage model 6 ]
                ]
            ]
        ]
