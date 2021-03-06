
package ;

import flixel.FlxG;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxVector;

import ScriptBehavior.BehaviorState;

class ScriptManager 
{
    private inline static var SCRIPT_DIRECTORY = 'assets/scripts/';

    private var _interpreter : hscript.Interp;
    private var _parser : hscript.Parser;
    private var _scripts : Map<String, hscript.Expr>;

    public function new() : Void
    {
        _interpreter = new hscript.Interp();
        _parser = new hscript.Parser();

        _interpreter.variables.set("Std", Std);
        _interpreter.variables.set("Now", Date.now);
        _interpreter.variables.set("FlxG", FlxG);
        _interpreter.variables.set("FlxRandom", FlxRandom);
        _interpreter.variables.set("FlxPoint", FlxPoint);
        _interpreter.variables.set("FlxVector", FlxVector);
        _interpreter.variables.set("FlxCollision", FlxCollision);
        _interpreter.variables.set("FlxSpriteUtil", FlxSpriteUtil);
        _interpreter.variables.set("BehaviorState", BehaviorState);
        _interpreter.variables.set("GameState", Reg.state);

        load_scripts();
    }

    public function execute(ScriptName : String, ScriptState : Dynamic) : Bool
    {
        try
        {
            _interpreter.variables.set("Script", ScriptState);

            #if DEBUG_BEHAVIORS
            trace('*** executing $ScriptName -> ${ScriptState}');
            #end

            _interpreter.execute(_scripts.get(ScriptName));

            return true;
        }
        catch(err : Dynamic)
        {
            trace('Error executing script $ScriptName: $err');
            return false;
        }
    }

    private function load_scripts() : Void
    {
        _scripts = new Map<String, hscript.Expr>();

        for (ass in openfl.Assets.list())
        {
            if (ass.indexOf(SCRIPT_DIRECTORY) != -1)
            {
                var script : String = openfl.Assets.getText(ass);

                try 
                {
                    var ast : hscript.Expr = _parser.parseString(script);

                    _scripts.set(ass, ast);
                }
                catch(err : Dynamic)
                {
                    trace('Error parsing script $ass: $err');
                }
            }
        }
    }
}