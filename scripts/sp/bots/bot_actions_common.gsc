/*
	Bot actions are in two parts
*/
#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

register_bot_action( group, action_name, action_func, action_process_order_func, should_do_func, check_if_complete_func, set_complete_func, on_completion_func, should_cancel_func, on_cancel_func, should_postpone_func, on_postpone_func, priority_func )
{
	if ( !isDefined( level.zbots_actions ) )
	{
		level.zbots_actions = [];
	}
	if ( !isDefined( level.zbots_actions[ action_name ] ) )
	{
		level.zbots_actions[ action_name ] = [];
	}
	level.zbots_actions[ action_name ] = spawnStruct();
	level.zbots_actions[ action_name ].group = group;
	level.zbots_actions[ action_name ].action = action_func;
	level.zbots_actions[ action_name ].should_do_func = should_do_func;
	level.zbots_actions[ action_name ].action_process_order_func = action_process_order_func;
	level.zbots_actions[ action_name ].check_if_complete_func = check_if_complete_func;
	level.zbots_actions[ action_name ].set_complete_func = set_complete_func;
	level.zbots_actions[ action_name ].on_completion_func = on_completion_func;
	level.zbots_actions[ action_name ].should_cancel_func = should_cancel_func;
	level.zbots_actions[ action_name ].on_cancel_func = on_cancel_func;
	level.zbots_actions[ action_name ].should_postpone_func = should_postpone_func;
	level.zbots_actions[ action_name ].on_postpone_func = on_postpone_func;
	level.zbots_actions[ action_name ].priority_func = priority_func;
}

initialize_bot_actions_queue()
{
	keys = getArrayKeys( level.zbots_actions );
	for ( i = 0; i < keys.size; i++ )
	{
		self register_bot_objective_action_for_queue( keys[ i ], level.zbots_actions[ keys[ i ] ].group );
	}
}

register_bot_objective_action_for_queue( action_name )
{
	if ( !isDefined( self.zbot_actions_in_queue ) )
	{
		self.zbot_actions_in_queue = [];
	}
	if ( !isDefined( self.zbot_actions_in_queue[ group_name ] ) )
	{
		self.zbot_actions_in_queue[ group_name ] = [];
	}
	self.zbot_actions_in_queue[ group_name ][ action_name ] = spawnStruct();
	self.zbot_actions_in_queue[ group_name ][ action_name ].postponed = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].canceled = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].queued = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].completed = false;
	self.zbot_actions_in_queue[ group_name ][ action_name ].is_current = false;
}

process_next_queued_action( group_name )
{
	if ( self.action_queue.size <= 0 )
	{
		return;
	}
	self [[ self.action_queue[ group_name ][ 0 ].action ]]();

	self wait_for_action_completion( self.action_queue[ group_name ][ 0 ].action_name );
}

wait_for_action_completion( group_name, action_name )
{
	result = self waittill_any_return( action_name + "_completion", action_name + "_cancel", action_name + "_postpone", "disconnect" );
	if ( !isDefined( result ) )
	{
		return;
	}
	if ( result == "disconnect" )
	{
		return;
	}
	if ( ( result == action_name + "_completion" ) )
	{
		self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].queued = false;
		arrayRemoveIndex( self.action_queue[ group_name ], 0 );
		self thread [[ self.action_queue[ group_name ][ 0 ].on_completion_func ]]();
	}
	else if ( result == action_name + "_cancel" )
	{
		self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].postponed = false;
		self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].queued = false;
		arrayRemoveIndex( self.action_queue[ group_name ], 0 );
		self thread [[ self.action_queue[ group_name ][ 0 ].on_cancel_func ]]();
	}
	else if ( result == action_name + "_postpone" )
	{
		self.zbot_actions_in_queue[ group_name ][ self.action_queue[ group_name ][ 0 ].action_name ].postponed = true;
		postponed_action = self.action_queue[ group_name ][ 0 ];
		arrayRemoveIndex( self.action_queue[ group_name ], 0 );
		postponed_action.priority = 0;
		self.action_queue[ group_name ][ self.action_queue[ group_name ].size ] = postponed_action;
		self thread [[ self.action_queue[ group_name ][ 0 ].on_postpone_func ]]();
	}
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

pick_actions_to_add_to_queue( group_name, action_keys )
{
	for ( i = 0; i < action_keys.size; i++ )
	{
		if ( !self.zbot_actions_in_queue[ group_name ][ action_keys[ i ] ].queued && [[ level.zbots_actions[ group_name ][ action_keys[ i ] ].should_do_func ]]() )
		{
			self.action_queue[ group_name ][ self.action_queue[ group_name ].size ] = spawnStruct();
			self.action_queue[ group_name ][ self.action_queue[ group_name ].size - 1 ].action_name = action_keys[ i ];
			self.action_queue[ group_name ][ self.action_queue[ group_name ].size - 1 ].priority = self [[ level.zbots_actions[ group_name ][ action_keys[ i ] ].priority_func ]]();
			self.zbot_actions_in_queue[ group_name ][ action_keys[ i ] ].queued = true;
		}
	}
}

check_if_actions_should_be_canceled_in_group( group_name, action_keys )
{
	for ( i = 0; i < action_keys.size; i++ )
	{
		if ( self.zbot_actions_in_queue[ group_name ][ action_keys[ i ] ].queued && [[ level.zbots_actions[ group_name ][ action_keys[ i ] ].should_cancel_func ]]() )
		{
			self notify( action_keys[ i ] + "_cancel" );
		}
	}
}

check_if_actions_should_be_postponed_in_group( group_name, action_keys )
{
	for ( i = 0; i < action_keys.size; i++ )
	{
		if ( self.zbot_actions_in_queue[ group_name ][ action_keys[ i ] ].queued && [[ level.zbots_actions[ group_name ][ action_keys[ i ] ].should_postpone_func ]]() )
		{
			self notify( action_keys[ i ] + "_postpone" );
		}
	}
}