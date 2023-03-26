/*
	Bot actions are in two parts
*/
#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;

register_bot_action( group, action_name, action_func, should_do_func, action_process_order_func, action_completion_func, should_cancel_func, on_cancel_func, should_postpone_func, on_postpone_func, priority_func )
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
	level.zbots_actions[ action_name ].on_completion_func = action_completion_func;
	level.zbots_actions[ action_name ].should_cancel_func = should_cancel_func;
	level.zbots_actions[ action_name ].on_cancel_func = on_cancel_func;
	level.zbots_actions[ action_name ].should_postpone_func = should_postpone_func;
	level.zbots_actions[ action_name ].on_postpone_func = on_postpone_func;
	level.zbots_actions[ action_name ].priority_func = priority_func;
}

register_bot_action_queue_action( action_name )
{
	if ( !isDefined( self.actions_in_queue ) )
	{
		self.actions_in_queue = [];
	}
	self.actions_in_queue[ action_name ] = spawnStruct();
	self.actions_in_queue[ action_name ].postponed = false;
	self.actions_in_queue[ action_name ].canceled = false;
	self.actions_in_queue[ action_name ].queued = false;
	self.actions_in_queue[ action_name ].completed = false;
}