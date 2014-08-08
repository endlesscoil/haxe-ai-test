
package ;

import Behavior.BehaviorState;
import flixel.FlxState;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import flixel.util.FlxCollision;

using flixel.util.FlxSpriteUtil;

enum BehaviorState
{
    IDLE;
    RUNNING;
    SUCCEEDED;
    FAILED;
}

class Brain
{
    private var _behavior : Behavior = null;

    public function new() : Void
    {

    }

    public function update() : Void
    {
        if (_behavior != null && _behavior.status() == BehaviorState.RUNNING)
            _behavior.update();
    }

    public function is_idle() : Bool
    {
        return _behavior.status() != BehaviorState.RUNNING;
    }

    public function set_behavior(NewBehavior : Behavior) : Void
    {
        _behavior = NewBehavior;

        _behavior.start();
    }
}

class Behavior 
{
    public static function MoveTo(Body : Actor, X : Float, Y : Float, Speed : Float)
    {
        return new MoveToBehavior(Body, X, Y, Speed);
    }

    public static function Chase(Body : Actor, Speed : Float)
    {
        return new ChaseBehavior(Body, Speed);
    }

    private var _state : BehaviorState = BehaviorState.IDLE;

    private function new() : Void { }
    public function start() : Void { _state = BehaviorState.RUNNING; }
    public function update() : Void { }
    public function reset() : Void { _state = BehaviorState.IDLE; }
    public function status() : BehaviorState { return _state; }
}

class MoveToBehavior extends Behavior
{
    public var x : Float;
    public var y : Float;
    public var speed : Float;

    public var _move_vector : FlxVector;

    private var _body : Actor;

    public function new(Body : Actor, X : Float, Y : Float, Speed : Float) : Void
    {
        super();

        x = X;
        y = Y;
        speed = Speed;

        _move_vector = FlxVector.get(0, 0);
        _body = Body;
    }

    override public function update() : Void
    {
        if (_body.position.x != x || _body.position.y != y)
        {
            _move_vector.x = x - _body.position.x;
            _move_vector.y = y - _body.position.y;
            _move_vector.normalize();

            var new_pos : FlxPoint = FlxPoint.weak(_body.position.x + _move_vector.x * speed, _body.position.y + _move_vector.y * speed);

            if (new_pos.distanceTo(FlxPoint.weak(x, y)) < speed)
                _body.setPosition(x, y);
            else
                _body.setPosition(new_pos.x, new_pos.y);
        }
        else
        {
            _state = BehaviorState.SUCCEEDED;
            trace('MoveTo: SUCCEEDED');
        }
    }
}

class ChaseBehavior extends Behavior
{
    private var _body : Actor;
    private var _current_target : Actor = null;

    public var speed : Float;

    public function new(Body : Actor, Speed : Float) : Void
    {
        super();

        _body = Body;
        speed = Speed;
    }

    override public function update() : Void
    {
        if (_current_target == null)
        {
            for (p in Reg.state.players)
            {
                if (p.position.distanceTo(_body.position) < 75)
                {
                    trace('acquired target: ${p}');
                    _current_target = p;
                    break;
                }
            }
        }

        // chase
        if (_current_target != null)
        {
            if (_body.position.distanceTo(_current_target.position) > 75)
            {
                trace('abandoning target.');
                _current_target = null;
            }
            else
            {
                var mv : FlxVector = FlxVector.get();

                mv.x = _current_target.position.x - _body.position.x;
                mv.y = _current_target.position.y - _body.position.y;
                mv.normalize();

                var new_pos : FlxPoint = FlxPoint.weak(_body.position.x + mv.x * speed, _body.position.y + mv.y * speed);

                _body.setPosition(new_pos.x, new_pos.y);

                if (FlxCollision.pixelPerfectCheck(_body.sprite, _current_target.sprite))
                {
                    trace('CAUGHT EM!');
                    _state = BehaviorState.SUCCEEDED;
                }
            }
        }
    }
}
