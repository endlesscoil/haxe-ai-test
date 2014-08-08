
package ;

import Behavior.BehaviorState;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

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