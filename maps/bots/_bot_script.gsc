#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;

/*
	When the bot gets added into the game.
*/
added()
{
	self endon( "disconnect" );

	self set_diff();
}

/*
	When the bot connects to the game.
*/
connected()
{
	self endon( "disconnect" );

	self thread difficulty();
	self thread onBotSpawned();
	self thread onSpawned();
}

/*
	The callback for when the bot gets damaged.
*/
onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
}

/*
	Updates the bot's difficulty variables.
*/
difficulty()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		if ( GetDvarInt( "bots_skill" ) != 9 )
		{
			switch ( self.pers["bots"]["skill"]["base"] )
			{
				case 1:
					self.pers["bots"]["skill"]["aim_time"] = 0.6;
					self.pers["bots"]["skill"]["init_react_time"] = 1500;
					self.pers["bots"]["skill"]["reaction_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 500;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 600;
					self.pers["bots"]["skill"]["remember_time"] = 750;
					self.pers["bots"]["skill"]["fov"] = 0.7;
					self.pers["bots"]["skill"]["dist_max"] = 2500;
					self.pers["bots"]["skill"]["dist_start"] = 1000;
					self.pers["bots"]["skill"]["spawn_time"] = 0.75;
					self.pers["bots"]["skill"]["help_dist"] = 0;
					self.pers["bots"]["skill"]["semi_time"] = 0.9;
					self.pers["bots"]["skill"]["shoot_after_time"] = 1;
					self.pers["bots"]["skill"]["aim_offset_time"] = 1.5;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 4;
					self.pers["bots"]["skill"]["bone_update_interval"] = 2;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_ankle_le,j_ankle_ri";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 0;
					self.pers["bots"]["behavior"]["nade"] = 10;
					self.pers["bots"]["behavior"]["sprint"] = 30;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 20;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 0;
					break;

				case 2:
					self.pers["bots"]["skill"]["aim_time"] = 0.55;
					self.pers["bots"]["skill"]["init_react_time"] = 1000;
					self.pers["bots"]["skill"]["reaction_time"] = 800;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 1250;
					self.pers["bots"]["skill"]["remember_time"] = 1500;
					self.pers["bots"]["skill"]["fov"] = 0.65;
					self.pers["bots"]["skill"]["dist_max"] = 3000;
					self.pers["bots"]["skill"]["dist_start"] = 1500;
					self.pers["bots"]["skill"]["spawn_time"] = 0.65;
					self.pers["bots"]["skill"]["help_dist"] = 500;
					self.pers["bots"]["skill"]["semi_time"] = 0.75;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.75;
					self.pers["bots"]["skill"]["aim_offset_time"] = 1;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 3;
					self.pers["bots"]["skill"]["bone_update_interval"] = 1.5;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_ankle_le,j_ankle_ri,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 10;
					self.pers["bots"]["behavior"]["nade"] = 15;
					self.pers["bots"]["behavior"]["sprint"] = 45;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 15;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 10;
					break;

				case 3:
					self.pers["bots"]["skill"]["aim_time"] = 0.4;
					self.pers["bots"]["skill"]["init_react_time"] = 750;
					self.pers["bots"]["skill"]["reaction_time"] = 500;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 1500;
					self.pers["bots"]["skill"]["remember_time"] = 2000;
					self.pers["bots"]["skill"]["fov"] = 0.6;
					self.pers["bots"]["skill"]["dist_max"] = 4000;
					self.pers["bots"]["skill"]["dist_start"] = 2250;
					self.pers["bots"]["skill"]["spawn_time"] = 0.5;
					self.pers["bots"]["skill"]["help_dist"] = 750;
					self.pers["bots"]["skill"]["semi_time"] = 0.65;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.65;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.75;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 2.5;
					self.pers["bots"]["skill"]["bone_update_interval"] = 1;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_spineupper,j_ankle_le,j_ankle_ri,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 20;
					self.pers["bots"]["behavior"]["nade"] = 20;
					self.pers["bots"]["behavior"]["sprint"] = 50;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 25;
					break;

				case 4:
					self.pers["bots"]["skill"]["aim_time"] = 0.3;
					self.pers["bots"]["skill"]["init_react_time"] = 600;
					self.pers["bots"]["skill"]["reaction_time"] = 400;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 1500;
					self.pers["bots"]["skill"]["remember_time"] = 3000;
					self.pers["bots"]["skill"]["fov"] = 0.55;
					self.pers["bots"]["skill"]["dist_max"] = 5000;
					self.pers["bots"]["skill"]["dist_start"] = 3350;
					self.pers["bots"]["skill"]["spawn_time"] = 0.35;
					self.pers["bots"]["skill"]["help_dist"] = 1000;
					self.pers["bots"]["skill"]["semi_time"] = 0.5;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.5;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.5;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 2;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.75;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_spineupper,j_ankle_le,j_ankle_ri,j_head,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 30;
					self.pers["bots"]["behavior"]["nade"] = 25;
					self.pers["bots"]["behavior"]["sprint"] = 55;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 35;
					break;

				case 5:
					self.pers["bots"]["skill"]["aim_time"] = 0.25;
					self.pers["bots"]["skill"]["init_react_time"] = 500;
					self.pers["bots"]["skill"]["reaction_time"] = 300;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1500;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 2000;
					self.pers["bots"]["skill"]["remember_time"] = 4000;
					self.pers["bots"]["skill"]["fov"] = 0.5;
					self.pers["bots"]["skill"]["dist_max"] = 7500;
					self.pers["bots"]["skill"]["dist_start"] = 5000;
					self.pers["bots"]["skill"]["spawn_time"] = 0.25;
					self.pers["bots"]["skill"]["help_dist"] = 1500;
					self.pers["bots"]["skill"]["semi_time"] = 0.4;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.35;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.35;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 1.5;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.5;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 40;
					self.pers["bots"]["behavior"]["nade"] = 35;
					self.pers["bots"]["behavior"]["sprint"] = 60;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 50;
					break;

				case 6:
					self.pers["bots"]["skill"]["aim_time"] = 0.2;
					self.pers["bots"]["skill"]["init_react_time"] = 250;
					self.pers["bots"]["skill"]["reaction_time"] = 150;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 2000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 3000;
					self.pers["bots"]["skill"]["remember_time"] = 5000;
					self.pers["bots"]["skill"]["fov"] = 0.45;
					self.pers["bots"]["skill"]["dist_max"] = 10000;
					self.pers["bots"]["skill"]["dist_start"] = 7500;
					self.pers["bots"]["skill"]["spawn_time"] = 0.2;
					self.pers["bots"]["skill"]["help_dist"] = 2000;
					self.pers["bots"]["skill"]["semi_time"] = 0.25;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.25;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.25;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 1;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.25;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_head,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 50;
					self.pers["bots"]["behavior"]["nade"] = 45;
					self.pers["bots"]["behavior"]["sprint"] = 65;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 75;
					break;

				case 7:
					self.pers["bots"]["skill"]["aim_time"] = 0.1;
					self.pers["bots"]["skill"]["init_react_time"] = 100;
					self.pers["bots"]["skill"]["reaction_time"] = 50;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 2500;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 4000;
					self.pers["bots"]["skill"]["remember_time"] = 7500;
					self.pers["bots"]["skill"]["fov"] = 0.4;
					self.pers["bots"]["skill"]["dist_max"] = 15000;
					self.pers["bots"]["skill"]["dist_start"] = 10000;
					self.pers["bots"]["skill"]["spawn_time"] = 0.05;
					self.pers["bots"]["skill"]["help_dist"] = 3000;
					self.pers["bots"]["skill"]["semi_time"] = 0.1;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 0;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.05;
					self.pers["bots"]["skill"]["bones"] = "j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 65;
					self.pers["bots"]["behavior"]["nade"] = 65;
					self.pers["bots"]["behavior"]["sprint"] = 70;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 5;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 90;
					break;
			}
		}

		wait 5;
	}
}

