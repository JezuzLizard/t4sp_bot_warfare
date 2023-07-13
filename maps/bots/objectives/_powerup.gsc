#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\objectives\_utility;

Finder( eObj )
{
	answer = [];
	ents = getentarray( "script_model", "classname" );

	if ( self inLastStand() )
	{
		return Answer;
	}

	for ( i = 0; i < ents.size; i++ )
	{
		if ( !isDefined( ents[i].powerup_name ) )
		{
			continue;
		}

		if ( GetPathIsInaccessible( self.origin, ents[i].origin ) )
		{
			continue;
		}

		if ( self GetBotsAmountForEntity( ents[i] ) >= 1 )
		{
			continue;
		}

		answer[answer.size] = self CreateFinderObjective( eObj, eObj.sName + "_" + ents[i] GetEntityNumber(), ents[i], self Priority( eObj, ents[i] ) );
	}

	return answer;
}

Priority( eObj, eEnt )
{
	// TODO: check powerup type
	base_priority = 0;
	base_priority += ClampLerp( Distance( self.origin, eEnt.origin ), 300, 700, 2, -2 );

	if ( self HasBotObjective() )
	{
		base_priority -= 1;
	}

	return base_priority;
}

Executer( eObj )
{
	self endon( "disconnect" );
	self endon( "zombified" );

	powerup = eObj.eEnt;

	self thread IncrementBotsForEntity( powerup );
	self thread WatchForCancel( powerup );

	self GoDoPowerup( eObj );

	self WatchForCancelCleanup();
	self DecrementBotsForEntity( powerup );
	self ClearScriptGoal();

	self CompletedObjective( eObj.bWasSuccessful, eObj.sReason );
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

	powerup = eObj.eEnt;

	// go to it
	self SetScriptGoal( powerup.origin, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		eObj.sReason = "didn't go to powerup";
		return;
	}

	if ( distance( powerup.origin, self.origin ) > 64 )
	{
		eObj.sReason = "not touching it";
		return;
	}

	eObj.sReason = "completed";
	eObj.bWasSuccessful = true;
}
