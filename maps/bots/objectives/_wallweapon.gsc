#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\objectives\_utility;

Finder( eObj )
{
	answer = [];

	if ( self inLastStand() )
	{
		return answer;
	}

	weapon_spawns = getentarray( "weapon_upgrade", "targetname" );

	if ( !isdefined( weapon_spawns ) || weapon_spawns.size <= 0 )
	{
		return answer;
	}

	weapons = self getweaponslist();

	// TODO check if need a new weapon, rate weapons too is better then current etc

	for ( i = 0; i < weapon_spawns.size; i++ )
	{
		player_has_weapon = false;

		if ( !isdefined( weapon_spawns[ i ].zombie_weapon_upgrade ) )
		{
			continue;
		}

		for ( h = 0; h < weapons.size; h++ )
		{
			if ( weapons[ h ] == weapon_spawns[ i ].zombie_weapon_upgrade )
			{
				player_has_weapon = true;
			}
		}

		is_grenade = ( weapontype( weapon_spawns[ i ].zombie_weapon_upgrade ) == "grenade" );

		if ( !player_has_weapon || is_grenade )
		{
			func = BotBuiltinGetFunction( "maps/_zombiemode_weapons", "get_weapon_cost" );

			if ( self.score < [[ func ]]( weapon_spawns[ i ].zombie_weapon_upgrade ) )
			{
				continue;
			}
		}
		else
		{
			func = BotBuiltinGetFunction( "maps/_zombiemode_weapons", "get_ammo_cost" );

			if ( self.score < [[ func ]]( weapon_spawns[ i ].zombie_weapon_upgrade ) )
			{
				continue;
			}
		}

		model = weapon_spawns[ i ];

		if ( isdefined( weapon_spawns[ i ].target ) )
		{
			model = getent( weapon_spawns[ i ].target, "targetname" );
		}

		if ( !isdefined( model ) )
		{
			continue;
		}

		org = self getOffset( model, weapon_spawns[ i ] );

		if ( GetPathIsInaccessible( self.origin, org ) )
		{
			continue;
		}

		answer[ answer.size ] = self CreateFinderObjectiveEZ( eObj, weapon_spawns[ i ] );
	}

	return answer;
}

getOffset( model, weapon )
{
	org = model get_angle_offset_node( 40, ( 0, -90, 0 ), ( 0, 0, 1 ) );

	test_org = ( org[ 0 ], org[ 1 ], weapon.origin[ 2 ] );

	if ( !weapon PointInsideUseTrigger( test_org ) )
	{
		org = model get_angle_offset_node( 40, ( 0, 90, 0 ), ( 0, 0, 1 ) );
	}

	return org;
}

Priority( eObj, eEnt )
{
	// TODO: check weallweapon type

	base_priority = 0;
	base_priority += ClampLerp( get_path_dist( self.origin, eEnt.origin ), 0, 800, 1, -2 );

	if ( self HasBotObjective() && self GetBotObjectiveEnt() != eEnt )
	{
		base_priority -= 1;
	}

	if ( issubstr( eEnt.zombie_weapon_upgrade, "kar98k" ) || issubstr( eEnt.zombie_weapon_upgrade, "type99" ) )
	{
		base_priority -= 999;
	}

	return base_priority;
}

Executer( eObj )
{
	self endon( "disconnect" );
	self endon( "zombified" );

	weapon = eObj.eent;

	self thread WatchForCancel( weapon );

	self GoDoWallweapon( eObj );

	self WatchForCancelCleanup();
	self ClearScriptAimPos();
	self ClearScriptGoal();
	self ClearPriorityObjective();

	self CompletedObjective( eObj.bwassuccessful, eObj.sreason );
}

WatchForCancelCleanup()
{
	self notify( "WatchForCancelWallweapon" );
}

WatchForCancel( weapon )
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "WatchForCancelWallweapon" );

	for ( ;; )
	{
		wait 0.05;

		if ( self inLastStand() )
		{
			self CancelObjective( "self inLastStand()" );
			break;
		}
	}
}

WatchToGoToWeapon( weapon )
{
	self endon( "cancel_bot_objective" );
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "goal" );
	self endon( "bad_path" );
	self endon( "new_goal" );

	for ( ;; )
	{
		wait 0.05;

		if ( self istouching( weapon ) || weapon PointInsideUseTrigger( self.origin ) )
		{
			self notify( "goal" );
			break; // is this needed?
		}
	}
}

GoDoWallweapon( eObj )
{
	self endon( "cancel_bot_objective" );

	weapon = eObj.eent;
	model = weapon;

	if ( isdefined( weapon.target ) )
	{
		model = getent( weapon.target, "targetname" );
	}

	org = self getOffset( model, weapon );

	weap = self getcurrentweapon();

	if ( weap == "none" || !self getammocount( weap ) )
	{
		self SetPriorityObjective();
	}

	// go to weapon
	self thread WatchToGoToWeapon( weapon );
	self SetScriptGoal( org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		eObj.sreason = "didn't go to weapon";
		return;
	}

	if ( !self istouching( weapon ) && !weapon PointInsideUseTrigger( self.origin ) )
	{
		eObj.sreason = "not touching weapon";
		return;
	}

	// ok we are touching weapon, lets look at it
	self SetScriptAimPos( weapon.origin );

	// wait to look at it
	wait 1;

	// press use
	self thread BotPressUse( 0.15 );
	wait 0.1;

	eObj.sreason = "completed";
	eObj.bwassuccessful = true;
}
