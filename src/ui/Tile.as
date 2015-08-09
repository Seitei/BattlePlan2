package ui {
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;
import starling.utils.Color;

import utils.Utils;

public class Tile extends Sprite{

    private var _assets:AssetManager;
    private var _frame:Image;
    private static const ANIM_TIME:Number = 0.10;
    private var _description:String;
    private var _buildingCost:int;
    private var _disable:Quad;

    public function Tile(description:String, container:Boolean) {

        _description = description;
        _assets = GameApp.getAssetManager();

        _buildingCost = Utils.getDefinitionByType(description).cost;
        trace(_buildingCost);
        _frame = new Image(_assets.getTexture("tile_frame"));
        addChild(_frame);
        _frame.visible = false;

        var image:Image = new Image(_assets.getTexture(description + "_icon"));
        addChild(image);

        this.visible = false;

        _disable = new Quad(this.width, this.height, Color.BLACK);
        _disable.alpha = 0.5;
        addChild(_disable);

        checkCost();

    }

    private function checkCost():void {

        if(_buildingCost > GameApp.instance.getGold()){
            setState(false);
        }
        else {
            setState(true);
        }

    }


    private function setState(state:Boolean):void {

        removeEventListener(TouchEvent.TOUCH, onTouch);

        if(state){
            addEventListener(TouchEvent.TOUCH, onTouch);
            _disable.visible = false;
        }
        else {
            _disable.visible = true;
        }

    }


    private function onTouch(e:TouchEvent):void {

        var hover:Touch = e.getTouch(this, TouchPhase.HOVER);
        var began:Touch = e.getTouch(this, TouchPhase.BEGAN);

        if(hover){
            _frame.visible = true;
        }
        else {
            _frame.visible = false;
        }

        if(began){

            removeEventListener(TouchEvent.TOUCH, onTouch);
            dispatchEventWith("tileClicked", true, this);
            //vanish();

        }

    }

    public function vanish(delay:Number):void {

        var alphaTween:Tween = new Tween(this, ANIM_TIME, Transitions.LINEAR);
        Starling.juggler.add(alphaTween);
        alphaTween.delay = delay;
        alphaTween.animate("alpha", 0);

        var moveTween:Tween = new Tween(this, ANIM_TIME, Transitions.LINEAR);
        moveTween.delay = delay;
        Starling.juggler.add(moveTween);
        moveTween.animate("x", this.x - this.width - 40);

        moveTween.onComplete = onCompleteMoveTween;

    }

    private function onCompleteMoveTween():void{

        this.visible = false;

    }


    public function appear(delay:Number):void {

        this.visible = true;

        this.alpha = 0;
        var alphaTween:Tween = new Tween(this, ANIM_TIME, Transitions.LINEAR);
        Starling.juggler.add(alphaTween);
        alphaTween.delay = delay;
        alphaTween.animate("alpha", 1);

        this.x = stage.stageWidth + 20;
        var moveTween:Tween = new Tween(this, ANIM_TIME, Transitions.LINEAR);
        moveTween.delay = delay;
        Starling.juggler.add(moveTween);
        moveTween.animate("x", this.x - this.width - 40);

        checkCost();

    }

    public function get description():String {

        return _description;

    }

















}
}
