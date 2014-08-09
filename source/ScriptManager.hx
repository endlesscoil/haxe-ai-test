
package ;

import hscript;
import flixel.FlxG;

class ScriptManager 
{
    private var _interpreter : Interp;
    private var _parser : Parser;
    private var _scripts : Map<String, String>;

    public function new() : Void
    {
        _interpreter = new Interp();
        _parser = new Parser();

        load_scripts();
    }

    private function load_scripts() : Void
    {
        _scripts = new Map<String, String>();
    }
}