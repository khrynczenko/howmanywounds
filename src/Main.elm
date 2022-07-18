module Main exposing (main)

import Html exposing (Html, br, button, div, form, h1, input, label, text)
import Html.Attributes exposing (class, for, id, name, type_)
import Html.Events exposing (onClick, onInput)


type alias WarscrollStats =
    { attacks : Int
    , toHit : Int
    , toWound : Int
    , rend : Int
    , damage : Int
    }


type alias Model =
    WarscrollStats


type Stat
    = Attacks
    | ToHit
    | ToWound
    | Rend
    | Damage


type WarscrollFormChanged
    = AttacksChanged Int
    | ToHitChanged Int
    | ToWoundChanged Int
    | RendChanged Int
    | DamageChanged Int


changeStat : Stat -> String -> WarscrollFormChanged
changeStat stat formText =
    case stat of
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
    WarscrollFormChanged


initialModel : WarscrollStats
initialModel =
    { attacks = 0, toHit = 0, toWound = 0, rend = 0, damage = 0 }


view : Model -> Html Msg
view _ =
    div [ class "content" ]
        [ h1 [] [ text "How Many Wounds" ]
        , div []
            [ form []
                [ label [ for "attacks" ] [ text "Attacks:", br [] [] ]
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


main : Html Msg
main =
    view initialModel
