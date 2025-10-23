#include maps\_utility;
#include common_scripts\utility;

#include maps\bots\_bot_utility;

main()
{
	if ( GetDvarInt( "scr_disableHotJoinFixes" ) )
	{
		return;
	}
	
	level.endGameInCommonZombiemode = [];
	level.endGameInCommonZombiemode["nazi_zombie_sumpf"] = true;
}

init()
{
	if ( GetDvarInt( "scr_disableHotJoinFixes" ) )
	{
		return;
	}

	// do prints, handle hotjoining and leavers
	level thread onPlayerConnect();
	
	if ( !isDefined( level.script ) )
	{
		level.script = Tolower( GetDvar( "mapname" ) );
	}
	
	// setup hot joining
	level.oldSpawnClient = level.spawnClient;
	wait 0.05; // vm decomp bug? required for override to work...
	level.spawnClient = ::spawnClientOverride;
	
	if ( !isDefined( level.hotJoinPlayer ) )
	{
		level.hotJoinPlayer = ::hotJoin;
	}
	
	// setup how endgame
	// if ( !isDefined( level.endGameFunc ) )
	// {
	// 	if ( level.script == "nazi_zombie_prototype" )
	// 	{
	// 		level.endGameFunc = ::endGamePrototype;
	// 	}
	// 	else if ( level.script == "nazi_zombie_asylum" )
	// 	{
	// 		level.endGameFunc = ::endGameAsylum;
	// 	}
	// 	else if ( isDefined( level.endGameInCommonZombiemode[level.script] ) )
	// 	{
	// 		level.endGameFunc = ::endGameCommonZombiemodeScript;
	// 	}
	// 	else if ( isZombieMode() )
	// 	{
	// 		level.endGameFunc = ::endGameNotify;
	// 	}
	// 	else
	// 	{
	// 		level.endGameFunc = ::endGameSP;
	// 	}
	// }
	
	if ( !isDefined( level.isPlayerDead ) )
	{
		level.isPlayerDead = ::checkIsPlayerDead;
	}
	
	// make dead players into spectators
	// if ( isZombieMode() )
	// {
	// 	level.oldOverridePlayerKilled = level.overridePlayerKilled;
	// 	level.overridePlayerKilled = ::playerKilledOverride;
		
	// 	// setup this callback
	// 	zmb_spawnSpectator = GetFunction( "maps/_callbackglobal", "spawnspectator" );
		
	// 	if ( isDefined( zmb_spawnSpectator ) && level.spawnSpectator == zmb_spawnSpectator )
	// 	{
	// 		if ( level.script == "nazi_zombie_prototype" )
	// 		{
	// 			zmb_spawnSpectator = GetFunction( "maps/_zombiemode_prototype", "spawnspectator" );
				
	// 			if ( isDefined( zmb_spawnSpectator ) )
	// 			{
	// 				level.spawnSpectator = zmb_spawnSpectator;
	// 			}
	// 		}
	// 		else if ( level.script == "nazi_zombie_asylum" )
	// 		{
	// 			zmb_spawnSpectator = GetFunction( "maps/_zombiemode_asylum", "spawnspectator" );
				
	// 			if ( isDefined( zmb_spawnSpectator ) )
	// 			{
	// 				level.spawnSpectator = zmb_spawnSpectator;
	// 			}
	// 		}
	// 		else
	// 		{
	// 			zmb_spawnSpectator = GetFunction( "maps/_zombiemode", "spawnspectator" );
				
	// 			if ( isDefined( zmb_spawnSpectator ) )
	// 			{
	// 				level.spawnSpectator = zmb_spawnSpectator;
	// 			}
	// 		}
	// 	}
	// }
}

isZombieMode()
{
	return ( isDefined( level.is_zombie_level ) && level.is_zombie_level );
}

// endGamePrototype()
// {
// 	func = getFunction( "maps/_zombiemode_prototype", "end_game" );
	
// 	if ( isDefined( func ) )
// 	{
// 		level thread [[func]]();
// 	}
// }

// endGameAsylum()
// {
// 	func = getFunction( "maps/_zombiemode_asylum", "end_game" );
	
// 	if ( isDefined( func ) )
// 	{
// 		level thread [[func]]();
// 	}
// }

// endGameCommonZombiemodeScript()
// {
// 	func = getFunction( "maps/_zombiemode", "end_game" );
	
// 	if ( isDefined( func ) )
// 	{
// 		level thread [[func]]();
// 	}
// }

endGameNotify()
{
	level notify( "end_game" );
}

endGameSP()
{
	missionfailed();
}

checkIsPlayerDead( player )
{
	in_laststand_func = ::player_is_in_laststand;
	
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
	{
		self thread [[level.hotJoinPlayer]]();
	}
	else
	{
		self thread [[level.oldSpawnClient]]();
	}
}

getHotJoinPlayer()
{
	players = get_players();
	
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		if ( !isDefined( player ) || !isDefined( player.sessionstate ) )
		{
			continue;
		}
		
		if ( player == self )
		{
			continue;
		}
		
		if ( player.sessionstate == "spectator" )
		{
			continue;
		}
		
		if ( isDefined( player.is_zombie ) && player.is_zombie )
		{
			continue;
		}
		
		return player;
	}
	
	return undefined;
}

getHotJoinAi( team )
{
	ais = GetAiArray( team );
	ai = undefined;
	
	if ( ais.size )
	{
		ai = ais[randomint( ais.size )];
	}
	
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
		{
			continue;
		}
		
		if ( self == players[i] )
		{
			break;
		}
	}
	
	spawn_obj = structs[i];
	
	if ( !isDefined( spawn_obj ) )
	{
		spawn_obj = structs[0];
	}
	
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
			{
				return;
			}
			
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
	{
		self.spectate_cam delete ();
	}
	
	if ( ( !isZombieMode() && !level.otherPlayersSpectate && ( !isDefined( spawn_obj.force_spectator ) || !spawn_obj.force_spectator ) ) ||
		( isDefined( spawn_obj.force_spawn ) && spawn_obj.force_spawn ) )
	{
		self thread [[level.spawnPlayer]]();
	}
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
	
	//logprint( "Q;" + lpguid + ";" + lpselfnum + ";" + name + "\n" );
	
	// check if we need to end the game cause last person left alive left the game
	checkForAllDead( self );
}

onConnect()
{
	self endon( "disconnect" );
	
	//logprint( "J;" + self getguid() + ";" + self getentitynumber() + ";" + self.playername + "\n" );
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		
		iprintln( player.playername + " connected" );
		
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
		{
			continue;
		}
		
		if ( isDefined( excluded_player ) && excluded_player == player )
		{
			continue;
		}
		
		if ( isdefined( level.isPlayerDead ) && [[level.isPlayerDead]]( player ) )
		{
			continue;
		}
		
		count++;
	}
	
	if ( count == 0 && isdefined( level.endGameFunc ) )
	{
		level thread [[level.endGameFunc]]();
	}
}
