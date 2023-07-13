#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_common;
#include maps\bots\script_objectives\_obj_utility;

bot_post_think_common( state )
{
	obj = bot_objective_history_get_current();

	switch ( state )
	{
		case "completed":
			self bot_objective_print( obj.group, obj.id, "Bot <" + self.playername + "> objective was completed", "bot_post_think_common" );
			break;
		case "canceled":
			self bot_objective_print( obj.group, obj.id, "Bot <" + self.playername + "> objective was canceled Reason: " + self.obj_cancel_reason, "bot_post_think_common" );
			break;
	}
	self.obj_cancel_reason = "";
	self thread ClearScriptGoal();
	self ClearScriptAimPos();
	self ClearPriorityObjective();
	self bot_clear_objective();
}

bot_obj_timeout( objective_group, time )
{
	self endon( objective_group + "_end_think" );
	wait time;
	self.obj_cancel_reason = "Obj timeout";
	self notify( objective_group + "_cancel" );
}

calculate_base_obj_priority( obj )
{
	dist = self get_path_dist( self.origin, obj.target_ent.origin );

	priority = 0;
	min_dist = 300;
	max_dist = 600;
	max_bonus = 2;
	min_bonus = 1;
	if ( dist <= min_dist )
	{
		priority += max_bonus;
	}
	else if ( dist <= max_dist )
	{
		priority += min_bonus;
	}
	else
	{
		dist_multi = 1 - ( ( dist - min_dist ) / ( max_dist - min_dist ) );
		priority += min_bonus + ( ( max_bonus - min_bonus ) * dist_multi );
	}

	return priority;
}

bot_grab_powerup( obj )
{
	self endon( "disconnect" );
	self endon( "powerup_end_think" );
	level endon( "end_game" );

	if ( !isDefined( obj ) )
	{
		return;
	}

	powerup_obj = obj;
	powerup_obj_ent = powerup_obj.target_ent;
	self bot_set_objective( "powerup", powerup_obj_ent );
	self bot_set_objective_owner( "powerup", powerup_obj_ent );

	self bot_objective_print( "powerup", powerup_obj.id, "Bot <" + self.playername + "> Attempting to grab powerup", "bot_grab_powerup" );
	self SetPriorityObjective();
	self SetScriptGoal( powerup_obj_ent.origin );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "powerup_cancel" );
		return;
	}
	//Wait to see if the bot was able to grab the powerup
	wait 0.5;
	//Check if powerup still exists
	if ( isDefined( powerup_obj_ent ) )
	{
		height_difference = powerup_obj_ent.origin[ 2 ] - self.origin[ 2 ];
		if ( height_difference > 0 && height_difference < 39 )
		{
			self BotJump();
			wait 0.5;
			waittillframeend;
			//Check if bot was able to grab the powerup by jumping
			if ( isDefined( powerup_obj_ent ) )
			{
				//Mark objective as bad so bots will ignore it from now on
				powerup_obj.bad = true;
			}
		}
		else
		{
			powerup_obj.bad = true;
		}

		if ( powerup_obj.bad )
		{
			self.obj_cancel_reason = "Obj was marked as bad";
			self notify( "powerup_cancel" );
			return;
		}
	}
}

bot_powerup_init()
{
	self.successfully_grabbed_powerup = false;
}

bot_powerup_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_grabbed_powerup = false;
}

bot_should_grab_powerup( struct )
{
	if ( level.zbot_objective_glob[ "powerup" ].active_objectives.size <= 0 )
	{
		return false;
	}
	MAX_DISTANCE_SQ = 10000 * 10000;
	BOT_SPEED_WHILE_SPRINTING_SQ = 285 * 285;
	self.available_powerups = [];

	powerup_objectives = get_all_objectives_for_group( "powerup" );
	obj_keys = getArrayKeys( powerup_objectives );
	for ( i = 0; i < powerup_objectives.size; i++ )
	{
		obj = powerup_objectives[ obj_keys[ i ] ];
		powerup = obj.target_ent;
		if ( !isDefined( powerup ) )
		{
			continue;
		}
		if ( obj.bad )
		{
			continue;
		}
		if ( isDefined( obj.owner ) )
		{
			continue;
		}
		time_left = powerup.time_left_until_timeout;
		distance_required_to_reach_powerup = distanceSquared( powerup.origin, self.origin );
		if ( distance_required_to_reach_powerup > BOT_SPEED_WHILE_SPRINTING_SQ * time_left )
		{
			continue;
		}
		if ( distanceSquared( powerup.origin, self.origin ) > MAX_DISTANCE_SQ )
		{
			continue;
		}
		if ( self GetPathIsInaccessible( powerup.origin ) )
		{
			continue;
		}
		self.available_powerups[ self.available_powerups.size ] = obj;
	}

	struct.possible_objs = self.available_powerups;
	return self.available_powerups.size > 0;
}

