#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_common;

bot_post_think_common( state, obj_ent )
{
	obj = bot_objective_history_get_current();

	switch ( state )
	{
		case "completed":
			bot_objective_print( "powerup", obj.id, "Bot <" + self.playername + "> objective was completed", "bot_post_think_common" );
			break;
		case "postponed":
			bot_objective_print( "powerup", obj.id, "Bot <" + self.playername + "> objective was postponed Reason: " + self.obj_postponed_reason, "bot_post_think_common" );
			break;
		case "canceled":
			bot_objective_print( "powerup", obj.id, "Bot <" + self.playername + "> objective was canceled Reason: " + self.obj_cancel_reason, "bot_post_think_common" );
			break;
	}
	self.obj_postponed_reason = "";
	self.obj_cancel_reason = "";
	self ClearScriptGoal();
	self ClearScriptAimPos();
	self ClearPriorityObjective();
	self bot_clear_objective();	
}

bot_grab_powerup()
{
	self endon( "disconnect" );
	self endon( "powerup_end_think" );
	self endon( "bot_in_invalid_state" );
	level endon( "end_game" );

	if ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 )
	{
		return;
	}

	powerup_obj = self.available_powerups[ 0 ];
	powerup_obj_ent = powerup_obj.target_ent;
	self bot_set_objective( "powerup", powerup_obj_ent );
	self bot_set_objective_owner( "powerup", powerup_obj_ent );

	bot_objective_print( "powerup", powerup_obj.id, "Bot <" + self.playername + "> starts objective", "bot_grab_powerup" );
	while ( true )
	{
		wait 1;
		self SetPriorityObjective();
		self SetScriptGoal( powerup_obj_ent.origin );

		result = self waittill_any_return( "goal", "bad_path", "new_goal" );

		if ( result != "goal" )
		{
			bot_objective_print( "powerup", powerup_obj.id, "Bot <" + self.playername + "> bad path", "bot_grab_powerup" );
			continue;
		}
		//Wait to see if the bot was able to grab the powerup
		wait 0.5;
		//Check if powerup still exists
		if ( isDefined( powerup_obj_ent ) )
		{
			height_difference = powerup_obj_ent.origin[ 2 ] - self.origin[ 2 ];
			if ( height_difference > 0 && height_difference < 49 )
			{
				self BotJump();
				wait 0.5;
				waittillframeend;
				//Check if bot was able to grab the powerup by jumping
				if ( self bot_has_objective() || isDefined( powerup_obj_ent ) )
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
				bot_objective_print( "powerup", powerup_obj.id, "Bot <" + self.playername + "> objective was marked as bad", "bot_grab_powerup" );
				break;
			}
		}
	}
}

bot_powerup_process_order()
{
	return 0;
}

bot_powerup_init()
{
	self.successfully_grabbed_powerup = false;
}

bot_powerup_post_think( state )
{
	obj = self bot_get_objective();
	powerup_obj_ent = obj.target_ent;
	self bot_post_think_common( state, powerup_obj_ent );
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
		if ( !isDefined( generatePath( self.origin, powerup.origin, self.team, level.bot_allowed_negotiation_links ) ) )
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

	canceled_goal = false;
	if ( !self bot_is_objective_owner( "powerup", obj.target_ent ) )
	{
		self.obj_cancel_reason = "No longer the obj owner";
		canceled_goal = true;
	}
	if ( canceled_goal )
	{
		self notify( "goal" );
	}
	return canceled_goal;
}

bot_powerup_should_postpone()
{
	return false;
}

