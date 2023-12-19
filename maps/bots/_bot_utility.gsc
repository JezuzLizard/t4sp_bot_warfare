#include common_scripts\utility;
#include maps\_utility;

/*
	Waits for the built-ins to be defined
*/
wait_for_builtins()
{
	for ( i = 0; i < 20; i++ )
	{
		if ( isdefined( level.bot_builtins ) )
			return true;

		if ( i < 18 )
			waittillframeend;
		else
			wait 0.05;
	}

	return false;
}

/*
	Prints to console without dev script on
*/
BotBuiltinPrintConsole( s )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "printconsole" ] ) )
	{
		[[ level.bot_builtins[ "printconsole" ] ]]( s );
	}
}

/*
	Bot action, does a bot action
	<client> botaction(<action string (+ or - then action like frag or smoke)>)
*/
BotBuiltinBotAction( action )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "botaction" ] ) )
	{
		self [[ level.bot_builtins[ "botaction" ] ]]( action );
	}
}

/*
	Clears the bot from movement and actions
	<client> botstop()
*/
BotBuiltinBotStop()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "botstop" ] ) )
	{
		self [[ level.bot_builtins[ "botstop" ] ]]();
	}
}

/*
	Sets the bot's movement
	<client> botmovement(<int left>, <int forward>)
*/
BotBuiltinBotMovement( left, forward )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "botmovement" ] ) )
	{
		self [[ level.bot_builtins[ "botmovement" ] ]]( left, forward );
	}
}

/*
	Sets melee params
*/
BotBuiltinBotMeleeParams( yaw, dist )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "botmeleeparams" ] ) )
	{
		self [[ level.bot_builtins[ "botmeleeparams" ] ]]( yaw, dist );
	}
}

/*
	Test if is a bot

*/
BotBuiltinIsBot()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "isbot" ] ) )
	{
		return self [[ level.bot_builtins[ "isbot" ] ]]();
	}

	return false;
}

/*
	Generates a path
*/
BotBuiltinGeneratePath( from, to, team, best_effort )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "generatepath" ] ) )
	{
		return [[ level.bot_builtins[ "generatepath" ] ]]( from, to, team, best_effort );
	}

	return [];
}

/*
	Returns function pointer
*/
BotBuiltinGetFunction( file, threadname )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "getfunction" ] ) )
	{
		return [[ level.bot_builtins[ "getfunction" ] ]]( file, threadname );
	}

	return undefined;
}

/*
	waw sp doesnt have
*/
BotBuiltinGetMins()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "getmins" ] ) )
	{
		return self [[ level.bot_builtins[ "getmins" ] ]]();
	}

	return ( 0, 0, 0 );
}

/*
	waw sp doesnt have
*/
BotBuiltinGetMaxs()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "getmaxs" ] ) )
	{
		return self [[ level.bot_builtins[ "getmaxs" ] ]]();
	}

	return ( 0, 0, 0 );
}

/*
	waw sp doesnt have
*/
BotBuiltinGetGuid()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "getguid" ] ) )
	{
		return self [[ level.bot_builtins[ "getguid" ] ]]();
	}

	return 0;
}

/*
*/
BotBuiltinSetAllowedTraversals( bot_allowed_negotiation_links )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "setallowedtraversals" ] ) )
	{
		[[ level.bot_builtins[ "setallowedtraversals" ] ]]( bot_allowed_negotiation_links );
	}
}

/*
*/
BotBuiltinSetIgnoredLinks( bot_ignore_links )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "setignoredlinks" ] ) )
	{
		[[ level.bot_builtins[ "setignoredlinks" ] ]]( bot_ignore_links );
	}
}

/*
*/
BotBuiltinGetNodeNumber()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "getnodenumber" ] ) )
	{
		return self [[ level.bot_builtins[ "getnodenumber" ] ]]();
	}

	return 0;
}

/*
*/
BotBuiltinGetLinkedNodes()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "getlinkednodes" ] ) )
	{
		return self [[ level.bot_builtins[ "getlinkednodes" ] ]]();
	}

	return [];
}

/*
*/
BotBuiltinAddTestClient()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "addtestclient" ] ) )
	{
		return [[ level.bot_builtins[ "addtestclient" ] ]]();
	}

	return undefined;
}

/*
*/
BotBuiltinCmdExec( what )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "cmdexec" ] ) )
	{
		[[ level.bot_builtins[ "cmdexec" ] ]]( what );
	}
}

/*
*/
BotBuiltinNotifyOnPlayerCommand( cmd, notif )
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "notifyonplayercommand" ] ) )
	{
		self [[ level.bot_builtins[ "notifyonplayercommand" ] ]]( cmd, notif );
	}
}

/*
	waw doesnt have
*/
BotBuiltinIsHost()
{
	if ( isdefined( level.bot_builtins ) && isdefined( level.bot_builtins[ "ishost" ] ) )
	{
		return self [[ level.bot_builtins[ "ishost" ] ]]();
	}

	return false;
}

