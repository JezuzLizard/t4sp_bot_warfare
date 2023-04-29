#include common_scripts\utility;
#include maps\_utility;
#include maps\so\zm_common\_zm_utility;

#include scripts\sp\bots\_bot_internal;

#include scripts\sp\bots\bot_actions_common;
#include scripts\sp\bots\bot_objective_common;
#include scripts\sp\bots\bot_difficulty_presets_common;
#include scripts\sp\bots\bot_personality_presets_common;
#include scripts\sp\bots\bot_target_common;
#include scripts\sp\bots\actions\combat;
#include scripts\sp\bots\actions\movement;
#include scripts\sp\bots\actions\objective;
#include scripts\sp\bots\actions\look;

#include scripts\sp\bots\bot_utility;

main()
{
	//Objective group is for things to go to usually allowing the bot to kill zombies on the way and survive as normal
	//Objectives can be canceled/postponed by combat, movement or by other objectives
	register_bot_action( "objective", "magicbox", ::bot_magicbox_purchase, ::bot_magicbox_process_order, ::bot_should_purchase_magicbox, ::bot_check_complete_magicbox, ::bot_set_complete_magicbox, ::bot_magicbox_purchase_on_completion, ::bot_magicbox_purchase_should_cancel, ::bot_magicbox_purchase_on_cancel, ::bot_magicbox_purchase_should_postpone, ::bot_magicbox_purchase_on_postpone, ::bot_magicbox_purchase_priority );
	register_bot_action( "objective", "wallbuy", ::bot_wallbuy_purchase, ::bot_wallbuy_process_order, ::bot_should_purchase_wallbuy, ::bot_check_complete_wallbuy, ::bot_set_complete_wallbuy, ::bot_wallbuy_purchase_on_completion, ::bot_wallbuy_purchase_should_cancel, ::bot_wallbuy_purchase_on_cancel, ::bot_wallbuy_purchase_should_postpone, ::bot_wallbuy_purchase_on_postpone, ::bot_wallbuy_purchase_priority );
	register_bot_action( "objective", "wallbuyammo", ::bot_wallbuy_ammo_purchase, ::bot_wallbuyammo_process_order, ::bot_should_purchase_wallbuy_ammo, ::bot_check_complete_wallbuy_ammo, ::bot_set_complete_wallbuy_ammo, ::bot_wallbuy_ammo_purchase_on_completion, ::bot_wallbuy_ammo_purchase_should_cancel, ::bot_wallbuy_ammo_purchase_on_cancel, ::bot_wallbuy_ammo_purchase_should_postpone, ::bot_wallbuy_ammo_purchase_on_postpone, ::bot_wallbuy_ammo_purchase_priority );
	register_bot_action( "objective", "perk", ::bot_perk_purchase, ::bot_perk_process_order, ::bot_should_purchase_perk, ::bot_check_complete_perk_purchase, ::bot_set_complete_perk_purchase, ::bot_perk_purchase_on_completion, ::bot_perk_purchase_should_cancel, ::bot_perk_purchase_on_cancel, ::bot_perk_purchase_should_postpone, ::bot_perk_purchase_on_postpone, ::bot_perk_purchase_priority );
	register_bot_action( "objective", "door", ::bot_door_purchase, ::bot_door_process_order, ::bot_should_purchase_door, ::bot_check_complete_door_purchase, ::bot_set_complete_door_purchase, ::bot_door_purchase_on_completion, ::bot_door_purchase_should_cancel, ::bot_door_purchase_on_cancel, ::bot_door_purchase_should_postpone, ::bot_door_purchase_on_postpone, ::bot_door_purchase_priority );
	register_bot_action( "objective", "debris", ::bot_debris_purchase, ::bot_debris_process_order, ::bot_should_purchase_debris, ::bot_check_complete_debris_purchase, ::bot_set_complete_debris_purchase, ::bot_debris_purchase_on_completion, ::bot_debris_purchase_should_cancel, ::bot_debris_purchase_on_cancel, ::bot_debris_purchase_should_postpone, ::bot_debris_purchase_on_postpone, ::bot_debris_purchase_priority );
	register_bot_action( "objective", "trap", ::bot_trap_purchase, ::bot_trap_process_order, ::bot_should_purchase_trap, ::bot_check_complete_trap_purchase, ::bot_set_complete_trap_purchase, ::bot_trap_purchase_on_completion, ::bot_trap_purchase_should_cancel, ::bot_trap_purchase_on_cancel, ::bot_trap_purchase_should_postpone, ::bot_trap_purchase_on_postpone, ::bot_trap_purchase_priority );
	register_bot_action( "objective", "packapunch", ::bot_packapunch_purchase, ::bot_packapunch_process_order, ::bot_should_purchase_packapunch, ::bot_check_complete_packapunch_purchase, ::bot_set_complete_packapunch_purchase, ::bot_packapunch_purchase_on_completion, ::bot_packapunch_purchase_should_cancel, ::bot_packapunch_purchase_on_cancel, ::bot_packapunch_purchase_should_postpone, ::bot_packapunch_purchase_on_postpone, ::bot_packapunch_purchase_priority );
	register_bot_action( "objective", "revive", ::bot_revive_player, ::bot_revive_process_order, ::bot_should_revive_player, ::bot_check_complete_revive_player, ::bot_set_complete_revive_player, ::bot_revive_player_on_completion, ::bot_revive_player_should_cancel, ::bot_revive_player_on_cancel, ::bot_revive_player_should_postpone, ::bot_revive_player_on_postpone, ::bot_revive_player_priority );
	//register_bot_action( "objective", "grabbuildable", ::bot_grab_buildable, ::bot_grab_buildable_process_order, ::bot_should_grab_buildable, ::bot_check_complete_grab_buildable, ::bot_set_complete_grab_buildable, ::bot_grab_buildable_on_completion, ::bot_grab_buildable_should_cancel, ::bot_grabbuild_buildable_on_cancel, ::bot_grab_buildable_should_postpone, ::bot_grab_buildable_on_postpone, ::bot_grab_buildable_priority  );
	//register_bot_action( "objective", "buildbuildable", ::bot_build_buildable, ::bot_build_buildable_process_order, ::bot_should_build_buildable, ::bot_check_complete_build_buildable, ::bot_set_complete_build_buildable, ::bot_build_buildable_on_completion, ::bot_build_buildable_should_cancel, ::bot_build_buildable_on_cancel, ::bot_build_buildable_should_postpone, ::bot_build_buildable_on_postpone, ::bot_build_buildable_priority );
	//register_bot_action( "objective", "part", ::bot_grab_part, ::bot_part_process_order, ::bot_should_grab_part, ::bot_check_complete_grab_part, ::bot_set_complete_grab_part, ::bot_part_on_completion, ::bot_part_should_cancel, ::bot_part_on_cancel, ::bot_part_should_postpone, ::bot_part_on_postpone, ::bot_part_priority );
	register_bot_action( "objective", "powerup", ::bot_grab_powerup, ::bot_powerup_process_order, ::bot_should_grab_powerup, ::bot_check_complete_grab_powerup, ::bot_set_complete_grab_powerup, ::bot_powerup_on_completion, ::bot_powerup_should_cancel, ::bot_powerup_on_cancel, ::bot_powerup_should_postpone, ::bot_powerup_on_postpone, ::bot_powerup_priority );

	//Combat actions
	//These all need definitions
	register_bot_action( "combat", "shoot", ::bot_shoot, ::bot_shoot_process_order, ::bot_should_shoot, ::bot_check_complete_shoot, ::bot_set_complete_shoot, ::bot_shoot_on_completion, ::bot_shoot_should_cancel, ::bot_shoot_on_cancel, ::bot_shoot_should_postpone, ::bot_shoot_on_postpone, ::bot_shoot_priority );
	register_bot_action( "combat", "reload", ::bot_reload, ::bot_reload_process_order, ::bot_should_reload, ::bot_check_complete_reload, ::bot_set_complete_reload, ::bot_reload_on_completion, ::bot_reload_should_cancel, ::bot_reload_on_cancel, ::bot_reload_should_postpone, ::bot_reload_on_postpone, ::bot_reload_priority );
	register_bot_action( "combat", "frag", ::bot_frag, ::bot_frag_process_order, ::bot_should_frag, ::bot_check_complete_frag, ::bot_set_complete_frag, ::bot_frag_on_completion, ::bot_frag_should_cancel, ::bot_frag_on_cancel, ::bot_frag_should_postpone, ::bot_frag_on_postpone, ::bot_frag_priority );
	register_bot_action( "combat", "tactical", ::bot_tactical, ::bot_tactical_process_order, ::bot_should_tactical, ::bot_check_complete_tactical, ::bot_set_complete_tactical, ::bot_tactical_on_completion, ::bot_tactical_should_cancel, ::bot_tactical_on_cancel, ::bot_tactical_should_postpone, ::bot_tactical_on_postpone, ::bot_tactical_priority );
	//register_bot_action( "combat", "combatoverride", ::bot_combatoverride, ::bot_combatoverride_process_order ::bot_should_combatoverride, ::bot_check_complete_combatoverride, ::bot_set_complete_combatoverride, ::bot_combatoverride_on_completion, ::bot_combatoverride_should_cancel, ::bot_combatoverride_on_cancel, ::bot_combatoverride_should_postpone, ::bot_combatoverride_on_postpone, ::bot_combatoverride_priority );

	//Movement actions
	//These all need definitions
	register_bot_action( "movement", "movetoobjective", ::bot_movetoobjective, ::bot_movetoobjective_process_order, ::bot_should_movetoobjective, ::bot_check_complete_movetoobjective, ::bot_set_complete_movetoobjective, ::bot_movetoobjective_on_completion, ::bot_movetoobjective_should_cancel, ::bot_movetoobjective_on_cancel, ::bot_movetoobjective_should_postpone, ::bot_movetoobjective_on_postpone, ::bot_movetoobjective_priority );
	//register_bot_action( "movement", "moveoverride", ::bot_moveoverride, ::bot_moveoverride_process_order, ::bot_should_moveoverride, ::bot_check_complete_moveoverride, ::bot_set_complete_moveoverride, ::bot_moveoverride_on_completion, ::bot_moveoverride_should_cancel, ::bot_moveoverride_on_cancel, ::bot_moveoverride_should_postpone, ::bot_moveoverride_on_postpone, ::bot_moveoverride_priority );
	register_bot_action( "movement", "train", ::bot_train, ::bot_train_process_order, ::bot_should_train, ::bot_check_complete_train, ::bot_set_complete_train, ::bot_train_on_completion, ::bot_train_should_cancel, ::bot_train_on_cancel, ::bot_train_should_postpone, ::bot_train_on_postpone, ::bot_train_priority );
	register_bot_action( "movement", "camp", ::bot_camp, ::bot_camp_process_order, ::bot_should_camp, ::bot_check_complete_camp, ::bot_set_complete_camp, ::bot_camp_on_completion, ::bot_camp_should_cancel, ::bot_camp_on_cancel, ::bot_camp_should_postpone, ::bot_camp_on_postpone, ::bot_camp_priority );
	register_bot_action( "movement", "flee", ::bot_flee, ::bot_flee_process_order, ::bot_should_flee, ::bot_check_complete_flee, ::bot_set_complete_flee, ::bot_flee_on_completion, ::bot_flee_should_cancel, ::bot_flee_on_cancel, ::bot_flee_should_postpone, ::bot_flee_on_postpone, ::bot_flee_priority );
	//register_bot_action( "follow" )

	register_bot_action( "look", "lookatobjective", ::bot_lookatobjective, ::bot_lookatobjective_process_order, ::bot_should_lookatobjective, ::bot_check_complete_lookatobjective, ::bot_set_complete_lookatobjective, ::bot_lookatobjective_on_completion, ::bot_lookatobjective_should_cancel, ::bot_lookatobjective_on_cancel, ::bot_lookatobjective_should_postpone, ::bot_lookatobjective_on_postpone, ::bot_lookatobjective_priority );
	register_bot_action( "look", "lookattarget", ::bot_lookattarget, ::bot_lookattarget_process_order, ::bot_should_lookattarget, ::bot_check_complete_lookattarget, ::bot_set_complete_lookattarget, ::bot_lookattarget_on_completion, ::bot_lookattarget_should_cancel, ::bot_lookattarget_on_cancel, ::bot_lookattarget_should_postpone, ::bot_lookattarget_on_postpone, ::bot_lookattarget_priority );
	register_bot_action( "look", "lookatgoal", ::bot_lookatgoal, ::bot_lookatgoal_process_order, ::bot_should_lookatgoal, ::bot_check_complete_lookatgoal, ::bot_set_complete_lookatgoal, ::bot_lookatgoal_on_completion, ::bot_lookatgoal_should_cancel, ::bot_lookatgoal_on_cancel, ::bot_lookatgoal_should_postpone, ::bot_lookatgoal_on_postpone, ::bot_lookatgoal_priority );
	//register_bot_action( "look", "ads", ::bot_ads, ::bot_ads_process_order, ::bot_should_ads, ::bot_check_complete_ads, ::bot_set_complete_ads, ::bot_ads_on_completion, ::bot_ads_should_cancel, ::bot_ads_on_cancel, ::bot_ads_should_postpone, ::bot_ads_on_postpone, ::bot_ads_priority );
	//register_bot_action( "look", "lookahead", ::bot_lookahead, ::bot_lookahead_process_order, ::bot_should_lookahead, ::bot_check_complete_lookahead, ::bot_set_complete_lookahead, ::bot_lookahead_on_completion, ::bot_lookahead_should_cancel, ::bot_lookahead_on_cancel, ::bot_lookahead_should_postpone, ::bot_lookahead_on_postpone, ::bot_lookahead_priority );

	register_bot_personality_type( "aggressive" );
	register_bot_personality_type( "passive" );
	register_bot_personality_type( "supportive" );
	register_bot_personality_type( "mixed" );
	register_bot_personality_type( "default" );

	register_bot_difficulty( "bone" );
	register_bot_difficulty( "crossbones" );
	register_bot_difficulty( "skull" );
	register_bot_difficulty( "knife" );
	register_bot_difficulty( "shotguns" );

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

	register_bot_target_type( "zombie" );
	register_bot_target_type( "zombie_dog" );

	level.bot_weapon_quality_poor = 0;
	level.bot_weapon_quality_fair = 1;
	level.bot_weapon_quality_good = 2;
	level.bot_weapon_quality_excellent = 3;
	level.bot_weapon_quality_best = 4;

	level.bots_minSprintDistance = 315;
	level.bots_minSprintDistance *= level.bots_minSprintDistance;
	level.bots_minGrenadeDistance = 256;
	level.bots_minGrenadeDistance *= level.bots_minGrenadeDistance;
	level.bots_maxGrenadeDistance = 1024;
	level.bots_maxGrenadeDistance *= level.bots_maxGrenadeDistance;
	level.bots_maxKnifeDistance = 80;
	level.bots_maxKnifeDistance *= level.bots_maxKnifeDistance;
	level.bots_goalDistance = 27.5;
	level.bots_goalDistance *= level.bots_goalDistance;
	level.bots_noADSDistance = 200;
	level.bots_noADSDistance *= level.bots_noADSDistance;
	level.bots_maxShotgunDistance = 500;
	level.bots_maxShotgunDistance *= level.bots_maxShotgunDistance;
	level.bots_listenDist = 100;

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

	level thread spawn_bots_for_host();

	level thread on_player_connect();

	level.waypoints = getAllNodes();

	level.waypoints_inside_playable_area = get_nodes_in_playable_area();

	level.waypointCount = level.waypoints.size;

	level.waypoint_count_inside_playable_area = level.waypoints_inside_playable_area.size;
}

