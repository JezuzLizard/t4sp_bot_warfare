#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_common;
#include maps\bots\script_objectives\_obj_utility;

create_static_objectives()
{
	if ( getDvar( "magicbox_node_forward_size" ) == "" )
	{
		setDvar( "magicbox_node_forward_size", 55 );
	}
	if ( getDvar( "magicbox_node_vertical_offset" ) == "" )
	{
		setDvar( "magicbox_node_vertical_offset", 10 );
	}
	if ( getDvar( "magicbox_node_angle" ) == "" )
	{
		setDvar( "magicbox_node_angle", 90 );
	}
	if ( getDvar( "perk_node_forward_size" ) == "" )
	{
		setDvar( "perk_node_forward_size", 55 );
	}
	if ( getDvar( "perk_node_vertical_offset" ) == "" )
	{
		setDvar( "perk_node_vertical_offset", 1 );
	}
	if ( getDvar( "perk_node_angle" ) == "" )
	{
		setDvar( "perk_node_angle", -90 );
	}
	if ( getDvar( "wallbuy_node_forward_size" ) == "" )
	{
		setDvar( "wallbuy_node_forward_size", 40 );
	}
	if ( getDvar( "wallbuy_node_vertical_offset" ) == "" )
	{
		setDvar( "wallbuy_node_vertical_offset", 1 );
	}
	if ( getDvar( "wallbuy_node_angle" ) == "" )
	{
		setDvar( "wallbuy_node_angle", -90 );
	}
	if ( getDvar( "packapunch_node_forward_size" ) == "" )
	{
		setDvar( "packapunch_node_forward_size", 55 );
	}
	if ( getDvar( "packapunch_node_vertical_offset" ) == "" )
	{
		setDvar( "packapunch_node_vertical_offset", 1 );
	}
	if ( getDvar( "packapunch_node_angle" ) == "" )
	{
		setDvar( "packapunch_node_angle", -90 );
	}
	if ( getDvar( "power_node_forward_size" ) == "" )
	{
		setDvar( "power_node_forward_size", 55 );
	}
	if ( getDvar( "power_node_vertical_offset" ) == "" )
	{
		setDvar( "power_node_vertical_offset", 1 );
	}
	if ( getDvar( "power_node_angle" ) == "" )
	{
		setDvar( "power_node_angle", -90 );
	}
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );

	if ( isDefined( weapon_spawns ) && weapon_spawns.size > 0 )
	{
		for( i = 0; i < weapon_spawns.size; i++ )
		{
			obj = add_possible_bot_objective( "wallbuy", weapon_spawns[ i ], false );
			obj = add_possible_bot_objective( "wallbuyammo", weapon_spawns[ i ], false );
			model = getEnt( weapon_spawns[ i ].target, "targetname" );
			weapon_spawns[ i ].bot_use_node = model get_angle_offset_node( getDvarInt( "wallbuy_node_forward_size" ), ( 0, getDvarInt( "wallbuy_node_angle" ), 0 ), ( 0, 0, getDvarInt( "wallbuy_node_vertical_offset" ) ) );
			model thread wallbuy_debug();
		}
	}

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	if ( isDefined( vending_triggers ) && vending_triggers.size > 0 )
	{
		for ( i = 0; i < vending_triggers.size; i++ )
		{
			obj = add_possible_bot_objective( "perk", vending_triggers[ i ], false );
			model = getEnt( vending_triggers[ i ].target, "targetname" );
			vending_triggers[ i ].bot_use_node = model get_angle_offset_node( getDvarInt( "perk_node_forward_size" ), ( 0, getDvarInt( "perk_node_angle" ), 0 ), ( 0, 0, getDvarInt( "perk_node_vertical_offset" ) ) );
			model thread perk_debug();
		}
	}

	//TODO: See if its possible to automatically detect if a door is blocking an objective
	zombie_doors = GetEntArray( "zombie_door", "targetname" );

	if ( isDefined( zombie_doors ) && zombie_doors.size > 0 )
	{
		for ( i = 0; i < zombie_doors.size; i++ )
		{
			if ( isDefined( zombie_doors[ i ].script_noteworthy ) && zombie_doors[ i ].script_noteworthy == "electric_door" )
			{
				continue;
			}
			obj = add_possible_bot_objective( "door", zombie_doors[ i ], true );
		}
		level thread watch_door_objectives( zombie_doors );
	}

	zombie_debris = GetEntArray( "zombie_debris", "targetname" );

	if ( isDefined( zombie_debris ) && zombie_debris.size > 0 )
	{
		for ( i = 0; i < zombie_debris.size; i++ )
		{
			obj = add_possible_bot_objective( "debris", zombie_debris[ i ], true );
		}
		level thread watch_debris_objectives( zombie_debris );
	}

	vending_upgrade_trigger = GetEntArray("zombie_vending_upgrade", "targetname");

	if ( isDefined( vending_upgrade_trigger ) && vending_upgrade_trigger.size > 0 )
	{
		for ( i = 0; i < vending_upgrade_trigger.size; i++ )
		{
			obj = add_possible_bot_objective( "packapunch", vending_upgrade_trigger[ i ], false );
			model = getEnt( vending_triggers[ i ].target, "targetname" );
			vending_upgrade_trigger[ i ].bot_use_node = model get_angle_offset_node( getDvarInt( "packapunch_node_forward_size" ), ( 0, getDvarInt( "packapunch_node_angle" ), 0 ), ( 0, 0, getDvarInt( "packapunch_node_vertical_offset" ) ) );
			model thread packapunch_debug();
		}
	}

	master_switch = getent("power_switch","targetname");
	if ( !isDefined( master_switch ) )
	{
		master_switch = getent("master_switch","targetname");
	}
	if ( isDefined( master_switch ) )
	{
		obj = add_possible_bot_objective( "power", master_switch, false );
		master_switch.bot_use_node = master_switch get_angle_offset_node( getDvarInt( "power_node_forward_size" ), ( 0, getDvarInt( "power_node_angle" ), 0 ), ( 0, 0, getDvarInt( "power_node_vertical_offset" ) ) );
		//model thread power_debug();
	}

	if ( isDefined( level.chests ) && level.chests.size > 0 )
	{
		level thread watch_magicbox_objectives();
	}

	//maps\bots\script_objectives\_obj_trackers;
	level thread store_powerups_dropped();
	level thread watch_for_downed_players();
}

