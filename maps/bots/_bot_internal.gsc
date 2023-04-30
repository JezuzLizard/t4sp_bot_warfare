#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;

/*
	When a bot is added (once ever) to the game (before connected).
	We init all the persistent variables here.
*/
added()
{
	self endon( "disconnect" );

	self.pers["bots"] = [];

	self.pers["bots"]["skill"] = [];
	self.pers["bots"]["skill"]["base"] = 7; // a base knownledge of the bot
	self.pers["bots"]["skill"]["aim_time"] = 0.05; // how long it takes for a bot to aim to a location
	self.pers["bots"]["skill"]["init_react_time"] = 0; // the reaction time of the bot for inital targets
	self.pers["bots"]["skill"]["reaction_time"] = 0; // reaction time for the bots of reoccuring targets
	self.pers["bots"]["skill"]["no_trace_ads_time"] = 2500; // how long a bot ads's when they cant see the target
	self.pers["bots"]["skill"]["no_trace_look_time"] = 10000; // how long a bot will look at a target's last position
	self.pers["bots"]["skill"]["remember_time"] = 25000; // how long a bot will remember a target before forgetting about it when they cant see the target
	self.pers["bots"]["skill"]["fov"] = -1; // the fov of the bot, -1 being 360, 1 being 0
	self.pers["bots"]["skill"]["dist_max"] = 100000 * 2; // the longest distance a bot will target
	self.pers["bots"]["skill"]["dist_start"] = 100000; // the start distance before bot's target abilitys diminish
	self.pers["bots"]["skill"]["spawn_time"] = 0; // how long a bot waits after spawning before targeting, etc
	self.pers["bots"]["skill"]["help_dist"] = 10000; // how far a bot has awareness
	self.pers["bots"]["skill"]["semi_time"] = 0.05; // how fast a bot shoots semiauto
	self.pers["bots"]["skill"]["shoot_after_time"] = 1; // how long a bot shoots after target dies/cant be seen
	self.pers["bots"]["skill"]["aim_offset_time"] = 1; // how long a bot correct's their aim after targeting
	self.pers["bots"]["skill"]["aim_offset_amount"] = 1; // how far a bot's incorrect aim is
	self.pers["bots"]["skill"]["bone_update_interval"] = 0.05; // how often a bot changes their bone target
	self.pers["bots"]["skill"]["bones"] = "j_head"; // a list of comma seperated bones the bot will aim at
	self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5; // a factor of how much ads to reduce when adsing
	self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5; // a factor of how much more aimspeed delay to add

	self.pers["bots"]["behavior"] = [];
	self.pers["bots"]["behavior"]["strafe"] = 50; // percentage of how often the bot strafes a target
	self.pers["bots"]["behavior"]["nade"] = 50; // percentage of how often the bot will grenade
	self.pers["bots"]["behavior"]["sprint"] = 50; // percentage of how often the bot will sprint
	self.pers["bots"]["behavior"]["camp"] = 50; // percentage of how often the bot will camp
	self.pers["bots"]["behavior"]["follow"] = 50; // percentage of how often the bot will follow
	self.pers["bots"]["behavior"]["crouch"] = 10; // percentage of how often the bot will crouch
	self.pers["bots"]["behavior"]["switch"] = 1; // percentage of how often the bot will switch weapons
	self.pers["bots"]["behavior"]["class"] = 1; // percentage of how often the bot will change classes
	self.pers["bots"]["behavior"]["jump"] = 100; // percentage of how often the bot will jumpshot and dropshot

	self.pers["bots"]["behavior"]["quickscope"] = false; // is a quickscoper
	self.pers["bots"]["behavior"]["initswitch"] = 10; // percentage of how often the bot will switch weapons on spawn
}