/*
	Sets the bot difficulty.
*/
set_diff()
{
	rankVar = GetDvarInt( "bots_skill" );

	switch ( rankVar )
	{
		case 0:
			self.pers["bots"]["skill"]["base"] = Round( random_normal_distribution( 3.5, 1.75, 1, 7 ) );
			break;

		case 8:
			break;

		case 9:
			self.pers["bots"]["skill"]["base"] = randomIntRange( 1, 7 );
			self.pers["bots"]["skill"]["aim_time"] = 0.05 * randomIntRange( 1, 20 );
			self.pers["bots"]["skill"]["init_react_time"] = 50 * randomInt( 100 );
			self.pers["bots"]["skill"]["reaction_time"] = 50 * randomInt( 100 );
			self.pers["bots"]["skill"]["no_trace_ads_time"] = 50 * randomInt( 100 );
			self.pers["bots"]["skill"]["no_trace_look_time"] = 50 * randomInt( 100 );
			self.pers["bots"]["skill"]["remember_time"] = 50 * randomInt( 100 );
			self.pers["bots"]["skill"]["fov"] = randomFloatRange( -1, 1 );

			randomNum = randomIntRange( 500, 25000 );
			self.pers["bots"]["skill"]["dist_start"] = randomNum;
			self.pers["bots"]["skill"]["dist_max"] = randomNum * 2;

			self.pers["bots"]["skill"]["spawn_time"] = 0.05 * randomInt( 20 );
			self.pers["bots"]["skill"]["help_dist"] = randomIntRange( 500, 25000 );
			self.pers["bots"]["skill"]["semi_time"] = randomFloatRange( 0.05, 1 );
			self.pers["bots"]["skill"]["shoot_after_time"] = randomFloatRange( 0.05, 1 );
			self.pers["bots"]["skill"]["aim_offset_time"] = randomFloatRange( 0.05, 1 );
			self.pers["bots"]["skill"]["aim_offset_amount"] = randomFloatRange( 0.05, 1 );
			self.pers["bots"]["skill"]["bone_update_interval"] = randomFloatRange( 0.05, 1 );
			self.pers["bots"]["skill"]["bones"] = "j_head,j_spineupper,j_ankle_ri,j_ankle_le";

			self.pers["bots"]["behavior"]["strafe"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["nade"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["sprint"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["camp"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["follow"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["crouch"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["switch"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["class"] = randomInt( 100 );
			self.pers["bots"]["behavior"]["jump"] = randomInt( 100 );
			break;

		default:
			self.pers["bots"]["skill"]["base"] = rankVar;
			break;
	}
}

/*
	When the bot spawned, after the difficulty wait. Start the logic for the bot.
*/
onBotSpawned()
{
	self endon( "disconnect" );
	level endon( "intermission" );

	for ( ;; )
	{
		self waittill( "bot_spawned" );

		self thread start_bot_threads();
	}
}

/*
	When the bot spawns.
*/
onSpawned()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );
		self thread bot_action_think();
		self.bot_lock_goal = false;
		self.bot_was_follow_script_update = undefined;
	}
}

/*
	Starts all the bot thinking
*/
start_bot_threads()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );
}

register_bot_objective( objective_group )
{
	if ( !isDefined( level.zbot_objective_glob ) )
	{
		level.zbot_objective_glob = [];
	}
	if ( !isDefined( level.zbot_objective_glob[ objective_group ] ) )
	{
		level.zbot_objective_glob[ objective_group ] = spawnStruct();
		level.zbot_objective_glob[ objective_group ].active_objectives = [];
	}
}

add_possible_bot_objective( objective_group, id, is_global_shared, target_ent )
{
	assert( isDefined( level.zbot_objective_glob ), "Trying to add objective before calling register_bot_objective" );

	assert( isDefined( level.zbot_objective_glob[ objective_group ] ), "Trying to add objective to group " + objective_group + " before calling register_bot_objective" );

	objective_struct = spawnStruct();
	objective_struct.group = objective_group;
	objective_struct.id = id;
	objective_struct.is_global_shared = is_global_shared;
	objective_struct.target_ent = target_ent;
	objective_struct.owner = undefined;
	objective_struct.is_objective = true;

	level.zbot_objective_glob[ objective_group ].active_objectives[ "obj_id_" + id ] = objective_struct;
}

get_bot_objective_by_id( objective_group, id )
{
	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	assert( isDefined( objective ), "Objective with " + id + " id does not point to a objective in group " + objective_group );

	return objective;
}

get_all_objectives_for_group( objective_group )
{
	return level.zbot_objective_glob[ objective_group ].active_objectives;
}

set_objective_for_bot( objective_group, id )
{
	possible_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = possible_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );

	assert( objective_exists, "Objective with " + id + " id does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	self.zbot_current_objective = objective;
}

clear_objective_for_bot()
{
	self.zbot_current_objective = undefined;
}

set_bot_objective_blocked_by_objective( primary_objective_group, primary_id, blocked_by_objective_group, blocked_by_id )
{
	primary_active_objectives = level.zbot_objective_glob[ primary_objective_group ].active_objectives;

	primary_objective = primary_active_objectives[ "obj_id_" + primary_id ];

	primary_objective_exists = isDefined( primary_objective );

	assert( primary_objective_exists, "Objective with " + primary_id + " id does not point to a objective in group " + primary_objective_group );
	if ( !primary_objective_exists )
	{
		return;
	}
	if ( primary_objective_group == blocked_by_objective_group )
	{
		assert( primary_id != blocked_by_id, "Objective with " + primary_id + " id should not be the same as the blocked_by_id if the objectives are in the same group of " + primary_objective_group );
		if ( primary_id == blocked_by_id )
		{
			return;
		}

		blocking_objective = primary_active_objectives[ "obj_id_" + blocked_by_id ];

		blocking_objective_exists = isDefined( blocking_objective );

		assert( blocking_objective_exists, "Objective with " + blocked_by_id + " id does not point to a objective in group " + blocked_by_objective_group );
		if ( !blocking_objective_exists )
		{
			return;
		}

		primary_objective.blocking_objective = blocking_objective;
	}
	else 
	{
		secondary_active_objectives = level.zbot_objective_glob[ blocked_by_objective_group ].active_objectives;

		blocking_objective = secondary_active_objectives[ "obj_id_" + blocked_by_id ];

		blocking_objective_exists = isDefined( blocking_objective );

		assert( blocking_objective_exists, "Objective with " + blocked_by_id + " id does not point to a objective in group " + blocked_by_objective_group );
		if ( !blocking_objective_exists )
		{
			return;
		}

		primary_objective.blocking_objective = blocking_objective;
	}
}

set_bot_global_shared_objective_owner_by_id( objective_group, id, new_owner )
{
	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	assert( objective_exists, "Objective with " + id + " id number does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	assert( objective.is_global_shared, "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
	if ( !objective.is_global_shared )
	{
		return;
	}

	objective.owner = new_owner;
}

set_bot_global_shared_objective_owner_by_reference( objective_group, objective, new_owner )
{
	is_objective = isDefined( objective.is_objective );
	assert( is_objective, "Objective arg is not a valid objective object" );
	if ( !is_objective )
	{
		return;
	}
	assert( objective.is_global_shared, "Objective with " + objective.id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
	if ( !objective.is_global_shared )
	{
		return;
	}

	objective.owner = new_owner;
}

free_bot_objective( objective_group, id )
{
	active_objectives = level.zbot_global_shared_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	assert( objective_exists, "Objective with " + id + " id number does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	players = getPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ].pers[ "isBot" ] )
		{
			if ( players[ i ].zbot_current_objective == objective )
			{
				players[ i ].zbot_current_objective = undefined;
			}
		}
	}

	objective = undefined;
}

register_bot_action( group_name, action_name, action_func, action_process_order_func, should_do_func, check_if_complete_func, set_complete_func, on_completion_func, should_cancel_func, on_cancel_func, should_postpone_func, on_postpone_func, priority_func )
{
	if ( !isDefined( level.zbots_actions ) )
	{
		level.zbots_actions = [];
	}
	if ( !isDefined( level.zbots_actions[ group_name ] ) )
	{
		level.zbots_actions[ group_name ] = [];
	}
	if ( !isDefined( level.zbots_actions[ group_name ][ action_name ] ) )
	{
		level.zbots_actions[ group_name ][ action_name ] = spawnStruct();
	}
	level.zbots_actions[ group_name ][ action_name ].action = action_func;
	level.zbots_actions[ group_name ][ action_name ].should_do_func = should_do_func;
	level.zbots_actions[ group_name ][ action_name ].action_process_order_func = action_process_order_func;
	level.zbots_actions[ group_name ][ action_name ].check_if_complete_func = check_if_complete_func;
	level.zbots_actions[ group_name ][ action_name ].set_complete_func = set_complete_func;
	level.zbots_actions[ group_name ][ action_name ].on_completion_func = on_completion_func;
	level.zbots_actions[ group_name ][ action_name ].should_cancel_func = should_cancel_func;
	level.zbots_actions[ group_name ][ action_name ].on_cancel_func = on_cancel_func;
	level.zbots_actions[ group_name ][ action_name ].should_postpone_func = should_postpone_func;
	level.zbots_actions[ group_name ][ action_name ].on_postpone_func = on_postpone_func;
	level.zbots_actions[ group_name ][ action_name ].priority_func = priority_func;
}

initialize_bot_actions_queue()
{
	group_keys = getArrayKeys( level.zbots_actions );
	for ( i = 0; i < group_keys.size; i++ )
	{
		action_keys = getArrayKeys( level.zbots_actions[ group_keys[ i ] ] );
		for ( j = 0; j < action_keys.size; j++ )
		{
			self register_bot_objective_action_for_queue( group_keys[ i ], action_keys[ j ] );
		}
	}
}

register_bot_objective_action_for_queue( group_name, action_name )
{
	if ( !isDefined( self.zbot_actions_in_queue ) )
	{
		self.zbot_actions_in_queue = [];
	}
	if ( !isDefined( self.zbot_actions_in_queue[ group_name ] ) )
	{
		self.zbot_actions_in_queue[ group_name ] = [];
	}
	if ( !isDefined( self.zbot_actions_in_queue[ group_name ][ action_name ] ) )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ] = spawnStruct();
	}
	self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].canceled = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].completed = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].is_current = false;
}

