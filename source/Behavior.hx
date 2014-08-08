
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

class Behavior 
{
    private var _state : BehaviorState = BehaviorState.IDLE;

    private function new() : Void { }

    public function start() : Void
    {
        _state = BehaviorState.RUNNING;
    }

    public function update() : Void { }

    public function reset() : Void
    {
        _state = BehaviorState.IDLE;
    }

    public function status() : BehaviorState
    {
        return _state;
    }
}

class MoveTo extends Behavior
{
    public var x : Float;
    public var y : Float;
    public var speed : Float;

    public var _move_vector : FlxVector;

    private var _target : Actor;

    public function new(TargetActor : Actor, X : Float, Y : Float, Speed : Float) : Void
    {
        super();

        x = X;
        y = Y;
        speed = Speed;

        _move_vector = FlxVector.get(0, 0);
        _target = TargetActor;
    }

    override public function update() : Void
    {
        if (_target.position.x != x || _target.position.y != y)
        {
            _move_vector.x = x - _target.position.x;
            _move_vector.y = y - _target.position.y;
            _move_vector.normalize();

            var new_pos : FlxPoint = FlxPoint.weak(_target.position.x + _move_vector.x * speed, _target.position.y + _move_vector.y * speed);

            if (new_pos.distanceTo(FlxPoint.weak(x, y)) < speed)
                _target.setPosition(x, y);
            else
                _target.setPosition(new_pos.x, new_pos.y);
        }
        else
        {
            _state = BehaviorState.SUCCEEDED;
            trace('MoveTo: SUCCEEDED');
        }
    }
}

class Chase extends Behavior
{
    private var _self : Actor;
    private var _current_target : Actor = null;

    public var speed : Float;

    public function new(Self : Actor, Speed : Float) : Void
    {
        super();

        _self = Self;
        speed = Speed;
    }

    override public function update() : Void
    {
        if (_current_target == null)
        {
            for (p in Reg.state.players)
            {
                if (p.position.distanceTo(_self.position) < 75)
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
            if (_self.position.distanceTo(_current_target.position) > 75)
            {
                trace('abandoning target.');
                _current_target = null;
            }
            else
            {
                var mv : FlxVector = FlxVector.get();

                mv.x = _current_target.position.x - _self.position.x;
                mv.y = _current_target.position.y - _self.position.y;
                mv.normalize();

                var new_pos : FlxPoint = FlxPoint.weak(_self.position.x + mv.x * speed, _self.position.y + mv.y * speed);

                _self.setPosition(new_pos.x, new_pos.y);

                if (FlxCollision.pixelPerfectCheck(_self.sprite, _current_target.sprite))
                {
                    trace('CAUGHT EM!');
                    _state = BehaviorState.SUCCEEDED;
                }
            }
        }
    }
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