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
	assert( isDefined( level.zbot_objective_glob ), "Trying to add objective before calling register_bot_objective" );

	assert( isDefined( level.zbot_objective_glob[ objective_group ] ), "Trying to add objective to group " + objective_group + " before calling register_bot_objective" );

	if ( !isDefined( target_ent ) )
	{
		assertMsg( "target_ent is undefined" );
		return;
	}

	id = target_ent getEntityNumber();

	objective_struct = spawnStruct();
	objective_struct.group = objective_group;
	objective_struct.is_global_shared = is_global_shared;
	objective_struct.target_ent = target_ent;
	objective_struct.owner = undefined;
	objective_struct.is_objective = true;
	objective_struct.bad = false;

	level.zbot_objective_glob[ objective_group ].active_objectives[ "obj_id_" + id ] = objective_struct;
}

get_bot_objective_by_entity_ref( objective_group, ent )
{
	if ( !isDefined( ent ) )
	{
		assertMsg( "Ent is undefined" );
		return;
	}

	id = ent getEntityNumber();

	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	assert( isDefined( objective ), "Objective with " + id + " id does not point to a objective in group " + objective_group );

	return objective;
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
	if ( !isDefined( ent ) )
	{
		assertMsg( "Ent is undefined" );
		return;
	}

	possible_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	id = ent getEntityNumber();

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

set_bot_objective_blocked_by_objective( primary_objective_group, primary_ent, blocked_by_objective_group, blocked_by_ent )
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

bot_is_objective_owner( objective_group, ent )
{
	if ( !isDefined( ent ) )
	{
		assertMsg( "Ent is undefined" );
		return false;
	}

	id = ent getEntityNumber();
	
	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	assert( objective_exists, "Objective with " + id + " id number does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return false;
	}

	assert( objective.is_global_shared, "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
	if ( !objective.is_global_shared )
	{
		return false;
	}

	return isDefined( objective.owner ) && objective.owner == self;
}

set_bot_global_shared_objective_owner_by_ent( objective_group, ent, new_owner )
{
	if ( !isDefined( ent ) )
	{
		assertMsg( "Ent is undefined" );
		return;
	}

	id = ent getEntityNumber();
	
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

mark_objective_bad( objective_group, ent )
{
	if ( !isDefined( ent ) )
	{
		assertMsg( "Ent is undefined" );
		return;
	}

	id = ent getEntityNumber();

	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	assert( objective_exists, "Objective with " + id + " id number does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	objective.bad = true;
}

free_bot_objective( objective_group, ent )
{
	if ( !isDefined( ent ) )
	{
		assertMsg( "Ent is undefined" );
		return;
	}

	id = ent getEntityNumber();

	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

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
		if ( isDefined( players[ i ].pers[ "isBot" ] ) && players[ i ].pers[ "isBot" ] )
		{
			if ( isDefined( players[ i ].zbot_current_objective ) && players[ i ].zbot_current_objective == objective )
			{
				players[ i ].zbot_current_objective = undefined;
			}
		}
	}

	active_objectives[ "obj_id_" + id ] = undefined;
}

bot_objective_print( objective_group, ent, message )
{
	if ( !isDefined( ent ) )
	{
		assertMsg( "Ent is undefined" );
		return;
	}

	id = ent getEntityNumber();

	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	assert( objective_exists, "Objective with " + id + " id number does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	if ( getDvarInt( "bot_obj_debug_" + objective_group ) != 0 )
	{
		printConsole( "Obj <" + objective_group + "> ent <" + id + "> " + message + "\n" );
	}
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
		waittillframeend;

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

	if ( self GetPathIsInaccessible() )
	{
		self.obj_cancel_reason = "Path was inaccessible";
		return true;
	}
	if ( obj.bad )
	{
		self.obj_cancel_reason = "Obj was bad";
		return true;
	}
	return false;
}