/*
	Returns if player is the host
*/
is_host()
{
	return ( isdefined( self.pers[ "bot_host" ] ) && self.pers[ "bot_host" ] );
}

/*
	Setups the host variable on the player
*/
doHostCheck()
{
	self.pers[ "bot_host" ] = false;

	if ( self is_bot() )
		return;

	result = false;

	if ( getdvar( "bots_main_firstIsHost" ) != "0" )
	{
		BotBuiltinPrintConsole( "WARNING: bots_main_firstIsHost is enabled" );

		if ( getdvar( "bots_main_firstIsHost" ) == "1" )
		{
			setdvar( "bots_main_firstIsHost", self BotBuiltinGetGuid() );
		}

		if ( getdvar( "bots_main_firstIsHost" ) == self BotBuiltinGetGuid() + "" )
			result = true;
	}

	DvarGUID = getdvar( "bots_main_GUIDs" );

	if ( DvarGUID != "" )
	{
		guids = strtok( DvarGUID, "," );

		for ( i = 0; i < guids.size; i++ )
		{
			if ( self BotBuiltinGetGuid() + "" == guids[ i ] )
				result = true;
		}
	}

	if ( !self BotBuiltinIsHost() && !result )
		return;

	self.pers[ "bot_host" ] = true;
}

/*
	Returns if the player is a bot.
*/
is_bot()
{
	return self BotBuiltinIsBot();
}

/*
	Set the bot's stance
*/
BotSetStance( stance )
{
	switch ( stance )
	{
		case "stand":
			self maps\bots\_bot_internal::stand();
			break;

		case "crouch":
			self maps\bots\_bot_internal::crouch();
			break;

		case "prone":
			self maps\bots\_bot_internal::prone();
			break;
	}
}

/*
	Bot presses the button for time.
*/
BotPressAttack( time )
{
	self maps\bots\_bot_internal::pressFire( time );
}

/*
	Bot presses the ads button for time.
*/
BotPressADS( time )
{
	self maps\bots\_bot_internal::pressADS( time );
}

/*
	Bot presses the use button for time.
*/
BotPressUse( time )
{
	self maps\bots\_bot_internal::use( time );
}

/*
	Bot presses the frag button for time.
*/
BotPressFrag( time )
{
	self maps\bots\_bot_internal::frag( time );
}

/*
	Bot presses the smoke button for time.
*/
BotPressSmoke( time )
{
	self maps\bots\_bot_internal::smoke( time );
}

/*
	Bot jumps
*/
BotJump()
{
	self maps\bots\_bot_internal::jump();
}

/*
	Returns the bot's random assigned number.
*/
BotGetRandom()
{
	return self.bot.rand;
}

/*
	Returns a random number thats different everytime it changes target
*/
BotGetTargetRandom()
{
	if ( !isdefined( self.bot.target ) )
		return undefined;

	return self.bot.target.rand;
}

/*
	Returns if the bot is fragging.
*/
IsBotFragging()
{
	return self.bot.isfraggingafter;
}

/*
	Returns if the bot is pressing smoke button.
*/
IsBotSmoking()
{
	return self.bot.issmokingafter;
}

/*
	Returns if the bot is sprinting.
*/
IsBotSprinting()
{
	return self.bot.issprinting;
}

/*
	Returns if the bot is reloading.
*/
IsBotReloading()
{
	return self.bot.isreloading;
}

/*
	Is bot knifing
*/
IsBotKnifing()
{
	return self.bot.isknifingafter;
}

/*
	Freezes the bot's controls.
*/
BotFreezeControls( what )
{
	self.bot.isfrozen = what;

	if ( what )
		self notify( "kill_goal" );
}

/*
	Returns if the bot is script frozen.
*/
BotIsFrozen()
{
	return self.bot.isfrozen;
}

/*
	Bot will stop moving
*/
BotStopMoving( what )
{
	self.bot.stop_move = what;

	if ( what )
		self notify( "kill_goal" );
}

/*
	Notify the bot chat message
*/
BotNotifyBotEvent( msg, a, b, c, d, e, f, g )
{
	self notify( "bot_event", msg, a, b, c, d, e, f, g );
}

/*
	Does the bot have an objective?
*/
BotHasObjective()
{
	return self maps\bots\objectives\_utility::HasBotObjective();
}

/*
	Returns if the bot has a script goal.
	(like t5 gsc bot)
*/
HasScriptGoal()
{
	return ( isdefined( self GetScriptGoal() ) );
}

/*
	Returns the pos of the bot's goal
*/
GetScriptGoal()
{
	return self.bot.script_goal;
}

