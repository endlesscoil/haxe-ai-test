
package ;

import haxe.Json;
import ScriptBehavior.SequenceBehavior;
import sys.FileSystem;
import sys.io.File;

class BehaviorManager 
{
	private static inline var BEHAVIOR_DIRECTORY : String = "assets/behaviors/";

	private var _behaviors : Map<String, ScriptBehavior>;
	public function get_behavior(Name : String) : ScriptBehavior
	{
		return _behaviors.get(Name);
	}

	public function new() : Void
	{
		load_behaviors();
	}


	
	private function load_behaviors() : Void
	{
		_behaviors = new Map<String, ScriptBehavior>();

        var files = FileSystem.readDirectory(BEHAVIOR_DIRECTORY);
        for (name in files)
        {
            var behavior_string : String = File.getContent(BEHAVIOR_DIRECTORY + name);
            try 
            {
            	var behavior_def : Dynamic = Json.parse(behavior_string);

            	trace('loaded $name - ' + behavior_def.type);

            	var b : ScriptBehavior = build_behavior(behavior_def);

                _behaviors.set(BEHAVIOR_DIRECTORY + name, b);
            }
            catch(err : Dynamic)
            {
                trace('Error parsing behavior $name: $err');
            }
        }
	}

	private function build_behavior(behavior_def : Dynamic) : ScriptBehavior
	{
		trace('building behavior: $behavior_def');
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
		trace('building sequence: $behavior_def');
		var behaviors : Array<ScriptBehavior> = new Array<ScriptBehavior>();
		var behavior : SequenceBehavior = null;

		for (i in 0...behavior_def.actions.length)
		{
			var b : ScriptBehavior = build_behavior(behavior_def.actions[i]);

			behaviors.push(b);
		}

		behavior = new SequenceBehavior(behaviors);

		trace('\tbehaviors: $behaviors');

		return behavior;
	}

	private function build_repetition(behavior_def : Dynamic) : ScriptBehavior
	{
		trace('building repetition: $behavior_def');
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