process_next_queued_action( group_name )
{
	if ( self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].queued )
	{
		return;
	}

	self.action_queue[ group_name ] = self sort_array_by_priority_field( self.action_queue[ group_name ] );

	self thread [[ self.action_queue[ group_name ][ 0 ].action ]]();

	self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].is_current = true;

	self thread wait_for_action_completion( group_name, self.action_queue[ group_name ][ 0 ].action_name );
}

wait_for_action_completion( group_name, action_name )
{
	self endon( "disconnect" );
	self endon( "stop_action_think" );
	level endon( "end_game" );

	action_complete_name = action_name + "_complete";
	action_cancel_name = action_name + "_cancel";
	action_postpone_name = action_name + "_postpone";

	result = self waittill_any_return( action_complete_name, action_cancel_name, action_postpone_name );
	if ( ( result == action_complete_name ) )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].completed = false;
		self.action_queue[ group_name ][ 0 ] = undefined;
		self thread [[ self.action_queue[ group_name ][ 0 ].on_completion_func ]]();
	}
	else if ( result == action_cancel_name )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].completed = false;
		self.action_queue[ group_name ][ 0 ] = undefined;
		self thread [[ self.action_queue[ group_name ][ 0 ].on_cancel_func ]]();
	}
	else if ( result == action_postpone_name )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = true;
		postponed_action = self.action_queue[ group_name ][ 0 ];
		self.action_queue[ group_name ][ 0 ] = undefined;
		postponed_action.priority = self [[ level.zbots_actions[ group_name ][ action_name ].priority_func ]]();
		self.action_queue[ group_name ] = array_insert( self.action_queue[ group_name ], postponed_action, 1 );
		self thread [[ self.action_queue[ group_name ][ 0 ].on_postpone_func ]]();
	}

	self notify( action_name + "_end_think" );

	self.zbot_actions_in_queue[ group_name ][ action_name ].is_current = false;
}

