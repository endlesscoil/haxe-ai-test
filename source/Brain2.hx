
package ;

import Behavior.BehaviorState;

class Brain2
{
    private var _behavior : ScriptBehavior = null;

    public function new() : Void
    {

    }

    public function update() : Void
    {
        if (_behavior != null && _behavior.state == BehaviorState.RUNNING)
            _behavior.update();
    }

    public function is_idle() : Bool
    {
        return _behavior.state != BehaviorState.RUNNING;
    }

    public function set_behavior(NewBehavior : ScriptBehavior) : Void
    {
        _behavior = NewBehavior;

        _behavior.start();
    }
}