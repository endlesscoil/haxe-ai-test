package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import Actor.Player;
import Actor.Enemy;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var players : Array<Player>;
	public var enemies : Array<Enemy>;
	private var _script_manager : ScriptManager;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_script_manager = new ScriptManager();
		_script_manager.execute(AssetPaths.test__hscript);

		players = new Array<Player>();
		for (i in 1...5)
		{
			var p = new Player();
			p.setPosition(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height));

			add(p.sprite);
			players.push(p);
		}

		enemies = new Array<Enemy>();
		for (i in 1...20)
		{
			var e : Enemy = new Enemy();
			e.setPosition(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height));

			add(e.sprite);
			enemies.push(e);
		}

		Reg.state = this;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();

		for (p in players)
		{
			p.destroy();
		}

		for (e in enemies)
		{
			e.destroy();
		}
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		for (p in players)
		{
			p.update();
		}

		for (e in enemies)
		{
			e.update();
		}
	}	

	public function test_hscript() : Void
	{
        var interp = new hscript.Interp();
        var parser = new hscript.Parser();

		var script = "

			var x = FlxG.width; 
			trace('x=' + Std.string(x));

			function foo()
			{
				for (p in state.players)
				{
					trace('p=' + Std.string(p));
				}
			}
		";

		var ast = parser.parseString(script);

		interp.variables.set("Std", Std);
		interp.variables.set("FlxG", FlxG);
		interp.variables.set("state", Reg.state);

		trace(interp.execute(ast));
	}
}