/*
	We clear all of the script variables and other stuff for the bots.
*/
resetBotVars()
{
	self.bot.script_target = undefined;
	self.bot.script_target_offset = undefined;
	self.bot.target = undefined;
	self.bot.targets = [];
	self.bot.target_this_frame = undefined;
	self.bot.after_target = undefined;
	self.bot.after_target_pos = undefined;
	self.bot.moveTo = self.origin;

	self.bot.script_aimpos = undefined;

	self.bot.script_goal = undefined;
	self.bot.script_goal_dist = 0.0;

	self.bot.next_wp = -1;
	self.bot.second_next_wp = -1;
	self.bot.towards_goal = undefined;
	self.bot.astar = [];
	self.bot.stop_move = false;
	self.bot.greedy_path = false;
	self.bot.climbing = false;
	self.bot.wantsprint = false;
	self.bot.last_next_wp = -1;
	self.bot.last_second_next_wp = -1;

	self.bot.isfrozen = false;
	self.bot.sprintendtime = -1;
	self.bot.isreloading = false;
	self.bot.issprinting = false;
	self.bot.isfragging = false;
	self.bot.issmoking = false;
	self.bot.isfraggingafter = false;
	self.bot.issmokingafter = false;
	self.bot.isknifing = false;
	self.bot.isknifingafter = false;

	self.bot.semi_time = false;
	self.bot.jump_time = undefined;
	self.bot.last_fire_time = -1;

	self.bot.is_cur_full_auto = false;
	self.bot.cur_weap_dist_multi = 1;
	self.bot.is_cur_sniper = false;

	self.bot.rand = randomInt( 100 );

	self botStop();
}

/*
	The callback hook when the bot gets damaged.
*/
onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
}

/*
	When a bot connects to the game.
	This is called when a bot is added and when multiround gamemode starts.
*/
connected()
{
	self endon( "disconnect" );

	self.bot = spawnStruct();
	self resetBotVars();

	self thread onPlayerSpawned();
}

/*
	When the bot spawns.
*/
onPlayerSpawned()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );

		self resetBotVars();
		self thread onWeaponChange();

		self thread reload_watch();
		self thread sprint_watch();

		self thread spawned();
	}
}

/*
	When the bot changes weapon.
*/
onWeaponChange()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	first = true;

	for ( ;; )
	{
		newWeapon = undefined;

		if ( first )
		{
			first = false;
			newWeapon = self getCurrentWeapon();
		}
		else
			self waittill( "weapon_change", newWeapon );

		self.bot.is_cur_full_auto = WeaponIsFullAuto( newWeapon );
		self.bot.cur_weap_dist_multi = SetWeaponDistMulti( newWeapon );
		self.bot.is_cur_sniper = /* IsWeapSniper( newWeapon ) */ false;
	}
}

/*
	Sets the factor of distance for a weapon
*/
SetWeaponDistMulti( weap )
{
	if ( weap == "none" )
		return 1;

	switch ( weaponClass( weap ) )
	{
		case "rifle":
			return 0.9;

		case "smg":
			return 0.7;

		case "pistol":
			return 0.5;

		default:
			return 1;
	}
}

/*
	Update's the bot if it is reloading.
*/
reload_watch()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		self waittill( "reload_start" );

		self reload_watch_loop();
	}
}

/*
	Update's the bot if it is reloading.
*/
reload_watch_loop()
{
	self.bot.isreloading = true;

	while ( true )
	{
		ret = self waittill_any_timeout( 7.5, "reload" );

		if ( ret == "timeout" )
			break;

		weap = self GetCurrentWeapon();

		if ( weap == "none" )
			break;

		if ( self GetWeaponAmmoClip( weap ) >= WeaponClipSize( weap ) )
			break;
	}

	self.bot.isreloading = false;
}

/*
	Updates the bot if it is sprinting.
*/
sprint_watch()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		self waittill( "sprint_begin" );
		self.bot.issprinting = true;
		self waittill( "sprint_end" );
		self.bot.issprinting = false;
		self.bot.sprintendtime = getTime();
	}
}

