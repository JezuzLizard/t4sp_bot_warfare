#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;

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

add_possible_bot_objective( objective_group, target_ent, is_global_shared )
{
	if ( !isDefined( target_ent ) )
	{
		objective_assert( objective_group, undefined, "add_possible_bot_objective", "[ent was undefined]" );
		return;
	}

	id = target_ent getEntityNumber();

	if ( !isDefined( level.zbot_objective_glob ) )
	{
		objective_assert( objective_group, id, "add_possible_bot_objective", "Trying to add objective before calling register_bot_objective for objective group " + objective_group );
		return;
	}

	if ( !isDefined( level.zbot_objective_glob[ objective_group ] ) )
	{
		objective_assert( objective_group, id, "add_possible_bot_objective", "Trying to add objective to group " + objective_group + " before calling register_bot_objective" );
		return;
	}

	objective_struct = spawnStruct();
	objective_struct.group = objective_group;
	objective_struct.is_global_shared = is_global_shared;
	objective_struct.target_ent = target_ent;
	objective_struct.owner = undefined;
	objective_struct.is_objective = true;
	objective_struct.bad = false;
	objective_struct.id = id;

	level.zbot_objective_glob[ objective_group ].active_objectives[ "obj_id_" + id ] = objective_struct;
}

get_objective( objective_group, ent, id )
{
	return get_objective_safe( objective_group, ent, id, "get_objective_by_entity_ref" );
}

get_all_objectives_for_group( objective_group )
{
	return level.zbot_objective_glob[ objective_group ].active_objectives;
}

bot_get_objective()
{
	return self.zbot_current_objective;
}

bot_has_objective()
{
	return isDefined( self.zbot_current_objective );
}

bot_set_objective( objective_group, ent )
{
	objective = get_objective_safe( objective_group, ent, id, "bot_set_objective" );
	if ( !isDefined( objective ) )
	{
		return;
	}

	new_obj_history = spawnStruct();
	new_obj_history.id = ent getEntityNumber();
	new_obj_history.group = objective_group;
	new_obj_history.ent_start_pos = ent.origin;
	new_obj_history.ent_end_pos = ent.origin;
	new_obj_history.bot_start_pos = self.origin;
	new_obj_history.bot_end_pos = self.origin;
	new_obj_history.start_time = getTime();
	new_obj_history.end_time = getTime();
	new_obj_history.time_spent = 0;

	self.bot_obj_history_prev_index = self.bot_obj_history_index;
	if ( self.bot_obj_history_index >= self.bot_obj_history_max_entries )
	{
		self.bot_obj_history_index = 0;
	}
	
	self.obj_history[ self.bot_obj_history_index ] = new_obj_history;
	self.zbot_current_objective = objective;
}

bot_clear_objective()
{
	self.zbot_current_objective = undefined;
}

