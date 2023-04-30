#include scripts\sp\bots\bot_objective_common;

bot_magicbox_purchase()
{
	self.target_pos = self.available_chests[ 0 ].origin;
}

bot_magicbox_process_order()
{

}

bot_should_purchase_magicbox()
{
	if ( !level.enable_magic )
	{
		return false;
	}
	if ( level.chests.size <= 0 )
	{
		return false;
	}
	self.available_chests = [];
	for ( i = 0; i < level.chests.size; i++ )
	{
		if ( level.chests[ i ].hidden )
		{
			continue;
		}
		if ( self.score < level.chests[ i ].zombie_cost )
		{
			continue;
		}
		self.available_chests[ self.available_chests.size ] = level.chests[ i ];
	}
	if ( self.available_chests.size > 0 )
	{
		for ( i = 0; i < self.available_chests.size; i++ )
		{
			if ( isDefined( self.available_chests[ i ].chest_user ) )
			{
				maps\_utility::array_remove_index( self.available_chests, i );
				i--;
			}
		}
	}
	return self.available_chests.size > 0;
}

bot_check_complete_magicbox() 
{
	return false;
}

bot_set_complete_magicbox()
{

}

bot_magicbox_purchase_on_completion()
{

}

bot_magicbox_purchase_should_cancel()
{
	return false;
}

bot_magicbox_purchase_on_cancel()
{

}

bot_magicbox_purchase_should_postpone()
{
	return false;
}

bot_magicbox_purchase_on_postpone()
{

}

bot_magicbox_purchase_priority()
{
	priority = 0;
	LOW_AMMO_THRESHOLD = 0.3;
	weapons = self getWeaponsListPrimaries();
	if ( weapons.size < 2 )
	{
		priority += 1;
	}
	for ( j = 0; j < weapons.size; j++ )
	{
		if ( self getWeaponAmmoStock( weapons[ j ] ) <= int( weaponmaxammo( weapons[ j ] ) *  LOW_AMMO_THRESHOLD ) )
		{
			priority += 1;
		}
	}
	return priority;
}

bot_wallbuy_purchase()
{

}

bot_wallbuy_process_order()
{
	return 0;
}

bot_should_purchase_wallbuy()
{
	return false;
}

bot_check_complete_wallbuy()
{
	return false;
}

bot_set_complete_wallbuy()
{

}

bot_wallbuy_purchase_on_completion()
{

}

bot_wallbuy_purchase_should_cancel()
{
	return false;
}

bot_wallbuy_purchase_on_cancel()
{

}

bot_wallbuy_purchase_should_postpone()
{
	return false;
}

bot_wallbuy_purchase_on_postpone()
{

}

bot_wallbuy_purchase_priority()
{
	return 0;
}

bot_wallbuy_ammo_purchase()
{

}

bot_wallbuyammo_process_order()
{
	return 0;
}

bot_should_purchase_wallbuy_ammo()
{
	return false;
}

bot_check_complete_wallbuy_ammo()
{
	return false;
}

bot_set_complete_wallbuy_ammo()
{

}

bot_wallbuy_ammo_purchase_on_completion()
{

}

bot_wallbuy_ammo_purchase_should_cancel()
{
	return false;
}

bot_wallbuy_ammo_purchase_on_cancel()
{

}

bot_wallbuy_ammo_purchase_should_postpone()
{
	return false;
}

bot_wallbuy_ammo_purchase_on_postpone()
{

}

bot_wallbuy_ammo_purchase_priority()
{
	return 0;
}

bot_perk_purchase()
{

}

bot_perk_process_order()
{
	return 0;
}

bot_should_purchase_perk()
{
	return false;
}

bot_check_complete_perk_purchase()
{
	return false;
}

bot_set_complete_perk_purchase()
{

}

bot_perk_purchase_on_completion()
{

}

bot_perk_purchase_should_cancel()
{
	return false;
}

bot_perk_purchase_on_cancel()
{
	
}

bot_perk_purchase_should_postpone()
{
	return false;
}

bot_perk_purchase_on_postpone()
{

}

bot_perk_purchase_priority()
{
	return 0;
}

bot_door_purchase()
{

}

bot_door_process_order()
{
	return 0;
}

bot_should_purchase_door()
{
	return false;
}

bot_check_complete_door_purchase()
{
	return false;
}

bot_set_complete_door_purchase()
{

}

bot_door_purchase_on_completion()
{

}

