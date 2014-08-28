package;

import Actor.TestActor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
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
	public var players : FlxTypedGroup<Player>;
	public var enemies : FlxTypedGroup<Enemy>;
	public var testers : FlxTypedGroup<TestActor>;
    public var bullets : FlxTypedGroup<FlxSprite>;
	private var _script_manager : ScriptManager;
	private var _behavior_manager : BehaviorManager;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		Reg.state = this;
		_script_manager = new ScriptManager();
		Reg.script_manager = _script_manager;

		_behavior_manager = new BehaviorManager();
		Reg.behavior_manager = _behavior_manager;


        bullets = new FlxTypedGroup<FlxSprite>(32);
        for (i in 0...32)
        {
        	var b : FlxSprite = new FlxSprite(-100, -100);
        	b.makeGraphic(5, 5, FlxColor.FUCHSIA);
        	b.width = b.height = 5;
        	b.exists = false;

        	bullets.add(b);
        }
		add(bullets);

		players = new FlxTypedGroup<Player>();
		for (i in 0...20)
		{
			var p = new Player(Std.string(i));
			p.setPosition(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height));

			players.add(p);
		}

		add(players);

		enemies = new FlxTypedGroup<Enemy>();
		for (i in 0...10)
		{
			var e : Enemy = new Enemy(Std.string(i));
			e.setPosition(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height));

			enemies.add(e);
		}
		add(enemies);

		testers = new FlxTypedGroup<TestActor>();
		for (i in 0...5)
		{
			var t = new TestActor();
			t.setPosition(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height));
			testers.add(t);
		}
		add(testers);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();

		players = FlxDestroyUtil.destroy(players);
		enemies = FlxDestroyUtil.destroy(enemies);
		testers = FlxDestroyUtil.destroy(testers);
		bullets = FlxDestroyUtil.destroy(bullets);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		FlxG.overlap(bullets, players, bulletHitsPlayer);
	}

	private function bulletHitsPlayer(Object1 : FlxObject, Object2 : FlxObject) : Void
	{
		Object1.kill();
		Object2.kill();
	}
}