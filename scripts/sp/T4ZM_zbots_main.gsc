#include common_scripts\utility;
#include maps\_utility;
#include scripts\sp\bots\_bot_utility;

/*
	Initiates the whole bot scripts.
*/
init()
{
	level.bw_VERSION = "2.1.0";

	if ( getDvar( "bots_main" ) == "" )
		setDvar( "bots_main", true );

	if ( !getDvarInt( "bots_main" ) )
		return;

	//thread load_waypoints(); //Don't call for now
	thread hook_callbacks();

	if ( getDvar( "bots_main_GUIDs" ) == "" )
		setDvar( "bots_main_GUIDs", "" ); //guids of players who will be given host powers, comma seperated

	if ( getDvar( "bots_main_firstIsHost" ) == "" )
		setDvar( "bots_main_firstIsHost", true ); //first player to connect is a host

	if ( getDvar( "bots_main_waitForHostTime" ) == "" )
		setDvar( "bots_main_waitForHostTime", 10.0 ); //how long to wait to wait for the host player

	if ( getDvar( "bots_main_kickBotsAtEnd" ) == "" )
		setDvar( "bots_main_kickBotsAtEnd", false ); //kicks the bots at game end

	if ( getDvar( "bots_manage_add" ) == "" )
		setDvar( "bots_manage_add", 0 ); //amount of bots to add to the game

	if ( getDvar( "bots_manage_fill" ) == "" )
		setDvar( "bots_manage_fill", 0 ); //amount of bots to maintain

	if ( getDvar( "bots_manage_fill_mode" ) == "" )
		setDvar( "bots_manage_fill_mode", 0 ); //fill mode, 0 adds everyone, 1 just bots, 2 maintains at maps, 3 is 2 with 1

	if ( getDvar( "bots_manage_fill_kick" ) == "" )
		setDvar( "bots_manage_fill_kick", false ); //kick bots if too many

	if ( getDvar( "bots_skill" ) == "" )
		setDvar( "bots_skill", 0 ); //0 is random, 1 is easy 7 is hard, 8 is custom, 9 is completely random

	if ( getDvar( "bots_skill_hard" ) == "" )
		setDvar( "bots_skill_hard", 0 ); //amount of hard bots on axis team

	if ( getDvar( "bots_skill_med" ) == "" )
		setDvar( "bots_skill_med", 0 );

	if ( getDvar( "bots_loadout_rank" ) == "" ) // what rank the bots should be around, -1 is around the players, 0 is all random
		setDvar( "bots_loadout_rank", -1 );

	if ( getDvar( "bots_loadout_prestige" ) == "" ) // what pretige the bots will be, -1 is the players, -2 is random
		setDvar( "bots_loadout_prestige", -1 );

	if ( getDvar( "bots_play_move" ) == "" ) //bots move
		setDvar( "bots_play_move", true );

	if ( getDvar( "bots_play_knife" ) == "" ) //bots knife
		setDvar( "bots_play_knife", true );

	if ( getDvar( "bots_play_fire" ) == "" ) //bots fire
		setDvar( "bots_play_fire", true );

	if ( getDvar( "bots_play_nade" ) == "" ) //bots grenade
		setDvar( "bots_play_nade", true );

	if ( getDvar( "bots_play_ads" ) == "" ) //bot ads
		setDvar( "bots_play_ads", true );

	if ( getDvar( "bots_play_aim" ) == "" )
		setDvar( "bots_play_aim", true );

	if ( !isDefined( game["botWarfare"] ) )
		game["botWarfare"] = true;

	level.bots_minSprintDistance = 315;
	level.bots_minSprintDistance *= level.bots_minSprintDistance;
	level.bots_minGrenadeDistance = 256;
	level.bots_minGrenadeDistance *= level.bots_minGrenadeDistance;
	level.bots_maxGrenadeDistance = 1024;
	level.bots_maxGrenadeDistance *= level.bots_maxGrenadeDistance;
	level.bots_maxKnifeDistance = 80;
	level.bots_maxKnifeDistance *= level.bots_maxKnifeDistance;
	level.bots_goalDistance = 27.5;
	level.bots_goalDistance *= level.bots_goalDistance;
	level.bots_noADSDistance = 200;
	level.bots_noADSDistance *= level.bots_noADSDistance;
	level.bots_maxShotgunDistance = 500;
	level.bots_maxShotgunDistance *= level.bots_maxShotgunDistance;

	level.players = [];
	level.bots = [];

	level.bots_fullautoguns = [];
	level.bots_fullautoguns["thompson"] = true;
	level.bots_fullautoguns["mp40"] = true;
	level.bots_fullautoguns["type100smg"] = true;
	level.bots_fullautoguns["ppsh"] = true;
	level.bots_fullautoguns["stg44"] = true;
	level.bots_fullautoguns["30cal"] = true;
	level.bots_fullautoguns["mg42"] = true;
	level.bots_fullautoguns["dp28"] = true;
	level.bots_fullautoguns["bar"] = true;
	level.bots_fullautoguns["fg42"] = true;
	level.bots_fullautoguns["type99lmg"] = true;

	level thread onPlayerConnect();
	level thread handleBots();
}

/*
	Starts the threads for bots.
*/
handleBots()
{
	level thread diffBots();
	level addBots();

	while ( !level.intermission )
		wait 0.05;

	setDvar( "bots_manage_add", getBotArray().size );

	if ( !getDvarInt( "bots_main_kickBotsAtEnd" ) )
		return;

	bots = getBotArray();

	for ( i = 0; i < bots.size; i++ )
	{
		bots[i] RemoveTestClient();
	}
}

