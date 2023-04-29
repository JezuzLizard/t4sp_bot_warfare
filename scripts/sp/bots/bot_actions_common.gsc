/*
	Bot actions are in two parts
*/
#include common_scripts\utility;
#include maps\_utility;
#include maps\so\zm_common\_zm_utility;
#include scripts\sp\bots\bot_utility;

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

	result = self waittill_any_return( action_name + "_complete", action_name + "_cancel", action_name + "_postpone" );
	if ( !isDefined( result ) )
	{
		return;
	}
	if ( result == "disconnect" )
	{
		return;
	}
	if ( ( result == action_name + "_complete" ) )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].completed = false;
		self.action_queue[ group_name ][ 0 ] = undefined;
		self thread [[ self.action_queue[ group_name ][ 0 ].on_completion_func ]]();
	}
	else if ( result == action_name + "_cancel" )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
		self.zbot_actions_in_queue[ group_name ][ action_name ].completed = false;
		self.action_queue[ group_name ][ 0 ] = undefined;
		self thread [[ self.action_queue[ group_name ][ 0 ].on_cancel_func ]]();
	}
	else if ( result == action_name + "_postpone" )
	{
		self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = true;
		postponed_action = self.action_queue[ group_name ][ 0 ];
		self.action_queue[ group_name ][ 0 ] = undefined;
		postponed_action.priority = self [[ level.zbots_actions[ group_name ][ action_name ].priority_func ]]();
		self.action_queue[ group_name ] = array_insert( self.action_queue[ group_name ], postponed_action, 1 );
		self thread [[ self.action_queue[ group_name ][ 0 ].on_postpone_func ]]();
	}

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

bot_action_think( group_name )
{
	self pick_actions_to_add_to_queue( group_name );

	//self check_for_forced_action( group_name );

	if ( self.action_queue[ group_name ].size <= 0 )
	{
		return;
	}

	self process_next_queued_action( group_name );

	self check_if_action_is_completed_in_group( group_name );
	self check_if_action_should_be_postponed_in_group( group_name );
	self check_if_action_should_be_canceled_in_group( group_name );

	self check_if_action_should_be_postponed_globally( group_name );
	self check_if_action_should_be_canceled_globally( group_name );
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