objective_set_blocked( primary_objective_group, primary_ent, blocked_by_objective_group, blocked_by_ent )
{
	if ( !isDefined( primary_ent ) )
	{
		assertMsg( "Primary_ent is undefined" );
		return;
	}

	if ( !isDefined( blocked_by_ent ) )
	{
		assertMsg( "Blocked_by_ent is undefined" );
		return;
	}

	primary_id = primary_ent getEntityNumber();

	blocked_by_id = blocked_by_ent getEntityNumber();

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

objective_remove_blocked()
{
	
}

objective_has_owner( objective_group, ent )
{
	objective = get_objective_safe( objective_group, ent, id, "objective_has_owner" );
	if ( !isDefined( objective ) )
	{
		return false;
	}

	id = ent getEntityNumber();

	if ( !objective.is_global_shared )
	{
		objective_assert( objective_group, id, "objective_has_owner", "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group )
		return false;
	}

	return isDefined( objective.owner );
}

bot_is_objective_owner( objective_group, ent )
{
	objective = get_objective_safe( objective_group, ent, id, "bot_is_objective_owner" );
	if ( !isDefined( objective ) )
	{
		return false;
	}

	id = ent getEntityNumber();

	if ( !objective.is_global_shared )
	{
		objective_assert( objective_group, id, "bot_is_objective_owner", "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group )
		return false;
	}

	return isDefined( objective.owner ) && objective.owner == self;
}

bot_set_objective_owner( objective_group, ent )
{
	objective = get_objective_safe( objective_group, ent, id, "bot_set_objective_owner" );
	if ( !isDefined( objective ) )
	{
		return;
	}

	id = ent getEntityNumber();

	if ( !objective.is_global_shared )
	{
		objective_assert( objective_group, id, "bot_set_objective_owner", "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group )
		return;
	}

	objective.owner = self;
}

mark_objective_bad( objective_group, ent )
{
	objective = get_objective_safe( objective_group, ent, id, "mark_objective_bad" );
	if ( !isDefined( objective ) )
	{
		return;
	}
	objective.bad = true;
}

free_bot_objective( objective_group, ent, id )
{
	objective = get_objective_safe( objective_group, ent, id, "free_bot_objective" );
	if ( !isDefined( objective ) )
	{
		return;
	}
	players = getPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ] is_bot() )
		{
			if ( isDefined( players[ i ].zbot_current_objective ) && players[ i ].zbot_current_objective == objective )
			{
				players[ i ].zbot_current_objective = undefined;
			}
		}
	}

	level.zbot_objective_glob[ objective_group ].active_objectives[ "obj_id_" + id ] = undefined;
}

get_objective_safe( objective_group, ent, id, function_name )
{
	if ( !isDefined( ent ) && !isDefined( id ) )
	{
		objective_assert( objective_group, id, function_name, "[ent and id were undefined]" );
		return undefined;
	}

	if ( isDefined( ent ) )
	{
		id = ent getEntityNumber();
	}

	if ( !isDefined( level.zbot_objective_glob[ objective_group ] ) )
	{
		objective_assert( objective_group, id, function_name, "[obj group is invalid]" );
		return undefined;
	}

	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	if ( !objective_exists )
	{
		objective_assert( objective_group, id, function_name, "[obj was undefined]" );
		return undefined;
	}
	return objective;
}

bot_objective_print( objective_group, id, message, function_name )
{
	if ( getDvarInt( "bot_obj_debug_all" ) != 0 || getDvarInt( "bot_obj_debug_" + objective_group ) != 0 )
	{
		objective_info_print( objective_group, id, function_name, message );
	}
}

objective_assert( objective_group, id, function_name, message )
{
	assertMsg( message );
	if ( getDvarInt( "bot_obj_debug_all" ) != 0 || getDvarInt( "bot_obj_debug_" + objective_group ) != 0 )
	{
		if ( !isDefined( id ) )
		{
			error_message = "ERROR: " + function_name + "() Obj <" + objective_group + "> " + message;
		}
		else
		{
			error_message = "ERROR: " + function_name + "() Obj <" + objective_group + "> ent <" + id + "> " + message;
		}
		logprint( error_message + "\n" );
		printConsole( error_message );
	}
}

objective_info_print( objective_group, id, function_name, message )
{
	obj = bot_objective_history_get_current();
	message = "INFO: " + function_name + "() Obj <" + objective_group + "> ent <" + id + "> pos <" + obj.ent_end_pos + "> " + message;
	logprint( message + "\n" );
	printConsole( message );
}

bot_objective_history_get_oldest()
{
	oldest = self.obj_history[ 0 ];
	for ( i = 1; i < self.obj_history.size; i++ )
	{
		if ( oldest.end_time < self.obj_history[ i ] )
		{
			continue;
		}
		oldest = self.obj_history[ i ];
	}
	return oldest;
}

bot_objective_history_get_current()
{
	return self.obj_history[ level.bot_obj_history_index ];
}

bot_objective_history_get_previous()
{
	return self.obj_history[ level.bot_obj_history_prev_index ];
}

/**********Action Section**********/

register_bot_action( group_name, action_name, action_func, action_process_order_func, init_func, post_think_func, should_do_func, check_if_complete_func, should_cancel_func, should_postpone_func, priority_func )
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
	level.zbots_actions[ group_name ][ action_name ].init_func = init_func;
	level.zbots_actions[ group_name ][ action_name ].post_think_func = post_think_func;
	level.zbots_actions[ group_name ][ action_name ].should_do_func = should_do_func;
	level.zbots_actions[ group_name ][ action_name ].action_process_order_func = action_process_order_func;
	level.zbots_actions[ group_name ][ action_name ].check_if_complete_func = check_if_complete_func;
	level.zbots_actions[ group_name ][ action_name ].should_cancel_func = should_cancel_func;
	level.zbots_actions[ group_name ][ action_name ].should_postpone_func = should_postpone_func;
	level.zbots_actions[ group_name ][ action_name ].priority_func = priority_func;
}

initialize_bot_actions_queue()
{
	self.action_queue = [];
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
	self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].is_current = false;
}

