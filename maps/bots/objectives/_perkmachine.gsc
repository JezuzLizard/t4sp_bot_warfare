#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\objectives\_utility;

init()
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	if ( !isDefined( vending_triggers ) || vending_triggers.size < 1 )
	{
		vending_triggers = getEntArray( "harrybo21_perk_trigger", "targetname" );

		if ( !isDefined( vending_triggers ) || vending_triggers.size < 1 )
		{
			return;
		}
	}

	for ( i = 0 ; i < vending_triggers.size; i++ )
	{
		vending_triggers[i] thread init_vending_trigger();
	}
}

init_vending_trigger()
{
	self endon( "death" );

	if ( self.targetname == "harrybo21_perk_trigger" )
	{
		machine = self getMachine();

		machine waittill( "activate_machine" );

		self.bot_powered_on = true;
	}
	else
	{
		perk = self getVendingPerk();
		notify_name = perk + "_power_on";

		level waittill( notify_name );

		self.bot_powered_on = true;
	}
}

Finder( eObj )
{
	answer = [];

	if ( self inLastStand() )
	{
		return answer;
	}

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	if ( !isDefined( vending_triggers ) || vending_triggers.size < 1 )
	{
		vending_triggers = getEntArray( "harrybo21_perk_trigger", "targetname" );

		if ( !isDefined( vending_triggers ) || vending_triggers.size < 1 )
		{
			return answer;
		}
	}

	for ( i = 0 ; i < vending_triggers.size; i++ )
	{
		vending = vending_triggers[i];

		if ( !isdefined( vending.bot_powered_on ) || !vending.bot_powered_on )
		{
			continue;
		}

		perk = vending getVendingPerk();
		cost = vending getPerkCost();

		if ( self.score < cost )
		{
			continue;
		}

		// perk limit??
		if ( self HasPerk( perk ) )
		{
			continue;
		}

		machine = vending getMachine();

		if ( !isDefined( machine ) )
		{
			continue;
		}

		org = self getOffset( machine );

		if ( GetPathIsInaccessible( self.origin, org ) )
		{
			continue;
		}

		answer[answer.size] = self CreateFinderObjective( eObj, eObj.sName + "_" + vending GetEntityNumber(), vending, self [[eObj.fpPriorty]]( eObj, vending ) );
	}

	return answer;
}

getMachine()
{
	return GetEnt( self.target, "targetname" );
}

getVendingPerk()
{
	if ( self.targetname == "harrybo21_perk_trigger" )
	{
		machine = self getMachine();
		return machine.script_string;
	}

	return self.script_noteworthy;
}

getPerkCost()
{
	if ( self.targetname == "harrybo21_perk_trigger" )
	{
		return level.zombie_perks[self getVendingPerk()].perk_cost;
	}

	cost = level.zombie_vars["zombie_perk_cost"];

	switch ( self getVendingPerk() )
	{
		case "specialty_armorvest":
			cost = 2500;
			break;

		case "specialty_quickrevive":
			cost = 1500;
			break;

		case "specialty_fastreload":
			cost = 3000;
			break;

		case "specialty_rof":
			cost = 2000;
			break;

		default:
			cost = 10000;
			break;
	}

	return cost;
}

getOffset( model )
{
	org = model get_angle_offset_node( 40, ( 0, -90, 0 ), ( 0, 0, 1 ) );

	return org;
}

Priority( eObj, eEnt )
{
	// TODO rank perks
	base_priority = 2;
	base_priority += ClampLerp( get_path_dist( self.origin, eEnt.origin ), 500, 1600, 3, 0 );

	if ( self HasBotObjective() && self.bot_current_objective.eEnt != eEnt )
	{
		base_priority -= 1;
	}

	return base_priority;
}

Executer( eObj )
{
	self endon( "disconnect" );
	self endon( "zombified" );

	vending = eObj.eEnt;

	self thread WatchForCancel( vending );

	self GoDoPerkMachine( eObj );

	self WatchForCancelCleanup();
	self ClearScriptAimPos();
	self ClearScriptGoal();

	self CompletedObjective( eObj.bWasSuccessful, eObj.sReason );
}

WatchForCancelCleanup()
{
	self notify( "WatchForCancelPerkmachine" );
}

WatchForCancel( vending )
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "WatchForCancelPerkmachine" );

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

WatchToGoToMachine( vending )
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

		if ( self IsTouching( vending ) || vending PointInsideUseTrigger( self.origin ) )
		{
			self notify( "goal" );
			break; // is this needed?
		}
	}
}

GoDoPerkMachine( eObj )
{
	self endon( "cancel_bot_objective" );

	vending = eObj.eEnt;
	machine = vending getMachine();
	perk = vending getVendingPerk();
	org = self getOffset( machine );

	// go to machine
	self thread WatchToGoToMachine( vending );
	self SetScriptGoal( org, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		eObj.sReason = "didn't go to machine";
		return;
	}

	if ( !self IsTouching( vending ) && !vending PointInsideUseTrigger( self.origin ) )
	{
		eObj.sReason = "not touching machine";
		return;
	}

	// ok we are touching machine, lets look at it
	self SetScriptAimPos( vending.origin );

	// wait to look at it
	wait 1;

	// press use
	self thread BotPressUse( 0.15 );
	wait 0.1;

	// ok we pressed use, DONE
	eObj.sReason = "completed " + perk;
	eObj.bWasSuccessful = true;
}