/*
	Sets the bot's goal, will acheive it when dist away from it.
*/
SetScriptGoal( goal, dist )
{
	if ( !isdefined( dist ) )
		dist = 16;

	self.bot.script_goal = goal;
	self.bot.script_goal_dist = dist;
	waittillframeend;
	self notify( "new_goal_internal" );
	self notify( "new_goal" );
}

/*
	Clears the bot's goal.
*/
ClearScriptGoal()
{
	self SetScriptGoal( undefined, 0 );
}

/*
	Returns whether the bot has a priority objective
*/
HasPriorityObjective()
{
	return self.bot.prio_objective;
}

/*
	Sets the bot to prioritize the objective over targeting enemies
*/
SetPriorityObjective()
{
	self.bot.prio_objective = true;
	self notify( "kill_goal" );
}

/*
	Clears the bot's priority objective to allow the bot to target enemies automatically again
*/
ClearPriorityObjective()
{
	self.bot.prio_objective = false;
	self notify( "kill_goal" );
}

/*
	Sets the aim position of the bot
*/
SetScriptAimPos( pos )
{
	self.bot.script_aimpos = pos;
}

/*
	Clears the aim position of the bot
*/
ClearScriptAimPos()
{
	self SetScriptAimPos( undefined );
}

/*
	Returns the aim position of the bot
*/
GetScriptAimPos()
{
	return self.bot.script_aimpos;
}

/*
	Returns if the bot has a aim pos
*/
HasScriptAimPos()
{
	return isdefined( self GetScriptAimPos() );
}

/*
	Sets the bot's target to be this ent.
*/
SetAttacker( att )
{
	self.bot.target_this_frame = att;
}

/*
	Sets the script enemy for a bot.
*/
SetScriptEnemy( enemy, offset )
{
	self.bot.script_target = enemy;
	self.bot.script_target_offset = offset;
}

/*
	Removes the script enemy of the bot.
*/
ClearScriptEnemy()
{
	self SetScriptEnemy( undefined, undefined );
}

/*
	Returns the entity of the bot's target.
*/
GetThreat()
{
	if ( !isdefined( self.bot.target ) )
		return undefined;

	return self.bot.target.entity;
}

/*
	Returns if the bot has a script enemy.
*/
HasScriptEnemy()
{
	return ( isdefined( self.bot.script_target ) );
}

/*
	Returns if the bot has a threat.
*/
HasThreat()
{
	return ( isdefined( self GetThreat() ) );
}

/*
	Returns a valid grenade launcher weapon
*/
getValidTube()
{
	weaps = self getweaponslist();

	for ( i = 0; i < weaps.size; i++ )
	{
		weap = weaps[ i ];

		if ( !self getammocount( weap ) )
			continue;

		if ( issubstr( weap, "gl_" ) && !issubstr( weap, "_gl_" ) )
			return weap;
	}

	return undefined;
}

/*
	Returns a random grenade in the bot's inventory.
*/
getValidGrenade()
{
	grenadeTypes = [];
	grenadeTypes[ grenadeTypes.size ] = "stielhandgranate";

	possibles = [];

	for ( i = 0; i < grenadeTypes.size; i++ )
	{
		if ( !self hasweapon( grenadeTypes[ i ] ) )
			continue;

		if ( !self getammocount( grenadeTypes[ i ] ) )
			continue;

		possibles[ possibles.size ] = grenadeTypes[ i ];
	}

	return PickRandom( possibles );
}

/*
	Picks a random thing
*/
PickRandom( arr )
{
	if ( !arr.size )
		return undefined;

	return arr[ randomint( arr.size ) ];
}

/*
	If weap is a secondary gnade
*/
isSecondaryGrenade( gnade )
{
	return ( gnade == "zombie_cymbal_monkey" );
}

/*
	CoD4
*/
getBaseWeaponName( weap )
{
	return strtok( weap, "_" )[ 0 ];
}

/*
	Returns if the given weapon is full auto.
*/
WeaponIsFullAuto( weap )
{
	weaptoks = strtok( weap, "_" );

	return isdefined( weaptoks[ 0 ] ) && isstring( weaptoks[ 0 ] ) && isdefined( level.bots_fullautoguns[ weaptoks[ 0 ]] );
}

/*
	helper
*/
waittill_either_return_( str1, str2 )
{
	self endon( str1 );
	self waittill( str2 );
	return true;
}

/*
	Returns which string gets notified first
*/
waittill_either_return( str1, str2 )
{
	if ( !isdefined( self waittill_either_return_( str1, str2 ) ) )
		return str1;

	return str2;
}

