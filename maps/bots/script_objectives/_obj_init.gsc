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

	register_bot_action( "objective", "magicbox",  ::bot_magicbox_purchase,
	    ::bot_magicbox_purchase_process_order,
	    ::bot_magicbox_purchase_init,
	    ::bot_magicbox_purchase_post_think,
	    ::bot_should_purchase_magicbox,
	    ::bot_check_complete_purchase_magicbox,
	    ::bot_magicbox_purchase_should_cancel,
	    ::bot_magicbox_purchase_should_postpone,
	    ::bot_magicbox_purchase_priority );
	
	register_bot_objective( "magicbox" );
	register_bot_objective( "wallbuy" );
	register_bot_objective( "wallbuyammo" );
	register_bot_objective( "perk" );
	register_bot_objective( "door" );
	register_bot_objective( "debris" );
	register_bot_objective( "trap" );
	register_bot_objective( "packapunch" );
	register_bot_objective( "revive" );
	//register_bot_objective( "grabbuildable" );
	//register_bot_objective( "buildbuildable" );
	//register_bot_objective( "part" );
	register_bot_objective( "powerup" );

	create_static_objectives();
}

connected()
{
	self endon( "disconnect" );

	self thread initialize_bot_actions_queue();

	self.on_powerup_grab_func = ::bot_on_powerup_grab;
	self.on_revive_success_func = ::bot_on_revive_success;
	self.on_magicbox_weapon_grab_func = ::bot_on_magicbox_weapon_grab;

	self.obj_postponed_reason = "";
	self.obj_cancel_reason = "";

	self.obj_history = [];
	self.bot_obj_history_max_entries = 20;
	self.bot_obj_history_index = 0;
	self.bot_obj_history_prev_index = 0;
}

spawned()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );

	self thread bot_action_think();
	//self thread cleanup_on_disconnect();
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