bot_check_complete_grab_powerup()
{
	return self.successfully_grabbed_powerup;
}

bot_powerup_should_cancel()
{
	obj = self bot_get_objective();

	goal_canceled = false;
	if ( !self bot_is_objective_owner( "powerup", obj.target_ent ) )
	{
		self.obj_cancel_reason = "No longer the obj owner";
		goal_canceled = true;
	}
	return goal_canceled;
}

bot_powerup_priority( obj )
{
	priority = 0;
	base_priority = self calculate_base_obj_priority( obj );
	priority += base_priority;
	return priority;
}

//TODO: Possibly add the ability to circle revive?
bot_revive_player( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "revive_end_think" );
	level endon( "end_game" );

	player_to_revive_obj = obj;

	player_to_revive = player_to_revive_obj.target_ent;
	self bot_set_objective( "revive", player_to_revive );
	self bot_set_objective_owner( "revive", player_to_revive );
	self bot_objective_print( "revive", player_to_revive_obj.id, "Bot <" + self.playername + "> Attempting to revive " + player_to_revive.playername, "bot_revive_player" );
	//Constantly update the goal just in case the player is moving(T5 or higher only)
	self ClearScriptAimPos();
	self SetPriorityObjective();
	self SetScriptGoal( player_to_revive.origin, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "revive_cancel" );
		return;
	}
	if ( !isDefined( player_to_revive.revivetrigger ) )
	{
		self.obj_cancel_reason = "No revive trigger";
		self notify( "revive_cancel" );
		return;
	}
	//Check if the bot is reviving the player already and also that the player isn't being revived already
	if ( player_to_revive.revivetrigger.beingrevived )
	{
		self.obj_cancel_reason = "Player is already being revived";
		self notify( "revive_cancel" );
		return;
	}

	self SetScriptAimPos( player_to_revive.origin );

	time = 3.2;
	if ( self hasPerk( "specialty_quickrevive" ) )
	{
		time /= 2;
	}
	self thread bot_obj_timeout( "revive", time + 1 );
	self thread BotPressUse( time );

	self thread knocked_off_revive_watcher();
}

knocked_off_revive_watcher( revivee )
{
	while ( self maps\_laststand::is_reviving( revivee ) )
	{
		wait 0.05;
	}
	if ( isDefined( revivee.revivetrigger ) )
	{
		self.obj_cancel_reason = "Knocked off revive";
		self notify( "revive_cancel" );
	}
}

bot_revive_player_init()
{
	self.successfully_revived_player = false;
}

bot_revive_player_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_revived_player = false;
}

bot_should_revive_player( struct )
{
	downed_players_objs = get_all_objectives_for_group( "revive" );
	if ( downed_players_objs.size <= 0 )
	{
		return false;
	}

	self.available_revives = [];

	obj_keys = getArrayKeys( downed_players_objs );
	for ( i = 0; i < downed_players_objs.size; i++ )
	{
		obj = downed_players_objs[ obj_keys[ i ] ];
		player = obj.target_ent;
		if ( player == self )
		{
			continue;
		}
		if ( isDefined( obj.owner ) )
		{
			continue;
		}
		if ( obj.bad )
		{
			continue;
		}
		if ( self GetPathIsInaccessible( player.origin ) )
		{
			continue;
		}
		self.available_revives[ self.available_revives.size ] = obj;
	}
	struct.possible_objs = self.available_revives;
	return self.available_revives.size > 0;
}

bot_check_complete_revive_player()
{
	return self.successfully_revived_player;
}

bot_revive_player_should_cancel()
{
	obj = self bot_get_objective();

	goal_canceled = false;
	if ( !isDefined( obj.target_ent.revivetrigger ) )
	{
		self.obj_cancel_reason = "Revive trigger didn't exist";
		goal_canceled = true;
	}
	else if ( !self bot_is_objective_owner( "revive", obj.target_ent ) )
	{
		self.obj_cancel_reason = "No longer the obj owner";
		goal_canceled = true;
	}
	return goal_canceled;
}

