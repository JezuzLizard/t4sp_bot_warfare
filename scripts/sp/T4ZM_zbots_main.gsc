#include common_scripts\utility;
#include maps\_utility;
#include maps\_zombiemode_utility;



#include scripts\sp\bots\actions\combat;
#include scripts\sp\bots\actions\movement;
#include scripts\sp\bots\actions\objective;

main()
{
	//3 separate bot think threads
	//Objective group is for things to go to usually allowing the bot to kill zombies on the way and survive as normal
	//Objectives can be canceled/postponed by combat thread, movement thread or by other objectives
	register_bot_action( "objective", "magicbox", ::bot_magicbox_purchase, ::bot_magicbox_process_order, ::bot_should_purchase_magicbox, ::bot_magicbox_purchase_on_completion, ::bot_magicbox_purchase_should_cancel, ::bot_magicbox_purchase_on_cancel, ::bot_magicbox_purchase_should_postpone, ::bot_magicbox_purchase_on_postpone, ::bot_magicbox_purchase_priority );
	register_bot_action( "objective", "wallbuy", ::bot_wallbuy_purchase, ::bot_wallbuy_process_order, ::bot_should_purchase_wallbuy, ::bot_wallbuy_purchase_on_completion, ::bot_wallbuy_purchase_should_cancel, ::bot_wallbuy_purchase_on_cancel, ::bot_wallbuy_purchase_should_postpone, ::bot_wallbuy_purchase_on_postpone, ::bot_wallbuy_purchase_priority );
	register_bot_action( "objective", "wallbuyammo", ::bot_wallbuy_ammo_purchase, ::bot_wallbuyammo_process_order, ::bot_should_purchase_wallbuy_ammo, ::bot_wallbuy_ammo_purchase_on_completion, ::bot_wallbuy_ammo_purchase_should_cancel, ::bot_wallbuy_ammo_purchase_on_cancel, ::bot_wallbuy_ammo_purchase_should_postpone, ::bot_wallbuy_ammo_purchase_on_postpone, ::bot_wallbuy_ammo_purchase_priority );
	register_bot_action( "objective", "perk", ::bot_perk_purchase, ::bot_perk_process_order, ::bot_should_purchase_perk, ::bot_perk_purchase_on_completion, ::bot_perk_purchase_should_cancel, ::bot_perk_purchase_on_cancel, ::bot_perk_purchase_should_postpone, ::bot_perk_purchase_on_postpone, ::bot_perk_purchase_priority );
	register_bot_action( "objective", "door", ::bot_door_purchase, ::bot_door_process_order, ::bot_should_purchase_door, ::bot_door_purchase_on_completion, ::bot_door_purchase_should_cancel, ::bot_door_purchase_on_cancel, ::bot_door_purchase_should_postpone, ::bot_door_purchase_on_postpone, ::bot_door_purchase_priority );
	register_bot_action( "objective", "debris", ::bot_debris_purchase, ::bot_debris_process_order, ::bot_should_purchase_debris, ::bot_debris_purchase_on_completion, ::bot_debris_purchase_should_cancel, ::bot_debris_purchase_on_cancel, ::bot_debris_purchase_should_postpone, ::bot_debris_purchase_on_postpone, ::bot_debris_purchase_priority );
	register_bot_action( "objective", "trap", ::bot_trap_purchase, ::bot_trap_process_order, ::bot_should_purchase_trap, ::bot_trap_purchase_on_completion, ::bot_trap_purchase_should_cancel, ::bot_trap_purchase_on_cancel, ::bot_trap_purchase_should_postpone, ::bot_trap_purchase_on_postpone, ::bot_trap_purchase_priority );
	register_bot_action( "objective", "packapunch", ::bot_packapunch_purchase, ::bot_packapunch_process_order, ::bot_should_purchase_packapunch, ::bot_packapunch_purchase_on_completion, ::bot_packapunch_purchase_should_cancel, ::bot_packapunch_purchase_on_cancel, ::bot_packapunch_purchase_should_postpone, ::bot_packapunch_purchase_on_postpone, ::bot_packapunch_purchase_priority );
	register_bot_action( "objective", "revive", ::bot_revive_player, ::bot_revive_process_order, ::bot_should_revive_player, ::bot_revive_player_on_completion, ::bot_revive_player_should_cancel, ::bot_revive_player_on_cancel, ::bot_revive_player_should_postpone, ::bot_revive_player_on_postpone, ::bot_revive_player_priority );
	register_bot_action( "objective", "grabbuildable", ::bot_grab_buildable, ::bot_grabbuildable_process_order, ::bot_should_grab_buildable, ::bot_grab_buildable_on_completion, ::bot_grab_buildable_should_cancel, ::bot_grabbuild_buildable_on_cancel, ::bot_grab_buildable_should_postpone, ::bot_grab_buildable_on_postpone, ::bot_grab_buildable_priority  );
	register_bot_action( "objective", "buildbuildable", ::bot_build_buildable, ::bot_buildbuildable_process_order, ::bot_should_build_buildable, ::bot_build_buildable_on_completion, ::bot_build_buildable_should_cancel, ::bot_build_buildable_on_cancel, ::bot_build_buildable_should_postpone, ::bot_build_buildable_on_postpone, ::bot_build_buildable_priority );
	register_bot_action( "objective", "part", ::bot_grab_part, ::bot_part_process_order, ::bot_should_grab_part, ::bot_part_on_completion, ::bot_part_should_cancel, ::bot_part_on_cancel, ::bot_part_should_postpone, ::bot_part_on_postpone, ::bot_part_priority );
	register_bot_action( "objective", "powerup", ::bot_grab_powerup, ::bot_powerup_process_order, ::bot_should_grab_powerup, ::bot_powerup_on_completion, ::bot_powerup_should_cancel, ::bot_powerup_on_cancel, ::bot_powerup_should_postpone, ::bot_powerup_on_postpone, ::bot_powerup_priority );

	//Combat thread actions
	//These all need definitions
	register_bot_action( "combat", "aimatsinglenormalzombie", ::bot_aimatsinglenormalzombie, ::bot_aimatsinglenormalzombie_process_order ::bot_should_aimatsinglenormalzombie, ::bot_aimatsinglenormalzombie_on_completion, ::bot_aimatsinglenormalzombie_should_cancel, ::bot_aimatsinglenormalzombie_on_cancel, ::bot_aimatsinglenormalzombie_should_postpone, ::bot_aimatsinglenormalzombie_on_postpone, ::bot_aimatsinglenormalzombie_priority );
	register_bot_action( "combat", "shootsinglenormalzombie", ::bot_shootsinglenormalzombie, ::bot_shootsinglenormalzombie_process_order ::bot_should_shootsinglenormalzombie, ::bot_shootsinglenormalzombie_on_completion, ::bot_shootsinglenormalzombie_should_cancel, ::bot_shootsinglenormalzombie_on_cancel, ::bot_shootsinglenormalzombie_should_postpone, ::bot_shootsinglenormalzombie_on_postpone, ::bot_shootsinglenormalzombie_priority );
	register_bot_action( "combat", "aimatmultiplenormalzombies", ::bot_aimatmultiplenormalzombies, ::bot_aimatmultiplenormalzombies_process_order ::bot_should_aimatmultiplenormalzombies, ::bot_aimatmultiplenormalzombies_on_completion, ::bot_aimatmultiplenormalzombies_should_cancel, ::bot_aimatmultiplenormalzombies_on_cancel, ::bot_aimatmultiplenormalzombies_should_postpone, ::bot_aimatmultiplenormalzombies_on_postpone, ::bot_aimatmultiplenormalzombies_priority );
	register_bot_action( "combat", "shootmultiplenormalzombies", ::bot_shootmultiplenormalzombies, ::bot_shootmultiplenormalzombies_process_order ::bot_should_shootmultiplenormalzombies, ::bot_shootmultiplenormalzombie_on_completion, ::bot_shootmultiplenormalzombie_should_cancel, ::bot_shootmultiplenormalzombie_on_cancel, ::bot_shootmultiplenormalzombie_should_postpone, ::bot_shootmultiplenormalzombie_on_postpone, ::bot_shootmultiplenormalzombie_priority );
	register_bot_action( "combat", "meleesinglenormalzombie", ::bot_meleesinglenormalzombie, ::bot_meleesinglenormalzombie_process_order ::bot_should_meleesinglenormalzombie, ::bot_meleesinglenormalzombie_on_completion, ::bot_meleesinglenormalzombie_should_cancel, ::bot_meleesinglenormalzombie_on_cancel, ::bot_meleesinglenormalzombie_should_postpone, ::bot_meleesinglenormalzombie_on_postpone, ::bot_meleesinglenormalzombie_priority );
	register_bot_action( "combat", "shootsingledogzombie", ::bot_shootsingledogzombie, ::bot_shootsingledogzombie_process_order ::bot_should_shootsingledogzombie, ::bot_shootsingledogzombie_on_completion, ::bot_shootsingledogzombie_should_cancel, ::bot_shootsingledogzombie_on_cancel, ::bot_shootsingledogzombie_should_postpone, ::bot_shootsingledogzombie_on_postpone, ::bot_shootsingledogzombie_priority );
	register_bot_action( "combat", "shootmultipledogzombies", ::bot_shootmultipledogzombies, ::bot_shootmultipledogzombies_process_order ::bot_should_shootmultipledogzombies, ::bot_shootmultipledogzombies_on_completion, ::bot_shootmultipledogzombies_should_cancel, ::bot_shootmultipledogzombies_on_cancel, ::bot_shootmultipledogzombies_should_postpone, ::bot_shootmultipledogzombies_on_postpone, ::bot_shootmultipledogzombies_priority );
	register_bot_action( "combat", "meleesingledogzombie", ::bot_meleesingledogzombie, ::bot_meleesingledogzombie_process_order ::bot_should_meleesingledogzombie, ::bot_meleesingledogzombie_on_completion, ::bot_meleesingledogzombie_should_cancel, ::bot_meleesingledogzombie_on_cancel, ::bot_meleesingledogzombie_should_postpone, ::bot_meleesingledogzombie_on_postpone, ::bot_meleesingledogzombie_priority );

	//Movement thread actions
	//These all need definitions
	register_bot_action( "movement", "movetoobjective", ::bot_movetoobjective, ::bot_movetoobjective_process_order ::bot_should_movetoobjective, ::bot_movetoobjective_on_completion, ::bot_movetoobjective_should_cancel, ::bot_movetoobjective_on_cancel, ::bot_movetoobjective_should_postpone, ::bot_movetoobjective_on_postpone, ::bot_movetoobjective_priority );
	register_bot_action( "movement", "train", ::bot_train, ::bot_train_process_order ::bot_should_train, ::bot_train_on_completion, ::bot_train_should_cancel, ::bot_train_on_cancel, ::bot_train_should_postpone, ::bot_train_on_postpone, ::bot_train_priority );
	register_bot_action( "movement", "camp", ::bot_camp, ::bot_camp_process_order ::bot_should_camp, ::bot_camp_on_completion, ::bot_camp_should_cancel, ::bot_camp_on_cancel, ::bot_camp_should_postpone, ::bot_camp_on_postpone, ::bot_camp_priority );
	register_bot_action( "movement", "flee", ::bot_flee, ::bot_flee_process_order ::bot_should_flee, ::bot_flee_on_completion, ::bot_flee_should_cancel, ::bot_flee_on_cancel, ::bot_flee_should_postpone, ::bot_flee_on_postpone, ::bot_flee_priority );

	level.bot_weapon_quality_poor = 0;
	level.bot_weapon_quality_fair = 1;
	level.bot_weapon_quality_good = 2;
	level.bot_weapon_quality_excellent = 3;
	level.bot_weapon_quality_best = 4;

	/*
	level.bot_powerup_priority_none = 0;
	level.bot_powerup_priority_low = 1;
	level.bot_powerup_priority_medium = 2;
	level.bot_powerup_priority_high = 3;
	level.bot_powerup_priority_urgent = 4;
	register_bot_powerup_priority( "nuke", level.bot_powerup_priority_high, level.bot_powerup_priority_urgent );
	register_bot_powerup_priority( "insta_kill", level.bot_powerup_priority_high, level.bot_powerup_priority_urgent );
	register_bot_powerup_priority( "full_ammo", level.bot_powerup_priority_medium, level.bot_powerup_priority_low );
	register_bot_powerup_priority( "double_points", level.bot_powerup_priority_low, level.bot_powerup_priority_none );
	register_bot_powerup_priority( "carpenter", level.bot_powerup_priority_low, level.bot_powerup_priority_none );
	register_bot_powerup_priority( "fire_sale", level.bot_powerup_priority_low, level.bot_powerup_priority_none );
	register_bot_powerup_priority( "free_perk", level.bot_powerup_priority_medium, level.bot_powerup_priority_low );
	register_bot_powerup_priority( "zombie_blood", level.bot_powerup_priority_high, level.bot_powerup_priority_urgent);
	*/
	level thread store_powerups_dropped();
	level thread spawn_bots();
}