/*
	Taken from iw4 script
*/
waittill_any_timeout( timeOut, string1, string2, string3, string4, string5 )
{
	if ( ( !isdefined( string1 ) || string1 != "death" ) &&
	    ( !isdefined( string2 ) || string2 != "death" ) &&
	    ( !isdefined( string3 ) || string3 != "death" ) &&
	    ( !isdefined( string4 ) || string4 != "death" ) &&
	    ( !isdefined( string5 ) || string5 != "death" ) )
		self endon( "death" );

	ent = spawnstruct();

	if ( isdefined( string1 ) )
		self thread waittill_string( string1, ent );

	if ( isdefined( string2 ) )
		self thread waittill_string( string2, ent );

	if ( isdefined( string3 ) )
		self thread waittill_string( string3, ent );

	if ( isdefined( string4 ) )
		self thread waittill_string( string4, ent );

	if ( isdefined( string5 ) )
		self thread waittill_string( string5, ent );

	ent thread _timeout( timeOut );

	ent waittill( "returned", msg );
	ent notify( "die" );
	return msg;
}

/*
	Used for waittill_any_timeout
*/
_timeout( delay )
{
	self endon( "die" );

	wait( delay );
	self notify( "returned", "timeout" );
}

/*
	Gets a player who is host
*/
GetHostPlayer()
{
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[ i ];

		if ( !player is_host() )
			continue;

		return player;
	}

	return undefined;
}

/*
    Waits for a host player
*/
bot_wait_for_host()
{
	host = undefined;

	while ( !isdefined( level ) || !isdefined( level.players ) )
		wait 0.05;

	for ( i = getdvarfloat( "bots_main_waitForHostTime" ); i > 0; i -= 0.05 )
	{
		host = GetHostPlayer();

		if ( isdefined( host ) )
			break;

		wait 0.05;
	}

	if ( !isdefined( host ) )
		return;

	for ( i = getdvarfloat( "bots_main_waitForHostTime" ); i > 0; i -= 0.05 )
	{
		if ( isdefined( host.pers[ "team" ] ) )
			break;

		wait 0.05;
	}

	if ( !isdefined( host.pers[ "team" ] ) )
		return;

	for ( i = getdvarfloat( "bots_main_waitForHostTime" ); i > 0; i -= 0.05 )
	{
		if ( host.pers[ "team" ] == "allies" || host.pers[ "team" ] == "axis" )
			break;

		wait 0.05;
	}
}

/*
	Returns the cone dot (like fov, or distance from the center of our screen). 1.0 = directly looking at, 0.0 = completely right angle, -1.0, completely 180
*/
getConeDot( to, from, dir )
{
	dirToTarget = vectornormalize( to - from );
	forward = anglestoforward( dir );
	return vectordot( dirToTarget, forward );
}

/*
	Returns the distance squared in a 2d space
*/
distancesquared2D( to, from )
{
	to = ( to[ 0 ], to[ 1 ], 0 );
	from = ( from[ 0 ], from[ 1 ], 0 );

	return distancesquared( to, from );
}

/*
	distance from box
*/
Rectdistancesquared( origin )
{
	dx = 0;
	dy = 0;
	dz = 0;

	if ( origin[ 0 ] < self.x0 )
		dx = origin[ 0 ] - self.x0;
	else if ( origin[ 0 ] > self.x1 )
		dx = origin[ 0 ] - self.x1;

	if ( origin[ 1 ] < self.y0 )
		dy = origin[ 1 ] - self.y0;
	else if ( origin[ 1 ] > self.y1 )
		dy = origin[ 1 ] - self.y1;


	if ( origin[ 2 ] < self.z0 )
		dz = origin[ 2 ] - self.z0;
	else if ( origin[ 2 ] > self.z1 )
		dz = origin[ 2 ] - self.z1;

	return dx * dx + dy * dy + dz * dz;
}

/*
	Rounds to the nearest whole number.
*/
Round( x )
{
	y = int( x );

	if ( abs( x ) - abs( y ) > 0.5 )
	{
		if ( x < 0 )
			return y - 1;
		else
			return y + 1;
	}
	else
		return y;
}

/*
	Rounds up the given value.
*/
RoundUp( floatVal )
{
	i = int( floatVal );

	if ( i != floatVal )
		return i + 1;
	else
		return i;
}

/*
	Clamps between value
*/
Clamp( a, minv, maxv )
{
	return max( min( a, maxv ), minv );
}

/*
	converts a string into a float
*/
float( num )
{
	setdvar( "temp_dvar_bot_util", num );

	return getdvarfloat( "temp_dvar_bot_util" );
}

/*
	returns nodes in playable area
*/
get_nodes_in_playable_area()
{
	total_nodes = getallnodes();
	filtered_nodes = [];

	for ( i = 0; i < total_nodes.size; i++ )
	{
		if ( !is_point_in_playable_area( total_nodes[ i ].origin ) )
		{
			continue;
		}

		filtered_nodes[ filtered_nodes.size ] = total_nodes[ i ];

		if ( ( i % 10 ) == 0 )
		{
			wait 0.05;
		}
	}

	return filtered_nodes;
}