bot_revive_player_priority( obj )
{
	return 2;
}

bot_magicbox_purchase( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "magicbox_end_think" );
	level endon( "end_game" );

	magicbox_obj = obj;

	magicbox = magicbox_obj.target_ent;
	self bot_set_objective( "magicbox", magicbox );
	//self bot_set_objective_owner( "magicbox", magicbox );
	self bot_objective_print( "magicbox", magicbox_obj.id, "Bot <" + self.playername + "> Attempting to purchase magicbox", "bot_magicbox_purchase" );
	magicbox_obj.magicbox_weapon_spawn_time = undefined;

	lookat_org = magicbox.origin + ( 0, 0, 35 );
	goal_org = magicbox.bot_use_node;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "magicbox_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
	wait 0.75;
	waittillframeend;
	//self ClearScriptAimPos();
	//self ClearScriptGoal();
	if ( !magicbox._box_open )
	{
		self.obj_cancel_reason = "Failed to open";
		self notify( "magicbox_cancel" );
		return;
	}

	if ( !isDefined( magicbox.weapon_spawn_org ) )
	{
		self.obj_cancel_reason = "No weapon spawn org";
		self notify( "magicbox_cancel" );
		return;
	}
	magicbox.weapon_spawn_org waittill( "randomization_done" );
	self bot_objective_print( "magicbox", magicbox_obj.id, "Bot <" + self.playername + "> randomization_done", "bot_magicbox_purchase" );

	magicbox_obj.magicbox_weapon_spawn_time = getTime();

	if ( self bot_should_reject_magicbox_weapon( magicbox.weapon_string ) )
	{
		self.obj_cancel_reason = "Rejected magicbox weapon: " + magicbox.weapon_string;
		self notify( "magicbox_cancel" );
		return;
	}

	self ClearScriptAimPos();
	self SetPriorityObjective();
	self SetScriptGoal( goal_org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal on pickup";
		self notify( "magicbox_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "magicbox", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_magicbox_purchase_init()
{
	self.successfully_grabbed_magicbox_weapon = false;
}

bot_magicbox_purchase_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_grabbed_magicbox_weapon = false;
}

bot_should_purchase_magicbox( struct )
{
	magicbox_objs = get_all_objectives_for_group( "magicbox" );
	if ( magicbox_objs.size <= 0 )
	{
		return false;
	}
	if ( isDefined( level.enable_magic ) && !level.enable_magic )
	{
		return false;
	}
	self.available_chests = [];
	magicbox_objs_keys = getArrayKeys( magicbox_objs );
	for ( i = 0; i < magicbox_objs.size; i++ )
	{
		obj = magicbox_objs[ magicbox_objs_keys[ i ] ];
		magicbox = obj.target_ent;
		if ( isDefined( self.last_magicbox_purchase_time ) && getTime() < ( self.last_magicbox_purchase_time + 60000 ) )
		{
			self bot_objective_print( "magicbox", obj.id, "Bot <" + self.playername + "> not purchasing this magicbox box because this action is on cooldown", "bot_should_purchase_magicbox" );
			continue;
		}
		if ( magicbox.hidden )
		{
			self bot_objective_print( "magicbox", obj.id, "Bot <" + self.playername + "> not purchasing this magicbox box because it is hidden", "bot_should_purchase_magicbox" );
			continue;
		}
		if ( isDefined( obj.owner ) )
		{
			self bot_objective_print( "magicbox", obj.id, "Bot <" + self.playername + "> not purchasing this magicbox box because it has an owner", "bot_should_purchase_magicbox" );
			continue;
		}
		if ( isDefined( magicbox.chest_user ) )
		{
			self bot_objective_print( "magicbox", obj.id, "Bot <" + self.playername + "> not purchasing this magicbox box because it has a user", "bot_should_purchase_magicbox" );
			continue;
		}
		if ( self.score < magicbox.zombie_cost )
		{
			self bot_objective_print( "magicbox", obj.id, "Bot <" + self.playername + "> not purchasing this magicbox box because it is unaffordable", "bot_should_purchase_magicbox" );
			continue;
		}
		if ( self GetPathIsInaccessible( magicbox.bot_use_node ) )
		{
			self bot_objective_print( "magicbox", obj.id, "Bot <" + self.playername + "> not purchasing this magicbox box because it cannot be pathed to", "bot_should_purchase_magicbox" );
			continue;
		}
		self.available_chests[ self.available_chests.size ] = obj;
	}
	struct.possible_objs = self.available_chests;
	return self.available_chests.size > 0;
}

bot_check_complete_purchase_magicbox()
{
	return self.successfully_grabbed_magicbox_weapon;
}

bot_should_reject_magicbox_weapon( obj )
{
	return false;
}

bot_magicbox_purchase_should_cancel()
{
	obj = self bot_get_objective();

	goal_canceled = false;
	/*
	if ( !self bot_is_objective_owner( "magicbox", obj.target_ent ) )
	{
		self.obj_cancel_reason = "No longer the obj owner";
		goal_canceled = true;
	}
	*/
	if ( isDefined( obj.magicbox_weapon_spawn_time )
		&& isDefined( obj.target_ent.chest_user )
		&& obj.target_ent.chest_user == self
		&& ( getTime() >= ( obj.magicbox_weapon_spawn_time + 12000 ) ) )
	{
		self.obj_cancel_reason = "Weapon timed out";
		goal_canceled = true;
	}
	return goal_canceled;
}

bot_magicbox_purchase_priority( obj )
{
	/*
	priority = 0;
	LOW_AMMO_THRESHOLD = 0.3;
	weapons = self getWeaponsListPrimaries();
	if ( weapons.size < 2 )
	{
		priority += 1;
	}
	for ( j = 0; j < weapons.size; j++ )
	{
		if ( self getWeaponAmmoStock( weapons[ j ] ) <= int( weaponmaxammo( weapons[ j ] ) *  LOW_AMMO_THRESHOLD ) )
		{
			priority += 1;
		}
	}
	return priority;
	*/
	return 0;
}

bot_perk_purchase( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "perk_end_think" );
	level endon( "end_game" );

	perk_obj = obj;

	perk_ent = perk_obj.target_ent;
	self bot_set_objective( "perk", perk_ent );
	self bot_objective_print( "perk", perk_obj.id, "Bot <" + self.playername + "> Attempting to purchase " + perk_ent.script_noteworthy, "bot_perk_purchase" );

	lookat_org = perk_ent.origin + ( 0, 0, 35 );
	goal_org = perk_ent.bot_use_node;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "perk_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "perk", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_perk_purchase_init()
{
	self.successfully_bought_perk = false;
}

bot_perk_purchase_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_bought_perk = false;
}

