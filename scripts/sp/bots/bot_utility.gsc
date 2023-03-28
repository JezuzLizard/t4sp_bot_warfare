#include common_scripts\utility;
#include maps\_utility;
#include maps\so\zm_common\_zm_utility;

register_stats_for_bot_weapon( weapon, score )
{
	if ( !isDefined( level.bot_weapons_stats ) )
	{
		level.bot_weapons_stats = [];
	}
	level.bot_weapons_stats[ weapon ] = score;
}

parse_bot_weapon_stats_from_table()
{
	WEAPON_COLUMN = 0;
	SCORE_COLUMN = 1;
	/*
	row = 0;
	while ( true )
	{
		weapon = fs_tablelookupcolumnforrow( "tables\bot_weapon_stats.csv", row, WEAPON_COLUMN );
		if ( !isDefined( weapon ) || weapon == "" )
		{
			break;
		}
		score = fs_tablelookupcolumnforrow( "tables\bot_weapon_stats.csv", row, SCORE_COLUMN );
		if ( !isDefined( score ) || score == "" )
		{
			row++;
			continue;
		}
		if ( isDefined( level.zombie_include_weapons[ weapon + "_zm" ] ) )
		{
			register_stats_for_bot_weapon( weapon + "_zm", int( score ) );
			if ( isDefined( level.zombie_include_weapons[ weapon + "_upgraded_zm" ] ) )
			{
				register_stats_for_bot_weapon( weapon + "_upgraded_zm", int( score ) + 1 );
			}
		}
		else if ( isDefined( level.zombie_include_weapons[ weapon ] ) )
		{
			register_stats_for_bot_weapon( weapon, int( score ) );
		}
		row++;
	}
	*/
}

array_validate( array )
{
	return isDefined( array ) && isArray( array ) && array.size > 0;
}

array_add( array, item )
{
	array[ array.size ] = item;
}

swap( array, index1, index2 )
{
	temp = array[ index1 ];
	array[ index1 ] = array[ index2 ];
	array[ index2 ] = temp;
	return array;
}

merge_sort( current_list, func_sort, param )
{
	if ( current_list.size <= 1 )
	{
		return current_list;
	}
		
	left = [];
	right = [];
	
	middle = current_list.size / 2;
	
	for ( x = 0; x < middle; x++ )
	{
		array_add( left, current_list[ x ] );
	}
	
	for ( ; x < current_list.size; x++ )
	{
		array_add( right, current_list[ x ] );
	}
	
	left = merge_sort( left, func_sort, param );
	right = merge_sort( right, func_sort, param );
	
	//result = merge( left, right, func_sort, param );

	//return result;
}

quickSort(array, compare_func) 
{
	return quickSortMid(array, 0, array.size -1, compare_func);     
}

quickSortMid( array, start, end, compare_func )
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
			while ( [[ compare_func ]](array[i], pivot) && i <= end && k > i)
				i++;
			while ( ![[ compare_func ]](array[k], pivot) && k >= start && k >= i)
				k--;
			if (k > i)
				array = swap(array, i, k);
		}
		array = swap(array, start, k);
		array = quickSortMid(array, start, k - 1, compare_func);
		array = quickSortMid(array, k + 1, end, compare_func);
	}
	else
		return array;
	
	return array;
}

quicksort_compare(left, right)
{
	return left <= right;
}

push( array, val, index )
{
	if ( !isdefined( index ) )
	{
		// use max free integer as index
		index = 0;
		keys = GetArrayKeys( array );
		for ( i = 0; i < keys.size; i++ )
		{
			key = keys[ i ];
			if ( IsInt( key ) && ( key >= index ) )
			{
				index = key + 1;
			}
		}
	}
	
	array = array_insert( array, val, index );
	return array;
}