/*
	is the point in playable area?
*/
is_point_in_playable_area( point )
{
	playable_area = getentarray( "playable_area", "targetname" );

	in_playable_area = false;

	if ( !isdefined( playable_area ) || playable_area.size < 1 )
	{
		in_playable_area = true;
	}

	temp_ent = spawn( "script_origin", point );

	if ( !in_playable_area )
	{
		for ( p = 0; p < playable_area.size; p++ )
		{
			if ( temp_ent istouching( playable_area[ p ] ) )
			{
				in_playable_area = true;
				break;
			}
		}
	}

	temp_ent delete ();

	return in_playable_area;
}

/*
	Loads the waypoints. Populating everything needed for the waypoints.
*/
load_waypoints()
{
	bot_allowed_negotiation_links = [];
	bot_allowed_negotiation_links[ bot_allowed_negotiation_links.size ] = "zombie_jump_down_72";
	bot_allowed_negotiation_links[ bot_allowed_negotiation_links.size ] = "zombie_jump_down_96";
	bot_allowed_negotiation_links[ bot_allowed_negotiation_links.size ] = "zombie_jump_down_120";
	bot_allowed_negotiation_links[ bot_allowed_negotiation_links.size ] = "zombie_jump_down_127";
	bot_allowed_negotiation_links[ bot_allowed_negotiation_links.size ] = "zombie_jump_down_184";
	bot_allowed_negotiation_links[ bot_allowed_negotiation_links.size ] = "zombie_jump_down_190";

	bot_ignore_links = [];

	switch ( level.script )
	{
		case "nazi_zombie_sumpf":
			a = [];
			a[ a.size ] = 1825;
			a[ a.size ] = 1826;
			a[ a.size ] = 1829;
			a[ a.size ] = 1830;
			a[ a.size ] = 1833;
			a[ a.size ] = 1837;
			bot_ignore_links[ 1603 + "" ] = a;

			a = [];
			a[ a.size ] = 1829;
			bot_ignore_links[ 1604 + "" ] = a;

			a = [];
			a[ a.size ] = 1904;
			bot_ignore_links[ 1823 + "" ] = a;

			a = [];
			a[ a.size ] = 1603;
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			a[ a.size ] = 1906;
			bot_ignore_links[ 1825 + "" ] = a;

			a = [];
			a[ a.size ] = 1603;
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			a[ a.size ] = 1907;
			bot_ignore_links[ 1826 + "" ] = a;

			a = [];
			a[ a.size ] = 1904;
			bot_ignore_links[ 1827 + "" ] = a;

			a = [];
			a[ a.size ] = 1603;
			a[ a.size ] = 1604;
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			a[ a.size ] = 1906;
			a[ a.size ] = 1907;
			bot_ignore_links[ 1829 + "" ] = a;


			a = [];
			a[ a.size ] = 1603;
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			a[ a.size ] = 1907;
			bot_ignore_links[ 1830 + "" ] = a;

			a = [];
			a[ a.size ] = 1904;
			bot_ignore_links[ 1831 + "" ] = a;

			a = [];
			a[ a.size ] = 1603;
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			a[ a.size ] = 1906;
			a[ a.size ] = 1907;
			bot_ignore_links[ 1833 + "" ] = a;

			a = [];
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			bot_ignore_links[ 1834 + "" ] = a;

			a = [];
			a[ a.size ] = 1603;
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			a[ a.size ] = 1906;
			a[ a.size ] = 1907;
			bot_ignore_links[ 1837 + "" ] = a;

			a = [];
			a[ a.size ] = 1903;
			a[ a.size ] = 1904;
			bot_ignore_links[ 1838 + "" ] = a;

			a = [];
			a[ a.size ] = 1825;
			a[ a.size ] = 1826;
			a[ a.size ] = 1829;
			a[ a.size ] = 1830;
			a[ a.size ] = 1833;
			a[ a.size ] = 1834;
			a[ a.size ] = 1837;
			a[ a.size ] = 1838;
			bot_ignore_links[ 1903 + "" ] = a;

			a = [];
			a[ a.size ] = 1823;
			a[ a.size ] = 1825;
			a[ a.size ] = 1826;
			a[ a.size ] = 1827;
			a[ a.size ] = 1829;
			a[ a.size ] = 1830;
			a[ a.size ] = 1831;
			a[ a.size ] = 1833;
			a[ a.size ] = 1834;
			a[ a.size ] = 1837;
			a[ a.size ] = 1838;
			bot_ignore_links[ 1904 + "" ] = a;

			a = [];
			a[ a.size ] = 1825;
			a[ a.size ] = 1829;
			a[ a.size ] = 1833;
			a[ a.size ] = 1837;
			bot_ignore_links[ 1906 + "" ] = a;

			a = [];
			a[ a.size ] = 1826;
			a[ a.size ] = 1829;
			a[ a.size ] = 1830;
			a[ a.size ] = 1833;
			a[ a.size ] = 1837;
			bot_ignore_links[ 1907 + "" ] = a;
			break;
	}

	// arrays are passed by value in gsc... hope this isnt gunna run out of vars
	BotBuiltinSetAllowedTraversals( bot_allowed_negotiation_links );
	BotBuiltinSetIgnoredLinks( bot_ignore_links );
	level.bot_ignore_links = bot_ignore_links;

	level.waypoints = getallnodes();
	level.waypointcount = level.waypoints.size;

	level.waypointsinplayablearea = [];
	level.waypointsinplayablearea = get_nodes_in_playable_area();
}