bot_should_purchase_perk( struct )
{
	perk_objs = get_all_objectives_for_group( "perk" );
	if ( perk_objs.size <= 0 )
	{
		return false;
	}
	if ( isDefined( level.enable_magic ) && !level.enable_magic )
	{
		return false;
	}
	self.available_perks = [];
	perk_objs_keys = getArrayKeys( perk_objs );
	perk_objs_keys = array_randomize( perk_objs_keys );
	for ( i = 0; i < perk_objs.size; i++ )
	{
		obj = perk_objs[ perk_objs_keys[ i ] ];
		perk_ent = obj.target_ent;
		perk = perk_ent.script_noteworthy;
		if ( !level._custom_perks[ perk ].powered_on )
		{
			self bot_objective_print( "perk", obj.id, "Bot <" + self.playername + "> not purchasing " + perk + " because its not powered on", "bot_should_purchase_perk" );
			continue;
		}
		if ( self hasPerk( perk ) )
		{
			self bot_objective_print( "perk", obj.id, "Bot <" + self.playername + "> not purchasing " + perk + " because we already have it", "bot_should_purchase_perk" );
			continue;
		}
		if ( ( isDefined( self.is_drinking ) && self.is_drinking > 0 ) && self getCurrentWeapon() == level._custom_perks[ perk ].perk_bottle )
		{
			self bot_objective_print( "perk", obj.id, "Bot <" + self.playername + "> not purchasing " + perk + " because we are already drinking the perk we want", "bot_should_purchase_perk" );
			continue;
		}
		if ( self.score < level._custom_perks[ perk ].cost )
		{
			self bot_objective_print( "perk", obj.id, "Bot <" + self.playername + "> not purchasing " + perk + " because we can't afford it", "bot_should_purchase_perk" );
			continue;
		}
		if ( self GetPathIsInaccessible( perk_ent.bot_use_node ) )
		{
			self bot_objective_print( "perk", obj.id, "Bot <" + self.playername + "> not purchasing " + perk + " because it cannot be pathed to", "bot_should_purchase_perk" );
			continue;
		}
		self.available_perks[ self.available_perks.size ] = obj;
	}
	struct.possible_objs = self.available_perks;
	return self.available_perks.size > 0;
}