copy_default_action_settings_to_queue( group_name, action_name )
{
	//self.group = level.zbots_actions[ group_name ][ action_name ].group;
	self.action = level.zbots_actions[ group_name ][ action_name ].action;
	//self.should_do_func = level.zbots_actions[ group_name ][ action_name ].should_do_func;
	self.on_completion_func = level.zbots_actions[ group_name ][ action_name ].on_completion_func;
	self.should_cancel_func = level.zbots_actions[ group_name ][ action_name ].should_cancel_func;
	self.on_cancel_func = level.zbots_actions[ group_name ][ action_name ].on_cancel_func;
	self.should_postpone_func = level.zbots_actions[ group_name ][ action_name ].should_postpone_func;
	self.on_postpone_func = level.zbots_actions[ group_name ][ action_name ].on_postpone_func;
	self.priority_func = level.zbots_actions[ group_name ][ action_name ].priority_func;
}

pick_actions_to_add_to_queue( group_name )
{
	action_keys = getArrayKeys( level.zbots_actions[ group_name ] );

	//TODO: Use process order funcs to determine the order of actions being added to the queue
	//For now just randomize the order of the keys
	/*
	for ( i = 0; i < action_keys; i++ )
	{

	}
	*/

	if ( !isDefined( self.action_id ) )
	{
		self.action_id = 0;
	}

	for ( i = 0; i < action_keys.size; i++ )
	{
		if ( !self.zbot_actions_in_queue[ group_name ][ action_keys[ i ] ].queued && [[ level.zbots_actions[ group_name ][ action_keys[ i ] ].should_do_func ]]() )
		{
			self.action_queue[ group_name ][ self.action_queue[ group_name ].size ] = spawnStruct();
			self.action_queue[ group_name ][ self.action_queue[ group_name ].size - 1 ].action_name = action_keys[ i ];
			self.action_queue[ group_name ][ self.action_queue[ group_name ].size - 1 ].action_id = self.action_id;
			self.action_queue[ group_name ][ self.action_queue[ group_name ].size - 1 ].priority = self [[ level.zbots_actions[ group_name ][ action_keys[ i ] ].priority_func ]]();
			self.zbot_actions_in_queue[ group_name ][ action_keys[ i ] ].queued = true;
			self.action_id++;
		}
	}
}

