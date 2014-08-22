
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
    private var _body : Actor;
    private var _initial_state : Dynamic = {};
    public var script_state : Dynamic = {};

    public var state(get, set) : BehaviorState;
    public function get_state() : BehaviorState return script_state.state;
    public function set_state(State : BehaviorState) : BehaviorState return script_state.state = State;

    public function new(Name : String, ?InitialScriptState : Dynamic) : Void 
    { 
    	_manager = Reg.script_manager;
    	_script_name = Name;

    	if (InitialScriptState != null)
    	{
    		trace('initializing states... $script_state  ...... $_initial_state .... $InitialScriptState');
    		_initial_state = InitialScriptState;
    		script_state = Reflect.copy(InitialScriptState);
    	}

    	state = BehaviorState.IDLE;
    }
    public function start(Body : Actor) : Void 
    { 
    	reset();
    	_body = Body;
    	script_state.body = Body;
    	state = BehaviorState.RUNNING;
    }

    public function update() : Void 
    { 
    	_manager.execute(_script_name, script_state);
    }

    public function reset() : Void 
    { 
    	trace('$_script_name reset');
    	trace('$script_state -> $_initial_state');
    	script_state = Reflect.copy(_initial_state);
    	state = BehaviorState.IDLE; 
    }
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

	override public function start(Body : Actor) : Void
	{
		state = BehaviorState.RUNNING;
		_action.start(Body);
	}

	override public function reset() : Void
	{
        trace('repeat reset1');
		super.reset();
		trace('Repeat reset');
		_action.reset();
		_repetition = 0;
        state = BehaviorState.IDLE;
	}

	override public function update() : Void
	{
		if (_repetition >= _repeat_count - 1)
		{
			trace('REPEAT COMPLETE');
			state = BehaviorState.SUCCEEDED;
			//reset();
			return;
		}

		//if (_action.state != BehaviorState.RUNNING)
		//	_repetition += 1;

		_action.update();
		if (_action.state == BehaviorState.SUCCEEDED)
		{
			trace('REPEAT ACTION ${_repetition} COMPLETE');
			_action.reset();
			_repetition += 1;
		}
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

	override public function reset() : Void
	{
		super.reset();
		trace('Seq reset');

		_current_idx = -1;
        state = BehaviorState.IDLE;

		for (a in _actions)
		{
			a.reset();
		}
	}

	override public function update() : Void
	{
		trace('Sequence update: ${_current_idx}');

		if (_current_idx == -1 || (_actions[_current_idx].state != BehaviorState.RUNNING && _actions[_current_idx].state != BehaviorState.IDLE))
		{
			_current_idx++;
			if (_current_idx > _actions.length - 1)
			{
				trace('SEQUENCE COMPLETE!');
				reset();
				state = BehaviorState.SUCCEEDED;
				return;
			}

			//_actions[_current_idx].script_state.body = script_state.body;
			trace('STARTING SEQ ${_current_idx}');
			_actions[_current_idx].start(_body);
		}

		trace('SEQUENCE UPDATE ${_current_idx}');
		_actions[_current_idx].update();
	}
}