bot_spawn_init()
{
	time = gettime();

	if ( !isdefined( self.bot ) )
	{
		self.bot = spawnstruct();
		self.bot.threat = spawnstruct();
	}

	self.bot.glass_origin = undefined;
	self.bot.ignore_entity = [];
	self.bot.previous_origin = self.origin;
	self.bot.time_ads = 0;
	self.bot.update_c4 = time + randomintrange( 1000, 3000 );
	self.bot.update_crate = time + randomintrange( 1000, 3000 );
	self.bot.update_crouch = time + randomintrange( 1000, 3000 );
	self.bot.update_failsafe = time + randomintrange( 1000, 3000 );
	self.bot.update_idle_lookat = time + randomintrange( 1000, 3000 );
	self.bot.update_killstreak = time + randomintrange( 1000, 3000 );
	self.bot.update_lookat = time + randomintrange( 1000, 3000 );
	self.bot.update_objective = time + randomintrange( 1000, 3000 );
	self.bot.update_objective_patrol = time + randomintrange( 1000, 3000 );
	self.bot.update_patrol = time + randomintrange( 1000, 3000 );
	self.bot.update_toss = time + randomintrange( 1000, 3000 );
	self.bot.update_launcher = time + randomintrange( 1000, 3000 );
	self.bot.update_weapon = time + randomintrange( 1000, 3000 );

	self.bot.threat.entity = undefined;
	self.bot.threat.position = ( 0, 0, 0 );
	self.bot.threat.time_first_sight = 0;
	self.bot.threat.time_recent_sight = 0;
	self.bot.threat.time_aim_interval = 0;
	self.bot.threat.time_aim_correct = 0;
	self.bot.threat.update_riotshield = 0;
}

bot_should_hip_fire()
{
	enemy = self.bot.threat.entity;
	weapon = self getcurrentweapon();

	if ( weapon == "none" )
		return 0;

	if ( weaponisdualwield( weapon ) )
		return 1;

	weapon_class = weaponclass( weapon );

	if ( isplayer( enemy ) && weapon_class == "spread" )
		return 1;

	distsq = distancesquared( self.origin, enemy.origin );
	distcheck = 0;

	switch ( weapon_class )
	{
		case "mg":
			distcheck = 250;
			break;
		case "smg":
			distcheck = 350;
			break;
		case "spread":
			distcheck = 400;
			break;
		case "pistol":
			distcheck = 200;
			break;
		case "rocketlauncher":
			distcheck = 0;
			break;
		case "rifle":
		default:
			distcheck = 300;
			break;
	}

	if ( isweaponscopeoverlay( weapon ) )
		distcheck = 500;

	return distsq < distcheck * distcheck;
}

get_allies()
{
	return getPlayers( self.team );
}

get_zombies()
{
	return getAiSpeciesArray( level.zombie_team, "all" );
}

find_gaps()
{

}

are_enemies_horded()
{
	MINIMUM_PERCENT_TO_BE_HORDE = 0.9;
	DISTANCE_SQ = 120 * 120;
	zombies = get_zombies();
	amount_in_horde = 0;
	max_eligible_zombies = isDefined( level.speed_change_round ) ? zombies.size - level.speed_change_num  : zombies.size;
	expected_amount_in_horde_min = int( max_eligible_zombies * MINIMUM_PERCENT_TO_BE_HORDE );
	if ( isDefined( level.speed_change_round ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( zombies[ i ].zombie_move_speed == "walk" )
			{
				continue;
			}
			if ( !isDefined( zombies[ i + 1 ] ) )
			{
				return false;
			}
			if ( zombies[ i + 1 ].zombie_move_speed != "walk" )
			{
				if ( distanceSquared( zombies[ i + 1 ].origin, zombies[ i ].origin ) <= DISTANCE_SQ )
				{
					amount_in_horde++;
				}
			}
			if ( amount_in_horde >= expected_amount_in_horde_min )
			{
				return true;
			}
		}
	}
	else 
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( !isDefined( zombies[ i + 1 ] ) )
			{
				return false;
			}
			if ( distanceSquared( zombies[ i + 1 ].origin, zombies[ i ].origin ) <= DISTANCE_SQ )
			{
				amount_in_horde++;
			}
			if ( amount_in_horde >= expected_amount_in_horde_min )
			{
				return true;
			}
		}
	}
	return false;
}

any_enemies_in_direction( dir )
{

}