bot_clear_actions_queue()
{
	group_keys = getArrayKeys( level.zbots_actions );
	for ( i = 0; i < group_keys.size; i++ )
	{
		self.action_queue[ group_keys[ i ] ] = [];
		action_keys = getArrayKeys( level.zbots_actions[ group_keys[ i ] ] );
		for ( j = 0; j < action_keys.size; j++ )
		{
			self register_bot_objective_action_for_queue( group_keys[ i ], action_keys[ j ] );
		}
	}	
}

check_if_action_is_completed_in_group( group_name )
{
	if ( [[ level.zbots_actions[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].check_if_complete_func ]]() )
	{
		self notify( self.action_queue[ group_name ][ 0 ].action_name + "_complete" );
	}
}

check_if_action_should_be_postponed_in_group( group_name )
{
	if ( [[ level.zbots_actions[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].should_postpone_func ]]() )
	{
		self notify( self.action_queue[ group_name ][ 0 ].action_name + "_postpone" );
	}
}

check_if_action_should_be_canceled_in_group( group_name )
{
	if ( [[ level.zbots_actions[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].should_cancel_func ]]() )
	{
		self notify( self.action_queue[ group_name ][ 0 ].action_name + "_cancel" );
	}
}

check_if_action_should_be_postponed_globally( group_name )
{
	if ( action_should_be_postponed_global( group_name, self.action_queue[ group_name ][ 0 ].action_name ) )
	{
		self notify( self.action_queue[ group_name ][ 0 ].action_name + "_postpone" );
	}
}