/*
	We clear all of the script variables and other stuff for the bots.
*/
resetBotVars()
{
	self.bot = spawnStruct();
	self.bot.script_target = undefined;
	self.bot.script_target_offset = undefined;
	self.bot.target = undefined;
	self.bot.targets = [];
	self.bot.target_this_frame = undefined;
	self.bot.after_target = undefined;
	self.bot.after_target_pos = undefined;
	self.bot.moveTo = self.origin;

	self.bot.script_aimpos = undefined;

	self.bot.script_goal = undefined;
	self.bot.script_goal_dist = 0.0;

	self.bot.next_wp = -1;
	self.bot.second_next_wp = -1;
	self.bot.towards_goal = undefined;
	self.bot.astar = [];
	self.bot.stop_move = false;
	self.bot.greedy_path = false;
	self.bot.climbing = false;
	self.bot.wantsprint = false;
	self.bot.last_next_wp = -1;
	self.bot.last_second_next_wp = -1;

	self.bot.isfrozen = false;
	self.bot.sprintendtime = -1;
	self.bot.isreloading = false;
	self.bot.issprinting = false;
	self.bot.isfragging = false;
	self.bot.issmoking = false;
	self.bot.isfraggingafter = false;
	self.bot.issmokingafter = false;
	self.bot.isknifing = false;
	self.bot.isknifingafter = false;

	self.bot.semi_time = false;
	self.bot.jump_time = undefined;
	self.bot.last_fire_time = -1;

	self.bot.is_cur_full_auto = false;
	self.bot.cur_weap_dist_multi = 1;
	self.bot.is_cur_sniper = false;

	self.bot.rand = randomInt( 100 );

	self botStop();
}