bot_door_purchase_should_cancel()
{
	return false;
}

bot_door_purchase_on_cancel()
{

}

bot_door_purchase_should_postpone()
{
	return false;
}

bot_door_purchase_on_postpone()
{

}

bot_door_purchase_priority()
{
	return 0;
}

bot_debris_purchase()
{

}

bot_debris_process_order()
{
	return 0;
}

bot_should_purchase_debris()
{
	return false;
}

bot_check_complete_debris_purchase()
{
	return false;
}

bot_set_complete_debris_purchase()
{

}

bot_debris_purchase_on_completion()
{

}

bot_debris_purchase_should_cancel()
{
	return false;
}

bot_debris_purchase_on_cancel()
{

}

bot_debris_purchase_should_postpone()
{
	return false;
}

bot_debris_purchase_on_postpone()
{

}

bot_debris_purchase_priority()
{
	return 0;
}

bot_trap_purchase()
{

}

bot_trap_process_order()
{
	return 0;
}

bot_should_purchase_trap()
{
	return false;
}

bot_check_complete_trap_purchase()
{
	return false;
}

bot_set_complete_trap_purchase()
{

}

bot_trap_purchase_on_completion()
{

}

bot_trap_purchase_should_cancel()
{
	return false;
}

bot_trap_purchase_on_cancel()
{

}

bot_trap_purchase_should_postpone()
{
	return false;
}

bot_trap_purchase_on_postpone()
{

}

bot_trap_purchase_priority()
{
	return 0;
}

bot_packapunch_purchase()
{

}

bot_packapunch_process_order()
{
	return 0;
}

bot_should_purchase_packapunch()
{
	return false;
}

bot_check_complete_packapunch_purchase()
{
	return false;
}

bot_set_complete_packapunch_purchase()
{

}

bot_packapunch_purchase_on_completion()
{

}

bot_packapunch_purchase_should_cancel()
{
	return false;
}

bot_packapunch_purchase_on_cancel()
{

}

bot_packapunch_purchase_should_postpone()
{
	return false;
}

bot_packapunch_purchase_on_postpone()
{

}

bot_packapunch_purchase_priority()
{
	return 0;
}

bot_revive_player()
{
	if ( !isDefined( self.available_revives ) || self.available_revives.size <= 0 )
	{
		return;
	}

	self endon( "disconnect" );
	level endon( "end_game" );

	player_to_revive_obj = self.available_revives[ 0 ];

	set_bot_global_shared_objective_owner_by_reference( "revive", player_to_revive_obj, self );

	player_to_revive = player_to_revive_obj.target_ent;

	action_id = self.action_queue[ "objective" ][ 0 ].action_id;

	//If player is no longer valid to revive stop trying to revive
	//If bot doesn't have an objective anymore or the objective has changed stop trying to revive
	while ( isDefined( player_to_revive ) && isDefined( player_to_revive_obj ) && isDefined( self.action_queue[ "objective" ][ 0 ] ) && action_id == self.action_queue[ "objective" ][ 0 ].action_id )
	{
		self.target_pos = player_to_revive.origin;

		if ( self.can_do_objective_now )
		{
			//TODO: Add check to see if another player is reviving target player
			//TODO: Add code to revive player, possibly add the ability to circle revive?
		}
		wait 0.2;
	}
}

bot_revive_process_order()
{
	return 0;
}

bot_should_revive_player()
{
	downed_players_objs = get_all_objectives_for_group( "revive" );
	if ( downed_players_objs.size <= 0 )
	{
		return false;
	}

	self.available_revives = [];

	obj_keys = getArrayKeys( downed_players_objs );
	for ( i = 0; i < downed_players_objs.size; i++ )
	{
		if ( isDefined( downed_players_objs[ obj_keys[ i ] ].owner ) )
		{
			continue;
		}

		self.available_revives[ self.available_revives.size ] = downed_players_objs[ obj_keys[ i ] ];
	}
	return self.available_revives.size > 0;
}

bot_check_complete_revive_player()
{
	if ( self.successfully_revived_player )
	{
		return true;
	}
	return false;
}

bot_set_complete_revive_player()
{
	self.successfully_revived_player = true;
}

bot_revive_player_on_completion()
{
	self.successfully_revived_player = false;
}

bot_revive_player_should_cancel()
{
	return !isDefined( self.available_revives[ 0 ].target_ent.revivetrigger );
}

bot_revive_player_on_cancel()
{

}

