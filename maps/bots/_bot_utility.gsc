#include common_scripts\utility;
#include maps\_utility;

/*
	Returns if player is the host
*/
is_host()
{
	return ( isDefined( self.pers["bot_host"] ) && self.pers["bot_host"] );
}

/*
	Setups the host variable on the player
*/
doHostCheck()
{
	self.pers["bot_host"] = false;

	if ( self is_bot() )
		return;

	result = false;

	if ( getDvar( "bots_main_firstIsHost" ) != "0" )
	{
		PrintConsole( "WARNING: bots_main_firstIsHost is enabled\n" );

		if ( getDvar( "bots_main_firstIsHost" ) == "1" )
		{
			setDvar( "bots_main_firstIsHost", self getguid() );
		}

		if ( getDvar( "bots_main_firstIsHost" ) == self getguid() + "" )
			result = true;
	}

	DvarGUID = getDvar( "bots_main_GUIDs" );

	if ( DvarGUID != "" )
	{
		guids = strtok( DvarGUID, "," );

		for ( i = 0; i < guids.size; i++ )
		{
			if ( self getguid() + "" == guids[i] )
				result = true;
		}
	}

	if ( !result )
		return;

	self.pers["bot_host"] = true;
}

/*
	Returns if the player is a bot.
*/
is_bot()
{
	return self isBot();
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
	Bot changes to the weap
*/
BotChangeToWeapon( weap )
{
	self botWeapon( weap );
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
	if ( !isDefined( self.bot.target ) )
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
	Returns if the bot has a script goal.
	(like t5 gsc bot)
*/
HasScriptGoal()
{
	return ( isDefined( self GetScriptGoal() ) );
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
	if ( !isDefined( dist ) )
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
	Returns whether the bot is at it's goal
*/

AtScriptGoal()
{
	if ( !isDefined( self.bot.script_goal ) )
	{
		return false;
	}
	return distanceSquared( self.origin, self.bot.script_goal ) <= ( self.bot.script_goal_dist * self.bot.script_goal_dist );
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
	return isDefined( self GetScriptAimPos() );
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
	return ( isDefined( self.bot.script_target ) );
}

/*
	Returns if the bot has a threat.
*/
HasThreat()
{
	return ( isDefined( self GetThreat() ) );
}

/*
	Returns a valid grenade launcher weapon
*/
getValidTube()
{
	weaps = self getweaponslist();

	for ( i = 0; i < weaps.size; i++ )
	{
		weap = weaps[i];

		if ( !self getAmmoCount( weap ) )
			continue;

		if ( isSubStr( weap, "gl_" ) && !isSubStr( weap, "_gl_" ) )
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
	grenadeTypes[grenadeTypes.size] = "stielhandgranate";

	possibles = [];

	for ( i = 0; i < grenadeTypes.size; i++ )
	{
		if ( !self hasWeapon( grenadeTypes[i] ) )
			continue;

		if ( !self getAmmoCount( grenadeTypes[i] ) )
			continue;

		possibles[possibles.size] = grenadeTypes[i];
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

	return arr[randomInt( arr.size )];
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
	return strtok( weap, "_" )[0];
}

/*
	Returns if the given weapon is full auto.
*/
WeaponIsFullAuto( weap )
{
	weaptoks = strtok( weap, "_" );

	return isDefined( weaptoks[0] ) && isString( weaptoks[0] ) && isdefined( level.bots_fullautoguns[weaptoks[0]] );
}

/*
	Returns what our eye height is.
*/
GetEyeHeight()
{
	myEye = self GetEyePos();

	return myEye[2] - self.origin[2];
}

/*
	Returns (iw4) eye pos.
*/
GetEyePos()
{
	return self getTagOrigin( "tag_eye" );
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
	if ( !isDefined( self waittill_either_return_( str1, str2 ) ) )
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
		player = level.players[i];

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

	while ( !isDefined( level ) || !isDefined( level.players ) )
		wait 0.05;

	for ( i = getDvarFloat( "bots_main_waitForHostTime" ); i > 0; i -= 0.05 )
	{
		host = GetHostPlayer();

		if ( isDefined( host ) )
			break;

		wait 0.05;
	}

	if ( !isDefined( host ) )
		return;

	for ( i = getDvarFloat( "bots_main_waitForHostTime" ); i > 0; i -= 0.05 )
	{
		if ( IsDefined( host.pers[ "team" ] ) )
			break;

		wait 0.05;
	}

	if ( !IsDefined( host.pers[ "team" ] ) )
		return;

	for ( i = getDvarFloat( "bots_main_waitForHostTime" ); i > 0; i -= 0.05 )
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
	dirToTarget = VectorNormalize( to - from );
	forward = AnglesToForward( dir );
	return vectordot( dirToTarget, forward );
}

/*
	Returns the distance squared in a 2d space
*/
DistanceSquared2D( to, from )
{
	to = ( to[0], to[1], 0 );
	from = ( from[0], from[1], 0 );

	return DistanceSquared( to, from );
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

	return GetDvarFloat( "temp_dvar_bot_util" );
}

get_nodes_in_playable_area()
{
	total_nodes = getAllNodes();
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

is_point_in_playable_area( point )
{
	playable_area = getentarray( "playable_area", "targetname" );

	in_playable_area = false;

	if ( !isDefined( playable_area ) || playable_area.size < 1 )
	{
		in_playable_area = true;
	}

	temp_ent = spawn( "script_origin", point );

	if ( !in_playable_area )
	{
		for ( p = 0; p < playable_area.size; p++ )
		{
			if ( temp_ent isTouching( playable_area[ p ] ) )
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
	level.waypoints = GetAllNodes();
	level.waypointCount = level.waypoints.size;

	level.waypointsInPlayableArea = get_nodes_in_playable_area();
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
	Returns an array of all the bots in the game.
*/
getBotArray()
{
	result = [];
	playercount = level.players.size;

	for ( i = 0; i < playercount; i++ )
	{
		player = level.players[i];

		if ( !player is_bot() )
			continue;

		result[result.size] = player;
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

/*
	A heap invarient comparitor, used for traces. Wanting the trace with the largest length first in the heap.
*/
HeapTraceFraction( item, item2 )
{
	return item["fraction"] > item2["fraction"];
}

/*
	Returns a new heap.
*/
NewHeap( compare )
{
	heap_node = spawnStruct();
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
	self.data[insert] = item;

	current = insert + 1;

	while ( current > 1 )
	{
		last = current;
		current = int( current / 2 );

		if ( ![[self.compare]]( item, self.data[current - 1] ) )
			break;

		self.data[last - 1] = self.data[current - 1];
		self.data[current - 1] = item;
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

	if ( [[self.compare]]( self.data[left - 1], self.data[right - 1] ) )
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

	move = self.data[remove - 1];
	self.data[0] = move;
	self.data[remove - 1] = undefined;
	remove--;

	if ( !remove )
		return remove;

	last = 1;
	next = self _HeapNextChild( 1, remove );

	while ( next != -1 )
	{
		if ( [[self.compare]]( move, self.data[next - 1] ) )
			break;

		self.data[last - 1] = self.data[next - 1];
		self.data[next - 1] = move;

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
	/*  if (!isDefined(level.log_cache))
		level.log_cache = [];

	    key = x + "";

	    if (isDefined(level.log_cache[key]))
		return level.log_cache[key];*/

	//thanks Bob__ at stackoverflow
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

	//level.log_cache[key] = answer;
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
		total += array[i];
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
		tmp[i] = ( array[i] - mean ) * ( array[i] - mean );
	}

	total = 0;

	for ( i = 0; i < tmp.size; i++ )
	{
		total = total + tmp[i];
	}

	return Sqrt( total / array.size );
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
		x1 = 2 * RandomFloatRange( 0, 1 ) - 1;
		x2 = 2 * RandomFloatRange( 0, 1 ) - 1;
		w = x1 * x1 + x2 * x2;
	}

	w = Sqrt( ( -2.0 * Log( w ) ) / w );
	y1 = x1 * w;
	number = mean + y1 * std_deviation;

	if ( IsDefined( lower_bound ) && number < lower_bound )
	{
		number = lower_bound;
	}

	if ( IsDefined( upper_bound ) && number > upper_bound )
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
	return self maps\_laststand::player_is_in_laststand();
}

/*
	getRandomGoal
*/
getRandomGoal()
{
	return PickRandom( level.waypointsInPlayableArea ).origin;
}

/*
	Checks if target is dog
*/
targetIsDog()
{
	return isDefined( self.targetname ) && self.targetname == "zombie_dog";
}

/*
	Checks if target is gibbed
*/
targetIsGibbed()
{
	return isDefined( self.gibbed ) && self.gibbed;
}

swap_array_index( array, index1, index2 )
{
	temp = array[ index1 ];
	array[ index1 ] = array[ index2 ];
	array[ index2 ] = temp;
	return array;
}

quickSort(array, compare_func, compare_func_arg1) 
{
	return quickSortMid( array, 0, array.size - 1, compare_func, compare_func_arg1 );     
}

/*
	Quicksort algorithm copied from T7 modified for T4
*/
quickSortMid( array, start, end, compare_func, compare_func_arg1 )
{
	i = start;
	k = end;

	if(!IsDefined(compare_func))
		compare_func = ::quicksort_compare;

	if (end - start >= 1)
	{
		pivot = array[start];

		while (k > i)
		{
			while ( [[ compare_func ]](array[i], pivot, compare_func_arg1) && i <= end && k > i)
				i++;
			while ( ![[ compare_func ]](array[k], pivot, compare_func_arg1) && k >= start && k >= i)
				k--;
			if (k > i)
				array = swap_array_index(array, i, k);
		}
		array = swap_array_index(array, start, k);
		array = quickSortMid(array, start, k - 1, compare_func);
		array = quickSortMid(array, k + 1, end, compare_func);
	}
	else
		return array;
	
	return array;
}

quicksort_compare(left, right, compare_func_arg1)
{
	return left <= right;
}

quicksort_compare_priority_field(left, right, compare_func_arg1)
{
	return left.priority <= right.priority;
}

quicksort_compare_pers_value_highest_to_lowest( left, right, compare_func_arg1 )
{
	return left.pers[ compare_func_arg1 ] <= right.pers[ compare_func_arg1 ];
}

quicksort_compare_pers_value_lowest_to_highest( left, right, compare_func_arg1 )
{
	return left.pers[ compare_func_arg1 ] >= right.pers[ compare_func_arg1 ];
}

assign_priority_to_powerup( powerup )
{
	if ( !isDefined( powerup ) )
	{
		return;
	}
	priority = 0;
	powerup_is_max_ammo = false;
	switch ( powerup.powerup_name )
	{
		case "zombie_blood":
		case "insta_kill":
		case "nuke":
			priority += 2;
			break;
		case "full_ammo":
			powerup_is_max_ammo = true;
			priority += 1;
			break;
		case "double_points":
		case "fire_sale":
		case "carpenter":
		case "free_perk":
			priority += 1;
			break;
		default:
			priority += 0;
			break;
	}
	if ( powerup_is_max_ammo )
	{
		LOW_AMMO_THRESHOLD = 0.3;
		
		players = getPlayers();

		for ( i = 0; i < players.size; i++ )
		{
			weapons = players[ i ] getWeaponsListPrimaries();
			for ( j = 0; j < weapons.size; j++ )
			{
				if ( players[ i ] getWeaponAmmoStock( weapons[ j ] ) <= int( weaponmaxammo( weapons[ j ] ) *  LOW_AMMO_THRESHOLD ) )
				{
					priority += 1;
					break;
				}
			}
			if ( priority > 3 )
			{
				break;
			}
		}
	}

	if ( maps\_laststand::player_any_player_in_laststand() )
	{
		switch ( powerup.powerup_name )
		{
			case "zombie_blood":
			case "insta_kill":
			case "nuke":
				priority += 1;
				break;
			case "full_ammo":
				priority += 0;
				break;
			case "double_points":
			case "fire_sale":
			case "carpenter":
			case "free_perk":
				priority -= 1;
				break;
			default:
				priority += 0;
				break;
		}
	}

	if ( powerup.time_left_until_timeout < 10.0 )
	{
		priority += 1;
	}
	if ( priority < 0 )
	{
		priority = 0;
	}
	powerup.priority = priority;
}

sort_array_by_priority_field( array, item )
{
	if ( isDefined( item ) )
	{
		array[ array.size ] = item;
	}

	array = quickSort( array, ::quicksort_compare_priority_field, undefined );
	return array;
}

get_players_sorted_by_highest_pers_value( pers_name )
{
	players = getPlayers();

	if ( !isDefined( players[ 0 ].pers[ pers_name ] ) )
	{
		assertMsg( "Uninitialized pers value: " + pers_name );
		return undefined;
	}

	return quickSort( players, ::quicksort_compare_pers_value_highest_to_lowest, pers_name );
}

get_players_sorted_by_lowest_pers_value( pers_name )
{
	players = getPlayers();

	if ( !isDefined( players[ 0 ].pers[ pers_name ] ) )
	{
		assertMsg( "Uninitialized pers value: " + pers_name );
		return undefined;
	}

	return quickSort( players, ::quicksort_compare_pers_value_lowest_to_highest, pers_name );
}