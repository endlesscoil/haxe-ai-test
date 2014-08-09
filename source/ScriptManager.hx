
package ;

import sys.FileSystem;
import flixel.FlxG;
import sys.io.File;

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

        trace('test: ' + AssetPaths.test__hscript);

        load_scripts();
    }

    public function execute(ScriptName : String) : Bool
    {
        try
        {
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

        var files = FileSystem.readDirectory(SCRIPT_DIRECTORY);
        for (name in files)
        {
            var script : String = File.getContent(SCRIPT_DIRECTORY + name);
            try 
            {
                var ast : hscript.Expr = _parser.parseString(script);

                _scripts.set(SCRIPT_DIRECTORY + name, ast);
            }
            catch(err : Dynamic)
            {
                trace('Error parsing script $name: $err');
            }
        }
    }
}