bot_check_complete_perk_purchase()
{
	return self.successfully_bought_perk;
}

bot_perk_purchase_should_cancel()
{
	obj = self bot_get_objective();

	goal_canceled = false;
	perk = obj.target_ent.script_noteworthy;
	if ( self hasPerk( perk ) )
	{
		self bot_objective_print( "perk", obj.id, "Bot <" + self.playername + "> not purchasing " + perk + " because we already have it", "bot_should_purchase_perk" );
		goal_canceled = true;
	}
	return goal_canceled;
}

bot_perk_purchase_priority( obj )
{
	return 1;
}

bot_door_purchase( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "door_end_think" );
	level endon( "end_game" );

	door_obj = obj;

	door_ent = door_obj.target_ent;
	self bot_set_objective( "door", door_ent );
	self bot_objective_print( "door", door_obj.id, "Bot <" + self.playername + "> Attempting to purchase " + door_ent.target, "bot_door_purchase" );

	lookat_org = door_ent.origin;
	goal_org = door_ent.origin;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 48 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "door_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "door", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_door_purchase_init()
{
	self.successfully_bought_door = false;
}

bot_door_purchase_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_bought_door = false;
}

bot_should_purchase_door( struct )
{
	door_objs = get_all_objectives_for_group( "door" );
	if ( door_objs.size <= 0 )
	{
		return false;
	}
	self.available_doors = [];
	door_objs_keys = getArrayKeys( door_objs );
	for ( i = 0; i < door_objs.size; i++ )
	{
		obj = door_objs[ door_objs_keys[ i ] ];
		door_ent = obj.target_ent;
		is_electric_door = isDefined( door_ent.script_noteworthy ) && door_ent.script_noteworthy == "electric_door";
		if ( is_electric_door )
		{
			self bot_objective_print( "door", obj.id, "Bot <" + self.playername + "> not purchasing <" + door_ent.target + "> because it is electric", "bot_should_purchase_door" );
			continue;
		}
		if ( self.score < door_ent.zombie_cost )
		{
			self bot_objective_print( "door", obj.id, "Bot <" + self.playername + "> not purchasing <" + door_ent.target + "> because we can't afford it", "bot_should_purchase_door" );
			continue;
		}
		if ( self GetPathIsInaccessible( door_ent.origin, 192.0 ) )
		{
			self bot_objective_print( "door", obj.id, "Bot <" + self.playername + "> not purchasing <" + door_ent.target + "> because it cannot be pathed to", "bot_should_purchase_door" );
			continue;
		}
		self.available_doors[ self.available_doors.size ] = obj;
	}
	struct.possible_objs = self.available_doors;
	return self.available_doors.size > 0;
}

bot_check_complete_door_purchase()
{
	return self.successfully_bought_door;
}

bot_door_purchase_should_cancel()
{
	return false;
}

bot_door_purchase_priority( obj )
{
	return 0;
}

bot_debris_purchase( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "debris_end_think" );
	level endon( "end_game" );

	debris_obj = obj;

	debris_ent = debris_obj.target_ent;
	self bot_set_objective( "debris", debris_ent );
	self bot_objective_print( "debris", debris_obj.id, "Bot <" + self.playername + "> Attempting to purchase " + debris_ent.target, "bot_debris_purchase" );

	lookat_org = debris_ent.origin;
	goal_org = debris_ent.origin;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 48 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "door_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "debris", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_debris_purchase_init()
{
	self.successfully_bought_debris = false;
}

bot_debris_purchase_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_bought_debris = false;
}

bot_should_purchase_debris( struct )
{
	debris_objs = get_all_objectives_for_group( "debris" );
	if ( debris_objs.size <= 0 )
	{
		return false;
	}
	self.available_doors = [];
	debris_objs_keys = getArrayKeys( debris_objs );
	for ( i = 0; i < debris_objs.size; i++ )
	{
		obj = debris_objs[ debris_objs_keys[ i ] ];
		debris_ent = obj.target_ent;
		if ( self.score < debris_ent.zombie_cost )
		{
			self bot_objective_print( "debris", obj.id, "Bot <" + self.playername + "> not purchasing <" + debris_ent.target + "> because we can't afford it", "bot_should_purchase_debris" );
			continue;
		}
		if ( self GetPathIsInaccessible( debris_ent.origin, 192.0 ) )
		{
			self bot_objective_print( "debris", obj.id, "Bot <" + self.playername + "> not purchasing <" + debris_ent.target + "> because it cannot be pathed to", "bot_should_purchase_debris" );
			continue;
		}
		self.available_doors[ self.available_doors.size ] = obj;
	}
	struct.possible_objs = self.available_doors;
	return self.available_doors.size > 0;
}