/*
	Returns a good amount of players.
*/
getGoodMapAmount()
{
	return 2;
}

/*
	Returns the friendly user name for a given map's codename
*/
getMapName( map )
{
	return map;
}

/*
	Returns a bot to be kicked
*/
getBotToKick()
{
	bots = getBotArray();

	if ( !isdefined( bots ) || !isdefined( bots.size ) || bots.size <= 0 || !isdefined( bots[ 0 ] ) )
		return undefined;

	tokick = undefined;

	// just kick lowest skill
	for ( i = 0; i < bots.size; i++ )
	{
		bot = bots[ i ];

		if ( !isdefined( bot ) )
			continue;

		if ( !isdefined( bot.pers ) || !isdefined( bot.pers[ "bots" ] ) || !isdefined( bot.pers[ "bots" ][ "skill" ] ) || !isdefined( bot.pers[ "bots" ][ "skill" ][ "base" ] ) )
			continue;

		if ( isdefined( tokick ) && bot.pers[ "bots" ][ "skill" ][ "base" ] > tokick.pers[ "bots" ][ "skill" ][ "base" ] )
			continue;

		tokick = bot;
	}

	return tokick;
}

/*
	Returns an array of all the bots in the game.
*/
getBotArray()
{
	result = [];
	playercount = level.players.size;

	for ( i = 0; i < playercount; i++ )
	{
		player = level.players[ i ];

		if ( !player is_bot() )
			continue;

		result[ result.size ] = player;
	}

	return result;
}

/*
	A heap invarient comparitor, used for numbers, numbers with the highest number will be first in the heap.
*/
Heap( item, item2 )
{
	return item > item2;
}

/*
	A heap invarient comparitor, used for numbers, numbers with the lowest number will be first in the heap.
*/
ReverseHeap( item, item2 )
{
	return item < item2;
}

HeapPriority( item, item2 )
{
	return item.fpriority > item2.fpriority;
}

/*
	A heap invarient comparitor, used for traces. Wanting the trace with the largest length first in the heap.
*/
HeapTraceFraction( item, item2 )
{
	return item[ "fraction" ] > item2[ "fraction" ];
}

/*
	Returns a new heap.
*/
NewHeap( compare )
{
	heap_node = spawnstruct();
	heap_node.data = [];
	heap_node.compare = compare;

	return heap_node;
}

/*
	Inserts the item into the heap. Called on a heap.
*/
HeapInsert( item )
{
	insert = self.data.size;
	self.data[ insert ] = item;

	current = insert + 1;

	while ( current > 1 )
	{
		last = current;
		current = int( current / 2 );

		if ( ![[ self.compare ]]( item, self.data[ current - 1 ] ) )
			break;

		self.data[ last - 1 ] = self.data[ current - 1 ];
		self.data[ current - 1 ] = item;
	}
}

/*
	Helper function to determine what is the next child of the bst.
*/
_HeapNextChild( node, hsize )
{
	left = node * 2;
	right = left + 1;

	if ( left > hsize )
		return -1;

	if ( right > hsize )
		return left;

	if ( [[ self.compare ]]( self.data[ left - 1 ], self.data[ right - 1 ] ) )
		return left;
	else
		return right;
}

/*
	Removes an item from the heap. Called on a heap.
*/
HeapRemove()
{
	remove = self.data.size;

	if ( !remove )
		return remove;

	move = self.data[ remove - 1 ];
	self.data[ 0 ] = move;
	self.data[ remove - 1 ] = undefined;
	remove--;

	if ( !remove )
		return remove;

	last = 1;
	next = self _HeapNextChild( 1, remove );

	while ( next != -1 )
	{
		if ( [[ self.compare ]]( move, self.data[ next - 1 ] ) )
			break;

		self.data[ last - 1 ] = self.data[ next - 1 ];
		self.data[ next - 1 ] = move;

		last = next;
		next = self _HeapNextChild( next, remove );
	}

	return remove;
}

/*
	Returns the natural log of x using harmonic series.
*/
Log( x )
{
	old_sum = 0.0;
	xmlxpl = ( x - 1 ) / ( x + 1 );
	xmlxpl_2 = xmlxpl * xmlxpl;
	denom = 1.0;
	frac = xmlxpl;
	sum = frac;

	while ( sum != old_sum )
	{
		old_sum = sum;
		denom += 2.0;
		frac *= xmlxpl_2;
		sum += frac / denom;
	}

	answer = 2.0 * sum;
	return answer;
}