/*
	We wait for a time defined by the bot's difficulty and start all threads that control the bot.
*/
spawned()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	wait self.pers["bots"]["skill"]["spawn_time"];

	self thread doBotMovement();
	self thread walk();

	self notify( "bot_spawned" );
}

/*
	Bot moves towards the point
*/
doBotMovement()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	data = spawnStruct();
	data.wasMantling = false;

	for ( data.i = 0; true; data.i += 0.05 )
	{
		wait 0.05;

		waittillframeend;
		self doBotMovement_loop( data );
	}
}

/*
	Bot moves towards the point
*/
doBotMovement_loop( data )
{
	move_To = self.bot.moveTo;
	angles = self GetPlayerAngles();
	dir = ( 0, 0, 0 );

	if ( DistanceSquared( self.origin, move_To ) >= 49 )
	{
		cosa = cos( 0 - angles[1] );
		sina = sin( 0 - angles[1] );

		// get the direction
		dir = move_To - self.origin;

		// rotate our direction according to our angles
		dir = ( dir[0] * cosa - dir[1] * sina,
		        dir[0] * sina + dir[1] * cosa,
		        0 );

		// make the length 127
		dir = VectorNormalize( dir ) * 127;

		// invert the second component as the engine requires this
		dir = ( dir[0], 0 - dir[1], 0 );
	}

	startPos = self.origin + ( 0, 0, 50 );
	startPosForward = startPos + anglesToForward( ( 0, angles[1], 0 ) ) * 25;
	bt = bulletTrace( startPos, startPosForward, false, self );

	if ( bt["fraction"] >= 1 )
	{
		// check if need to jump
		bt = bulletTrace( startPosForward, startPosForward - ( 0, 0, 40 ), false, self );

		if ( bt["fraction"] < 1 && bt["normal"][2] > 0.9 && data.i > 1.5 )
		{
			data.i = 0;
			self thread jump();
		}
	}
	// check if need to knife glass
	else if ( bt["surfacetype"] == "glass" )
	{
		if ( data.i > 1.5 )
		{
			data.i = 0;
			self thread knife();
		}
	}
	else
	{
		// check if need to crouch
		if ( bulletTracePassed( startPos - ( 0, 0, 25 ), startPosForward - ( 0, 0, 25 ), false, self ) && !self.bot.climbing )
			self crouch();
	}

	// move!
	if ( self.bot.wantsprint && self.bot.issprinting )
		dir = ( 127, dir[1], 0 );

	self botMovement( int( dir[0] ), int( dir[1] ) );
}

/*
	Bots will look at the pos
*/
bot_lookat( pos, time, vel, doAimPredict )
{
	self notify( "bots_aim_overlap" );
	self endon( "bots_aim_overlap" );
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "spawned_player" );
	level endon ( "intermission" );

	if ( level.intermission || self.bot.isfrozen || !getDvarInt( "bots_play_aim" ) )
		return;

	if ( !isDefined( pos ) )
		return;

	if ( !isDefined( doAimPredict ) )
		doAimPredict = false;

	if ( !isDefined( time ) )
		time = 0.05;

	if ( !isDefined( vel ) )
		vel = ( 0, 0, 0 );

	steps = int( time * 20 );

	if ( steps < 1 )
		steps = 1;

	myEye = self GetEyePos(); // get our eye pos

	if ( doAimPredict )
	{
		myEye += ( self getVelocity() * 0.05 ) * ( steps - 1 ); // account for our velocity

		pos += ( vel * 0.05 ) * ( steps - 1 ); // add the velocity vector
	}

	myAngle = self getPlayerAngles();
	angles = VectorToAngles( ( pos - myEye ) - anglesToForward( myAngle ) );

	X = AngleClamp180( angles[0] - myAngle[0] );
	X = X / steps;

	Y = AngleClamp180( angles[1] - myAngle[1] );
	Y = Y / steps;

	for ( i = 0; i < steps; i++ )
	{
		myAngle = ( AngleClamp180( myAngle[0] + X ), AngleClamp180( myAngle[1] + Y ), 0 );
		self setPlayerAngles( myAngle );
		wait 0.05;
	}
}