/*
	The hook callback for when any player becomes damaged.
*/
onPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset )
{
	if ( self is_bot() )
	{
		//self scripts\sp\bots\_bot_internal::onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset );
		self scripts\sp\bots\_bot_script::onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset );
	}

	self [[level.prevCallbackPlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, timeOffset );
}

/*
	Starts the callbacks.
*/
hook_callbacks()
{
	wait 0.05;
	level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::onPlayerDamage;
}

/*
	Thread when any player connects. Starts the threads needed.
*/
onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );

		player thread connected();
	}
}

/*
	When a bot disconnects.
*/
onDisconnectAll()
{
	self waittill( "disconnect" );

	level.players = array_remove( level.players, self );
}

/*
	When a bot disconnects.
*/
onDisconnect()
{
	self waittill( "disconnect" );

	level.bots = array_remove( level.bots, self );
}

/*
	Called when a player connects.
*/
connected()
{
	self endon( "disconnect" );

	if ( !isDefined( self.pers["bot_host"] ) )
		self thread doHostCheck();

	level.players[level.players.size] = self;
	self thread onDisconnectAll();

	if ( !self is_bot() )
		return;

	if ( !isDefined( self.pers["isBot"] ) )
	{
		// fast restart...
		self.pers["isBot"] = true;
	}

	if ( !isDefined( self.pers["isBotWarfare"] ) )
	{
		self.pers["isBotWarfare"] = true;
		self thread added();
	}

	self thread scripts\sp\bots\_bot_internal::connected();
	self thread scripts\sp\bots\_bot_script::connected();

	level.bots[level.bots.size] = self;
	self thread onDisconnect();

	level notify( "bot_connected", self );

	self thread watchBotDebugEvent();
}

/*
	DEBUG
*/
watchBotDebugEvent()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "bot_event", msg, str, b, c, d, e, f, g );

		if ( msg == "debug" && GetDvarInt( "bots_main_debug" ) )
		{
			PrintConsole( "Bot Warfare debug: " + self.name + ": " + str + "\n" );
		}
	}
}

/*
	When a bot gets added into the game.
*/
added()
{
	self endon( "disconnect" );

	self thread scripts\sp\bots\_bot_internal::added();
	//self thread scripts\sp\bots\_bot_script::added();
}

/*
	Adds a bot to the game.
*/
add_bot()
{
	bot = addtestclient();

	if ( isdefined( bot ) )
	{
		bot.pers["isBot"] = true;
		bot.pers["isBotWarfare"] = true;
		bot thread added();
	}
}

/*
	A server thread for monitoring all bot's difficulty levels for custom server settings.
*/
diffBots_loop()
{
	var_hard = getDVarInt( "bots_skill_hard" );
	var_med = getDVarInt( "bots_skill_med" );
	var_skill = getDvarInt( "bots_skill" );

	hard = 0;
	med = 0;

	if ( var_skill == 8 )
	{
		playercount = level.players.size;

		for ( i = 0; i < playercount; i++ )
		{
			player = level.players[i];

			if ( !isDefined( player.pers["team"] ) )
				continue;

			if ( !player is_bot() )
				continue;

			if ( hard < var_hard )
			{
				hard++;
				player.pers["bots"]["skill"]["base"] = 7;
			}
			else if ( med < var_med )
			{
				med++;
				player.pers["bots"]["skill"]["base"] = 4;
			}
			else
				player.pers["bots"]["skill"]["base"] = 1;
		}
	}
	else if ( var_skill != 0 && var_skill != 9 )
	{
		playercount = level.players.size;

		for ( i = 0; i < playercount; i++ )
		{
			player = level.players[i];

			if ( !player is_bot() )
				continue;

			player.pers["bots"]["skill"]["base"] = var_skill;
		}
	}
}

/*
	A server thread for monitoring all bot's difficulty levels for custom server settings.
*/
diffBots()
{
	for ( ;; )
	{
		wait 1.5;

		diffBots_loop();
	}
}

/*
	A server thread for monitoring all bot's in game. Will add and kick bots according to server settings.
*/
addBots_loop()
{
	botsToAdd = GetDvarInt( "bots_manage_add" );

	if ( botsToAdd > 0 )
	{
		SetDvar( "bots_manage_add", 0 );

		if ( botsToAdd > 4 )
			botsToAdd = 4;

		for ( ; botsToAdd > 0; botsToAdd-- )
		{
			level add_bot();
			wait 0.25;
		}
	}

	fillMode = getDVarInt( "bots_manage_fill_mode" );

	if ( fillMode == 2 || fillMode == 3 )
		setDvar( "bots_manage_fill", getGoodMapAmount() );

	fillAmount = getDvarInt( "bots_manage_fill" );

	players = 0;
	bots = 0;

	playercount = level.players.size;

	for ( i = 0; i < playercount; i++ )
	{
		player = level.players[i];

		if ( player is_bot() )
			bots++;
		else
			players++;
	}

	amount = bots;

	if ( fillMode == 0 || fillMode == 2 )
		amount += players;

	if ( amount < fillAmount )
		setDvar( "bots_manage_add", 1 );
	else if ( amount > fillAmount && getDvarInt( "bots_manage_fill_kick" ) )
	{
		tempBot = PickRandom( getBotArray() );

		if ( isDefined( tempBot ) )
			tempBot RemoveTestClient();
	}
}

/*
	A server thread for monitoring all bot's in game. Will add and kick bots according to server settings.
*/
addBots()
{
	level endon( "game_ended" );

	bot_wait_for_host();

	for ( ;; )
	{
		wait 1.5;

		addBots_loop();
	}
}