bot_check_complete_debris_purchase()
{
	return self.successfully_bought_debris;
}

bot_debris_purchase_should_cancel()
{
	return false;
}

bot_debris_purchase_priority( obj )
{
	return 0;
}

bot_wallbuy_purchase( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "wallbuy_end_think" );
	level endon( "end_game" );

	wallbuy_obj = obj;

	wallbuy_ent = wallbuy_obj.target_ent;
	self bot_set_objective( "wallbuy", wallbuy_ent );
	self bot_objective_print( "wallbuy", wallbuy_obj.id, "Bot <" + self.playername + "> Attempting to purchase " + wallbuy_ent.zombie_weapon_upgrade, "bot_wallbuy_purchase" );

	lookat_org = wallbuy_ent.origin;
	goal_org = wallbuy_ent.bot_use_node;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 24 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "wallbuy_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "wallbuy", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_wallbuy_purchase_init()
{
	self.successfully_bought_wallbuy = false;
}

bot_wallbuy_purchase_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_bought_wallbuy = false;
}

bot_should_purchase_wallbuy( struct )
{
	wallbuy_objs = get_all_objectives_for_group( "wallbuy" );
	if ( wallbuy_objs.size <= 0 )
	{
		return false;
	}
	self.available_wallbuys = [];
	wallbuy_objs_keys = getArrayKeys( wallbuy_objs );
	wallbuy_objs_keys = array_randomize( wallbuy_objs_keys );
	for ( i = 0; i < wallbuy_objs.size; i++ )
	{
		obj = wallbuy_objs[ wallbuy_objs_keys[ i ] ];
		wallbuy_ent = obj.target_ent;
		weapon = wallbuy_ent.zombie_weapon_upgrade;
		if ( isDefined( self.last_wallbuy_purchase_time ) && getTime() < ( self.last_wallbuy_purchase_time + 60000 ) )
		{
			self bot_objective_print( "wallbuy", obj.id, "Bot <" + self.playername + "> not purchasing <" + weapon + "> because this action is on cooldown", "bot_should_purchase_wallbuy" );
			continue;
		}
		if ( self hasWeapon( weapon ) )
		{
			self bot_objective_print( "wallbuy", obj.id, "Bot <" + self.playername + "> not purchasing <" + weapon + "> because we already have it", "bot_should_purchase_wallbuy" );
			continue;
		}
		if ( self.score < maps\so\zm_common\_zm_weapons::get_weapon_cost( weapon ) )
		{
			self bot_objective_print( "wallbuy", obj.id, "Bot <" + self.playername + "> not purchasing <" + weapon + "> because we can't afford it", "bot_should_purchase_wallbuy" );
			continue;
		}
		if ( self GetPathIsInaccessible( wallbuy_ent.bot_use_node ) )
		{
			self bot_objective_print( "wallbuy", obj.id, "Bot <" + self.playername + "> not purchasing <" + weapon + "> because it cannot be pathed to", "bot_should_purchase_wallbuy" );
			continue;
		}
		self.available_wallbuys[ self.available_wallbuys.size ] = obj;
	}
	struct.possible_objs = self.available_wallbuys;
	return self.available_wallbuys.size > 0;
}

bot_check_complete_wallbuy_purchase()
{
	return self.successfully_bought_wallbuy;
}

bot_wallbuy_purchase_should_cancel()
{
	return false;
}

bot_wallbuy_purchase_priority( obj )
{
	return 0;
}

bot_wallbuy_ammo_purchase( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "wallbuyammo_end_think" );
	level endon( "end_game" );

	wallbuy_obj = obj;

	wallbuy_ent = wallbuy_obj.target_ent;
	self bot_set_objective( "wallbuyammo", wallbuy_ent );
	self bot_objective_print( "wallbuyammo", wallbuy_obj.id, "Bot <" + self.playername + "> Attempting to purchase " + wallbuy_ent.zombie_weapon_upgrade, "bot_wallbuy_ammo_purchase" );

	lookat_org = wallbuy_ent.origin;
	goal_org = wallbuy_ent.bot_use_node;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 24 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "wallbuy_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "wallbuyammo", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_wallbuy_ammo_purchase_init()
{
	self.successfully_bought_wallbuy_ammo = false;
}