/*
	Returns true if the bot can fire their current weapon.
*/
canFire( curweap )
{
	if ( curweap == "none" )
		return false;

	return self GetWeaponammoclip( curweap );
}

/*
	Returns true if the bot is in range of their target.
*/
isInRange( dist, curweap )
{
	return true;
}

/*
	Returns true if the bot can ads their current gun.
*/
canAds( dist, curweap )
{
	return true;
}

/*
	This is the main walking logic for the bot.
*/
walk()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		wait 0.05;

		self botMoveTo( self.origin );

		if ( !getDvarInt( "bots_play_move" ) )
			continue;

		if ( level.intermission || self.bot.isfrozen || self.bot.stop_move )
			continue;

		self walk_loop();
	}
}

/*
	This is the main walking logic for the bot.
*/
walk_loop()
{
	hasTarget = isDefined( self.bot.target ) && isDefined( self.bot.target.entity );

	if ( hasTarget )
	{
		curweap = self getCurrentWeapon();

		if ( self.bot.isfraggingafter || self.bot.issmokingafter )
		{
			return;
		}

		if ( self.bot.target.trace_time && self canFire( curweap ) && self isInRange( self.bot.target.dist, curweap ) )
		{
			if ( self inLastStand() || self GetStance() == "prone" || ( self.bot.is_cur_sniper && self PlayerADS() > 0 ) )
				return;

			if ( self.bot.target.rand <= self.pers["bots"]["behavior"]["strafe"] )
				self strafe( self.bot.target.entity );

			return;
		}
	}

	dist = 16;

	goal = self getRandomGoal();

	isScriptGoal = false;

	if ( isDefined( self.bot.script_goal ) && !hasTarget )
	{
		goal = self.bot.script_goal;
		dist = self.bot.script_goal_dist;

		isScriptGoal = true;
	}
	else
	{
		if ( hasTarget )
			goal = self.bot.target.last_seen_pos;

		self notify( "new_goal_internal" );
	}

	self doWalk( goal, dist, isScriptGoal );
	self.bot.towards_goal = undefined;
	self.bot.next_wp = -1;
	self.bot.second_next_wp = -1;
}

/*
	Will walk to the given goal when dist near. Uses AStar path finding with the level's nodes.
*/
doWalk( goal, dist, isScriptGoal )
{
	level endon( "intermission" );
	self endon( "kill_goal" );
	self endon( "goal_internal" ); //so that the watchOnGoal notify can happen same frame, not a frame later

	dist *= dist;

	if ( isScriptGoal )
		self thread doWalkScriptNotify();

	self thread killWalkOnEvents();
	self thread watchOnGoal( goal, dist );

	current = self initAStar( goal );

	path_was_truncated = ( current + 1 ) >= 32;

	//Couldn't generate path to goal
	if ( current <= -1 )
	{
		self notify( "bad_path_internal" );
		return;
	}

	// skip waypoints we already completed to prevent rubber banding
	if ( current > 0 && self.bot.astar[current] == self.bot.last_next_wp && self.bot.astar[current - 1] == self.bot.last_second_next_wp )
		current = self removeAStar();

	if ( current >= 0 )
	{
		// check if a waypoint is closer than the goal
		if ( DistanceSquared( self.origin, level.waypoints[self.bot.astar[current]].origin ) < DistanceSquared( self.origin, goal ) || DistanceSquared( level.waypoints[self.bot.astar[current]].origin, PlayerPhysicsTrace( self.origin + ( 0, 0, 32 ), level.waypoints[self.bot.astar[current]].origin ) ) > 1.0 )
		{
			while ( current >= 0 )
			{
				self.bot.next_wp = self.bot.astar[current];
				self.bot.second_next_wp = -1;

				if ( current > 0 )
					self.bot.second_next_wp = self.bot.astar[current - 1];

				self notify( "new_static_waypoint" );

				self movetowards( level.waypoints[self.bot.next_wp].origin );
				self.bot.last_next_wp = self.bot.next_wp;
				self.bot.last_second_next_wp = self.bot.second_next_wp;

				current = self removeAStar();
			}
		}
	}

	if ( path_was_truncated )
	{
		self notify( "kill_goal" );
		return;
	}

	self.bot.next_wp = -1;
	self.bot.second_next_wp = -1;
	self notify( "finished_static_waypoints" );

	if ( DistanceSquared( self.origin, goal ) > dist )
	{
		self.bot.last_next_wp = -1;
		self.bot.last_second_next_wp = -1;
		self movetowards( goal ); // any better way??
	}

	self notify( "finished_goal" );

	wait 1;

	if ( DistanceSquared( self.origin, goal ) > dist )
		self notify( "bad_path_internal" );
}

