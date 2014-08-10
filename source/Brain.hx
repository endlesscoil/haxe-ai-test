
package ;

import ScriptBehavior.BehaviorState;

class Brain
{
    private var _behavior : ScriptBehavior = null;
    private var _body : Actor;

    public function new(?InitialBehavior : ScriptBehavior) : Void
    {
    	_behavior = InitialBehavior;

    	if (_behavior != null)
    		_behavior.start();
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
        //_behavior.script_state.body = _body;

        _behavior.start();
    }

    public function set_body(Body : Actor) : Void
    {
    	_body = Body;

    	if (_behavior != null)
    		_behavior.script_state.body = _body;
    }
}