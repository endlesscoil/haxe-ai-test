
package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
using flixel.util.FlxSpriteUtil;

interface Actor 
{
    public var name : String;
    public var sprite : FlxSprite;
    public var position : Dynamic = {x: 0, y: 0};

    public function destroy() : Void;
    public function setPosition(X : Float, Y : Float) : Void;
}

class Player implements Actor 
{
    public var name : String = "Player";
    public var sprite : FlxSprite;
    public var position : Dynamic = {x: 0, y: 0};

    public function new(?Name : String) : Void
    {
        if (Name != null)
            name = Name;

        sprite = new FlxSprite();

        sprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        sprite.drawCircle(sprite.width / 2, sprite.height / 2, 5, FlxColor.AQUAMARINE);
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
    public var position : Dynamic = {x: 0, y: 0};

    public function new(?Name : String) : Void
    {
        if (Name != null)
            name = Name;

        sprite = new FlxSprite();

        sprite.makeGraphic(10, 10, FlxColor.TRANSPARENT, true);
        sprite.drawCircle(sprite.width / 2, sprite.height / 2, 5, FlxColor.CRIMSON);
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