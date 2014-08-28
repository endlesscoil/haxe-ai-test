
package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
using flixel.util.FlxSpriteUtil;

interface Actor
{
    public var name : String;
    public var speed : Int;
    private var _brain : Brain;
}

class Player 
    extends FlxSprite 
    implements Actor
{
    public var name : String = "Player";
    public var speed : Int = 5;
    private var _brain : Brain;

    public function new(?Name : String) : Void
    {
        super();

        if (Name != null)
            name = Name;

        _brain = new Brain(this, Reg.behavior_manager.get_behavior(AssetPaths.BehaviorAssets.Wandering__json));

        makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        drawCircle(width / 2, height / 2, 5, FlxColor.AQUAMARINE);
    }

    public override function update() : Void
    {
        #if DEBUG_BEHAVIORS
        trace('Updating Player $name');
        #end

        super.update();

        if (alive)
        {
            _brain.update();

            if (_brain.is_idle())
                _brain.reset_behavior();
        }
    }

    public override function destroy() : Void
    {
        super.destroy();
    }
}

class Enemy 
    extends FlxSprite 
    implements Actor
{
    public var name : String = "Enemy";
    public var speed: Int = 1;
    private var _brain : Brain;

    public function new(?Name : String) : Void
    {
        super();

        if (Name != null)
            name = Name;

        _brain = new Brain(this, Reg.behavior_manager.get_behavior(AssetPaths.BehaviorAssets.Chase__json));

        makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        drawCircle(width / 2, height / 2, 5, 0xFFFF0000);
    }

    public override function update() : Void
    {
        #if DEBUG_BEHAVIORS
        trace('Updating Enemy $name');
        #end

        if(alive)
        {
            _brain.update();

            if (_brain.is_idle())
                _brain.reset_behavior();
        }

        super.update();
    }

    public override function destroy() : Void
    {
        super.destroy();
    }
}

class TestActor 
    extends FlxSprite 
    implements Actor
{
    public var name : String = "TestActor";
    public var speed : Int = 3;
    private var _brain : Brain;

    public function new(?Name : String) : Void
    {
        super();

        if (Name != null)
            name = Name;

        //_brain = new Brain(this, Reg.behavior_manager.get_behavior(AssetPaths.BehaviorAssets.BoxMove__json));
        _brain = new Brain(this, Reg.behavior_manager.get_behavior(AssetPaths.BehaviorAssets.Hunt__json));

        makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        drawCircle(width / 2, height / 2, 5, 0xFF00FF00);
    }

    public override function update() : Void
    {
        super.update();

        if(alive)
            _brain.update();
    }

    public override function destroy() : Void
    {
        super.destroy();
    }

    public function fire(Target : FlxSprite) : Void
    {
        var bullet : FlxSprite = Reg.state.bullets.recycle();

        bullet.reset(x + (width - bullet.width) / 2, y + (height - bullet.height / 2));
        bullet.angle  = FlxAngle.angleBetween(this, Target, true);
        bullet.velocity = FlxAngle.rotatePoint(150, 0, 0, 0, bullet.angle);
        bullet.velocity.x *= 2;
        bullet.velocity.y *= 2;
    }
}