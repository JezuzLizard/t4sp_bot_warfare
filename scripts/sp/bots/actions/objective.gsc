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
				arrayRemoveIndex( self.available_chests, i );
				i--;
			}
		}
	}
	return self.available_chests.size > 0;
}

bot_check_complete_magicbox() 
{

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
	const LOW_AMMO_THRESHOLD = 0.3;
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

}

bot_revive_process_order()
{
	return 0;
}

bot_should_revive_player()
{
	return false;
}

bot_check_complete_revive_player()
{

}

bot_set_complete_revive_player()
{

}

bot_revive_player_on_completion()
{

}

bot_revive_player_should_cancel()
{
	return false;
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
	self endon( "disconnect" );
	self endon( "new_objective" );
	if ( !isDefined( self.available_powerups ) || self.available_powerups.size <= 0 )
	{
		return;
	}
	self.target_pos = self.available_powerups[ 0 ].origin;
	self.target_powerup = self.available_powerups[ 0 ];
	level.zbots_powerups_targeted_for_grab[ level.zbots_powerups_targeted_for_grab.size ] = self.available_powerups[ 0 ];
}

bot_powerup_process_order()
{
	return 0;
}

bot_should_grab_powerup()
{
	if ( !isDefined( level.zbots_powerups ) || level.zbots_powerups.size <= 0  )
	{
		return false;
	}
	MAX_DISTANCE_SQ = 10000 * 10000;
	BOT_SPEED_WHILE_SPRINTING_SQ = 285 * 285;
	self.available_powerups = [];
	for ( i = 0; i < level.zbots_powerups.size; i++ )
	{
		if ( array_validate( level.zbots_powerups_targeted_for_grab ) )
		{
			already_targeted = false;
			for ( j = 0; j < level.zbots_powerups_targeted_for_grab.size; j++ )
			{
				if ( level.zbots_powerups_targeted_for_grab[ j ] == level.zbots_powerups[ i ] )
				{
					already_targeted = true;
					break;
				}
			}
			if ( already_targeted )
			{
				continue;
			}
		}
		time_left = level.zbots_powerups[ i ].time_left_until_timeout;
		distance_required_to_reach_powerup = distanceSquared( level.zbots_powerups[ i ].origin, self.origin );
		if ( distance_required_to_reach_powerup > BOT_SPEED_WHILE_SPRINTING_SQ * time_left )
		{
			continue;
		}
		if ( distanceSquared( level.zbots_powerups[ i ].origin, self.origin ) > MAX_DISTANCE_SQ )
		{
			continue;
		}
		if ( !findPath( self.origin, level.zbots_powerups[ i ].origin ) )
		{
			continue;
		}
		self.available_powerups[ self.available_powerups.size ] = level.zbots_powerups[ i ];
	}
	time_left = undefined;
	distance_required_to_reach_powerup = undefined;
	already_targeted = undefined;
	return self.available_powerups.size > 0;
}

bot_check_complete_grab_powerup()
{

}

bot_set_complete_grab_powerup()
{

}

bot_powerup_on_completion()
{

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
	return self.available_powerups[ 0 ].priority;
}