get_nodes_in_playable_area()
{
	total_nodes = getAllNodes();
	filtered_nodes = [];
	for ( i = 0; i < total_nodes.size; i++ )
	{
		if ( !is_point_in_playable_area( total_nodes[ i ].origin ) )
		{
			continue;
		}
		filtered_nodes[ filtered_nodes.size ] = total_nodes[ i ];
		if ( ( i % 10 ) == 0 )
		{
			wait 0.05;
		}
	}
	return filtered_nodes;
}

is_point_in_playable_area( point )
{
	playable_area = getentarray( "playable_area", "targetname" );

	in_playable_area = false;

	if ( !isDefined( playable_area ) || playable_area.size < 1 )
	{
		in_playable_area = true;
	}

	temp_ent = spawn( "script_origin", point );

	if ( !in_playable_area )
	{
		for ( p = 0; p < playable_area.size; p++ )
		{
			if ( temp_ent isTouching( playable_area[ p ] ) )
			{
				in_playable_area = true;
				break;
			}
		}
	}

	temp_ent delete();

	return in_playable_area;
}

on_player_connect()
{
	i = 0;
	while ( true )
	{
		level waittill( "connected", player );
		player thread on_player_spawned();
		player.client_id = i;
		if ( player isBot() )
		{
			player resetBotVars();
			player.successfully_grabbed_powerup = false;
			player.successfully_revived_player = false;
			player.successfully_moved_to_objective = false;
			player.can_do_objective_now = false;
			player.on_powerup_grab_func = ::bot_on_powerup_grab;
			player thread zbot_spawn();
		}
		else
		{
			player thread bot_control();
		}
		i++;
	}
}

