#include scripts\sp\bots\_bot_utility;
#include maps\_utility;
#include common_scripts\utility;

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

		//if ( !getDvarInt( "bots_play_move" ) )
		//	continue;

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
			if ( self maps\_laststand::player_is_in_laststand() || self GetStance() == "prone" || ( self.bot.is_cur_sniper && self PlayerADS() > 0 ) )
				return;

			if ( self.bot.target.rand <= self.pers["bots"]["behavior"]["strafe"] )
				self strafe( self.bot.target.entity );

			return;
		}
	}

	dist = 16;

	goal = level.waypoints_inside_playable_area[randomInt( level.waypoint_count_inside_playable_area )].origin;

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
	level endon( "end_game" );
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
	Bot will reload.
*/
reload()
{
	self endon( "death" );
	self endon( "disconnect" );
	self notify( "bot_reload" );
	self endon( "bot_reload" );

	self botAction( "+reload" );
	wait 0.05;
	self botAction( "-reload" );
}

/*
	Bot will hold the frag button for a time
*/
frag( time )
{
	self endon( "death" );
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
	self endon( "death" );
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
	Bot will fire if true or not.
*/
fire( what )
{
	self notify( "bot_fire" );

	if ( what )
		self botAction( "+fire" );
	else
		self botAction( "-fire" );
}

/*
	Bot will fire for a time.
*/
pressFire( time )
{
	self endon( "death" );
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
	Bot will ads if true or not.
*/
ads( what )
{
	self notify( "bot_ads" );

	if ( what )
		self botAction( "+ads" );
	else
		self botAction( "-ads" );
}

/*
	Bot will press ADS for a time.
*/
pressADS( time )
{
	self endon( "death" );
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
	Bot will press use for a time.
*/
use( time )
{
	self endon( "death" );
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
	if ( curweap == "none" )
		return false;

	weapclass = weaponClass( curweap );

	if ( weapclass == "spread" && dist > level.bots_maxShotgunDistance )
		return false;

	if ( curweap == "m2_flamethrower_mp" && dist > level.bots_maxShotgunDistance )
		return false;

	return true;
}