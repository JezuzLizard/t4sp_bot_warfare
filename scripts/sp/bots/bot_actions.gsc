/*
	Bot actions are in two parts
*/
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include scripts\zm\bots\bot_utility;

register_bot_action( group, action_name, action_func, should_do_func, action_completion_func, should_cancel_func, on_cancel_func, should_postpone_func, on_postpone_func, priority_func )
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
	level.zbots_actions[ action_name ].on_completion_func = action_completion_func;
	level.zbots_actions[ action_name ].should_cancel_func = should_cancel_func;
	level.zbots_actions[ action_name ].on_cancel_func = on_cancel_func;
	level.zbots_actions[ action_name ].should_postpone_func = should_postpone_func;
	level.zbots_actions[ action_name ].on_postpone_func = on_postpone_func;
	level.zbots_actions[ action_name ].priority_func = priority_func;
}

register_bot_powerup_priority( powerup, priority_normal, priority_emergency )
{
	if ( !isDefined( level.zbots_powerup_priorities ) )
	{
		level.zbots_powerup_priorities = [];
	}
	level.zbots_powerup_priorities[ powerup ] = spawnStruct();
	level.zbots_powerup_priorities[ powerup ].normal = priority_normal;
	level.zbots_powerup_priorities[ powerup ].emergency = priority_emergency;
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
}

bot_magicbox_purchase()
{
	self.target_pos = self.available_chests[ 0 ].origin;
}

bot_should_purchase_magicbox()
{
	if ( level.chests.size <= 0 )
	{
		return false;
	}
	if ( !level.enable_magic )
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

bot_should_purchase_wallbuy()
{
	return false;
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

bot_should_purchase_wallbuy_ammo()
{
	return false;
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

bot_should_purchase_perk()
{
	return false;
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

bot_should_purchase_door()
{
	return false;
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

bot_should_purchase_debris()
{
	return false;
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

bot_should_purchase_trap()
{
	return false;
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

bot_revive_player()
{

}

bot_should_revive_player()
{
	return false;
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

bot_should_grab_buildable()
{
	return false;
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

bot_should_build_buildable()
{
	return false;
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

bot_should_grab_powerup()
{
	if ( !( isDefined( level.zbots_powerups ) && level.zbots_powerups.size > 0 ) )
	{
		return false;
	}
	const MAX_DISTANCE_SQ = 10000 * 10000;
	const BOT_SPEED_WHILE_SPRINTING_SQ = 380 * 380;
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

bot_powerup_on_completion()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	self notify( "powerup_completion_func" );
	self endon( "powerup_completion_func" );
	self endon( "pause_bot_think" );
	self endon( "powerup_cancel" );
	self endon( "powerup_postpone" );
	while ( !isDefined( self.target_powerup ) )
	{
		wait 0.05;
	}
	self.target_powerup waittill( "death" );
	self.actions_in_queue[ "powerup" ].queued = false;
	self notify( "powerup_completion" );
	self.available_powerups = undefined;
	self.target_pos = undefined;
}

bot_powerup_should_cancel()
{
	return false;
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