bot_control()
{
	self endon( "disconnect" );
	self notifyOnPlayerCommand( "+smoke", "new_script_goal" );
	while ( true )
	{
		self waittill( "new_script_goal" );
		players = getPlayers();
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[ i ] isBot() )
			{
				players[ i ] scripts\sp\bots\_bot_utility::SetScriptGoal( self.origin );
				players[ i ] thread clear_script_on_event();
			}
		}
		self iPrintLn( "Set new goal for bots" );
	}
}

clear_script_on_event()
{
	self endon( "disconnect" );
	result = self waittill_any_return( "new_goal", "goal", "bad_path" );
	if ( result != "new_goal" )
	{
		self scripts\sp\bots\_bot_utility::ClearScriptGoal();
	}
}

on_player_spawned()
{
	self waittill( "spawned_player" );
	self.score = 100000;
}

zbot_spawn()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	while ( true )
	{
		self waittill( "spawned_player" );
		self thread doBotMovement();
		//self thread grenade_danger();
		//self thread check_reload();
		//self thread stance();
		self thread walk();
		//self thread target();
		//self thread updateBones();
		//self thread aim();
		//self thread watchHoldBreath();
		//self thread onNewEnemy();
		//self thread watchGrenadeFire();
		//self thread watchPickupGun();
	}
}

