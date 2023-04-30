#include maps\_utility;
#include common_scripts\utility;

main()
{
	if ( GetDvarInt( "scr_disableHotJoinFixes" ) )
		return;

	level.endGameInCommonZombiemode = [];
	level.endGameInCommonZombiemode["nazi_zombie_sumpf"] = true;

	if ( isDedicated() )
	{
		// we are always in coop mode for dedis
		is_coop = getFunction( "maps/_utility", "is_coop" );

		if ( isDefined( is_coop ) )
			replaceFunc( is_coop, ::alwaysTrue );


		// make lowest player num the host
		get_host = getFunction( "maps/_utility", "get_host" );

		if ( isDefined( get_host ) )
			replaceFunc( get_host, ::getHostDedi );


		// no force Ending
		forceEnd = getFunction( "maps/_cooplogic", "forceend" );

		if ( isDefined( forceEnd ) )
			replaceFunc( forceEnd, ::noop );


		// fix this gsc thread leak in the vanilla game
		ammo_dialog_timer = getFunction( "maps/_zombiemode", "ammo_dialog_timer" );

		if ( isDefined( ammo_dialog_timer ) )
			replaceFunc( ammo_dialog_timer, ::ammo_dialog_timer_func );


		// add a timeout for all_players_connected
		all_players_connected = getFunction( "maps/_load", "all_players_connected" );

		if ( isDefined( all_players_connected ) )
			replaceFunc( all_players_connected, ::all_players_connected_func );
	}
}

init()
{
	if ( GetDvarInt( "scr_disableHotJoinFixes" ) )
		return;

	// do prints, handle hotjoining and leavers
	level thread onPlayerConnect();

	// lets be the last to setup func ptrs
	for ( i = 0; i < 10; i++ )
		waittillframeend;

	if ( !isDefined( level.script ) )
		level.script = Tolower( GetDvar( "mapname" ) );

	// setup hot joining
	level.oldSpawnClient = level.spawnClient;
	level.spawnClient = ::spawnClientOverride;

	if ( !isDefined( level.hotJoinPlayer ) )
		level.hotJoinPlayer = ::hotJoin;

	// setup how endgame
	if ( !isDefined( level.endGame ) )
	{
		if ( level.script == "nazi_zombie_prototype" )
			level.endGame = ::endGamePrototype;
		else if ( level.script == "nazi_zombie_asylum" )
			level.endGame = ::endGameAsylum;
		else if ( isDefined( level.endGameInCommonZombiemode[level.script] ) )
			level.endGame = ::endGameCommonZombiemodeScript;
		else if ( isZombieMode() )
			level.endGame = ::endGameNotify;
		else
			level.endGame = ::endGameSP;
	}

	if ( !isDefined( level.isPlayerDead ) )
		level.isPlayerDead = ::checkIsPlayerDead;

	// make dead players into spectators
	if ( isZombieMode() )
	{
		level.oldOverridePlayerKilled = level.overridePlayerKilled;
		level.overridePlayerKilled = ::playerKilledOverride;

		// setup this callback
		zmb_spawnSpectator = GetFunction( "maps/_callbackglobal", "spawnspectator" );

		if ( isDefined( zmb_spawnSpectator ) && level.spawnSpectator == zmb_spawnSpectator )
		{
			if ( level.script == "nazi_zombie_prototype" )
			{
				zmb_spawnSpectator = GetFunction( "maps/_zombiemode_prototype", "spawnspectator" );

				if ( isDefined( zmb_spawnSpectator ) )
					level.spawnSpectator = zmb_spawnSpectator;
			}
			else if ( level.script == "nazi_zombie_asylum" )
			{
				zmb_spawnSpectator = GetFunction( "maps/_zombiemode_asylum", "spawnspectator" );

				if ( isDefined( zmb_spawnSpectator ) )
					level.spawnSpectator = zmb_spawnSpectator;
			}
			else
			{
				zmb_spawnSpectator = GetFunction( "maps/_zombiemode", "spawnspectator" );

				if ( isDefined( zmb_spawnSpectator ) )
					level.spawnSpectator = zmb_spawnSpectator;
			}
		}
	}
}

getHostDedi()
{
	return get_players()[0];
}

alwaysTrue()
{
	return true;
}

noop()
{
}

all_players_connected_func()
{
	timeout_started = false;
	timeout_point = 0;

	while ( 1 )
	{
		num_con = getnumconnectedplayers();
		num_exp = getnumexpectedplayers();

		if ( num_con == num_exp && ( num_exp != 0 ) )
			break;

		if ( num_con > 0 )
		{
			if ( !timeout_started )
			{
				timeout_started = true;
				timeout_point = getDvarFloat( "sv_connecttimeout" ) * 1000 + getTime();
			}

			if ( getTime() > timeout_point )
				break;
		}
		else
			timeout_started = false;

		wait( 0.05 );
	}

	flag_set( "all_players_connected" );
	// CODER_MOD: GMJ (08/28/08): Setting dvar for use by code
	SetDvar( "all_players_are_connected", "1" );
}

ammo_dialog_timer_func()
{
	level notify( "ammo_out" );

	func = getFunction( "maps/_zombiemode", "ammo_dialog_timer" );

	if ( !isDefined( func ) )
		return;

	disableDetourOnce( func );
	self [[func]]();
}

isZombieMode()
{
	return ( isDefined( level.is_zombie_level ) && level.is_zombie_level );
}

endGamePrototype()
{
	func = getFunction( "maps/_zombiemode_prototype", "end_game" );

	if ( isDefined( func ) )
		level thread [[func]]();
}

endGameAsylum()
{
	func = getFunction( "maps/_zombiemode_asylum", "end_game" );

	if ( isDefined( func ) )
		level thread [[func]]();
}

