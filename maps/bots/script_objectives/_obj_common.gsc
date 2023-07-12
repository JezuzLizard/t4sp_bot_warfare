#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_utility;

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

	return level.zbot_objective_glob[ objective_group ].active_objectives[ "obj_id_" + id ];
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

bot_set_objective( objective_group, ent, id )
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
	objective = self.zbot_current_objective;
	if ( !isDefined( objective ) )
	{
		return;
	}
	self bot_clear_objective_owner( objective.group, objective.target_ent );
	self.zbot_current_objective = undefined;
}

objective_has_owner( objective_group, ent, id )
{
	objective = get_objective_safe( objective_group, ent, id, "objective_has_owner" );
	if ( !isDefined( objective ) )
	{
		return false;
	}

	if ( !isDefined( id ) )
	{
		id = ent getEntityNumber();
	}

	if ( !objective.is_global_shared )
	{
		objective_assert( objective_group, id, "objective_has_owner", "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
		return false;
	}

	return isDefined( objective.owner );
}

bot_is_objective_owner( objective_group, ent, id )
{
	objective = get_objective_safe( objective_group, ent, id, "bot_is_objective_owner" );
	if ( !isDefined( objective ) )
	{
		return false;
	}

	if ( !isDefined( id ) )
	{
		id = ent getEntityNumber();
	}

	if ( !objective.is_global_shared )
	{
		objective_assert( objective_group, id, "bot_is_objective_owner", "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
		return false;
	}

	return isDefined( objective.owner ) && objective.owner == self;
}

bot_set_objective_owner( objective_group, ent, id )
{
	objective = get_objective_safe( objective_group, ent, id, "bot_set_objective_owner" );
	if ( !isDefined( objective ) )
	{
		return;
	}

	if ( !isDefined( id ) )
	{
		id = ent getEntityNumber();
	}

	if ( !objective.is_global_shared )
	{
		objective_assert( objective_group, id, "bot_set_objective_owner", "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
		return;
	}

	objective.owner = self;
}

bot_clear_objective_owner( objective_group, ent, id )
{
	objective = get_objective_safe( objective_group, ent, id, "clear_objective_owner" );
	if ( !isDefined( objective ) )
	{
		return;
	}

	if ( !isDefined( objective.owner ) )
	{
		return;
	}

	if ( objective.owner != self )
	{
		return;
	}

	objective.owner = undefined;
}

mark_objective_bad( objective_group, ent, id )
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
	if ( isDefined( ent ) )
	{
		id = ent getEntityNumber();
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
		self objective_info_print( objective_group, id, function_name, message );
	}
}

objective_assert( objective_group, id, function_name, message )
{
	assertMsg( message );
	if ( getDvarInt( "bot_obj_debug_all" ) != 0 || getDvarInt( "bot_obj_debug_" + objective_group ) != 0 )
	{
		if ( !isDefined( id ) )
		{
			error_message = "BOT_OBJ_ERROR: Time <" + getTime() + "> " + function_name + "() Obj <" + objective_group + "> " + message;
		}
		else
		{
			error_message = "BOT_OBJ_ERROR: Time <" + getTime() + "> " + function_name + "() Obj <" + objective_group + "> Ent <" + id + "> " + message;
		}
		logprint( error_message + "\n" );
		printConsole( error_message );
	}
}

objective_info_print( objective_group, id, function_name, message )
{
	message = "BOT_OBJ_INFO: Time <" + getTime() + "> " + function_name + "() Obj <" + objective_group + "> ent <" + id + "> " + message;
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
	return self.obj_history[ self.bot_obj_history_index ];
}

bot_objective_history_get_previous()
{
	return self.obj_history[ self.bot_obj_history_prev_index ];
}

/**********Action Section**********/

register_bot_action( action_name, action_func, init_func, post_think_func, should_do_func, check_if_complete_func, should_cancel_func, priority_func )
{
	if ( !isDefined( level.zbots_actions ) )
	{
		level.zbots_actions = [];
	}
	if ( !isDefined( level.zbots_actions[ action_name ] ) )
	{
		level.zbots_actions[ action_name ] = spawnStruct();
	}
	level.zbots_actions[ action_name ].action = action_func;
	level.zbots_actions[ action_name ].init_func = init_func;
	level.zbots_actions[ action_name ].post_think_func = post_think_func;
	level.zbots_actions[ action_name ].should_do_func = should_do_func;
	level.zbots_actions[ action_name ].check_if_complete_func = check_if_complete_func;
	level.zbots_actions[ action_name ].should_cancel_func = should_cancel_func;
	level.zbots_actions[ action_name ].priority_func = priority_func;
}

bot_process_action()
{
	self endon( "stop_action_think" );

	action_name = self.bot_action.action_name;

	self [[ level.zbots_actions[ action_name ].init_func ]]();

	self thread [[ level.zbots_actions[ action_name ].action ]]();

	self.running_action = true;
	self wait_for_action_completion( action_name );
}

wait_for_action_completion( action_name )
{
	action_complete_name = action_name + "_complete";
	action_cancel_name = action_name + "_cancel";

	result = self waittill_any_return( action_complete_name, action_cancel_name );

	end_state = undefined;

	if ( ( result == action_complete_name ) )
	{
		end_state = "completed";
	}
	else if ( result == action_cancel_name )
	{
		end_state = "canceled";
	}

	self notify( action_name + "_end_think" );

	self [[ level.zbots_actions[ action_name ].post_think_func ]]( end_state );

	self.bot_action = undefined;

	self.obj_history[ self.bot_obj_history_index ].end_time = getTime();
	end_time = self.obj_history[ self.bot_obj_history_index ].end_time;
	start_time = self.obj_history[ self.bot_obj_history_index ].start_time;
	self.obj_history[ self.bot_obj_history_index ].time_spent = end_time - start_time;
	self.obj_history[ self.bot_obj_history_index ].bot_end_pos = self.origin;
	self.bot_obj_history_index++;
	self.running_action = false;
}

bot_pick_action()
{
	action_keys = getArrayKeys( level.zbots_actions );

	possible_actions = NewHeap( ::HeapPriority );
	for ( i = 0; i < action_keys.size; i++ )
	{
		if ( self [[ level.zbots_actions[ action_keys[ i ] ].should_do_func ]]() )
		{
			possible_action = spawnStruct();
			possible_action.action_name = action_keys[ i ];
			possible_action.priority = self [[ level.zbots_actions[ action_keys[ i ] ].priority_func ]]();
			possible_actions HeapInsert( possible_action );
			printConsole( self.playername + " Adding action " + action_keys[ i ] + " to queue of size: " + possible_actions.data.size );
		}
	}

	forced_action = getDvar( "bots_debug_forced_action" );

	if ( ( !isDefined( possible_actions.data ) || possible_actions.data.size <= 0 ) && forced_action == "" )
	{
		return false;
	}
	if ( forced_action != "" )
	{
		entnum_and_forced_action = strTok( forced_action, " " );
		if ( entnum_and_forced_action.size != 2 )
		{
			setDvar( "bots_debug_forced_action", "" );
		}
		else if ( int( entnum_and_forced_action[ 0 ] ) == self getEntityNumber() && isDefined( level.zbots_actions[ entnum_and_forced_action[ 1 ] ] ) )
		{
			possible_action = spawnStruct();
			possible_action.action_name = entnum_and_forced_action[ 1 ];
			possible_action.priority = 999;
			self.bot_action = possible_action;
			setDvar( "bots_debug_forced_action", "" );
			printConsole( self.playername + " Picking forced action " + self.bot_action.action_name + " Priority " + self.bot_action.priority );
			return true;
		}

	}
	self.bot_action = possible_actions.data[ 0 ];
	printConsole( self.playername + " Picking action " + self.bot_action.action_name + " Priority " + self.bot_action.priority );
	return true;
}

bot_check_action_complete( action_name )
{
	assert( isDefined( level.zbots_actions[ action_name ].check_if_complete_func ) );

	is_complete = self [[ level.zbots_actions[ action_name ].check_if_complete_func ]]();

	if ( is_complete )
	{
		self notify( action_name + "_complete" );
		self notify( "goal" );
	}
	return is_complete;
}

bot_check_if_action_should_be_canceled_in_group( action_name )
{
	should_cancel = self [[ level.zbots_actions[ action_name ].should_cancel_func ]]();
	if ( should_cancel )
	{
		self notify( action_name + "_cancel" );
		self notify( "goal" );
	}

	return should_cancel;
}

bot_check_if_action_should_be_canceled_globally( action_name )
{
	should_cancel = self action_should_be_canceled_global( action_name );
	if ( should_cancel )
	{
		self notify( action_name + "_cancel" );
		self notify( "goal" );
	}
	return should_cancel;
}

bot_action_think()
{
	self endon( "disconnect" );
	self endon( "zombified" );
	level endon( "end_game" );

	self thread bot_action_pump();

	while ( true )
	{
		if ( getDvarInt( "bot_obj_debug_all" ) != 0 )
		{
			wait 1;
		}
		else
		{
			wait 1;
		}
		//Wait until the end of the frame so any variables set by _bot_internal in the current frame will have up to date values
		waittillframeend;

		self.bot_action = undefined;
		if ( !self bot_pick_action() )
		{
			if ( getDvarInt( "bot_obj_debug_all" ) != 0 )
			{
				printConsole( "BOT_ACTION_THINK: " + self.playername + " does not have an action selected" );
			}
			continue;
		}

		self bot_process_action();

		while ( !maps\so\zm_common\_zm_utility::is_player_valid( self ) )
		{
			if ( getDvarInt( "bot_obj_debug_all" ) != 0 )
			{
				printConsole( "BOT_ACTION_THINK: " + self.playername + " is not in a valid state" );
			}
			wait 1;
		}
	}
}

bot_action_pump()
{
	self endon( "disconnect" );
	self endon( "zombified" );
	level endon( "end_game" );

	while ( true )
	{
		wait 0.05;
		if ( !isDefined( self.bot_action ) )
		{
			continue;
		}
		action_name = self.bot_action.action_name;
		if ( self bot_check_action_complete( action_name ) )
		{
		}
		else if ( self bot_check_if_action_should_be_canceled_globally( action_name ) )
		{
		}
		else if ( self bot_check_if_action_should_be_canceled_in_group( action_name ) )
		{
		}

		while ( !maps\so\zm_common\_zm_utility::is_player_valid( self ) )
		{
			wait 1;
		}
	}
}

action_should_be_postponed_global( action_name )
{
	return false;
}

action_should_be_canceled_global( action_name )
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
	else if ( isDefined( obj.target_ent.player_visibility ) && !obj.target_ent.player_visibility[ self getEntityNumber() + "" ] )
	{
		self.obj_cancel_reason = "Trigger wasn't visible";
		goal_canceled = true;
	}
	else if ( !isDefined( obj.target_ent.bot_use_node ) && self GetPathIsInaccessible( obj.target_ent.origin ) )
	{
		self.obj_cancel_reason = "Path to ent was inaccessible";
		goal_canceled = true;
	}
	else if ( isDefined( obj.target_ent.bot_use_node ) && self GetPathIsInaccessible( obj.target_ent.bot_use_node ) )
	{
		self.obj_cancel_reason = "Path to use node was inaccessible";
		goal_canceled = true;
	}
	else if ( obj.bad )
	{
		self.obj_cancel_reason = "Obj was bad";
		goal_canceled = true;
	}
	else if ( !maps\so\zm_common\_zm_utility::is_player_valid( self ) )
	{
		self.obj_cancel_reason = "In invalid state";
		goal_canceled = true;
	}
	return goal_canceled;
}

get_angle_offset_node( forward_size, angle_offset, offset )
{
	if ( !isDefined( forward_size ) )
	{
		forward_size = 40;
	}
	if ( !isDefined( angle_offset ) )
	{
		angle_offset = ( 0, 0, 0 );
	}
	if ( !isDefined( offset ) )
	{
		offset = ( 0, 0, 0 );
	}

	angles = ( 0, self.angles[ 1 ], 0 );
	angles += angle_offset;
	node = self.origin + ( AnglesToForward( angles ) * forward_size ) + offset;
	node = clamp_to_ground( node );
	return node;
}

clamp_to_ground( org )
{
	trace = playerPhysicsTrace( org + ( 0, 0, 20 ), org - ( 0, 0, 2000 ) );
	return trace;
}
