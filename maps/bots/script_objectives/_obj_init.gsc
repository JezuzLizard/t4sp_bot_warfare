#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_common;
#include maps\bots\script_objectives\_obj_actions;
#include maps\bots\script_objectives\_obj_trackers;

init()
{
	//maps\bots\script_objectives\_obj_common;
	//maps\bots\script_objectives\_obj_actions;
	register_bot_action( "objective", "powerup", ::bot_grab_powerup,
	    ::bot_powerup_process_order,
	    ::bot_powerup_init,
	    ::bot_powerup_post_think,
	    ::bot_should_grab_powerup,
	    ::bot_check_complete_grab_powerup,
	    ::bot_powerup_should_cancel,
	    ::bot_powerup_should_postpone,
	    ::bot_powerup_priority );

	register_bot_action( "objective", "revive",  ::bot_revive_player,
	    ::bot_revive_process_order,
	    ::bot_revive_player_init,
	    ::bot_revive_player_post_think,
	    ::bot_should_revive_player,
	    ::bot_check_complete_revive_player,
	    ::bot_revive_player_should_cancel,
	    ::bot_revive_player_should_postpone,
	    ::bot_revive_player_priority );
	register_bot_objective( "powerup" );
	register_bot_objective( "revive" );

	//maps\bots\script_objectives\_obj_trackers;
	level thread store_powerups_dropped();
	level thread watch_for_downed_players();
}

connected()
{
	self endon( "disconnect" );

	self thread initialize_bot_actions_queue();
	self thread bot_valid_pump();
	//self thread bot_objective_inaccessible_pump();

	self.on_powerup_grab_func = ::bot_on_powerup_grab;
	self.on_revive_success_func = ::bot_on_revive_success;

	self.obj_postponed_reason = "";
	self.obj_cancel_reason = "";
}

spawned()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );

	self thread bot_action_think();
}

start_bot_threads()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );
}

//TODO: Add ability to pause an action so the bot won't be doing it while its paused but when its unpaused they can resume the action with the same settings
//Similar to postpone except instead of selecting a new action the current action is preserved
action_should_be_paused_global( primary_group_name, action_name )
{
	return false;
}