init()
{
	parse_bot_weapon_stats_from_table();
}

register_action_queue_actions()
{
	self register_bot_action_queue_action( "magicbox" );
	self register_bot_action_queue_action( "wallbuy" );
	self register_bot_action_queue_action( "wallbuyammo" );
	self register_bot_action_queue_action( "perk" );
	self register_bot_action_queue_action( "door" );
	self register_bot_action_queue_action( "debris" );
	self register_bot_action_queue_action( "trap" );
	self register_bot_action_queue_action( "revive" );
	self register_bot_action_queue_action( "buildable" );
	self register_bot_action_queue_action( "buildbuildable" );
	self register_bot_action_queue_action( "part" );
	self register_bot_action_queue_action( "powerup" );
}

spawn_bots()
{
	level waittill( "connected", player );

	while ( true )
	{
		spawn_bots();
		wait 1;
	}
}

spawn_bots()
{
	required_bots = 3;
	bot_count = 0;
	while ( bot_count < required_bots )
	{
		bot = undefined;
		while ( !isDefined( bot ) )
		{
			bot = addTestClient();
		}
		bot.pers[ "isBot" ] = true;
		bot.action_queue = [];
		bot register_action_queue_actions();
		bot thread bot_movement_think();
		//bot thread bot_combat_think();
		bot thread bot_think();
		bot_count++;
	}
}

