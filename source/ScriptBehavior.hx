
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

    public function clone() : ScriptBehavior
    {
        var obj = Type.createEmptyInstance(Type.getClass(this)); 
        for(ff in Reflect.fields(this)) 
        {
            Reflect.setField(obj, ff, Reflect.field(this, ff)); 
        }

        obj._body = null;
        obj.reset();

        return obj;
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
        if (state == BehaviorState.RUNNING)
    	   _manager.execute(_script_name, script_state);
    }

    public function reset() : Void 
    {
        #if DEBUG_BEHAVIORS
    	trace('reset $script_state -> $_initial_state');
        #end

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

    override public function clone() : ScriptBehavior
    {
        var obj : RepeatBehavior = cast super.clone();

        obj._action = _action.clone();
        obj.reset();

        return obj;
    }

	override public function start(Body : Actor) : Void
	{
        super.start(Body);
		state = BehaviorState.RUNNING;
		_action.start(Body);
	}

	override public function reset() : Void
	{
		super.reset();
		_action.reset();
		_repetition = 0;
        state = BehaviorState.IDLE;
	}

	override public function update() : Void
	{
		if (_repetition >= _repeat_count - 1 && _repeat_count != -1)
		{
            #if DEBUG_BEHAVIORS
			trace('REPEAT COMPLETE');
            #end

			state = BehaviorState.SUCCEEDED;
			//reset();
			return;
		}

        if (_action.state == BehaviorState.IDLE)
            _action.start(_body);

		_action.update();
		if (_action.state == BehaviorState.SUCCEEDED)
		{
            #if DEBUG_BEHAVIORS
			trace('REPEAT ACTION ${_repetition} COMPLETE');
            #end

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

    override public function clone() : ScriptBehavior
    {
        var obj = Type.createEmptyInstance(Type.getClass(this)); 
        for(ff in Reflect.fields(this)) 
        {
            if (ff != '_actions')
                Reflect.setField(obj, ff, Reflect.field(this, ff)); 
        }

        obj._actions = new Array<ScriptBehavior>();
        for (i in 0..._actions.length)
        {
            var act : ScriptBehavior = cast _actions[i].clone();
            act.reset();
            obj._actions.push(act);
        }

        obj.reset();

        return obj;
    }

	override public function reset() : Void
	{
		super.reset();
		_current_idx = -1;
        state = BehaviorState.IDLE;

		for (a in _actions)
		{
			a.reset();
		}
	}

	override public function update() : Void
	{
		if (_current_idx == -1 || (_actions[_current_idx].state != BehaviorState.RUNNING && _actions[_current_idx].state != BehaviorState.IDLE))
		{
			_current_idx++;
			if (_current_idx > _actions.length - 1)
			{
                #if DEBUG_BEHAVIORS
				trace('SEQUENCE COMPLETE!');
                #end

				reset();
				state = BehaviorState.SUCCEEDED;
				return;
			}

            #if DEBUG_BEHAVIORS
			trace('STARTING SEQ ${_current_idx}');
            #end

			_actions[_current_idx].start(_body);
		}

        #if DEBUG_BEHAVIORS
		trace('SEQUENCE UPDATE ${_current_idx}');
        #end
        
		_actions[_current_idx].update();
	}
}