/*
	Taken from t5 gsc.
	Returns an array of number's average.
*/
array_average( array )
{
	assert( array.size > 0 );
	total = 0;

	for ( i = 0; i < array.size; i++ )
	{
		total += array[ i ];
	}

	return ( total / array.size );
}

/*
	Taken from t5 gsc.
	Returns an array of number's standard deviation.
*/
array_std_deviation( array, mean )
{
	assert( array.size > 0 );
	tmp = [];

	for ( i = 0; i < array.size; i++ )
	{
		tmp[ i ] = ( array[ i ] - mean ) * ( array[ i ] - mean );
	}

	total = 0;

	for ( i = 0; i < tmp.size; i++ )
	{
		total = total + tmp[ i ];
	}

	return sqrt( total / array.size );
}

/*
	Taken from t5 gsc.
	Will produce a random number between lower_bound and upper_bound but with a bell curve distribution (more likely to be close to the mean).
*/
random_normal_distribution( mean, std_deviation, lower_bound, upper_bound )
{
	x1 = 0;
	x2 = 0;
	w = 1;
	y1 = 0;

	while ( w >= 1 )
	{
		x1 = 2 * randomfloatrange( 0, 1 ) - 1;
		x2 = 2 * randomfloatrange( 0, 1 ) - 1;
		w = x1 * x1 + x2 * x2;
	}

	w = sqrt( ( -2.0 * Log( w ) ) / w );
	y1 = x1 * w;
	number = mean + y1 * std_deviation;

	if ( isdefined( lower_bound ) && number < lower_bound )
	{
		number = lower_bound;
	}

	if ( isdefined( upper_bound ) && number > upper_bound )
	{
		number = upper_bound;
	}

	return ( number );
}

/*
	If the player is in laststand
*/
inLastStand()
{
	func = BotBuiltinGetFunction( "maps/_laststand", "player_is_in_laststand" );

	return self [[ func ]]();
}

/*
	Is reviving player
*/
isReviving( revivee )
{
	func = BotBuiltinGetFunction( "maps/_laststand", "is_reviving" );

	return self [[ func ]]( revivee );
}

/*
	getRandomGoal
*/
getRandomGoal()
{
	if ( !level.waypointsinplayablearea.size )
	{
		return self.origin;
	}

	return PickRandom( level.waypointsinplayablearea ).origin;
}

/*
	Checks if target is dog
*/
targetIsDog()
{
	return isdefined( self.targetname ) && self.targetname == "zombie_dog";
}

/*
	Checks if target is gibbed
*/
targetIsGibbed()
{
	return isdefined( self.gibbed ) && self.gibbed;
}

/*
	is weap primary?
*/
isWeaponPrimary( weap )
{
	weaps = self getweaponslistprimaries();

	for ( i = 0; i < weaps.size; i++ )
	{
		if ( weap == weaps[ i ] )
			return true;
	}

	return false;
}

/*
	Checks whether the path generated by the ASTAR path finding is inaccessible
*/
GetPathIsInaccessible( from, to, team, best_effort )
{
	path = BotBuiltinGeneratePath( from, to, team, best_effort );
	return ( !isdefined( path ) || ( path.size <= 0 ) );
}

/*
	Returns how long the path is
*/
get_path_dist( start, end, team )
{
	path = BotBuiltinGeneratePath( start, end, team, 192.0 );

	if ( !isdefined( path ) || path.size <= 0 )
	{
		return 999999999;
	}

	dist = 0;
	prev_node = undefined;

	for ( i = 0; i < path.size; i++ )
	{
		if ( i == 0 )
		{
			prev_node = path[ i ];
			continue;
		}

		dist += distance( prev_node.origin, path[ i ].origin );
		prev_node = path[ i ];
	}

	return dist;
}

/*
	Clamp lerp,
*/
ClampLerp( dist, min_dist, max_dist, max_bonus, min_bonus )
{
	answer = 0;

	if ( dist <= min_dist )
	{
		answer += max_bonus;
	}
	else if ( dist >= max_dist )
	{
		answer += min_bonus;
	}
	else
	{
		dist_multi = 1 - ( ( dist - min_dist ) / ( max_dist - min_dist ) );
		answer += min_bonus + ( ( max_bonus - min_bonus ) * dist_multi );
	}

	return answer;
}

/*
	Base an origin offset from an ent
*/
get_angle_offset_node( forward_size, angle_offset, offset )
{
	if ( !isdefined( forward_size ) )
	{
		forward_size = 40;
	}

	if ( !isdefined( angle_offset ) )
	{
		angle_offset = ( 0, 0, 0 );
	}

	if ( !isdefined( offset ) )
	{
		offset = ( 0, 0, 0 );
	}

	angles = ( 0, self.angles[ 1 ], 0 );
	angles += angle_offset;
	node = self.origin + ( anglestoforward( angles ) * forward_size ) + offset;
	node = clamp_to_ground( node );

	if ( getdvarint( "bots_main_debug" ) )
	{
		self thread debug_offset_line( node );
	}

	return node;
}