endGameCommonZombiemodeScript()
{
	func = getFunction( "maps/_zombiemode", "end_game" );

	if ( isDefined( func ) )
		level thread [[func]]();
}

endGameNotify()
{
	level notify( "end_game" );
}

endGameSP()
{
	if ( get_players().size <= 0 )
		cmdexec( "map_restart" );
	else
		missionfailed();
}

checkIsPlayerDead( player )
{
	in_laststand_func = GetFunction( "maps/_laststand", "player_is_in_laststand" );

	return ( player.sessionstate == "spectator" || ( isDefined( in_laststand_func ) && player [[in_laststand_func]]() ) || ( isDefined( player.is_zombie ) && player.is_zombie ) );
}

playerKilledOverride()
{
	self [[level.player_becomes_zombie]]();
	checkForAllDead( self );
	self [[level.oldOverridePlayerKilled]]();
}

spawnClientOverride()
{
	if ( flag( "all_players_spawned" ) )
		self thread [[level.hotJoinPlayer]]();
	else
		self thread [[level.oldSpawnClient]]();
}

getHotJoinPlayer()
{
	players = get_players();

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !isDefined( player ) || !isDefined( player.sessionstate ) )
			continue;

		if ( player == self )
			continue;

		if ( player.sessionstate == "spectator" )
			continue;

		if ( isDefined( player.is_zombie ) && player.is_zombie )
			continue;

		return player;
	}

	return undefined;
}

getHotJoinAi( team )
{
	ais = GetAiArray( team );
	ai = undefined;

	if ( ais.size )
		ai = ais[randomint( ais.size )];

	return ai;
}

getHotJoinInitSpawn()
{
	structs = getstructarray( "initial_spawn_points", "targetname" );
	players = get_players();
	i = 0;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i] ) )
			continue;

		if ( self == players[i] )
			break;
	}

	spawn_obj = structs[i];

	if ( !isDefined( spawn_obj ) )
		spawn_obj = structs[0];

	return spawn_obj;
}

hotJoin()
{
	self endon( "disconnect" );
	self endon( "end_respawn" );

	// quik hax: prevent spectators_respawn from spawning us
	self.sessionstate = "playing";
	waittillframeend;
	self.sessionstate = "spectator";

	player = self getHotJoinPlayer();
	ally = self getHotJoinAi( "allies" );
	enemy = self getHotJoinAi( "axis" );
	spawn_pt = self getHotJoinInitSpawn();

	spawn_obj = spawnStruct();

	if ( isDefined( spawn_pt ) )
	{
		spawn_obj = spawn_pt;
	}
	else if ( isDefined( player ) )
	{
		spawn_obj.origin = player getOrigin();
		spawn_obj.angles = player.angles;
	}
	else if ( isDefined( ally ) )
	{
		spawn_obj.origin = ally getOrigin();
		spawn_obj.angles = ally.angles;
	}
	else if ( isDefined( enemy ) )
	{
		spawn_obj.origin = enemy getOrigin();
		spawn_obj.angles = enemy.angles;
	}
	else
	{
		spawn_obj.origin = ( 0, 0, 0 );
		spawn_obj.angles = ( 0, 0, 0 );
	}

	// check if custom logic for hotjoining
	if ( isDefined( level.customHotJoinPlayer ) )
	{
		temp_obj = self [[level.customHotJoinPlayer]]( spawn_obj );

		// check if theres a spawn obj
		if ( isDefined( temp_obj ) )
		{
			// check if we should cancel spawning this player (maybe its already done)
			if ( isDefined( temp_obj.cancel ) && temp_obj.cancel )
				return;

			// set our spawn location
			spawn_obj = temp_obj;
		}
	}

	// set spawn params
	self setorigin( spawn_obj.origin );
	self setplayerangles( spawn_obj.angles );
	self.spectator_respawn = spawn_obj;
	self.respawn_point = spawn_obj;

	// do the spawn
	println( "*************************Client hotjoin***" );

	self unlink();

	if ( isdefined( self.spectate_cam ) )
		self.spectate_cam delete ();

	if ( ( !isZombieMode() && !level.otherPlayersSpectate && ( !isDefined( spawn_obj.force_spectator ) || !spawn_obj.force_spectator ) ) ||
	    ( isDefined( spawn_obj.force_spawn ) && spawn_obj.force_spawn ) )
		self thread [[level.spawnPlayer]]();
	else
	{
		self thread [[level.spawnSpectator]]();
		checkForAllDead( self );
	}
}

onDisconnect()
{
	lpselfnum = self getentitynumber();
	lpguid = self getguid();
	name = self.playername;

	self waittill( "disconnect" );

	logprint( "Q;" + lpguid + ";" + lpselfnum + ";" + name + "\n" );

	// check if we need to end the game cause last person left alive left the game
	checkForAllDead( self );
}

onConnect()
{
	self endon( "disconnect" );

	logprint( "J;" + self getguid() + ";" + self getentitynumber() + ";" + self.playername + "\n" );
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );

		iprintln( player.playername + " connected." );

		player thread onDisconnect();
		player thread onConnect();
	}
}

checkForAllDead( excluded_player )
{
	players = get_players();
	count = 0;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[ i ];

		if ( !isDefined( player ) || !isDefined( player.sessionstate ) )
			continue;

		if ( isDefined( excluded_player ) && excluded_player == player )
			continue;

		if ( [[level.isPlayerDead]]( player ) )
			continue;

		count++;
	}

	if ( count == 0 )
	{
		PrintConsole( "Ending game as no players are left alive..." );
		level thread [[level.endGame]]();
	}
}
