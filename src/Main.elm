module Main exposing (main)

import Browser exposing (element)
import Html exposing (Html, br, button, div, form, h1, input, label, table, td, text, th, tr)
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
view model =
    div [ class "content" ]
        [ viewForm, viewDamageTable model ]


viewForm : Html Msg
viewForm =
    div []
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
                , td [] [ text <| String.fromInt model.damage ]
                ]
            , tr []
                [ td [] [ text "3+" ]
                , td [] [ text <| String.fromInt model.damage ]
                ]
            , tr []
                [ td [] [ text "4+" ]
                , td [] [ text <| String.fromInt model.damage ]
                ]
            , tr []
                [ td [] [ text "5+" ]
                , td [] [ text <| String.fromInt model.damage ]
                ]
            , tr []
                [ td [] [ text "6+" ]
                , td [] [ text <| String.fromInt model.damage ]
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AttacksChanged value ->
            ( { model | attacks = value }, Cmd.none )

        ToHitChanged value ->
            ( { model | toHit = value }, Cmd.none )

        ToWoundChanged value ->
            ( { model | toWound = value }, Cmd.none )

        RendChanged value ->
            ( { model | rend = value }, Cmd.none )

        DamageChanged value ->
            ( { model | damage = value }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
