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

	ents = getentarray( "script_model", "classname" );

	for ( i = 0; i < ents.size; i++ )
	{
		// not a powerup script_model
		if ( !isdefined( ents[i].powerup_name ) )
		{
			continue;
		}

		// can we path to it?
		if ( GetPathIsInaccessible( self.origin, ents[i].origin ) )
		{
			continue;
		}

		// make sure we are the only one going for it
		if ( self GetBotsAmountForEntity( ents[i] ) >= 1 )
		{
			continue;
		}

		answer[answer.size] = self CreateFinderObjectiveEZ( eObj, ents[i] );
	}

	return answer;
}

Priority( eObj, eEnt )
{
	// TODO: check powerup type
	base_priority = 0;
	base_priority += ClampLerp( get_path_dist( self.origin, eEnt.origin ), 300, 700, 2, -2 );

	if ( self HasBotObjective() && self GetBotObjectiveEnt() != eEnt )
	{
		base_priority -= 1;
	}

	return base_priority;
}

Executer( eObj )
{
	self endon( "disconnect" );
	self endon( "zombified" );

	powerup = eObj.eent;
	org = powerup.origin;

	self thread IncrementBotsForEntity( powerup );
	self thread WatchForCancel( powerup );

	self GoDoPowerup( eObj );

	self WatchForCancelCleanup();
	self DecrementBotsForEntity( powerup );
	self ClearScriptGoal();

	if ( distance( org, self.origin ) <= 64 )
	{
		eObj.sreason = "completed";
		eObj.bwassuccessful = true;
	}

	self CompletedObjective( eObj.bwassuccessful, eObj.sreason );
}

WatchForCancelCleanup()
{
	self notify( "WatchForCancelPowerup" );
}

WatchForCancel( powerup )
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "WatchForCancelPowerup" );

	for ( ;; )
	{
		wait 0.05;

		if ( self inLastStand() )
		{
			self CancelObjective( "self inLastStand()" );
			break;
		}

		if ( !isdefined( powerup ) )
		{
			self CancelObjective( "!isdefined( powerup )" );
			break;
		}
	}
}

GoDoPowerup( eObj )
{
	self endon( "cancel_bot_objective" );

	powerup = eObj.eent;

	// go to it
	self SetScriptGoal( powerup.origin, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		eObj.sreason = "didn't go to powerup";
		return;
	}

	if ( !isdefined( powerup ) || !isdefined( powerup.origin ) )
	{
		return;
	}

	if ( distance( powerup.origin, self.origin ) > 64 )
	{
		eObj.sreason = "not touching it";
		return;
	}

	eObj.sreason = "completed";
	eObj.bwassuccessful = true;
}
