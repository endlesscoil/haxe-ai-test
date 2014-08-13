
package ;

import ScriptBehavior.BehaviorState;

class Brain
{
    private var _behavior : ScriptBehavior = null;
    private var _body : Actor;

    public function new(Body : Actor, ?InitialBehavior : ScriptBehavior) : Void
    {
    	_body = Body;
    	_behavior = InitialBehavior;

    	if (_behavior != null)
    		_behavior.start(_body);
    }

    public function update() : Void
    {
    	//trace('_Behavior.state=${_behavior.state}');
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

        _behavior.start(_body);
    }
}