/**
 * Created by leandro on 6/19/2015.
 */
package game {

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

import utils.CustomTimer;
import utils.StateMachine;

import utils.Utils;

public class Player {
    public var enemyPlayer:Player;
    public var main:Unit;
    public var team:int;
    public var gold:int;
    public var type:String;
    public var npc:Boolean;
    public var remote:Boolean;
    private var unitToPutLines:UnitView;
    private var linesToPlace:Array;
    private var buildingSelected:String;
    private var selectedUnit:UnitView;
    private var stateMachine:StateMachine = new StateMachine();
    public var hud:UIElementView;

    private var placeTimer:CustomTimer = new CustomTimer(500);
    private var lineTimer:CustomTimer = new CustomTimer(200);

    public function Player() {
        stateMachine.state = "waitingAction";
        stateMachine.defineStateRelation("waitingAction", "placingBuilding", "place");
        stateMachine.defineStateRelation("placingBuilding", "selectingPath", "placed");
        stateMachine.defineStateRelation("placingBuilding", "waitingAction", "placedNoLines");
        stateMachine.defineStateRelation("selectingPath", "waitingAction", "selected");

        placeTimer.addEventListener(TimerEvent.TIMER, onPlaceTimer);
        lineTimer.addEventListener(TimerEvent.TIMER, onLineTimer);
    }

    public function update():void{
        if(!remote){
            if((GameApp.instance.stateMachine.state == "turn0" && team == 0) || (GameApp.instance.stateMachine.state == "turn1" && team == 1)) {
                if(npc) {
                    if (!placeTimer.running && !lineTimer.running) {
                        placeTimer.start();
                    }
                } else {
                    switch(stateMachine.state){
                        case "waitingAction":
                            buildingSelected = null;
                            if (GameApp.instance.pressedKeys[Keyboard.Q]) {
                                GameApp.instance.releaseKey(Keyboard.Q);
                                buildingSelected = "unitSpawner";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.W]) {
                                GameApp.instance.releaseKey(Keyboard.W);
                                buildingSelected = "fastUnitSpawner";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.E]) {
                                GameApp.instance.releaseKey(Keyboard.E);
                                buildingSelected = "heavyUnitSpawner";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.R]) {
                                GameApp.instance.releaseKey(Keyboard.R);
                                buildingSelected = "knightSpawner";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.A]) {
                                GameApp.instance.releaseKey(Keyboard.A);
                                buildingSelected = "rangedSpawner";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.S]) {
                                GameApp.instance.releaseKey(Keyboard.S);
                                buildingSelected = "strongRangedSpawner";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.D]) {
                                GameApp.instance.releaseKey(Keyboard.D);
                                buildingSelected = "aoeSpawner";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.Z]) {
                                GameApp.instance.releaseKey(Keyboard.Z);
                                buildingSelected = "resource";
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.X]) {
                                GameApp.instance.releaseKey(Keyboard.X);
                                buildingSelected = "tower";
                            }
                            if (buildingSelected && Utils.getDefinitionByType(buildingSelected).cost <= gold) {
                                unitToPutLines = GameApp.instance.createPlaceView(GameApp.instance.mousePos.x, GameApp.instance.mousePos.y, buildingSelected, this);
                                stateMachine.dispatchEvent("place");
                            } else if(GameApp.instance.pressedKeys[Keyboard.ESCAPE]){
                                GameApp.instance.releaseKey(Keyboard.ESCAPE);
                                placeTimer.stop();
                                GameApp.instance.passTurn();
                            }
                            break;
                        case "placingBuilding":
                            //TweenLite.to(unitToPutLines.view, .15, {x:GameApp.instance.mousePos.x, y:GameApp.instance.mousePos.y, ease:Linear.easeNone});
                            if(GameApp.instance.mousePressed) {
                                GameApp.instance.releaseMouse();
                                if(Utils.getDefinitionByType(buildingSelected).hasPath) {
                                    stateMachine.dispatchEvent("placed");
                                } else {
                                    stateMachine.dispatchEvent("placedNoLines");
                                }
                                selectedUnit = buyBuilding(unitToPutLines.view.x, unitToPutLines.view.y, buildingSelected);
                                unitToPutLines.view.parent.removeChild(unitToPutLines.view);
                            }
                            break;
                        case "selectingPath":
                            if (GameApp.instance.pressedKeys[Keyboard.SPACE]) {
                                GameApp.instance.releaseKey(Keyboard.SPACE);
                                GameApp.instance.drawFromBuildingLine(selectedUnit, GameApp.instance.mousePos.x, GameApp.instance.mousePos.y);
                            }
                            if (GameApp.instance.pressedKeys[Keyboard.ENTER]) {
                                GameApp.instance.releaseKey(Keyboard.ENTER);
                                stateMachine.dispatchEvent("selected");
                            }
                            break;
                    }
                }
            }
        }
    }

    private function onPlaceMoveComplete():void{
        var unit:UnitView;
        unit = buyBuilding(unitToPutLines.view.x, unitToPutLines.view.y, buildingSelected);
        if(Math.random() < .3){
            //unit.owner.mode = "moveOnly";
        }

        unitToPutLines.view.parent.removeChild(unitToPutLines.view);
        if(unit){

            var data:Object = Utils.getDefinitionByType(buildingSelected);
            if(data.hasPath) {
                var mainPos:Point;
                for each(var otherUnit:UnitView in GameApp.instance.units[team == 0 ? 1 : 0]) {
                    if (otherUnit.owner.type == "main" && otherUnit.owner.team != team) {
                        mainPos = new Point(otherUnit.owner.x, otherUnit.owner.y);
                        break;
                    }
                }
                if (mainPos) {
                    linesToPlace = unit.owner.curvePath([mainPos]);
                    placeTimer.stop();
                    lineTimer.start();
                    unitToPutLines = unit;
                }
            }

        }
    }

    private function onPlaceTimer(e:TimerEvent):void{

        var buildings:Array = ["unitSpawner", "fastUnitSpawner", "rangedUnitSpawner", "strongRangedUnitSpawner", "aoeUnitSpawner", "heavyUnitSpawner", "knightSpawner", "resource", "tower"];
        var shuffled:Array = new Array(buildings.length);

        var randomPos:Number = 0;
        for (var i:int = 0; i < shuffled.length; i++)
        {
            randomPos = int(Math.random() * buildings.length);
            shuffled[i] = buildings.splice(randomPos, 1)[0];
        }
        buildingSelected = null;
        for(var j:int = shuffled.length - 1; j >= 0; j--){
            var data:Object = Utils.getDefinitionByType(shuffled[j]);
            if(gold >= data.cost){
                buildingSelected = shuffled[j];
            }
        }
        if (!buildingSelected || gold <= 0) {
            placeTimer.stop();
            GameApp.instance.passTurn();
        } else {
            switch(GameApp.ORIENTATION){
                case "topDown":
                    if (team == 0) {
                        unitToPutLines = GameApp.instance.createPlaceView(GameApp.STAGE_WIDTH * Math.random(), 25 + ((GameApp.STAGE_HEIGHT / 2) - 50) * Math.random(), buildingSelected, this);
                        //TweenLite.to(unitToPutLines.view, placeTimer.duration/2000, {x:GameApp.STAGE_WIDTH * Math.random(), y:25 + ((GameApp.STAGE_HEIGHT / 2) - 50) * Math.random(), onComplete:onPlaceMoveComplete});
                    } else {
                        unitToPutLines = GameApp.instance.createPlaceView(GameApp.STAGE_WIDTH * Math.random(), GameApp.STAGE_HEIGHT - 25 - ((GameApp.STAGE_HEIGHT / 2) - 50) * Math.random(), buildingSelected, this);
                        //TweenLite.to(unitToPutLines.view, placeTimer.duration/2000, {x:GameApp.STAGE_WIDTH * Math.random(), y:GameApp.STAGE_HEIGHT - 25 - ((GameApp.STAGE_HEIGHT / 2) - 50) * Math.random(), onComplete:onPlaceMoveComplete});
                    }
                    break;
                case "leftRight":
                    if (team == 0) {
                        unitToPutLines = GameApp.instance.createPlaceView(25 + ((GameApp.STAGE_WIDTH / 2) - 50) * Math.random(), GameApp.STAGE_HEIGHT * Math.random(), buildingSelected, this);
                        //TweenLite.to(unitToPutLines.view, placeTimer.duration/2000, {x:25 + ((GameApp.STAGE_WIDTH / 2) - 50) * Math.random(), y:GameApp.STAGE_HEIGHT * Math.random(), onComplete:onPlaceMoveComplete});
                    } else {
                        unitToPutLines = GameApp.instance.createPlaceView(GameApp.STAGE_WIDTH - 25 - ((GameApp.STAGE_WIDTH / 2) - 50) * Math.random(), GameApp.STAGE_HEIGHT * Math.random(), buildingSelected, this);
                        //TweenLite.to(unitToPutLines.view, placeTimer.duration/2000, {x:GameApp.STAGE_WIDTH - 25 - ((GameApp.STAGE_WIDTH / 2) - 50) * Math.random(), y:GameApp.STAGE_HEIGHT * Math.random(), onComplete:onPlaceMoveComplete});
                    }
                    break;
            }
        }
    }

    private function onLineTimer(e:TimerEvent):void{
        if(linesToPlace.length > 0) {
            var currentPathPoint:Point = linesToPlace.shift();
            GameApp.instance.drawFromBuildingLine(unitToPutLines, currentPathPoint.x, currentPathPoint.y);
        } else {
            lineTimer.stop();
            placeTimer.start();
        }
    }

    private function buyBuilding(x:Number, y:Number, type:String):UnitView{
        var data:Object = Utils.getDefinitionByType(type);
        if(gold >= data.cost){
            return GameApp.instance.createBuilding(x, y, type, this);
        }
        return null;
    }
}
}
