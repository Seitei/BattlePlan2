/**
 * Created by leandro on 6/26/2015.
 */
package utils {
import game.Unit;
import game.UnitView;

public class Utils {
    public function Utils() {
    }

    public static function deleteUnitView(array:Vector.<UnitView>, i:int):void{
        var lastElement:UnitView = array.pop();
        if(i < array.length)
            array[i] = lastElement;
    }

    public static function deleteUnit(array:Vector.<Unit>, i:int):void{
        var lastElement:Unit = array.pop();
        if(i < array.length)
            array[i] = lastElement;
    }

    public static function getDefinitionByType(type:String):Object{
        var result:Object = new Object();
        switch(type){
            case "base":
                result.actions = new Array();
                result.entityType = "none";
                break;
            case "entity":
                result = getDefinitionByType("base");
                result.entityType = "unit";
                result.hp = 0;
                result.speed = 0;
                result.damage = 0;
                result.range = 0;
                result.aoe = 0;
                result.radius = 10;
                result.maxUnits = 0;
                result.asset = "d";
                result.scaleX = 1;
                result.scaleY = 1;
                result.attackCooldown = 0;
                result.income = 0;
                break;
            case "building":
                result = getDefinitionByType("entity");
                result.entityType = "building";
                result.hp = 5000;
                result.radius = 30;
                result.cost = 10;
                result.hasPath = false;
                break;
            case "main":
                result = getDefinitionByType("building");
                result.hp = 10000;
                result.scaleX = 1.5;
                result.scaleY = 1.5;
                result.income = 10;
                result.cost = 0;
                break;
            case "tower":
                result = getDefinitionByType("building");
                result.attackCooldown = 1000;
                result.asset = "c";
                result.aoe = 25;
                result.cost = 10;
                result.damage = 75;
                result.range = 60;
                break;
            case "resource":
                result = getDefinitionByType("building");
                result.asset = "d";
                result.income = 5;
                break;
            case "spawner":
                result = getDefinitionByType("building");
                result.hasPath = true;
                break;
            case "unitSpawner":
                result = getDefinitionByType("spawner");
                result.actions.push("summonUnit");
                result.asset = "u1";
                break;
            case "fastUnitSpawner":
                result = getDefinitionByType("spawner");
                result.actions.push("summonFastUnit");
                result.asset = "u2";
                result.cost = 7;
                break;
            case "rangedUnitSpawner":
                result = getDefinitionByType("spawner");
                result.actions.push("summonRangedUnit");
                result.asset = "u3";
                result.cost = 15;
                break;
            case "strongRangedUnitSpawner":
                result = getDefinitionByType("spawner");
                result.actions.push("summonStrongRangedUnit");
                result.asset = "u4";
                result.cost = 30;
                break;
            case "aoeUnitSpawner":
                result = getDefinitionByType("spawner");
                result.actions.push("summonAoeUnit");
                result.asset = "u5";
                result.cost = 25;
                break;
            case "heavyUnitSpawner":
                result = getDefinitionByType("spawner");
                result.actions.push("summonHeavyUnit");
                result.asset = "u6";
                result.cost = 20;
                break;
            case "knightSpawner":
                result = getDefinitionByType("spawner");
                result.actions.push("summonKnight");
                result.asset = "u7";
                result.cost = 40;
                break;
            case "action":
                result = getDefinitionByType("base");
                result.entityType = "action";
                result.cooldown = 0;
                break;
            case "summonAction":
                result = getDefinitionByType("action");
                result.actions.push("summon");
                result.unitSummoned = null;
                result.cooldown = 3000;
                break;
            case "summonUnit":
                result = getDefinitionByType("summonAction");
                result.unitSummoned = "unit";
                break;
            case "summonFastUnit":
                result = getDefinitionByType("summonAction");
                result.unitSummoned = "fastUnit";
                result.cooldown = 2000;
                break;
            case "summonRangedUnit":
                result = getDefinitionByType("summonAction");
                result.unitSummoned = "rangedUnit";
                break;
            case "summonStrongRangedUnit":
                result = getDefinitionByType("summonAction");
                result.unitSummoned = "strongRangedUnit";
                result.cooldown = 4000;
                break;
            case "summonAoeUnit":
                result = getDefinitionByType("summonAction");
                result.unitSummoned = "aoeUnit";
                result.cooldown = 4000;
                break;
            case "summonHeavyUnit":
                result = getDefinitionByType("summonAction");
                result.unitSummoned = "heavyUnit";
                break;
            case "summonKnight":
                result = getDefinitionByType("summonAction");
                result.unitSummoned = "knight";
                result.cooldown = 5000;
                break;
            case "unit":
                result = getDefinitionByType("entity");
                result.attackCooldown = 1000;
                result.hp = 500;
                result.speed = .5;
                result.damage = 10;
                result.asset = "U1Png";
                result.scaleX = .5;
                result.scaleY = .5;
                break;
            case "fastUnit":
                result = getDefinitionByType("unit");
                result.hp = 50;
                result.damage = 65;
                result.asset = "u2";
                break;
            case "rangedUnit":
                result = getDefinitionByType("unit");
                result.hp = 100;
                result.damage = 45;
                result.range = 50;
                result.asset = "u3";
                break;
            case "strongRangedUnit":
                result = getDefinitionByType("rangedUnit");
                result.damage = 150;
                result.range = 80;
                result.asset = "u4";
                break;
            case "aoeUnit":
                result = getDefinitionByType("rangedUnit");
                result.aoe = 50;
                result.asset = "u5";
                break;
            case "heavyUnit":
                result = getDefinitionByType("unit");
                result.hp = 1000;
                result.asset = "u6";
                break;
            case "knight":
                result = getDefinitionByType("heavyUnit");
                result.damage = 150;
                result.asset = "u7";
                break;
        }
        return result;
    }

}
}