/*
	Draw the offset
*/
debug_offset_line( node )
{
	self endon( "death" );
	self notify( "debug_offset_line" );
	self endon( "debug_offset_line" );

	while ( isdefined( self ) )
	{
		line( self.origin, node );
		wait 0.05;
	}
}

/*
	Is the point inside this use trigger?
*/
PointInsideUseTrigger( point )
{
	if ( getdvarint( "bots_main_debug" ) )
	{
		self thread debug_bounding_box_for_ent();
	}

	mins = self BotBuiltinGetMins();
	maxs = self BotBuiltinGetMaxs();

	box = spawnstruct();
	box.x0 = self.origin[ 0 ] + mins[ 0 ];
	box.x1 = self.origin[ 0 ] + maxs[ 0 ];
	box.y0 = self.origin[ 1 ] + mins[ 1 ];
	box.y1 = self.origin[ 1 ] + maxs[ 1 ];
	box.z0 = self.origin[ 2 ] + mins[ 2 ];
	box.z1 = self.origin[ 2 ] + maxs[ 2 ];

	if ( box Rectdistancesquared( self.origin ) > 72 * 72 )
	{
		return false;
	}

	if ( !sighttracepassed( point, self.origin, false, undefined ) )
	{
		return false;
	}

	return true;
}

/*
	Draw the aabb of the ent
*/
debug_bounding_box_for_ent( color )
{
	self endon( "death" );
	self notify( "debug_bounding_box_for_ent" );
	self endon( "debug_bounding_box_for_ent" );

	if ( !isdefined( color ) )
		color = ( randomfloatrange( 0, 1 ), randomfloatrange( 0, 1 ), randomfloatrange( 0, 1 ) );

	while ( isdefined( self ) )
	{
		mins = self BotBuiltinGetMins();
		maxs = self BotBuiltinGetMaxs();

		line( self.origin + ( mins[ 0 ], mins[ 1 ], mins[ 2 ] ), self.origin + ( mins[ 0 ], mins[ 1 ], maxs[ 2 ] ), color );
		line( self.origin + ( mins[ 0 ], mins[ 1 ], mins[ 2 ] ), self.origin + ( mins[ 0 ], maxs[ 1 ], mins[ 2 ] ), color );
		line( self.origin + ( mins[ 0 ], mins[ 1 ], mins[ 2 ] ), self.origin + ( maxs[ 0 ], mins[ 1 ], mins[ 2 ] ), color );

		line( self.origin + ( maxs[ 0 ], maxs[ 1 ], maxs[ 2 ] ), self.origin + ( maxs[ 0 ], maxs[ 1 ], mins[ 2 ] ), color );
		line( self.origin + ( maxs[ 0 ], maxs[ 1 ], maxs[ 2 ] ), self.origin + ( maxs[ 0 ], mins[ 1 ], maxs[ 2 ] ), color );
		line( self.origin + ( maxs[ 0 ], maxs[ 1 ], maxs[ 2 ] ), self.origin + ( mins[ 0 ], maxs[ 1 ], maxs[ 2 ] ), color );

		line( self.origin + ( maxs[ 0 ], mins[ 1 ], mins[ 2 ] ), self.origin + ( maxs[ 0 ], maxs[ 1 ], mins[ 2 ] ), color );
		line( self.origin + ( maxs[ 0 ], mins[ 1 ], mins[ 2 ] ), self.origin + ( maxs[ 0 ], mins[ 1 ], maxs[ 2 ] ), color );

		line( self.origin + ( mins[ 0 ], mins[ 1 ], maxs[ 2 ] ), self.origin + ( maxs[ 0 ], mins[ 1 ], maxs[ 2 ] ), color );
		line( self.origin + ( mins[ 0 ], mins[ 1 ], maxs[ 2 ] ), self.origin + ( mins[ 0 ], maxs[ 1 ], maxs[ 2 ] ), color );

		line( self.origin + ( mins[ 0 ], maxs[ 1 ], mins[ 2 ] ), self.origin + ( maxs[ 0 ], maxs[ 1 ], mins[ 2 ] ), color );
		line( self.origin + ( mins[ 0 ], maxs[ 1 ], mins[ 2 ] ), self.origin + ( mins[ 0 ], maxs[ 1 ], maxs[ 2 ] ), color );

		wait 0.05;
	}
}

/*
	Clamp the origin to the ground
*/
clamp_to_ground( org )
{
	trace = playerphysicstrace( org + ( 0, 0, 20 ), org - ( 0, 0, 2000 ) );
	return trace;
}