bot_wallbuy_ammo_purchase_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_bought_wallbuy_ammo = false;
}

bot_should_purchase_wallbuy_ammo( struct )
{
	wallbuy_objs = get_all_objectives_for_group( "wallbuyammo" );
	if ( wallbuy_objs.size <= 0 )
	{
		return false;
	}
	self.available_wallbuyammos = [];
	wallbuy_objs_keys = getArrayKeys( wallbuy_objs );
	wallbuy_objs_keys = array_randomize( wallbuy_objs_keys );
	for ( i = 0; i < wallbuy_objs.size; i++ )
	{
		obj = wallbuy_objs[ wallbuy_objs_keys[ i ] ];
		wallbuy_ent = obj.target_ent;
		weapon = wallbuy_ent.zombie_weapon_upgrade;
		if ( !self hasWeapon( weapon ) )
		{
			self bot_objective_print( "wallbuyammo", obj.id, "Bot <" + self.playername + "> not purchasing ammo for <" + weapon + "> because we don't have the weapon in our inventory", "bot_should_purchase_wallbuy_ammo" );
			continue;
		}
		if ( self.score < maps\so\zm_common\_zm_weapons::get_ammo_cost( weapon ) )
		{
			self bot_objective_print( "wallbuyammo", obj.id, "Bot <" + self.playername + "> not purchasing ammo for <" + weapon + "> because we can't afford it", "bot_should_purchase_wallbuy_ammo" );
			continue;
		}
		if ( ( self GetWeaponAmmoStock( weapon ) / WeaponMaxAmmo( weapon ) ) > 0.3 )
		{
			self bot_objective_print( "wallbuyammo", obj.id, "Bot <" + self.playername + "> not purchasing ammo for <" + weapon + "> because we don't need ammo", "bot_should_purchase_wallbuy_ammo" );
			continue;
		}
		if ( self GetPathIsInaccessible( wallbuy_ent.bot_use_node ) )
		{
			self bot_objective_print( "wallbuyammo", obj.id, "Bot <" + self.playername + "> not purchasing ammo for <" + weapon + "> because it cannot be pathed to", "bot_should_purchase_wallbuy_ammo" );
			continue;
		}
		self.available_wallbuyammos[ self.available_wallbuyammos.size ] = obj;
	}
	struct.possible_objs = self.available_wallbuyammos;
	return self.available_wallbuyammos.size > 0;
}

bot_check_complete_wallbuy_ammo_purchase()
{
	return self.successfully_bought_wallbuy_ammo;
}

bot_wallbuy_ammo_purchase_should_cancel()
{
	return false;
}

bot_wallbuy_ammo_purchase_priority()
{
	return 0;
}