bot_revive_player_should_postpone()
{
	return false;
}

bot_revive_player_on_postpone()
{

}

bot_revive_player_priority()
{
	return 0;
}

bot_grab_buildable()
{

}

bot_grab_buildable_process_order()
{
	return 0;
}

bot_should_grab_buildable()
{
	return false;
}

bot_check_complete_grab_buildable()
{
	return false;
}

bot_set_complete_grab_buildable()
{

}

bot_grab_buildable_on_completion()
{

}

bot_grab_buildable_should_cancel()
{
	return false;
}

bot_grabbuild_buildable_on_cancel()
{

}

bot_grab_buildable_should_postpone()
{
	return false;
}

bot_grab_buildable_on_postpone()
{

}

bot_grab_buildable_priority()
{
	return 0;
}

bot_build_buildable()
{

}

bot_build_buildable_process_order()
{
	return 0;
}

bot_should_build_buildable()
{
	return false;
}

bot_check_complete_build_buildable()
{
	return false;	
}

bot_set_complete_build_buildable()
{

}

bot_build_buildable_on_completion()
{

}

bot_build_buildable_should_cancel()
{
	return false;
}

bot_build_buildable_on_cancel()
{

}

bot_build_buildable_should_postpone()
{
	return false;
}

bot_build_buildable_on_postpone()
{

}

bot_build_buildable_priority()
{
	return 0;
}

bot_grab_part()
{

}

bot_part_process_order()
{
	return 0;
}

bot_should_grab_part()
{
	return false;
}

bot_part_on_completion()
{

}

bot_part_should_cancel()
{
	return false;
}

bot_check_complete_grab_part()
{
	return false;
}

bot_set_complete_grab_part()
{

}

bot_part_on_cancel()
{

}

bot_part_should_postpone()
{
	return false;
}

bot_part_on_postpone()
{

}

bot_part_priority()
{
	return 0;
}

bot_grab_powerup()
{
	self endon( "powerup_end_think" );

	if ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 )
	{
		return;
	}
	set_bot_global_shared_objective_owner_by_reference( "powerup", self.available_powerups[ 0 ], self );
	while ( true )
	{
		self SetScriptGoal( self.available_powerups[ 0 ].target_ent.origin );
		wait 0.05;
	}
}

bot_powerup_process_order()
{
	return 0;
}

bot_should_grab_powerup()
{
	if ( level.zbot_objective_glob[ "powerup" ].active_objectives.size <= 0 )
	{
		return false;
	}
	MAX_DISTANCE_SQ = 10000 * 10000;
	BOT_SPEED_WHILE_SPRINTING_SQ = 285 * 285;
	self.available_powerups = [];

	powerup_objectives = level.zbot_objective_glob[ "powerup" ].active_objectives;
	obj_keys = getArrayKeys( powerup_objectives );
	for ( i = 0; i < powerup_objectives.size; i++ )
	{
		obj = powerup_objectives[ obj_keys[ i ] ];
		powerup = obj.target_ent;
		if ( isDefined( obj.owner ) )
		{
			continue;
		}
		time_left = powerup.time_left_until_timeout;
		distance_required_to_reach_powerup = distanceSquared( powerup.origin, self.origin );
		if ( distance_required_to_reach_powerup > BOT_SPEED_WHILE_SPRINTING_SQ * time_left )
		{
			continue;
		}
		if ( distanceSquared( powerup.origin, self.origin ) > MAX_DISTANCE_SQ )
		{
			continue;
		}
		if ( !isDefined( generatePath( self.origin, powerup.origin, self.team, false ) ) )
		{
			continue;
		}
		self.available_powerups[ self.available_powerups.size ] = obj;
	}

	//TODO: Sort powerups by priority here
	return self.available_powerups.size > 0;
}

bot_check_complete_grab_powerup()
{
	if ( self.successfully_grabbed_powerup )
	{
		return true;
	}
	return false;
}

bot_set_complete_grab_powerup()
{

}

bot_powerup_on_completion()
{
	self.successfully_grabbed_powerup = false;
}

bot_powerup_should_cancel()
{
	return ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 );
}

bot_powerup_on_cancel()
{

}

bot_powerup_should_postpone()
{
	return false;
}

bot_powerup_on_postpone()
{

}

bot_powerup_priority()
{
	if ( !isDefined( self.available_powerups ) )
	{
		return 0;
	}
	return self.available_powerups[ 0 ].target_ent.priority;
}