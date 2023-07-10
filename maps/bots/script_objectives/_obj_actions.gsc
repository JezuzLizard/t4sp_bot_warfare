#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_common;

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

bot_grab_powerup()
{
	self endon( "disconnect" );
	self endon( "powerup_end_think" );
	level endon( "end_game" );

	if ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 )
	{
		return;
	}

	powerup_obj = self.available_powerups[ 0 ];
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

bot_should_grab_powerup()
{
	if ( level.zbot_objective_glob[ "powerup" ].active_objectives.size <= 0 )
	{
		return false;
	}
	MAX_DISTANCE_SQ = 10000 * 10000;
	BOT_SPEED_WHILE_SPRINTING_SQ = 285 * 285;
	self.available_powerups = [];

	powerup_objectives = level.zbot_objective_glob[ "powerup" ].active_objectives;
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

	//TODO: Sort powerups by priority here
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

bot_powerup_priority()
{
	return 3;
}

//TODO: Possibly add the ability to circle revive?
bot_revive_player()
{
	if ( !isDefined( self.available_revives ) || self.available_revives.size <= 0 )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "revive_end_think" );
	level endon( "end_game" );

	player_to_revive_obj = self.available_revives[ 0 ];
	
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

bot_should_revive_player()
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

bot_revive_player_priority()
{
	return 2;
}

bot_magicbox_purchase()
{
	if ( !isDefined( self.available_chests ) || self.available_chests.size <= 0 )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "magicbox_end_think" );
	level endon( "end_game" );

	magicbox_obj = self.available_chests[ 0 ];
	
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

bot_should_purchase_magicbox()
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
	if ( isDefined( obj.magicbox_weapon_spawn_time ) && ( getTime() >= ( obj.magicbox_weapon_spawn_time + 12000 ) ) )
	{
		self.obj_cancel_reason = "Weapon timed out";
		goal_canceled = true;	
	}
	return goal_canceled;
}

bot_magicbox_purchase_priority()
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

bot_perk_purchase()
{
	if ( !isDefined( self.available_perks ) || self.available_perks.size <= 0 )
	{
		return;
	}

	self endon( "disconnect" );
	self endon( "perk_end_think" );
	level endon( "end_game" );

	perk_obj = self.available_perks[ 0 ];
	
	perk_ent = perk_obj.target_ent;
	self bot_set_objective( "perk", perk_ent );
	self bot_objective_print( "perk", perk_obj.id, "Bot <" + self.playername + "> Attempting to purchase " + perk_ent.script_noteworthy, "bot_perk_purchase" );

	lookat_org = perk_ent.origin + ( 0, 0, 35 );
	goal_org = perk_ent.bot_use_node;

	self SetPriorityObjective();
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

bot_should_purchase_perk()
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

bot_perk_purchase_priority()
{
	return 1;
}