/*
	Will move towards the given goal. Will try to not get stuck by crouching, then jumping and then strafing around objects.
*/
movetowards( goal )
{
	if ( !isDefined( goal ) )
		return;

	self.bot.towards_goal = goal;

	lastOri = self.origin;
	stucks = 0;
	timeslow = 0;
	time = 0;

	if ( self.bot.issprinting )
		tempGoalDist = level.bots_goalDistance * 2;
	else
		tempGoalDist = level.bots_goalDistance;

	while ( distanceSquared( self.origin, goal ) > tempGoalDist )
	{
		self botMoveTo( goal );

		if ( time > 3000 )
		{
			time = 0;

			if ( distanceSquared( self.origin, lastOri ) < 32 * 32 )
			{
				self thread knife();
				wait 0.5;

				stucks++;

				randomDir = self getRandomLargestStafe( stucks );

				self BotNotifyBotEvent( "stuck" );

				self botMoveTo( randomDir );
				wait stucks;
				self stand();

				self.bot.last_next_wp = -1;
				self.bot.last_second_next_wp = -1;
			}

			lastOri = self.origin;
		}
		else if ( timeslow > 0 && ( timeslow % 1000 ) == 0 )
		{
			self thread doMantle();
		}
		else if ( time == 2000 )
		{
			if ( distanceSquared( self.origin, lastOri ) < 32 * 32 )
				self crouch();
		}
		else if ( time == 1750 )
		{
			if ( distanceSquared( self.origin, lastOri ) < 32 * 32 )
			{
				// check if directly above or below
				if ( abs( goal[2] - self.origin[2] ) > 64 && getConeDot( goal + ( 1, 1, 0 ), self.origin + ( -1, -1, 0 ), VectorToAngles( ( goal[0], goal[1], self.origin[2] ) - self.origin ) ) < 0.64 && DistanceSquared2D( self.origin, goal ) < 32 * 32 )
				{
					stucks = 2;
				}
			}
		}

		wait 0.05;
		time += 50;

		if ( lengthsquared( self getVelocity() ) < 1000 )
			timeslow += 50;
		else
			timeslow = 0;

		if ( self.bot.issprinting )
			tempGoalDist = level.bots_goalDistance * 2;
		else
			tempGoalDist = level.bots_goalDistance;

		if ( stucks >= 2 )
			self notify( "bad_path_internal" );
	}

	self.bot.towards_goal = undefined;
	self notify( "completed_move_to" );
}

/*
	The bot will strafe left or right from their enemy.
*/
strafe( target )
{
	self endon( "kill_goal" );
	self thread killWalkOnEvents();

	angles = VectorToAngles( vectorNormalize( target.origin - self.origin ) );
	anglesLeft = ( 0, angles[1] + 90, 0 );
	anglesRight = ( 0, angles[1] - 90, 0 );

	myOrg = self.origin + ( 0, 0, 16 );
	left = myOrg + anglestoforward( anglesLeft ) * 500;
	right = myOrg + anglestoforward( anglesRight ) * 500;

	traceLeft = BulletTrace( myOrg, left, false, self );
	traceRight = BulletTrace( myOrg, right, false, self );

	strafe = traceLeft["position"];

	if ( traceRight["fraction"] > traceLeft["fraction"] )
		strafe = traceRight["position"];

	self.bot.last_next_wp = -1;
	self.bot.last_second_next_wp = -1;
	self botMoveTo( strafe );
	wait 2;
	self notify( "kill_goal" );
}

