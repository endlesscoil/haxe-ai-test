
package ;

import Behavior.Brain;
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

        //var move_behavior = new Behavior.MoveTo(this, 100, 100, 5.0);
        var behavior = Behavior.MoveTo(this, 100, 100, 5.0);

        _brain = new Brain();
        _brain.set_behavior(behavior);

        sprite = new FlxSprite();

        sprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        sprite.drawCircle(sprite.width / 2, sprite.height / 2, 5, FlxColor.AQUAMARINE);
    }

    public function update() : Void
    {
        _brain.update();

        if (_brain.is_idle())
        {
            trace('idle.. wandering..');
            wander();
        }
    }

    public function destroy() : Void
    {
        sprite = FlxDestroyUtil.destroy(sprite);
    }

    public function wander() : Void
    {
        var pos = { x: FlxRandom.intRanged(0, FlxG.width), y: FlxRandom.intRanged(0, FlxG.height) };
        var speed = FlxRandom.intRanged(1, 10);

        trace('wandering to: ${pos} at ${speed} speed');
        _brain.set_behavior(new Behavior.MoveToBehavior(this, pos.x, pos.y, speed));
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

        //var behavior = new Behavior.MoveTo(this, 100, 100, 5.0);
        var behavior = new Behavior.ChaseBehavior(this, FlxRandom.intRanged(1, 5));
        _brain = new Brain();
        _brain.set_behavior(behavior);

        sprite = new FlxSprite();

        sprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        sprite.drawCircle(sprite.width / 2, sprite.height / 2, 5, FlxColor.CRIMSON);
    }

    public function update() : Void
    {
        _brain.update();

        if (_brain.is_idle())
        {
            wander();
        }
    }

    public function destroy() : Void
    {
        sprite = FlxDestroyUtil.destroy(sprite);
    }

    public function wander() : Void
    {
        var pos = { x: FlxRandom.intRanged(0, FlxG.width), y: FlxRandom.intRanged(0, FlxG.height) };
        var speed = FlxRandom.intRanged(1, 10);

        trace('wandering to: ${pos} at ${speed} speed');
        _brain.set_behavior(new Behavior.MoveToBehavior(this, pos.x, pos.y, speed));
    }

    public function setPosition(X : Float, Y : Float) : Void
    {
        position.x = X;
        position.y = Y;

        sprite.setPosition(X, Y);
    }
}