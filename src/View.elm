module View exposing (view)

import Calculator
import DamageChart
import Html exposing (Attribute, Html)
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


viewFormula : Html Msg
viewFormula =
    Html.article [ Attr.class "message formula" ]
        [ Html.div [ Attr.class "message-header" ]
            [ Html.p [] [ Html.text "Age of Sigmar" ]
            ]
        , Html.div [ Attr.class "message-body" ]
            [ Html.p []
                [ Html.text
                    """
            Thank you for using this Age of Sigmar average damage
            calculator! I hope you find it useful. The formula used is as
            below, where D stands for unit's damage, A for its number of
            attacks, H for its hit probability, W for wound probability,
            and S for enemy chance of saving.

            """
                , Html.hr [] []
                ]
            , Html.img [ Attr.src "static/formula.png" ] []
            ]
        ]


ionIcon : List (Attribute msg) -> List (Html msg) -> Html msg
ionIcon =
    Html.node "ion-icon"


viewFooter : Html Msg
viewFooter =
    Html.div [ Attr.class "block level" ]
        [ Html.span [ Attr.class "icon-text level-item" ]
            [ Html.a [ Attr.href "https://www.github.com/khrynczenko/howmanywounds" ]
                [ Html.span [ Attr.class "icon" ]
                    [ ionIcon [ Attr.name "logo-github" ] []
                    ]
                , Html.span [] [ Html.text " made with Elm" ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    Html.section [ class "section" ]
        [ Html.div [ class "container" ]
            [ Html.div [ class "box" ]
                [ Html.h1 [ class "title" ] [ Html.text "How many wounds" ]
                , Html.div [ class "columns" ]
                    [ Html.div [ class "column is-half" ]
                        [ viewForm model
                        , viewDamageTable model
                        ]
                    , Html.div [ class "column is-half" ]
                        [ Html.div [ Attr.class "chart" ]
                            [ DamageChart.makeChart model
                            , viewFormula
                            ]
                        ]
                    ]
                , Html.div [ class "columns" ]
                    [ Html.div [ class "column is-full" ]
                        [ viewFooter ]
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
                    "18"
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
                ]
            ]
        ]


buildDamageRow : Model -> Int -> Html Msg
buildDamageRow model ward =
    let
        saves =
            [ 2, 3, 4, 5, 6 ]

        makeDamageCell =
            \save ->
                Html.td []
                    [ formatDamage <|
                        Calculator.calculateDamage model.unit
                            save
                            { ward = ward
                            , elmAnalyzeBullshit = ()
                            }
                    ]

        descriptionCell =
            Html.th []
                [ Html.text <|
                    (String.fromInt ward ++ "+")
                ]

        damageCells =
            List.map makeDamageCell saves

        allCells =
            descriptionCell :: damageCells
    in
    Html.tr [] allCells


viewDamageTableCorner : Html Msg
viewDamageTableCorner =
    Html.table [ class "is-small m-0 is-size-7", Attr.width 0 ]
        [ Html.tr []
            [ Html.td [] [ Html.text "" ]
            , Html.td [ class "is-pulled-right" ] [ Html.text "Save" ]
            ]
        , Html.tr []
            [ Html.td [ class "is-pulled-right" ] [ Html.text "Ward" ]
            , Html.td [] [ Html.text "Damage" ]
            ]
        ]


viewDamageTable : Model -> Html Msg
viewDamageTable model =
    Html.div [ class "table-container" ]
        [ Html.table [ class "table is-hoverable is-fullwidth" ]
            [ Html.tbody []
                [ Html.tr []
                    [ Html.th [] [ viewDamageTableCorner ]
                    , Html.th [] [ Html.text "2+" ]
                    , Html.th [] [ Html.text "3+" ]
                    , Html.th [] [ Html.text "4+" ]
                    , Html.th [] [ Html.text "5+" ]
                    , Html.th [] [ Html.text "6+" ]
                    ]
                , buildDamageRow model 0
                , buildDamageRow model 2
                , buildDamageRow model 3
                , buildDamageRow model 4
                , buildDamageRow model 5
                , buildDamageRow model 6
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