check_if_action_should_be_canceled_globally( group_name )
{
	if ( action_should_be_canceled_global( group_name, self.action_queue[ group_name ][ 0 ].action_name ) )
	{
		self notify( self.action_queue[ group_name ][ 0 ].action_name + "_cancel" );
	}
}

//TODO: Figure out way of overriding the current action for flee movement action
check_for_forced_action( group_name )
{
	action_keys = getArrayKeys( level.zbots_actions[ group_name ] );
	action_priorities_array = [];
	for ( i = 0; i < action_keys.size; i++ )
	{
		action_priorities_array[ action_priorities_array.size ] = spawnStruct();
		action_priorities_array[ action_priorities_array.size - 1 ].priority = self [[ level.zbots_actions[ group_name ][ action_keys[ i ] ].priority_func ]]();
		action_priorities_array[ action_priorities_array.size - 1 ].action_name = action_keys[ i ];
	}

	action_priorities_array = sort_array_by_priority_field( action_priorities_array );

	if ( self.action_queue[ group_name ][ 0 ].priority < action_priorities_array[ 0 ].priority )
	{
		self notify( self.action_queue[ group_name ][ 0 ].action_name + "_cancel" );
	}
}

bot_action_think()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	while ( true )
	{
		wait 0.05;

		group_name = "objective";

		self pick_actions_to_add_to_queue( group_name );

		//self check_for_forced_action( group_name );

		if ( self.action_queue[ group_name ].size <= 0 )
		{
			continue;
		}

		self process_next_queued_action( group_name );

		self check_if_action_is_completed_in_group( group_name );
		self check_if_action_should_be_postponed_in_group( group_name );
		self check_if_action_should_be_canceled_in_group( group_name );

		self check_if_action_should_be_postponed_globally( group_name );
		self check_if_action_should_be_canceled_globally( group_name );
	}
}