//TODO: Make postponing save the settings for the action so when the action is being executed again the bot tries to do/get the same thing
//TODO: Make global canceling and postponing functionality
//TODO: Make shared global objective and normal objective globs work
//TODO: Allow bots to multitask objectives on the way by using the postpone system
//TODO: Cancel most objectives if the bot is invalid
//TODO: Add reset complete functions to reset successfully completed actions variables
//TODO: Ignore objectives if bot is not able fulfill them at the moment, bot can start doing objectives when they are in a good position to do so
//TODO: Add the ability to check if a bot is at an objective to start the action think
//TODO: Add atobjective movement handler to let objectives control movement temporarily
//TODO: Allow bots to still do actions while down if possible
//TODO: Track zombies targetting players

init()
{
	if ( isDefined( level.chests ) && level.chests.size > 0 )
	{
		for ( i = 0; i < level.chests.size; i++ )
		{
			level.chests[ i ].id = i;
		}
		//level thread watch_magicbox_objectives();
	}

	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	if ( isDefined( weapon_spawns ) && weapon_spawns.size > 0 )
	{
		for( i = 0; i < weapon_spawns.size; i++ )
		{
			weapon_spawns[ i ].id = i;
			add_possible_bot_objective( "wallbuy", i, false, weapon_spawns[ i ] );
			add_possible_bot_objective( "wallbuyammo", i, false, weapon_spawns[ i ] );
		}
	}

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	if ( isDefined( vending_triggers ) && vending_triggers.size > 0 )
	{
		for ( i = 0; i < vending_triggers.size; i++ )
		{
			vending_triggers[ i ].id = i;
			add_possible_bot_objective( "perk", i, false, vending_triggers[ i ] );
		}
	}

	//TODO: See if its possible to automatically detect if a door is blocking an objective
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	
	if ( isDefined( zombie_doors ) && zombie_doors.size > 0 )
	{
		for ( i = 0; i < zombie_doors.size; i++ )
		{
			zombie_doors[ i ].id = i;
			add_possible_bot_objective( "door", i, true, zombie_doors[ i ] );
		}
		level thread watch_door_objectives( zombie_doors );
	}

	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 

	if ( isDefined( zombie_debris ) && zombie_debris.size > 0 )
	{
		for ( i = 0; i < zombie_debris.size; i++ )
		{
			zombie_debris[ i ].id = i;
			add_possible_bot_objective( "debris", i, true, zombie_debris[ i ] );
		}
		level thread watch_debris_objectives( zombie_debris );
	}

	vending_upgrade_trigger = GetEntArray("zombie_vending_upgrade", "targetname");

	if ( isDefined( vending_upgrade_trigger ) && vending_upgrade_trigger.size > 0 )
	{
		for ( i = 0; i < vending_upgrade_trigger.size; i++ )
		{
			vending_upgrade_trigger[ i ].id = i;
			add_possible_bot_objective( "packapunch", i, false, vending_upgrade_trigger[ i ] );
		}
	}

	level.callbackActorSpawned = ::zbots_actor_spawned;
	level.callbackActorKilled = ::zbots_actor_killed;
	level.callbackActorDamage = ::zbots_actor_damage;

	level thread watch_for_downed_players();

	level thread store_powerups_dropped();

	parse_bot_weapon_stats_from_table();
}