/*
	Will return the pos of the largest trace from the bot.
*/
getRandomLargestStafe( dist )
{
	//find a better algo?
	traces = NewHeap( ::HeapTraceFraction );
	myOrg = self.origin + ( 0, 0, 16 );

	traces HeapInsert( bulletTrace( myOrg, myOrg + ( -100 * dist, 0, 0 ), false, self ) );
	traces HeapInsert( bulletTrace( myOrg, myOrg + ( 100 * dist, 0, 0 ), false, self ) );
	traces HeapInsert( bulletTrace( myOrg, myOrg + ( 0, 100 * dist, 0 ), false, self ) );
	traces HeapInsert( bulletTrace( myOrg, myOrg + ( 0, -100 * dist, 0 ), false, self ) );
	traces HeapInsert( bulletTrace( myOrg, myOrg + ( -100 * dist, -100 * dist, 0 ), false, self ) );
	traces HeapInsert( bulletTrace( myOrg, myOrg + ( -100 * dist, 100 * dist, 0 ), false, self ) );
	traces HeapInsert( bulletTrace( myOrg, myOrg + ( 100 * dist, -100 * dist, 0 ), false, self ) );
	traces HeapInsert( bulletTrace( myOrg, myOrg + ( 100 * dist, 100 * dist, 0 ), false, self ) );

	toptraces = [];

	top = traces.data[0];
	toptraces[toptraces.size] = top;
	traces HeapRemove();

	while ( traces.data.size && top["fraction"] - traces.data[0]["fraction"] < 0.1 )
	{
		toptraces[toptraces.size] = traces.data[0];
		traces HeapRemove();
	}

	return toptraces[randomInt( toptraces.size )]["position"];
}

/*
	Calls the astar search algorithm for the path to the goal.
*/
initAStar( goal )
{
	nodes = generatePath( self.origin, goal, self.team, false );

	if ( !isDefined( nodes ) )
	{
		return -1;
	}

	node_indexes = [];

	for ( i = nodes.size - 1; i >= 0; i-- )
	{
		node_indexes[ node_indexes.size ] = nodes[ i ] getNodeNumber();
	}

	self.bot.astar = node_indexes;

	return self.bot.astar.size - 1;
}

/*
	Cleans up the astar nodes for one node.
*/
removeAStar()
{
	remove = self.bot.astar.size - 1;

	self.bot.astar[remove] = undefined;

	return self.bot.astar.size - 1;
}

/*
	Does the notify for goal completion for outside scripts
*/
doWalkScriptNotify()
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "kill_goal" );

	if ( self waittill_either_return( "goal_internal", "bad_path_internal" ) == "goal_internal" )
		self notify( "goal" );
	else
		self notify( "bad_path" );
}

/*
	Will stop the goal walk when an enemy is found or flashed or a new goal appeared for the bot.
*/
killWalkOnEvents()
{
	self endon( "kill_goal" );
	self endon( "disconnect" );
	self endon( "zombified" );

	self waittill_any( "new_enemy", "new_goal_internal", "goal_internal", "bad_path_internal" );

	waittillframeend;

	self notify( "kill_goal" );
}

/*
	Will kill the goal when the bot made it to its goal.
*/
watchOnGoal( goal, dis )
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "kill_goal" );

	while ( DistanceSquared( self.origin, goal ) > dis )
		wait 0.05;

	self notify( "goal_internal" );
}

/*
	Bot will move towards here
*/
botMoveTo( where )
{
	self.bot.moveTo = where;
}

