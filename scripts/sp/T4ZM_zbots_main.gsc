#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include scripts\zm\bots\bot_actions;
#include scripts\zm\bots\bot_utility;
#include scripts\zm\bots\bot_difficulty;
#include scripts\zm\bots\_overrides;

main()
{
	replaceFunc( maps\mp\zombies\_zm_spawner::zombie_follow_enemy, ::zombie_follow_enemy_override );
	replaceFunc( maps\mp\zombies\_zm_powerups::powerup_timeout, ::powerup_timeout_override );

	register_bot_action( "purchase", "magicbox", ::bot_magicbox_purchase, ::bot_should_purchase_magicbox, ::bot_magicbox_purchase_on_completion, ::bot_magicbox_purchase_should_cancel, ::bot_magicbox_purchase_on_cancel, ::bot_magicbox_purchase_should_postpone, ::bot_magicbox_purchase_on_postpone, ::bot_magicbox_purchase_priority );
	register_bot_action( "purchase", "wallbuy", ::bot_wallbuy_purchase, ::bot_should_purchase_wallbuy, ::bot_wallbuy_purchase_on_completion, ::bot_wallbuy_purchase_should_cancel, ::bot_wallbuy_purchase_on_cancel, ::bot_wallbuy_purchase_should_postpone, ::bot_wallbuy_purchase_on_postpone, ::bot_wallbuy_purchase_priority );
	register_bot_action( "purchase", "wallbuyammo", ::bot_wallbuy_ammo_purchase, ::bot_should_purchase_wallbuy_ammo, ::bot_wallbuy_ammo_purchase_on_completion, ::bot_wallbuy_ammo_purchase_should_cancel, ::bot_wallbuy_ammo_purchase_on_cancel, ::bot_wallbuy_ammo_purchase_should_postpone, ::bot_wallbuy_ammo_purchase_on_postpone, ::bot_wallbuy_ammo_purchase_priority );
	register_bot_action( "purchase", "perk", ::bot_perk_purchase, ::bot_should_purchase_perk, ::bot_perk_purchase_on_completion, ::bot_perk_purchase_should_cancel, ::bot_perk_purchase_on_cancel, ::bot_perk_purchase_should_postpone, ::bot_perk_purchase_on_postpone, ::bot_perk_purchase_priority );
	register_bot_action( "purchase", "door", ::bot_door_purchase, ::bot_should_purchase_door, ::bot_door_purchase_on_completion, ::bot_door_purchase_should_cancel, ::bot_door_purchase_on_cancel, ::bot_door_purchase_should_postpone, ::bot_door_purchase_on_postpone, ::bot_door_purchase_priority );
	register_bot_action( "purchase", "debris", ::bot_debris_purchase, ::bot_should_purchase_debris, ::bot_debris_purchase_on_completion, ::bot_debris_purchase_should_cancel, ::bot_debris_purchase_on_cancel, ::bot_debris_purchase_should_postpone, ::bot_debris_purchase_on_postpone, ::bot_debris_purchase_priority );
	register_bot_action( "purchase", "trap", ::bot_trap_purchase, ::bot_should_purchase_trap, ::bot_trap_purchase_on_completion, ::bot_trap_purchase_should_cancel, ::bot_trap_purchase_on_cancel, ::bot_trap_purchase_should_postpone, ::bot_trap_purchase_on_postpone, ::bot_trap_purchase_priority );
	register_bot_action( "purchase", "packapunch", ::bot_packapunch_purchase, ::bot_should_packapunch );
	register_bot_action( "usetriggerhold", "revive", ::bot_revive_player, ::bot_should_revive_player, ::bot_revive_player_on_completion, ::bot_revive_player_should_cancel, ::bot_revive_player_on_cancel, ::bot_revive_player_should_postpone, ::bot_revive_player_on_postpone, ::bot_revive_player_priority );
	register_bot_action( "usetrigger", "grabbuildable", ::bot_grab_buildable, ::bot_should_grab_buildable, ::bot_grab_buildable_on_completion, ::bot_grab_buildable_should_cancel, ::bot_grabbuild_buildable_on_cancel, ::bot_grab_buildable_should_postpone, ::bot_grab_buildable_on_postpone, ::bot_grab_buildable_priority  );
	register_bot_action( "usetriggerhold", "buildbuildable", ::bot_build_buildable, ::bot_should_build_buildable, ::bot_build_buildable_on_completion, ::bot_build_buildable_should_cancel, ::bot_build_buildable_on_cancel, ::bot_build_buildable_should_postpone, ::bot_build_buildable_on_postpone, ::bot_build_buildable_priority );
	register_bot_action( "usetrigger", "part", ::bot_grab_part, ::bot_should_grab_part, ::bot_part_on_completion, ::bot_part_should_cancel, ::bot_part_on_cancel, ::bot_part_should_postpone, ::bot_part_on_postpone, ::bot_part_priority );
	register_bot_action( "touchtrigger", "powerup", ::bot_grab_powerup, ::bot_should_grab_powerup, ::bot_powerup_on_completion, ::bot_powerup_should_cancel, ::bot_powerup_on_cancel, ::bot_powerup_should_postpone, ::bot_powerup_on_postpone, ::bot_powerup_priority );
	//register_bot_action( level.bot_action_type_shoot, "shoot", ::bot_shoot, ::bot_should_shoot );
	//register_bot_action( level.bot_action_type_ads, "ads", ::bot_ads, ::bot_should_ads );
	//register_bot_action( level.bot_action_type_grenade, "grenade", ::bot_grenade, ::bot_should_grenade );

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
		if ( self.action_queue.size > 4 )
		{
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
		for ( i = 0; i < action_keys.size && self.action_queue.size < 3; i++ )
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