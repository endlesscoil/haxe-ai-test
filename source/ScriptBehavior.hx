
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
    public var script_state : Dynamic = {};

    public var state(get, set) : BehaviorState;
    public function get_state() : BehaviorState return script_state.state;
    public function set_state(State : BehaviorState) : BehaviorState return script_state.state = State;

    public function new(Name : String, ?InitialScriptState : Dynamic) : Void 
    { 
    	_manager = Reg.script_manager;
    	_script_name = Name;

    	if (InitialScriptState != null)
    		script_state = InitialScriptState;

    	state = BehaviorState.IDLE;
    }
    public function start() : Void { state = BehaviorState.RUNNING; }

    public function update() : Void 
    { 
    	_manager.execute(_script_name, script_state);
    }

    public function reset() : Void { state = BehaviorState.IDLE; }
}

class RepeatBehavior extends ScriptBehavior
{
	private var _repeat_count : Int = 1;
	private var _repetition : Int = 0;
	private var _action : ScriptBehavior;

	public function new(Action : ScriptBehavior, ?RepeatCount : Int = 1, ?InitialScriptState : Dynamic) : Void
	{
		super("", InitialScriptState);

		_action = Action;
		_repeat_count = RepeatCount;
	}

	override public function start() : Void
	{
		state = BehaviorState.RUNNING;
		_action.start();
	}

	override public function update() : Void
	{
		if (_repeat_count != -1 && _repetition > _repeat_count)
		{
			state = BehaviorState.SUCCEEDED;
			return;
		}

		_repetition += 1;

		_action.update();
	}
}

class SequenceBehavior extends ScriptBehavior
{
	private var _actions : Array<ScriptBehavior>;
	private var _current_idx : Int = -1;

	public function new(Actions : Array<ScriptBehavior>, ?InitialScriptState : Dynamic) : Void
	{
		super("", InitialScriptState);

		_actions = Actions;
	}

	override public function update() : Void
	{
		trace('Sequence update: ${_current_idx}');

		if (_current_idx == -1 || _actions[_current_idx].state != BehaviorState.RUNNING)
		{
			_current_idx++;
			if (_current_idx > _actions.length - 1)
			{
				trace('SEQUENCE COMPLETE!');
				state = BehaviorState.SUCCEEDED;
				return;
			}

			_actions[_current_idx].script_state.body = script_state.body;
			_actions[_current_idx].start();
		}

		_actions[_current_idx].update();
	}
}