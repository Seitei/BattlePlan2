package ui {

import flash.utils.Dictionary;

import starling.display.Sprite;
import starling.events.Event;

public class UI extends Sprite{

    private static var CATEGORIES:Array = ["spawners", "towers", "utilities"];
    private static var SPAWNERS:Array =   ["melee1", "melee2", "melee3", "melee4", "ranged1", "ranged2", "ranged3"];
    private static var TOWERS:Array =   ["tower"];
    private static var UTILITIES:Array =   ["resource"];
    private static const DELAY:Number = 0.03;

    private var _content:Dictionary;
    private var _categories:Array;
    private var _spawners:Array;
    private var _towers:Array;
    private var _utilities:Array;
    private var _showing:Boolean;
    private var _activeContent:String;

    public function UI() {

        _showing = false;
        _content = new Dictionary();
        _categories = new Array();
        _spawners = new Array();
        _towers = new Array();
        _utilities = new Array();

        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        addEventListener("tileClicked", onTileClicked);

    }

    private function onTileClicked(e:Event, tile:Tile):void {

        showContent(tile.description);

    }


    public function show():void {

        showContent("categories");
        _showing = true;

    }

    public function showing():Boolean {

        return _showing;

    }

    public function hide():void {

        var delayCounter:Number = 0;
        for each(var tile:Tile in _content[_activeContent]){

            delayCounter += DELAY;
            tile.vanish(delayCounter);

        }

        _showing = false;

    }

    public function showContent(selection:String):void {

        if(_activeContent && _activeContent != selection){

            var delayCounter:Number = 0;

            for each(var tile1:Tile in _content[_activeContent]){

                delayCounter += DELAY;
                tile1.vanish(delayCounter);

            }
        }

        if(_content[selection]){

            delayCounter = 0;

            for each(var tile2:Tile in _content[selection]){

                delayCounter += DELAY;
                tile2.appear(delayCounter);

            }

            _activeContent = selection;

        }
        else {

            dispatchEventWith("buildingSelected", true, selection);

        }

    }

    private function onAdded(e:Event):void {

        fillContent();

    }


    private function fillContent():void {

        var counter:int = 0;

        /****  CATEGORIES ****/

        for each(var category:String in CATEGORIES){

            var catTile:Tile = new Tile(category, true);
            catTile.y = 20 + (catTile.height + 20) * counter;
            addChild(catTile);
            _categories.push(catTile);

            counter ++;

        }

        _content["categories"] = _categories;

        counter = 0;

        /****  SPAWNERS ****/

        for each(var spawner:String in SPAWNERS){

            var spTile:Tile = new Tile(spawner, false);
            spTile.y = 20 + (spTile.height + 20) * counter;
            addChild(spTile);
            _spawners.push(spTile);
            counter ++;
        }

        _content["spawners"] = _spawners;


        counter = 0;

        /****  TOWERS ****/

        for each(var tower:String in TOWERS){

            var toTile:Tile = new Tile(tower, false);
            toTile.y = 20 + (toTile.height + 20) * counter;
            addChild(toTile);
            _towers.push(toTile);
            counter ++;
        }

        _content["towers"] = _towers;


        counter = 0;

        /****  UTILITIES ****/

        for each(var utility:String in UTILITIES){

            var utTile:Tile = new Tile(utility, false);
            utTile.y = 20 + (utTile.height + 20) * counter;
            addChild(utTile);
            _utilities.push(utTile);
            counter ++;
        }

        _content["utilities"] = _utilities;

    }



























































}
}