action_should_be_postponed_global( primary_group_name, action_name )
{
	return false;
}

action_should_be_canceled_global( primary_group_name, action_name )
{
	return false;
}

//TODO: Add ability to pause an action so the bot won't be doing it while its paused but when its unpaused they can resume the action with the same settings
//Similar to postpone except instead of selecting a new action the current action is preserved
action_should_be_paused_global( primary_group_name, action_name )
{
	return false;
}

bot_grab_powerup()
{
	self endon( "powerup_end_think" );

	if ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 )
	{
		return;
	}
	set_bot_global_shared_objective_owner_by_reference( "powerup", self.available_powerups[ 0 ], self );
	while ( true )
	{
		self SetScriptGoal( self.available_powerups[ 0 ].target_ent.origin );
		wait 0.05;
	}
}

bot_powerup_process_order()
{
	return 0;
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
		if ( !isDefined( generatePath( self.origin, powerup.origin, self.team, false ) ) )
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
	if ( self.successfully_grabbed_powerup )
	{
		return true;
	}
	return false;
}

bot_set_complete_grab_powerup()
{

}

bot_powerup_on_completion()
{
	self.successfully_grabbed_powerup = false;
}

bot_powerup_should_cancel()
{
	return ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 );
}

bot_powerup_on_cancel()
{

}