watch_power_objective( power_switch )
{
	while ( !isDefined( level.flag ) && !isDefined( level.flag[ "power_on" ] ) )
	{
		wait 0.05;
	}
	players = getPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		if ( player bot_get_objective() == "power" )
		{
			player.sucessfully_activated_power = true;
		}
	}
	waittillframeend;
	free_bot_objective( "power", power_switch );
}

watch_door_objectives( zombie_doors )
{
	level endon( "end_game" );

	for ( doors_opened_count = 0; doors_opened_count < zombie_doors.size; doors_opened_count++ )
	{
		level waittill( "door_opened", door, player );
		free_bot_objective( "door", door );
	}
}

watch_debris_objectives( zombie_debris )
{
	level endon( "end_game" );

	for ( debris_opened_count = 0; debris_opened_count < zombie_debris.size; debris_opened_count++ )
	{
		level waittill( "debris_opened", debris, player );
		free_bot_objective( "debris", debris );
	}
}

store_powerups_dropped()
{
	level endon( "end_game" );

	level thread free_powerups_dropped();

	level.zbots_powerups = [];
	while ( true )
	{
		level waittill( "powerup_dropped", powerup );
		waittillframeend;
		if ( !isDefined( powerup ) )
		{
			continue;
		}
		obj = add_possible_bot_objective( "powerup", powerup, true );
		obj.accessible = true;
		//maps\bots\_bot_utility::assign_priority_to_powerup( powerup );
		//level.zbots_powerups = maps\bots\_bot_utility::sort_array_by_priority_field( level.zbots_powerups, powerup );
	}
}

free_powerups_dropped()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "powerup_freed", powerup );
		id = powerup getEntityNumber();
		waittillframeend;
		free_bot_objective( "powerup", powerup, id );
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
		obj = add_possible_bot_objective( "revive", player, true );
		obj.accessible = true;
		player thread free_revive_objective_when_needed();
	}
}

free_revive_objective_when_needed()
{
	level endon( "end_game" );

	id = self getEntityNumber();
	self waittill_any( "disconnect", "zombified", "player_revived" );

	waittillframeend;

	free_bot_objective( "revive", self, id );
}

watch_magicbox_objectives()
{
	level endon( "end_game" );

	level waittill( "connected", player );

	cur_magicbox = maps\so\zm_common\_zm_magicbox::get_active_magicbox();
	add_possible_bot_objective( "magicbox", cur_magicbox, true );
	lid = cur_magicbox maps\so\zm_common\_zm_magicbox::get_chest_pieces()[ 1 ];
	cur_magicbox.bot_use_node = lid get_angle_offset_node( getDvarInt( "magicbox_node_forward_size" ), ( 0, getDvarInt( "magicbox_node_angle" ), 0 ), ( 0, 0, getDvarInt( "magicbox_node_vertical_offset" ) ) );

	cur_magicbox thread magicbox_debug();

	while ( true )
	{
		level waittill( "magicbox_teddy_bear", old_magicbox );
		waittillframeend;
		free_bot_objective( "magicbox", old_magicbox );
		level waittill( "new_magicbox", new_magicbox );
		add_possible_bot_objective( "magicbox", new_magicbox, true );
		lid = new_magicbox maps\so\zm_common\_zm_magicbox::get_chest_pieces()[ 1 ];
		new_magicbox.bot_use_node = lid get_angle_offset_node( getDvarInt( "magicbox_node_forward_size" ), ( 0, getDvarInt( "magicbox_node_angle" ), 0 ), ( 0, 0, getDvarInt( "magicbox_node_vertical_offset" ) ) );
		new_magicbox thread magicbox_debug();
	}
}

