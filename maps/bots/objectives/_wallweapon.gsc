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

	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" );

	if ( !isDefined( weapon_spawns ) || weapon_spawns.size <= 0 )
	{
		return answer;
	}

	weapons = self GetWeaponsList();

	// TODO check if need a new weapon, rate weapons too is better then current etc

	for ( i = 0; i < weapon_spawns.size; i++ )
	{
		player_has_weapon = false;

		if ( !isDefined( weapon_spawns[i].zombie_weapon_upgrade ) )
		{
			continue;
		}

		for ( h = 0; h < weapons.size; h++ )
		{
			if ( weapons[h] == weapon_spawns[i].zombie_weapon_upgrade )
			{
				player_has_weapon = true;
			}
		}

		is_grenade = ( WeaponType( weapon_spawns[i].zombie_weapon_upgrade ) == "grenade" );

		if ( !player_has_weapon || is_grenade )
		{
			func = GetFunction( "maps/_zombiemode_weapons", "get_weapon_cost" );

			if ( self.score < [[func]]( weapon_spawns[i].zombie_weapon_upgrade ) )
			{
				continue;
			}
		}
		else
		{
			func = GetFunction( "maps/_zombiemode_weapons", "get_ammo_cost" );

			if ( self.score < [[func]]( weapon_spawns[i].zombie_weapon_upgrade ) )
			{
				continue;
			}
		}

		model = getEnt( weapon_spawns[ i ].target, "targetname" );

		if ( !isDefined( model ) )
		{
			continue;
		}

		org = self getOffset( model, weapon_spawns[ i ] );

		if ( GetPathIsInaccessible( self.origin, org ) )
		{
			continue;
		}

		answer[answer.size] = self CreateFinderObjective( eObj, eObj.sName + "_" + weapon_spawns[i] GetEntityNumber(), weapon_spawns[i], self Priority( eObj, weapon_spawns[i] ) );
	}

	return answer;
}

getOffset( model, weapon )
{
	org = model get_angle_offset_node( 40, ( 0, -90, 0 ), ( 0, 0, 1 ) );

	test_org = ( org[0], org[1], weapon.origin[2] );

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
	base_priority += ClampLerp( get_path_dist( self.origin, eEnt.origin ), 0, 800, 2, -2 );

	if ( self HasBotObjective() )
	{
		base_priority -= 1;
	}

	if ( eEnt.zombie_weapon_upgrade == "zombie_kar98k" )
	{
		base_priority -= 99;
	}

	return base_priority;
}

Executer( eObj )
{
	self endon( "disconnect" );
	self endon( "zombified" );

	weapon = eObj.eEnt;

	self thread WatchForCancel( weapon );

	self GoDoWallweapon( eObj );

	self WatchForCancelCleanup();
	self ClearScriptAimPos();
	self ClearScriptGoal();
	self CompletedObjective( eObj.bWasSuccessful, eObj.sReason );
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

		if ( self IsTouching( weapon ) || weapon PointInsideUseTrigger( self.origin ) )
		{
			self notify( "goal" );
			break; // is this needed?
		}
	}
}

GoDoWallweapon( eObj )
{
	self endon( "cancel_bot_objective" );

	weapon = eObj.eEnt;
	model = getEnt( weapon.target, "targetname" );
	org = self getOffset( model, weapon );

	// go to weapon
	self thread WatchToGoToWeapon( weapon );
	self SetScriptGoal( org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		eObj.sReason = "didn't go to weapon";
		return;
	}

	if ( !self IsTouching( weapon ) && !weapon PointInsideUseTrigger( self.origin ) )
	{
		eObj.sReason = "not touching weapon";
		return;
	}

	// ok we are touching weapon, lets look at it
	self SetScriptAimPos( weapon.origin );

	// wait to look at it
	wait 1;

	// press use
	self thread BotPressUse( 0.15 );
	wait 0.1;

	eObj.sReason = "completed";
	eObj.bWasSuccessful = true;
}