zbots_actor_spawned()
{
	self.is_actor = true;
	self thread add_actor_to_target_glob();
}

add_actor_to_target_glob()
{
	wait 1; //Wait long enough for the actor to be initialized in script
	assert( isDefined( self.targetname ), "Actor doesn't have a targetname set" );
	if ( !isDefined( self.targetname ) )
	{
		return;
	}
	add_possible_bot_target( self.targetname, level.zbot_target_glob_ids[ self.targetname ], self );
	self.target_id = level.zbot_target_glob_ids[ self.targetname ];
	level.zbot_target_glob_ids[ self.targetname ]++;
}

zbots_actor_killed( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, iTimeOffset )
{
	free_bot_target( self.targetname, self.target_id );
}

zbots_actor_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset )
{
	if ( isPlayer( eAttacker ) && iDamage > 0 )
	{
		eAttacker set_target_damaged_by( self.targetname, self.target_id );
		eAttacker thread remove_target_damaged_by_after_time( self, self.target_id );
	}
	
	self FinishActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset );
}

remove_target_damaged_by_after_time( target_ent, id )
{
	player_entnum = self getEntityNumber();
	self endon( "disconnect" );
	target_ent notify( "damaged_by_player_" + player_entnum );
	target_ent endon( "damaged_by_player_" + player_entnum );
	target_ent endon( "death" );

	wait 6;

	self clear_target_damaged_by( target_ent.targetname, id );
}