process_next_queued_action( group_name )
{
	if ( self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].is_current )
	{
		return;
	}

	self.action_queue[ group_name ] = self sort_array_by_priority_field( self.action_queue[ group_name ] );

	action_name = self.action_queue[ group_name ][ 0 ].action_name;

	self [[ level.zbots_actions[ group_name ][ action_name ].init_func ]]();

	self thread [[ level.zbots_actions[ group_name ][ action_name ].action ]]();

	self.zbot_actions_in_queue[ group_name ][ action_name ].is_current = true;

	self thread wait_for_action_completion( group_name, action_name );
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

	save_action = false;

	end_state = undefined;

	if ( ( result == action_complete_name ) )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
		end_state = "completed";
	}
	else if ( result == action_cancel_name )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
		end_state = "canceled";
	}
	else if ( result == action_postpone_name )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = true;
		save_action = true;
		end_state = "postponed";
	}

	self.zbot_actions_in_queue[ group_name ][ action_name ].is_current = false;

	self notify( action_name + "_end_think" );

	self [[ level.zbots_actions[ group_name ][ action_name ].post_think_func ]]( end_state );

	if ( save_action )
	{
		postponed_action = self.action_queue[ group_name ][ 0 ];
		postponed_action.priority = self [[ level.zbots_actions[ group_name ][ action_name ].priority_func ]]();
		self.action_queue[ group_name ] = array_insert( self.action_queue[ group_name ], postponed_action, 2 );
		self.action_queue[ group_name ][ 0 ] = undefined;
	}
	else 
	{
		self.action_queue[ group_name ][ 0 ] = undefined;
	}

	self.obj_history[ self.bot_obj_history_index ].end_time = getTime();
	end_time = self.obj_history[ self.bot_obj_history_index ].end_time
	start_time = self.obj_history[ self.bot_obj_history_index ].start_time;
	self.obj_history[ self.bot_obj_history_index ].time_spent = end_time - start_time;
	self.obj_history[ self.bot_obj_history_index ].bot_end_pos = self.origin;
	self.bot_obj_history_index++;
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

	//Reboot the action queue because the last member was deleted which deletes the array
	if ( !isDefined( self.action_queue ) || !isDefined( self.action_queue[ group_name ] ) )
	{
		self.action_queue = [];
		self.action_queue[ group_name ] = [];
	}

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

check_if_action_is_completed_in_group( group_name, action_name )
{
	assert( isDefined( level.zbots_actions[ group_name ][ action_name ].check_if_complete_func ) );

	if ( self [[ level.zbots_actions[ group_name ][ action_name ].check_if_complete_func ]]() )
	{
		self notify( action_name + "_complete" );
	}
}

check_if_action_should_be_postponed_in_group( group_name, action_name )
{
	if ( self [[ level.zbots_actions[ group_name ][ action_name ].should_postpone_func ]]() )
	{
		self notify( action_name + "_postpone" );
	}
}

check_if_action_should_be_canceled_in_group( group_name, action_name )
{
	if ( self [[ level.zbots_actions[ group_name ][ action_name ].should_cancel_func ]]() )
	{
		self notify( action_name + "_cancel" );
	}
}

check_if_action_should_be_postponed_globally( group_name, action_name )
{
	if ( action_should_be_postponed_global( group_name, action_name ) )
	{
		self notify( action_name + "_postpone" );
	}
}

check_if_action_should_be_canceled_globally( group_name, action_name )
{
	if ( action_should_be_canceled_global( group_name, action_name ) )
	{
		self notify( action_name + "_cancel" );
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
		//Wait until the end of the frame so any variables set by _bot_internal in the current frame will have up to date values
		waittillframeend;

		if ( !maps\so\zm_common\_zm_utility::is_player_valid( self ) )
		{
			continue;
		}

		group_name = "objective";

		self pick_actions_to_add_to_queue( group_name );

		//self check_for_forced_action( group_name );

		if ( !isDefined( self.action_queue[ group_name ][ 0 ] ) )
		{
			continue;
		}

		self process_next_queued_action( group_name );

		action_name = self.action_queue[ group_name ][ 0 ].action_name;

		self check_if_action_is_completed_in_group( group_name, action_name );
		self check_if_action_should_be_postponed_in_group( group_name, action_name );
		self check_if_action_should_be_canceled_in_group( group_name, action_name );

		self check_if_action_should_be_postponed_globally( group_name, action_name );
		self check_if_action_should_be_canceled_globally( group_name, action_name );
	}
}

action_should_be_postponed_global( primary_group_name, action_name )
{
	return false;
}

action_should_be_canceled_global( primary_group_name, action_name )
{
	obj = self bot_get_objective();

	goal_canceled = false;
	if ( !isDefined( obj ) )
	{
		self.obj_cancel_reason = "Obj didn't exist";
		goal_canceled = true;
	}
	else if ( !isDefined( obj.target_ent ) )
	{
		self.obj_cancel_reason = "Obj entity doesn't exist";
		canceled_goal = true;
	}
	else if ( self GetPathIsInaccessible( obj.target_ent.origin ) )
	{
		self.obj_cancel_reason = "Path was inaccessible";
		goal_canceled = true;
	}
	else if ( obj.bad )
	{
		self.obj_cancel_reason = "Obj was bad";
		goal_canceled = true;
	}
	else if ( !maps\so\zm_common\_zm_utility::is_player_valid( self ) )
	{
		self.obj_cancel_reason = "In laststand";
		goal_canceled = true;
	}
	if ( goal_canceled )
	{
		self notify( "goal" );
	}
	return goal_canceled;
}