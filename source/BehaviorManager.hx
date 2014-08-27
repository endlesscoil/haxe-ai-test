
package ;

import haxe.Json;
import ScriptBehavior.SequenceBehavior;

class BehaviorManager 
{
	private static inline var BEHAVIOR_DIRECTORY : String = "assets/behaviors/";

	private var _behaviors : Map<String, ScriptBehavior>;
	public function get_behavior(Name : String) : ScriptBehavior
	{
        var template = _behaviors.get(Name);

		return template.clone();
	}

	public function new() : Void
	{
		load_behaviors();
	}

	private function load_behaviors() : Void
	{
		_behaviors = new Map<String, ScriptBehavior>();

        for (ass in openfl.Assets.list())
        {
            if (ass.indexOf(BEHAVIOR_DIRECTORY) != -1)
            {
                var behavior_string : String = openfl.Assets.getText(ass);

                try 
                {
                    var behavior_def : Dynamic = Json.parse(behavior_string);

                    #if DEBUG_BEHAVIORS
                    trace('loaded $ass - ' + behavior_def.type);
                    #end

                    var b : ScriptBehavior = build_behavior(behavior_def);

                    _behaviors.set(ass, b);
                }
                catch(err : Dynamic)
                {
                    trace('Error parsing script $ass: $err');
                }
            }
        }
	}

	private function build_behavior(behavior_def : Dynamic) : ScriptBehavior
	{
        #if DEBUG_BEHAVIORS
		trace('building behavior: $behavior_def');
        #end

		var behavior : ScriptBehavior = null;

		switch(behavior_def.type)
		{
			case "sequence":
				behavior = build_sequence(behavior_def);
			case "repeat":
				behavior = build_repetition(behavior_def);
			case "script":
				behavior = build_script(behavior_def);
		}

		return behavior;
	}

	private function build_sequence(behavior_def : Dynamic) : ScriptBehavior
	{
        #if DEBUG_BEHAVIORS
		trace('building sequence: $behavior_def');
        #end

		var behaviors : Array<ScriptBehavior> = new Array<ScriptBehavior>();
		var behavior : SequenceBehavior = null;

		for (i in 0...behavior_def.actions.length)
		{
			var b : ScriptBehavior = build_behavior(behavior_def.actions[i]);

			behaviors.push(b);
		}

		behavior = new SequenceBehavior(behaviors);

		return behavior;
	}

	private function build_repetition(behavior_def : Dynamic) : ScriptBehavior
	{
        #if DEBUG_BEHAVIORS
		trace('building repetition: $behavior_def');
        #end

		var behavior : ScriptBehavior = null;

		var temp_behavior : ScriptBehavior = build_behavior(behavior_def.action);
		behavior = new ScriptBehavior.RepeatBehavior(temp_behavior, behavior_def.count);

		return behavior;
	}

	private function build_script(behavior_def : Dynamic) : ScriptBehavior
	{
		var behavior : ScriptBehavior = null;

		behavior = new ScriptBehavior("assets/scripts/" + behavior_def.action + ".hscript", behavior_def.params);

		return behavior;
	}
}