copy_default_action_settings_to_queue( action_name )
{
	//self.group = level.zbots_actions[ action_name ].group;
	self.action = level.zbots_actions[ action_name ].action;
	//self.should_do_func = level.zbots_actions[ action_name ].should_do_func;
	self.on_completion_func = level.zbots_actions[ action_name ].on_completion_func;
	self.should_cancel_func = level.zbots_actions[ action_name ].should_cancel_func;
	self.on_cancel_func = level.zbots_actions[ action_name ].on_cancel_func;
	self.should_postpone_func = level.zbots_actions[ action_name ].should_postpone_func;
	self.on_postpone_func = level.zbots_actions[ action_name ].on_postpone_func;
	self.priority_func = level.zbots_actions[ action_name ].priority_func;
}

process_next_queued_action()
{
	if ( self.action_queue.size <= 0 )
	{
		return;
	}
	self thread [[ self.action_queue[ 0 ].on_completion_func ]]();
	if ( self.action_queue[ 0 ].can_cancel )
	{
		self thread [[ self.action_queue[ 0 ].on_cancel_func ]]();
	}
	if ( self.action_queue[ 0 ].can_postpone )
	{
		self thread [[ self.action_queue[ 0 ].on_postpone_func ]]();
	}
	self [[ self.action_queue[ 0 ].action ]]();

	self wait_for_action_completion( self.action_queue[ 0 ].action_name );
}

