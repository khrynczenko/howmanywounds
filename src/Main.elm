module Main exposing (main)

import Browser exposing (element)
import Html exposing (Html, br, div, form, h1, input, label, table, td, text, th, tr)
import Html.Attributes exposing (class, for, id, name, type_)
import Html.Events exposing (onInput)


type alias Save =
    Int


type alias Damage =
    Int


type alias Unit =
    { modelCount : Int
    , warscroll : Warscroll
    }


setWarscroll : Model -> Warscroll -> Model
setWarscroll model warscroll =
    { model | warscroll = warscroll }


convertStatToProbability : Int -> Float
convertStatToProbability stat =
    case stat of
        1 ->
            1.0

        2 ->
            0.84

        3 ->
            0.67

        4 ->
            0.5

        5 ->
            0.33

        6 ->
            0.17

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


type alias Warscroll =
    { attacks : Int
    , toHit : Int
    , toWound : Int
    , rend : Int
    , damage : Int
    }


type alias Model =
    Unit


type UnitStat
    = Models
    | Attacks
    | ToHit
    | ToWound
    | Rend
    | Damage


type UnitFormChanged
    = ModelCountChanged Int
    | AttacksChanged Int
    | ToHitChanged Int
    | ToWoundChanged Int
    | RendChanged Int
    | DamageChanged Int


changeStat : UnitStat -> String -> UnitFormChanged
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


type alias Msg =
    UnitFormChanged


initialModel : Model
initialModel =
    { modelCount = 0
    , warscroll =
        { attacks = 0
        , toHit = 0
        , toWound = 0
        , rend =
            0
        , damage = 0
        }
    }


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
                , td [] [ text <| String.fromFloat <| calculateDamage model 2 ]
                ]
            , tr []
                [ td [] [ text "3+" ]
                , td [] [ text <| String.fromFloat <| calculateDamage model 3 ]
                ]
            , tr []
                [ td [] [ text "4+" ]
                , td [] [ text <| String.fromFloat <| calculateDamage model 4 ]
                ]
            , tr []
                [ td [] [ text "5+" ]
                , td [] [ text <| String.fromFloat <| calculateDamage model 5 ]
                ]
            , tr []
                [ td [] [ text "6+" ]
                , td [] [ text <| String.fromFloat <| calculateDamage model 6 ]
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        warscroll =
            model.warscroll
    in
    case msg of
        ModelCountChanged value ->
            ( { model | modelCount = value }, Cmd.none )

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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