spawn_bots_for_host()
{
	level waittill( "connected", player );

	spawn_bots();
}

spawn_bots()
{
	required_bots = 3;
	bot_count = 0;
	while ( bot_count < required_bots )
	{
		bot = undefined;
		while ( !isDefined( bot ) && getPlayers().size < getDvarInt( "sv_maxclients" ) )
		{
			bot = addTestClient();
		}
		if ( !isDefined( bot ) )
		{
			return;
		}
		bot.pers[ "isBot" ] = true;
		bot.action_queue = [];
		bot.action_queue[ "objective" ] = [];
		bot.action_queue[ "combat" ] = [];
		bot.action_queue[ "movement" ] = [];
		bot.action_queue[ "look" ] = [];
		//bot register_action_queue_actions();
		//bot thread bot_think();
		bot_count++;
	}
}

bot_think()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	self waittill( "spawned_player" );

	while ( true )
	{
		wait 0.25;
		if ( !scripts\sp\bots\bot_utility::bot_valid( self ) )
		{
			self notify( "stop_action_think" );
			self bot_clear_actions_queue();
			while ( !scripts\sp\bots\bot_utility::bot_valid( self ) )
			{
				wait 1;
			}
		}

		group_name = "movement";

		self bot_action_think( group_name );

		group_name = "look";

		self bot_action_think( group_name );

		group_name = "combat";

		//self scripts\sp\bots\bot_target_common::bot_pick_target();

		self bot_action_think( group_name );

		group_name = "objective";

		self bot_action_think( group_name );
	}
}

watch_door_objectives( zombie_doors )
{
	level endon( "end_game" );

	for ( doors_opened_count = 0; doors_opened_count < zombie_doors.size; doors_opened_count++ )
	{
		level waittill( "door_opened", door, player );
		free_bot_objective( "door", door.id );
	}
}

watch_debris_objectives( zombie_debris )
{
	level endon( "end_game" );

	for ( debris_opened_count = 0; debris_opened_count < zombie_debris.size; debris_opened_count++ )
	{
		level waittill( "door_opened", debris, player );
		free_bot_objective( "door", debris.id );
	}
}

watch_magicbox_objectives()
{
	level endon( "end_game" );

	level waittill( "connected", player );

	prev_magicbox = maps\so\zm_common\_zm_magicbox::get_active_magicbox();
	while ( true )
	{
		cur_magicbox = maps\so\zm_common\_zm_magicbox::get_active_magicbox();
		if ( prev_magicbox != cur_magicbox )
		{
			add_possible_bot_objective( "magicbox", cur_magicbox.id, false, cur_magicbox );
			free_bot_objective( "magicbox", prev_magicbox.id );
			prev_magicbox = cur_magicbox;
		}
		wait 1;
	}
}

store_powerups_dropped()
{
	level endon( "end_game" );

	level.zbots_powerups = [];
	level.zbots_powerups_targeted_for_grab = [];
	id = 0;
	while ( true )
	{
		level waittill( "powerup_dropped", powerup );
		if ( !isDefined( powerup ) )
		{
			continue;
		}
		powerup.id = id;
		add_possible_bot_objective( "powerup", id, true, powerup );
		scripts\sp\bots\bot_utility::assign_priority_to_powerup( powerup );
		level.zbots_powerups = scripts\sp\bots\bot_utility::sort_array_by_priority_field( level.zbots_powerups, powerup );
		id++;
	}
}

free_powerups_dropped()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "powerup_freed", powerup );
		free_bot_objective( "powerup", powerup.id );
	}
}

watch_for_downed_players()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "player_entered_laststand", player );
		if ( !isDefined( player ) )
		{
			continue;
		}
		add_possible_bot_objective( "revive", player.client_id, true, player );
		player thread free_revive_objective_when_needed();
	}
}

free_revive_objective_when_needed()
{
	level endon( "end_game" );

	id = self.id;
	while ( isDefined( self ) && isDefined( self.revivetrigger ) )
	{
		wait 0.05;
	}

	free_bot_objective( "revive", id );
}

bot_on_powerup_grab( powerup )
{
	self.successfully_grabbed_powerup = true;
}