/*
	Bot will press ADS for a time.
*/
pressADS( time )
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_ads" );
	self endon( "bot_ads" );

	if ( !isDefined( time ) )
		time = 0.05;

	self botAction( "+ads" );

	if ( time )
		wait time;

	self botAction( "-ads" );
}

/*
	Bot will hold the frag button for a time
*/
frag( time )
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_frag" );
	self endon( "bot_frag" );

	if ( !isDefined( time ) )
		time = 0.05;

	self botAction( "+frag" );
	self.bot.isfragging = true;
	self.bot.isfraggingafter = true;

	if ( time )
		wait time;

	self botAction( "-frag" );
	self.bot.isfragging = false;

	wait 1.25;
	self.bot.isfraggingafter = false;
}

/*
	Bot will hold the 'smoke' button for a time.
*/
smoke( time )
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_smoke" );
	self endon( "bot_smoke" );

	if ( !isDefined( time ) )
		time = 0.05;

	self botAction( "+smoke" );
	self.bot.issmoking = true;
	self.bot.issmokingafter = true;

	if ( time )
		wait time;

	self botAction( "-smoke" );
	self.bot.issmoking = false;

	wait 1.25;
	self.bot.issmokingafter = false;
}

/*
	Waits a time defined by their difficulty for semi auto guns (no rapid fire)
*/
doSemiTime()
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_semi_time" );
	self endon( "bot_semi_time" );

	self.bot.semi_time = true;
	wait self.pers["bots"]["skill"]["semi_time"];
	self.bot.semi_time = false;
}

/*
	Bots will fire their gun.
*/
botFire()
{
	self.bot.last_fire_time = getTime();

	if ( self.bot.is_cur_full_auto )
	{
		self thread pressFire();
		return;
	}

	if ( self.bot.semi_time )
		return;

	self thread pressFire();
	self thread doSemiTime();
}

/*
	Bots do the mantle
*/
doMantle()
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "kill_goal" );

	self jump();

	wait 0.35;

	self jump();
}

/*
	Bot will fire for a time.
*/
pressFire( time )
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_fire" );
	self endon( "bot_fire" );

	if ( !isDefined( time ) )
		time = 0.05;

	self botAction( "+fire" );

	if ( time )
		wait time;

	self botAction( "-fire" );
}

/*
	Bot will knife.
*/
knife()
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_knife" );
	self endon( "bot_knife" );

	self.bot.isknifing = true;
	self.bot.isknifingafter = true;

	self botAction( "+melee" );
	wait 0.05;
	self botAction( "-melee" );

	self.bot.isknifing = false;

	wait 1;

	self.bot.isknifingafter = false;
}

/*
	Bot will press use for a time.
*/
use( time )
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_use" );
	self endon( "bot_use" );

	if ( !isDefined( time ) )
		time = 0.05;

	self botAction( "+activate" );

	if ( time )
		wait time;

	self botAction( "-activate" );
}

/*
	Bot will jump.
*/
jump()
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_jump" );
	self endon( "bot_jump" );

	if ( self getStance() != "stand" )
	{
		self stand();
		wait 1;
	}

	self botAction( "+gostand" );
	wait 0.05;
	self botAction( "-gostand" );
}

/*
	Bot will stand.
*/
stand()
{
	self botAction( "-gocrouch" );
	self botAction( "-goprone" );
}

/*
	Bot will crouch.
*/
crouch()
{
	self botAction( "+gocrouch" );
	self botAction( "-goprone" );
}

/*
	Bot will prone.
*/
prone()
{
	self botAction( "-gocrouch" );
	self botAction( "+goprone" );
}

/*
	Bot will sprint.
*/
sprint()
{
	self endon( "zombified" );
	self endon( "disconnect" );
	self notify( "bot_sprint" );
	self endon( "bot_sprint" );

	self botAction( "+sprint" );
	wait 0.05;
	self botAction( "-sprint" );
}