predict_entity_position_frames( frames )
{
	current_velocity = self getVelocity();
	predicted_origin = self.origin;
	for ( i = 0; i < frames; i++ )
	{
		predicted_origin += ( current_velocity / 20 );
	}
	return predicted_origin;
}

predict_entity_position_seconds( seconds )
{
	current_velocity = self getVelocity();
	predicted_origin = self.origin;
	for ( i = 0; i < seconds; i++ )
	{
		predicted_origin += current_velocity;
	}
	return predicted_origin;
}

any_zombies_targeting_self()
{
	ZOMBIE_TARGETING_DIST_SQ = 10 * 10;
	zombies = get_zombies();
	if ( !array_validate( zombies ) )
	{
		return false;
	}
	for ( i = 0; i < zombies.size; i++ )
	{
		if ( isDefined( zombies[ i ].favoriteenemy ) && zombies[ i ].favoriteenemy == self )
		{
			return true;
		}
		if ( isDefined( zombies[ i ].goal_pos ) && distanceSquared( zombies[ i ].goal_pos, self.origin ) < ZOMBIE_TARGETING_DIST_SQ )
		{
			return true;
		}
	}
	return false;
}

bot_is_in_danger( player )
{
	return false;
}

bot_valid( player )
{
	if ( !isdefined( player ) )
		return false;

	if ( !isalive( player ) )
		return false;

	if ( !isplayer( player ) )
		return false;

	if ( !is_true( player.pers[ "isBot" ] ) )
		return false;

	if ( isdefined( player.is_zombie ) && player.is_zombie == 1 )
		return false;

	if ( player.sessionstate == "spectator" )
		return false;

	if ( player.sessionstate == "intermission" )
		return false;

	if ( isdefined( player.intermission ) && player.intermission )
		return false;

	if ( isdefined( level.is_player_valid_override ) )
		return [[ level.is_player_valid_override ]]( player );

	return true;
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
		
		for ( i = 0; i < level.players.size; i++ )
		{
			weapons = level.players[ i ] getWeaponsListPrimaries();
			for ( j = 0; j < weapons.size; j++ )
			{
				if ( self getWeaponAmmoStock( weapons[ j ] ) <= int( weaponmaxammo( weapons[ j ] ) *  LOW_AMMO_THRESHOLD ) )
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

	if ( maps\mp\zombies\_zm_laststand::player_any_player_in_laststand() )
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

	priority_array = [];
	for ( i = 0; i < array.size; i++ )
	{
		priority_array[ i ] = array[ i ].priority;
	}
	priority_array = quickSort( priority_array );
	sorted_array = [];
	for ( i = 0; i < priority_array.size; i++ )
	{
		for ( j = 0; j < array.size; j++ )
		{
			if ( array[ j ].priority == priority_array[ i ] )
			{
				sorted_array[ sorted_array.size ] = array[ j ];
			}
		}
	}
	return sorted_array;
}

/*
We need to calculate where the bot should go to next and update their movement constantly here
If the calculations predicts death or teammates death based on current course we need recalculate next move
Updating every frame(0.05) should be sufficient 
Key to movement code is determining gaps, and safe lines to follow
Bot should try to find the nearest safe line and follow it
Due to many different variables(primarily resulting from other players) we need to constantly verify if the line is safe to follow
If the bot doesn't detect any danger allow them to stand still far enough away from the zombies to not draw aggro but close enough to shoot at them
Questions:
Can bots move and use the use button at the same time? Necessary to be able to support circle revive
How do we know the bot is safe where they are currently or where they will be moving to?
How do we determine gaps in zombies/terrain to slip through?
*/
movement_think()
{
	while ( true )
	{

	}
}

/*
bot methods docs

enum BotGoalPriority
{
  GOAL_PRIORITY_UNUSED = 0x0,
  GOAL_PRIORITY_LOW = 0x1,
  GOAL_PRIORITY_NORMAL = 0x2,
  GOAL_PRIORITY_HIGH = 0x3,
  GOAL_PRIORITY_URGENT = 0x4,
  GOAL_PRIORITY_MAX = 0x5,
};


success = bot addGoal( <origin|pathnode>, float<goalRadius>, BotGoalPriority<priority>, string<notify> );
bot cancelGoal( string<notify> );
bot atGoal( string[notify] );
bot hasGoal( string<notify> );
origin = bot getGoal( string<notify> );
bot pressUseButton( float<time_in_seconds> );
bot pressAttackButton( float<time_in_seconds> );
bot pressDtpButton();
bot pressAds( <bool> );
bot pressMelee();
bot throwGrenade( string<weapon_name>, vector<destination> );
dist = bot getLookaheadDist();
dir = bot getLookAheadDir();
bot lookAt( vector<origin> );
bot clearLookat();
pos = bot predictPosition( entity<ent>, int<num_frames> );
success = bot sightTracePassed( entity<ent>, vector[point] );
enemies = bot getThreats( float<fov> ); //Fov value can be -1 to find all enemies instead of enemies in fov.
bot botSetFailsafeNode( pathnode[node] );

player methods docs
player allowStand( <bool> );
player allowCrouch( <bool> );
player allowProne( <bool> );
player allowAds( <bool> );
player allowSprint( <bool> );
player allowMelee( <bool> );
player setSpawnWeapon( string<weapon_name> );
player isLookingAt( <entity> );
ads_amount = player playerAds();
stance = player getstance();
player setStance( string<stance> );
dot = player playerSightTrace( vector<item_position>, int<unk>, int<hitnum> );

entity methods docs
mins = entity getMins();
maxes = entity getMaxes();
absmins = entity getAdbMins();
absmaxes = entity getAbsMaxes();
eye = entity getEye();
centroid = entity getCentroid()
velocity = entity getVelocity();
vector = entity getpointinbounds( float<x>, float<y>, float<z> );
is_touching = entity isTouching( entity<ent>, vector[extra_boundary] );
is_touching = entity isTouchingVolume( vector<origin>, vector<mins>, vector<maxes> );

dot = entity damageConeTrace( vector<damage_origin>, entity[ent], vector[damage_angles], float[damage_amount] );
dot = entity sightConeTrace( vector<damage_origin>, entity[ent], vector[damage_angles], float[damage_amount] );

common functions docs

nodeStringTable = {
	"Path",
	"Cover Stand",
	"Cover Crouch",
	"Cover Crouch Window",
	"Cover Prone",
	"Cover Right",
	"Cover Left",
	"Cover Pillar",
	"Ambush",
	"Exposed",
	"Conceal Stand",
	"Conceal Crouch",
	"Conceal Prone",
	"Reacquire",
	"Balcony",
	"Scripted",
	"Begin",
	"End",
	"Turret",
	"Guard"
}

enum team_t
{
  TEAM_FREE = 0x0,
  TEAM_BAD = 0x0,
  TEAM_ALLIES = 0x1,
  TEAM_AXIS = 0x2,
  TEAM_THREE = 0x3,
  TEAM_FOUR = 0x4,
  TEAM_FIVE = 0x5,
  TEAM_SIX = 0x6,
  TEAM_SEVEN = 0x7,
  TEAM_EIGHT = 0x8,
  TEAM_NUM_PLAYING_TEAMS = 0x9,
  TEAM_SPECTATOR = 0x9,
  TEAM_NUM_TEAMS = 0xA,
  TEAM_LOCALPLAYERS = 0xB,
  TEAM_FIRST_PLAYING_TEAM = 0x1,
  TEAM_LAST_PLAYING_TEAM = 0x8,
};

nodespawn_t nodespawns[21]
{
'node_pathnode'
'node_guard'
'node_turret'
'node_negotiation_end'
'node_negotiation_begin'
'node_scripted'
'node_balcony'
'node_reacquire'
'node_concealment_prone'
'node_concealment_crouch'
'node_concealment_stand'
'node_exposed'
'node_ambush'
'node_cover_pillar'
'node_cover_left'
'node_cover_right'
'node_cover_prone'
'node_cover_crouch_window'
'node_cover_crouch'
'node_cover_stand'
}

node = getNode( string<name>, entkey<key> );
nodes = getNodeArray( string<name>, entkey<key );
nodes = getNodeArraySorted( string<name>, entkey<key>, vector[origin], float[max_dist] );
nodes = getAnyNodeArray( vector<origin>, float<max_dist> );
nodes = getCoverNodeArray( vector<origin>, float<max_dist> );
nodes = getAllNodes();
nodes = getNodesInRadius( vector<origin>, float<max_radius>, float<min_radius>, float[max_height], nodeStringTable[type], int<max_nodes> );
nodes = getNodesInRadiusSorted( vector<origin>, float<max_radius>, float<min_radius>, float[max_height], nodeStringTable[type], int<max_nodes> );
node = getNearestNode( vector<origin> );
node = getVisibleNode( vector<start>, vector<end>, entity[ent] );
nodes = getVisibleNodes( node_ent<node> );
visible = nodesVisible( node_ent<node>, node_ent<node> );
canpath = nodesCanPath( node_ent<node>, node_ent<node> );
canclaimnode = canClaimNode( node_ent<node>, team_t<team> );
setEnableNode( node_ent<node>, [bool] );
linkNodes( node_ent<node>, node_ent<node> );
unLinkNodes( node_ent<node>, node_ent<node> );
nodesAreLinked( node_ent<node>, node_ent<node> );
dropnodetofloor( node_ent<node> );
node = spawnPathNode( nodespawn_t<classname>, vector<origin>, vector<angles>, key[key1], value[val1],  ... );
deletePathNode( node_ent<node> );
occupied = isNodeOccupied( node_ent<node> );
nodeowner = getNodeOwner( node_ent<node> );
foundpath = findPath( vector<start>, vector<end>, entity[ent], bool[allow_negotiation_links], bool[allow_negotiation_hints] );

vector = vectorFromLineToPoint( vector<<start_pos>, vector<end_pos>, vector<point> );
point = pointOnSegmentNearestToPoint( vector<start_pos>, vector<end_pos>, vector<test_origin> );
pos_a_is_closer = closer( vector<ref_pos>, vector<a>, vector<b> );
dot = vectorDot( vector<a>, vector<b> );
cross = vectorCross( vector<a>, vector<b> );
normalized_vector = vectorNormalize( vector<vec> );
lerped_vector = vectorLerp( vector<from>, vector<to>, float<lerp> );
combined_angles = combineAngles( vector<a>, vector<b> );
angles = vectorToAngles( vector<vec> );
angle = absAngleClamp180( float<angle> );
angle = absAngleClamp360( float<angle> );
point = rotatePoint( vector<point>, vector<angles> );

trace
{
	"fraction",
	"position",
	"entity",
	"normal",
	"surfacetype"
}

trace = bulletTrace( vector<end_pos>, vector<start_pos>, bool<use_content_mask_flag>, entity<ignore_ent>, bool[modify_contents_flags1], bool[modify_contents_flags2] );
passed = bulletTracePassed( vector<start_pos>, vector<end_pos>, bool<use_clipmask>, entity<ignore_ent>, entity[ignore_ent2?], bool[check_fx_visibility] );
trace = groundTrace( vector<end_pos>, vector<start_pos>, bool<use_content_mask_flag>, entity<ignore_ent>, bool[modify_contents_flags1], bool[modify_contents_flags2] );
passed = sightTracePassed( vector<start_pos>, vector<end_pos>, bool<use_clipmask>, entity<ignore_ent> );

player_physics_trace = playerPhysicsTrace( vector<end_pos>, vector<start_pos> );
trace = physicsTrace( vector<end_pos>, vector<smins>, vector[maxes], vector[end_pos], entity[ignore_ent] );
trace = worldTrace( vector<end_pos>, vector<start_pos> );


? customs functions to add
node = bot getNextNodeInPath( vector<start>, vector<end>, entity[ent], bool[allow_negotiation_links], bool[allow_negotiation_hints] );
bot botMovementOverride( byte<forward>, byte<right> );
self botButtonOverride( string<button>, string<value> );
self botClearMovementOverride();
self botClearButtonOverride( string<value> );
*/