wait_for_action_completion( action_name )
{
	result = self waittill_any_return( action_name + "_completion", action_name + "_cancel", action_name + "_postpone" );
	if ( isDefined( result ) && ( result == action_name + "_completion" || result == action_name + "_cancel" ) )
	{
		self.actions_in_queue[ self.action_queue[ 0 ].action_name ].queued = false;
		arrayRemoveIndex( self.action_queue, 0 );
	}
	else if ( result == action_name + "_postpone" )
	{
		postponed_action = self.action_queue[ 0 ];
		arrayRemoveIndex( self.action_queue, 0 );
		postponed_action.priority = 0;
		self.action_queue[ self.action_queue.size ] = postponed_action;
	}
}

bot_think()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	self waittill( "spawned_player" );

	while ( true )
	{
		wait 0.05;
		if ( !bot_valid( self ) )
		{
			self.action_queue = [];
			wait 1;
			continue;
		}
		/*
		action_keys = getArrayKeys( level.zbots_actions );
		for ( i = 0; i < action_keys.size; i++ )
		{
			if ( self.actions_in_queue[ action_keys[ i ] ].canceled )
			{
				self.actions_in_queue[ action_keys[ i ] ].canceled = false;
			}
		}
		action_keys = getArrayKeys( level.zbots_actions );
		for ( i = 0; i < action_keys.size; i++ )
		{
			if ( self.actions_in_queue[ action_keys[ i ] ].postponed )
			{
				self.actions_in_queue[ action_keys[ i ] ].postponed = false;
			}
		}
		*/
		action_keys = getArrayKeys( level.zbots_actions );
		for ( i = 0; i < action_keys.size; i++ )
		{
			if ( !self.actions_in_queue[ action_keys[ i ] ].queued && [[ level.zbots_actions[ action_keys[ i ] ].should_do_func ]]() )
			{
				self.action_queue[ self.action_queue.size ] = spawnStruct();
				self.action_queue[ self.action_queue.size - 1 ] copy_default_action_settings_to_queue( action_keys[ i ] );
				self.action_queue[ self.action_queue.size - 1 ].action_name = action_keys[ i ];
				self.action_queue[ self.action_queue.size - 1 ].priority = self [[ level.zbots_actions[ action_keys[ i ] ].priority_func ]]();
				self.actions_in_queue[ action_keys[ i ] ].queued = true;
			}
		}
		self.action_queue = self sort_array_by_priority_field( self.action_queue );
		self process_next_queued_action();
	}
}

