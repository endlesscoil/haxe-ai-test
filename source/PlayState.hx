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
	private var _player : Player;
	private var _enemies : Array<Enemy>;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_player = new Player("Bob");
		_player.setPosition(FlxG.width / 2, FlxG.height / 2);
		add(_player.sprite);

		_enemies = new Array<Enemy>();

		for (i in 1...10)
		{
			var tenemy : Enemy = new Enemy();
			tenemy.setPosition(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height));

			add(tenemy.sprite);
			_enemies.push(tenemy);
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();

		_player.destroy();

		for (e in _enemies)
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

		_player.update();
		for (e in _enemies)
		{
			e.update();
		}
	}	
}