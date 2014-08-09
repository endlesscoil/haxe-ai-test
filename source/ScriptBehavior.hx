
package ;

enum BehaviorState
{
    IDLE;
    RUNNING;
    SUCCEEDED;
    FAILED;
}

class ScriptBehavior 
{
    public static function MoveTo(Body : Actor, X : Float, Y : Float, Speed : Float)
    {
        return new ScriptBehavior(AssetPaths.MoveTo__hscript, { body: Body, x: X, y: Y, speed: Speed } );
    }

    public static function Chase(Body : Actor, Speed : Float)
    {
        return new ScriptBehavior(AssetPaths.Chase__hscript, { body: Body, speed: Speed });
    }

    private var _manager : ScriptManager;
    private var _script_name : String;
    private var _script_state : Dynamic = {};

    public var state(get, set) : BehaviorState;
    public function get_state() : BehaviorState return _script_state.state;
    public function set_state(State : BehaviorState) : BehaviorState return _script_state.state = State;

    public function new(Name : String, ?InitialScriptState : Dynamic) : Void 
    { 
    	_manager = Reg.script_manager;
    	_script_name = Name;

    	if (InitialScriptState != null)
    		_script_state = InitialScriptState;

    	state = BehaviorState.IDLE;
    }
    public function start() : Void { state = BehaviorState.RUNNING; }

    public function update() : Void 
    { 
    	_manager.execute(_script_name, _script_state);
    }

    public function reset() : Void { state = BehaviorState.IDLE; }
}