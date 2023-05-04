#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_common;

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

	set_bot_global_shared_objective_owner_by_ent( "powerup", powerup_obj_ent, self );
	self bot_set_objective( "powerup", powerup_obj_ent );

	bot_objective_print( "powerup", powerup_obj_ent, "Bot <" + self.playername + "> starts objective" );
	while ( isDefined( powerup_obj_ent ) && isDefined( powerup_obj ) && self bot_is_objective_owner( "powerup", powerup_obj_ent ) )
	{
		wait 1;
		self SetPriorityObjective();
		self SetScriptGoal( powerup_obj_ent.origin );

		result = self waittill_any_return( "goal", "bad_path", "new_goal" );

		if ( result != "goal" )
		{
			bot_objective_print( "powerup", powerup_obj_ent, "Bot <" + self.playername + "> bad path" );
			continue;
		}
		//Wait to see if the bot was able to grab the powerup
		wait 0.5;
		//Check if powerup still exists
		if ( isDefined( powerup_obj_ent ) )
		{
			height_difference = self.origin[ 2 ] - powerup_obj_ent.origin[ 2 ];
			if ( height_difference < 49 )
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
				bot_objective_print( "powerup", powerup_obj_ent, "Bot <" + self.playername + "> objective was marked as bad" );
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
	switch ( state )
	{
		case "completed":
			bot_objective_print( "powerup", powerup_obj_ent, "Bot <" + self.playername + "> objective was completed" );
			break;
		case "postponed":
			bot_objective_print( "powerup", powerup_obj_ent, "Bot <" + self.playername + "> objective was postponed Reason: " + self.obj_postponed_reason );
			break;
		case "canceled":
			bot_objective_print( "powerup", powerup_obj_ent, "Bot <" + self.playername + "> objective was canceled Reason: " + self.obj_cancel_reason );
			break;
	}
	self.successfully_grabbed_powerup = false;
	self.obj_cancel_reason = "";
	self ClearScriptGoal();
	self ClearScriptAimPos();
	self ClearPriorityObjective();
	self clear_objective_for_bot();
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
	if ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 )
	{
		self.obj_cancel_reason = "No available powerups";
		return true;
	}
	if ( !isDefined( self.available_powerups[ 0 ].target_ent ) )
	{
		self.obj_cancel_reason = "Powerup doesn't exist";
		return true;
	}
	return false ;
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
	set_bot_global_shared_objective_owner_by_ent( "revive", player_to_revive, self );
	bot_objective_print( "revive", player_to_revive, "Bot <" + self.playername + "> objective started" );
	//If player is no longer valid to revive stop trying to revive
	//If bot doesn't have an objective anymore or the objective has changed stop trying to revive
	while ( isDefined( player_to_revive ) && isDefined( player_to_revive_obj ) && self bot_is_objective_owner( "revive", player_to_revive ) )
	{
		wait 1;
		//Constantly update the goal just in case the player is moving(T5 or higher only)
		self ClearScriptAimPos();
		self SetPriorityObjective();
		self SetScriptGoal( player_to_revive.origin, 32 );

		result = self waittill_any_return( "goal", "bad_path", "new_goal" );

		//printConsole( result );
		if ( result != "goal" )
		{
			bot_objective_print( "revive", player_to_revive, "Bot <" + self.playername + "> bad path" );
			continue;
		}
		if ( !isDefined( player_to_revive.revivetrigger ) )
		{
			return;
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
	switch ( state )
	{
		case "completed":
			bot_objective_print( "revive", revive_obj_ent, "Bot <" + self.playername + "> objective was completed" );
			break;
		case "postponed":
			bot_objective_print( "revive", revive_obj_ent, "Bot <" + self.playername + "> objective was postponed Reason: " + self.obj_postponed_reason );
			break;
		case "canceled":
			bot_objective_print( "revive", revive_obj_ent, "Bot <" + self.playername + "> objective was canceled Reason: " + self.obj_cancel_reason );
			break;
	}
	self.should_cancel_revive_obj = false;
	self.successfully_revived_player = false;
	self.obj_cancel_reason = "";
	self ClearScriptGoal();
	self ClearScriptAimPos();
	self ClearPriorityObjective();
	self clear_objective_for_bot();
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
	if ( !isDefined( self.available_revives[ 0 ] ) )
	{
		self.obj_cancel_reason = "Obj didn't exist";
		return true;
	}
	if ( !isDefined( self.available_revives[ 0 ].target_ent ) )
	{
		self.obj_cancel_reason = "Entity didn't exist";
		return true;
	}
	if ( !isDefined( self.available_revives[ 0 ].target_ent.revivetrigger ) )
	{
		self.obj_cancel_reason = "Revive trigger didn't exist";
		return true;
	}
	return false;
}

bot_revive_player_should_postpone()
{
	return false;
}

bot_revive_player_priority()
{
	return 0;
}