bot_packapunch_purchase( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "packapunch_end_think" );
	level endon( "end_game" );

	packapunch_obj = obj;

	packapunch = packapunch_obj.target_ent;
	self bot_set_objective( "packapunch", packapunch );
	//self bot_set_objective_owner( "magicbox", magicbox );
	self bot_objective_print( "packapunch", packapunch_obj.id, "Bot <" + self.playername + "> Attempting to purchase packapunch", "bot_packapunch_purchase" );

	lookat_org = packapunch.origin + ( 0, 0, 35 );
	goal_org = packapunch.bot_use_node;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "packapunch_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
	wait 0.75;
	waittillframeend;
	//self ClearScriptAimPos();
	//self ClearScriptGoal();

	packapunch waittill( "pap_pickup_ready" );
	self bot_objective_print( "packapunch", packapunch_obj.id, "Bot <" + self.playername + "> pap_pickup_ready", "bot_packapunch_purchase" );

	self ClearScriptAimPos();
	self SetPriorityObjective();
	self SetScriptGoal( goal_org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal on pickup";
		self notify( "packapunch_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "packapunch", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_packapunch_purchase_init()
{
	self.successfully_bought_packapunch = false;
}

bot_packapunch_purchase_post_think( state )
{
	self bot_post_think_common( state );
	self.successfully_bought_packapunch = false;
}

bot_should_purchase_packapunch( struct )
{
	packapunch_objs = get_all_objectives_for_group( "packapunch" );
	if ( packapunch_objs.size <= 0 )
	{
		return false;
	}
	self.available_packapunchs = [];
	packapunch_objs_keys = getArrayKeys( packapunch_objs );
	packapunch_objs_keys = array_randomize( packapunch_objs_keys );
	for ( i = 0; i < packapunch_objs.size; i++ )
	{
		obj = packapunch_objs[ packapunch_objs_keys[ i ] ];
		packapunch_ent = obj.target_ent;
		if ( self.score < level._custom_packapunch.cost )
		{
			self bot_objective_print( "packapunch", obj.id, "Bot <" + self.playername + "> not purchasing packapunch because we can't afford it", "bot_should_purchase_packapunch" );
			continue;
		}
		if ( self GetPathIsInaccessible( packapunch_ent.bot_use_node ) )
		{
			self bot_objective_print( "packapunch", obj.id, "Bot <" + self.playername + "> not purchasing packapunch because it cannot be pathed to", "bot_should_purchase_packapunch" );
			continue;
		}
		self.available_packapunchs[ self.available_packapunchs.size ] = obj;
	}
	struct.possible_objs = self.available_packapunchs;
	return self.available_packapunchs.size > 0;
}

bot_check_complete_packapunch_purchase()
{
	return self.successfully_bought_packapunch;
}

bot_packapunch_purchase_should_cancel()
{
	obj = self bot_get_objective();

	goal_canceled = false;
	if ( isDefined( obj.target_ent.packapunch_weapon_spawn_time )
		&& isDefined( obj.target_ent.packapunch_user )
		&& obj.target_ent.packapunch_user == self
		&& ( getTime() >= ( obj.target_ent_packapunch_weapon_spawn_time + ( level.packapunch_timeout * 1000 ) ) ) )
	{
		self.obj_cancel_reason = "Weapon timed out";
		goal_canceled = true;
	}
	return goal_canceled;
}

bot_packapunch_purchase_priority( obj )
{
	return 0;
}

bot_power_activate( obj )
{
	if ( !isDefined( obj ) )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "power_end_think" );
	level endon( "end_game" );

	power_obj = obj;

	power_ent = power_obj.target_ent;
	self bot_set_objective( "power", power_ent );
	self bot_objective_print( "power", power_obj.id, "Bot <" + self.playername + "> Attempting to activate power", "bot_power_activate" );

	lookat_org = power_ent.origin;
	goal_org = power_ent.bot_use_node;

	self ClearScriptAimPos();
	self SetScriptGoal( goal_org, 24 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		self.obj_cancel_reason = "Bad path/new goal";
		self notify( "power_cancel" );
		return;
	}

	self SetScriptAimPos( lookat_org );
	self thread bot_obj_timeout( "power", 2 );
	wait randomFloatRange( 0.5, 1.5 );

	self thread BotPressUse( 0.2 );
}

bot_power_activate_init()
{
	self.successfully_activated_power = false;
}

bot_power_activate_post_think(state)
{
	self bot_post_think_common( state );
	self.successfully_activated_power = false;
}

bot_should_activate_power( struct )
{
	power_objs = get_all_objectives_for_group( "power" );
	if ( power_objs.size <= 0 )
	{
		return false;
	}
	self.available_powers = [];
	power_objs_keys = getArrayKeys( power_objs );
	power_objs_keys = array_randomize( power_objs_keys );
	for ( i = 0; i < power_objs.size; i++ )
	{
		obj = power_objs[ power_objs_keys[ i ] ];
		power_ent = obj.target_ent;
		if ( self GetPathIsInaccessible( power_ent.bot_use_node ) )
		{
			self bot_objective_print( "power", obj.id, "Bot <" + self.playername + "> not activating power because it cannot be pathed to", "bot_power_activate" );
			continue;
		}
		self.available_powers[ self.available_powers.size ] = obj;
	}
	struct.possible_objs = self.available_powers;
	return self.available_powers.size > 0;
}

bot_check_complete_power_activate()
{
	return self.successfully_activated_power;
}

bot_power_activate_should_cancel()
{
	obj = self bot_get_objective();

	goal_canceled = false;
	if ( isDefined( level.flag[ "power_on" ] ) && level.flag[ "power_on" ] )
	{
		self.obj_cancel_reason = "Power is already on";
		goal_canceled = true;
	}
	return goal_canceled;
}

bot_power_activate_priority( obj )
{
	return 0;
}