magicbox_debug()
{
	self notify( "magicbox_debug" );
	self endon( "magicbox_debug");
	level endon( "magicbox_teddy_bear" );
	if ( getDvarInt( "bot_obj_debug_all" ) == 0 && getDvarInt( "bot_obj_debug_perk" ) == 0 )
	{
		return;
	}
	while ( true )
	{
		lid = self maps\so\zm_common\_zm_magicbox::get_chest_pieces()[ 1 ];
		node = lid get_angle_offset_node( getDvarInt( "magicbox_node_forward_size" ), ( 0, getDvarInt( "magicbox_node_angle" ), 0 ), ( 0, 0, getDvarInt( "magicbox_node_vertical_offset" ) ) );
		self.bot_use_node = node;
		line( self.origin, node, ( 1.0, 1.0, 1.0 ) );
		wait 0.05;
	}
}

perk_debug()
{
	if ( getDvarInt( "bot_obj_debug_all" ) == 0 && getDvarInt( "bot_obj_debug_perk" ) == 0 )
	{
		return;
	}
	while ( true )
	{
		node = self get_angle_offset_node( getDvarInt( "perk_node_forward_size" ), ( 0, getDvarInt( "perk_node_angle" ), 0 ), ( 0, 0, getDvarInt( "perk_node_vertical_offset" ) ) );
		self.bot_use_node = node;
		line( self.origin, node, ( 1.0, 1.0, 1.0 ) );
		wait 0.05;
	}
}

wallbuy_debug()
{
	if ( getDvarInt( "bot_obj_debug_all" ) == 0 && getDvarInt( "bot_obj_debug_wallbuy" ) == 0 )
	{
		return;
	}
	while ( true )
	{
		node = self get_angle_offset_node( getDvarInt( "wallbuy_node_forward_size" ), ( 0, getDvarInt( "wallbuy_node_angle" ), 0 ), ( 0, 0, getDvarInt( "wallbuy_node_vertical_offset" ) ) );
		self.bot_use_node = node;
		line( self.origin, node, ( 1.0, 1.0, 1.0 ) );
		wait 0.05;
	}
}

packapunch_debug()
{
	if ( getDvarInt( "bot_obj_debug_all" ) == 0 && getDvarInt( "bot_obj_debug_packapunch" ) == 0 )
	{
		return;
	}
	while ( true )
	{
		node = self get_angle_offset_node( getDvarInt( "packapunch_node_forward_size" ), ( 0, getDvarInt( "packapunch_node_angle" ), 0 ), ( 0, 0, getDvarInt( "packapunch_node_vertical_offset" ) ) );
		self.bot_use_node = node;
		line( self.origin, node, ( 1.0, 1.0, 1.0 ) );
		wait 0.05;
	}
}

bot_on_powerup_grab( powerup )
{
	self bot_objective_print( "powerup", powerup getEntityNumber(), "bot_on_powerup_grab", "Bot <" + self.playername + "> grabbed powerup" );
	self.successfully_grabbed_powerup = true;
}

bot_on_revive_success( revivee )
{
	self bot_objective_print( "revive", revivee getEntityNumber(), "bot_on_revive_success", "Bot <" + self.playername + "> revived <" + revivee.playername + ">" );
	self.successfully_revived_player = true;
}

bot_on_magicbox_weapon_grab( magicbox, weapon )
{
	self bot_objective_print( "magicbox", magicbox getEntityNumber(), "bot_on_magicbox_weapon_grab", "Bot <" + self.playername + "> grabbed <" + weapon + "> from the box" );
	self.successfully_grabbed_magicbox_weapon = true;
	self.last_magicbox_purchase_time = getTime();
}

bot_on_perk_purchase( trigger, perk )
{
	self bot_objective_print( "perk", trigger getEntityNumber(), "bot_on_perk_purchase", "Bot <" + self.playername + "> purchased <" + perk + ">" );
	self.successfully_bought_perk = true;
}

bot_on_door_purchase_func( door )
{
	self bot_objective_print( "door", door getEntityNumber(), "bot_on_door_purchase_func", "Bot <" + self.playername + "> purchased door" );
	self.successfully_bought_door = true;
}

bot_on_debris_purchase_func( debris )
{
	self bot_objective_print( "debris", debris getEntityNumber(), "bot_on_debris_purchase_func", "Bot <" + self.playername + "> purchased debris" );
	self.successfully_bought_debris = true;
}

bot_on_wallbuy_purchase_func( trigger, weapon )
{
	self bot_objective_print( "wallbuy", trigger getEntityNumber(), "bot_on_wallbuy_purchase_func", "Bot <" + self.playername + "> purchased wallbuy <" + weapon + ">" );
	self.successfully_bought_wallbuy = true;
	self.last_wallbuy_purchase_time = getTime();
}

bot_on_wallbuy_ammo_purchase_func( trigger, weapon )
{
	self bot_objective_print( "wallbuyammo", trigger getEntityNumber(), "bot_on_wallbuy_ammo_purchase_func", "Bot <" + self.playername + "> purchased wallbuy ammo <" + weapon + ">" );
	self.successfully_bought_wallbuy_ammo = true;
}