bot_powerup_priority()
{
	if ( !isDefined( self.available_powerups ) )
	{
		return 0;
	}
	//return self.available_powerups[ 0 ].target_ent.priority;
	return 0;
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
	self endon( "bot_in_invalid_state" );
	level endon( "end_game" );

	player_to_revive_obj = self.available_revives[ 0 ];
	
	player_to_revive = player_to_revive_obj.target_ent;
	self bot_set_objective( "revive", player_to_revive );
	self bot_set_objective_owner( "revive", player_to_revive );
	bot_objective_print( "revive", player_to_revive_obj.id, "Bot <" + self.playername + "> objective started", "bot_revive_player" );
	//If player is no longer valid to revive stop trying to revive
	//If bot doesn't have an objective anymore or the objective has changed stop trying to revive
	while ( true )
	{
		wait 1;
		//Constantly update the goal just in case the player is moving(T5 or higher only)
		self ClearScriptAimPos();
		self SetPriorityObjective();
		self SetScriptGoal( player_to_revive.origin, 32 );

		result = self waittill_any_return( "goal", "bad_path", "new_goal" );

		if ( result != "goal" )
		{
			bot_objective_print( "revive", player_to_revive_obj.id, "Bot <" + self.playername + "> bad path", "bot_revive_player" );
			continue;
		}
		if ( !isDefined( player_to_revive.revivetrigger ) )
		{
			continue;
		}
		//Check if the bot is reviving the player already and also that the player isn't being revived already
		if ( player_to_revive.revivetrigger.beingrevived )
		{
			continue;
		}

		self SetScriptAimPos( player_to_revive.origin );

		time = 3.2;
		if ( self hasPerk( "specialty_quickrevive" ) )
		{
			time /= 2;
		}
		self thread BotPressUse( time );

		while ( self maps\_laststand::is_reviving( player_to_revive ) )
		{
			wait 0.05;
		}
		//Wait to see if we cleared the objective by successfully reviving the player
		waittillframeend;
	}
}

bot_revive_process_order()
{
	return 0;
}

bot_revive_player_init()
{
	self.should_cancel_revive_obj = false;
	self.successfully_revived_player = false;
}

bot_revive_player_post_think( state )
{
	obj = self bot_get_objective();
	revive_obj_ent = obj.target_ent;
	self bot_post_think_common( state, revive_obj_ent );
	self.should_cancel_revive_obj = false;
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
		if ( isDefined( obj.owner ) )
		{
			continue;
		}
		if ( obj.bad )
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
	if ( goal_canceled )
	{
		self notify( "goal" );
	}
	return goal_canceled;
}

bot_revive_player_should_postpone()
{
	return false;
}

bot_revive_player_priority()
{
	return 0;
}

bot_magicbox_purchase()
{
	self.target_pos = self.available_chests[ 0 ].origin;
}

bot_magicbox_purchase_process_order()
{

}

bot_magicbox_purchase_init()
{

}

bot_magicbox_purchase_post_think( state )
{
	obj = self bot_get_objective();
	magicbox_obj_ent = obj.target_ent;
	self bot_post_think_common( state, magicbox_obj_ent );	
}

bot_should_purchase_magicbox()
{
	magicbox_objs = get_all_objectives_for_group( "magicbox" );
	if ( magicbox_objs.size <= 0 )
	{
		return false;
	}
	if ( !level.enable_magic )
	{
		return false;
	}
	if ( level.chests.size <= 0 )
	{
		return false;
	}
	self.available_chests = [];
	for ( i = 0; i < magicbox_objs.size; i++ )
	{
		if ( level.chests[ i ].hidden )
		{
			continue;
		}
		if ( self.score < level.chests[ i ].zombie_cost )
		{
			continue;
		}
		self.available_chests[ self.available_chests.size ] = level.chests[ i ];
	}
	if ( self.available_chests.size > 0 )
	{
		for ( i = 0; i < self.available_chests.size; i++ )
		{
			if ( isDefined( self.available_chests[ i ].chest_user ) )
			{
				maps\_utility::array_remove_index( self.available_chests, i );
				i--;
			}
		}
	}
	return self.available_chests.size > 0;
}

bot_check_complete_purchase_magicbox() 
{
	return false;
}

bot_magicbox_purchase_should_cancel()
{
	return false;
}

bot_magicbox_purchase_should_postpone()
{
	return false;
}

bot_magicbox_purchase_priority()
{
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
}