bot_powerup_should_postpone()
{
	return false;
}

bot_powerup_on_postpone()
{

}

bot_powerup_priority()
{
	if ( !isDefined( self.available_powerups ) )
	{
		return 0;
	}
	return self.available_powerups[ 0 ].target_ent.priority;
}

bot_revive_player()
{
	if ( !isDefined( self.available_revives ) || self.available_revives.size <= 0 )
	{
		return;
	}

	self endon( "disconnect" );
	level endon( "end_game" );

	player_to_revive_obj = self.available_revives[ 0 ];

	set_bot_global_shared_objective_owner_by_reference( "revive", player_to_revive_obj, self );

	player_to_revive = player_to_revive_obj.target_ent;

	action_id = self.action_queue[ "objective" ][ 0 ].action_id;

	//If player is no longer valid to revive stop trying to revive
	//If bot doesn't have an objective anymore or the objective has changed stop trying to revive
	while ( isDefined( player_to_revive ) && isDefined( player_to_revive_obj ) && isDefined( self.action_queue[ "objective" ][ 0 ] ) && action_id == self.action_queue[ "objective" ][ 0 ].action_id )
	{
		self.target_pos = player_to_revive.origin;

		if ( self.can_do_objective_now )
		{
			//TODO: Add check to see if another player is reviving target player
			//TODO: Add code to revive player, possibly add the ability to circle revive?
		}
		wait 0.2;
	}
}

bot_revive_process_order()
{
	return 0;
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
		if ( isDefined( downed_players_objs[ obj_keys[ i ] ].owner ) )
		{
			continue;
		}

		self.available_revives[ self.available_revives.size ] = downed_players_objs[ obj_keys[ i ] ];
	}
	return self.available_revives.size > 0;
}

bot_check_complete_revive_player()
{
	if ( self.successfully_revived_player )
	{
		return true;
	}
	return false;
}

bot_set_complete_revive_player()
{
	self.successfully_revived_player = true;
}

bot_revive_player_on_completion()
{
	self.successfully_revived_player = false;
}

bot_revive_player_should_cancel()
{
	return !isDefined( self.available_revives[ 0 ].target_ent.revivetrigger );
}

bot_revive_player_on_cancel()
{

}

bot_revive_player_should_postpone()
{
	return false;
}

bot_revive_player_on_postpone()
{

}

bot_revive_player_priority()
{
	return 0;
}

store_powerups_dropped()
{
	level endon( "end_game" );

	level thread free_powerups_dropped();

	level.zbots_powerups = [];
	id = 0;
	while ( true )
	{
		level waittill( "powerup_dropped", powerup );
		if ( !isDefined( powerup ) )
		{
			continue;
		}
		powerup.id = id;
		add_possible_bot_objective( "powerup", id, true, powerup );
		level thread objective_think( "powerup", id );
		scripts\sp\bots\bot_utility::assign_priority_to_powerup( powerup );
		level.zbots_powerups = scripts\sp\bots\bot_utility::sort_array_by_priority_field( level.zbots_powerups, powerup );
		id++;
	}
}

free_powerups_dropped()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "powerup_freed", powerup );
		free_bot_objective( "powerup", powerup.id );
	}
}

watch_for_downed_players()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "player_entered_laststand", player );
		if ( !isDefined( player ) )
		{
			continue;
		}
		add_possible_bot_objective( "revive", player.client_id, true, player );
		player thread free_revive_objective_when_needed();
	}
}

free_revive_objective_when_needed()
{
	level endon( "end_game" );

	id = self.id;
	while ( isDefined( self ) && isDefined( self.revivetrigger ) )
	{
		wait 0.05;
	}

	free_bot_objective( "revive", id );
}