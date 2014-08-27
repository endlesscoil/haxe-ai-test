
package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
using flixel.util.FlxSpriteUtil;

interface Actor 
{
    public var name : String;
    public var sprite : FlxSprite;
    public var position : FlxPoint;

    public function destroy() : Void;
    public function setPosition(X : Float, Y : Float) : Void;
}

class Player implements Actor 
{
    public var name : String = "Player";
    public var sprite : FlxSprite;
    public var position : FlxPoint;

    private var _brain : Brain;

    public function new(?Name : String) : Void
    {
        if (Name != null)
            name = Name;

        position = FlxPoint.get();

        var behavior = Reg.behavior_manager.get_behavior(AssetPaths.BehaviorAssets.Wandering__json);
        _brain = new Brain(this, behavior);

        sprite = new FlxSprite();
        sprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        sprite.drawCircle(sprite.width / 2, sprite.height / 2, 5, FlxColor.AQUAMARINE);
    }

    public function update() : Void
    {
        #if DEBUG_BEHAVIORS
        trace('Updating Player $name');
        #end

        _brain.update();

        if (_brain.is_idle())
            _brain.reset_behavior();
    }

    public function destroy() : Void
    {
        sprite = FlxDestroyUtil.destroy(sprite);
    }

    public function setPosition(X : Float, Y : Float) : Void
    {
        position.x = X;
        position.y = Y;

        sprite.setPosition(X, Y);
    }
}

class Enemy implements Actor
{
    public var name : String = "Enemy";
    public var sprite : FlxSprite;
    public var position : FlxPoint;

    private var _brain : Brain;

    public function new(?Name : String) : Void
    {
        if (Name != null)
            name = Name;

        position = FlxPoint.get();

        _brain = new Brain(this, Reg.behavior_manager.get_behavior(AssetPaths.BehaviorAssets.Chase__json));

        sprite = new FlxSprite();
        sprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        sprite.drawCircle(sprite.width / 2, sprite.height / 2, 5, 0xFFFF0000);
    }

    public function update() : Void
    {
        #if DEBUG_BEHAVIORS
        trace('Updating Enemy $name');
        #end

        _brain.update();

        if (_brain.is_idle())
            _brain.reset_behavior();
    }

    public function destroy() : Void
    {
        sprite = FlxDestroyUtil.destroy(sprite);
    }

    public function setPosition(X : Float, Y : Float) : Void
    {
        position.x = X;
        position.y = Y;

        sprite.setPosition(X, Y);
    }
}

class TestActor implements Actor
{
    public var name : String = "TestActor";
    public var sprite : FlxSprite;
    public var position : FlxPoint;

    private var _brain : Brain;

    public function new(?Name : String) : Void
    {
        if (Name != null)
            name = Name;

        position = FlxPoint.get();

        var behavior = Reg.behavior_manager.get_behavior(AssetPaths.BehaviorAssets.BoxMove__json);
        _brain = new Brain(this, behavior);

        sprite = new FlxSprite();
        sprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        sprite.drawCircle(sprite.width / 2, sprite.height / 2, 5, 0xFF00FF00);
    }

    public function update() : Void
    {
        _brain.update();
    }

    public function destroy() : Void
    {
        sprite = FlxDestroyUtil.destroy(sprite);
    }

    public function setPosition(X : Float, Y : Float) : Void
    {
        position.x = X;
        position.y = Y;

        sprite.setPosition(X, Y);
    }
}