bot_movement_think()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	/*
	if ( self any_zombies_targeting_self() )
	{

	}
	*/
	self.currently_moving = false;
	while ( true )
	{
		wait 0.05;
		if ( isDefined( self.target_pos ) && !self.currently_moving )
		{
			self lookAt( self.target_pos );
			self addGoal( self.target_pos, 36, 4, "move_to_target_pos" );
			self.currently_moving = true;
		}
		if ( self hasGoal( "move_to_target_pos" ) )
		{
			if ( self atGoal( "move_to_target_pos" ) )
			{
				self clearLookat();
				self.currently_moving = false;
				if ( isDefined( self.goal_type ) && isDefined( level.bot_at_goal_callback[ self.goal_type ] ) )
				{
					self [[ level.bot_at_goal_callback[ self.goal_type ] ]]();
				}
			}
		}
	}
}

store_powerups_dropped()
{
	level.zbots_powerups = [];
	level.zbots_powerups_targeted_for_grab = [];
	id_num = 0;
	while ( true )
	{
		level waittill( "powerup_dropped", powerup );
		if ( !isDefined( powerup ) )
		{
			continue;
		}
		assign_priority_to_powerup( powerup );
		level.zbots_powerups = sort_array_by_priority_field( level.zbots_powerups, powerup );
		powerup thread remove_from_bot_powerups_list_on_death();
	}
}

remove_from_bot_powerups_list_on_death()
{
	self waittill( "death" );
	arrayRemoveValue( level.zbots_powerups, self );
	arrayRemoveValue( level.zbots_powerups_targeted_for_grab, self );
	for ( i = 0; i < level.players.size; i++ )
	{
		if ( is_true( level.players[ i ].pers[ "isBot" ] ) && isDefined( level.players[ i ].available_powerups ) )
		{
			arrayRemoveValue( level.players[ i ].available_powerups, self );
		}
	}
}