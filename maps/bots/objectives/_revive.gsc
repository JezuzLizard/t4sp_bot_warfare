#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\objectives\_utility;

Finder( eObj )
{
	Players = get_players();
	Answer = [];

	if ( self inLastStand() )
	{
		return Answer;
	}

	for ( i = 0; i < Players.size; i++ )
	{
		Player = Players[i];

		if ( !IsDefined( Player ) || !IsDefined( Player.team ) )
		{
			continue;
		}

		if ( Player == self )
		{
			continue;
		}

		if ( Player.sessionstate != "playing" )
		{
			continue;
		}

		if ( !Player inLastStand() || Player.revivetrigger.beingrevived )
		{
			continue;
		}

		if ( GetPathIsInaccessible( self.origin, Player.origin ) )
		{
			continue;
		}

		if ( self GetBotsAmountForEntity( Player ) >= 1 )
		{
			continue;
		}

		Answer[Answer.size] = self CreateFinderObjective( eObj, eObj.sName + "_" + Player GetEntityNumber(), Player, self [[eObj.fpPriority]]( eObj, Player ) );
	}

	return Answer;
}

Priority( eObj, eEnt )
{
	base_priority = 3;
	base_priority += ClampLerp( Distance( self.origin, eEnt.origin ), 500, 1200, 2, -2 );

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

	revivee = eObj.eEnt;

	self thread IncrementBotsForEntity( revivee );
	self thread WatchForCancelRevive( revivee );

	self GoDoRevive( eObj );

	self WatchForCancelReviveCleanup();
	self DecrementBotsForEntity( revivee );
	self ClearScriptAimPos();
	self ClearScriptGoal();
	self ClearPriorityObjective();

	self CompletedObjective( eObj.bWasSuccessful, eObj.sReason );
}

WatchForCancelReviveCleanup()
{
	self notify( "WatchForCancelRevive" );
}

WatchForCancelRevive( revivee )
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "WatchForCancelRevive" );

	for ( ;; )
	{
		wait 0.05;

		if ( self inLastStand() )
		{
			self CancelObjective( "self inLastStand()" );
			break;
		}

		if ( !isdefined( revivee ) || !revivee inLastStand() )
		{
			self CancelObjective( "!isdefined( revivee ) || !revivee inLastStand()" );
			break;
		}

		if ( revivee.revivetrigger.beingrevived && !self maps\_laststand::is_reviving( revivee ) )
		{
			self CancelObjective( "revivee.revivetrigger.beingrevived && !self maps\_laststand::is_reviving( revivee )" );
			break;
		}
	}
}

WatchToGoToGuy( revivee )
{
	self endon( "cancel_bot_objective" );
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "goal" );
	self endon( "bad_path" );
	self endon( "new_goal" );

	for ( ;; )
	{
		wait 1;

		if ( self IsTouching( revivee.revivetrigger ) )
		{
			self notify( "goal" );
			break; // is this needed?
		}
	}
}

WatchForSuccessRevive( eObj )
{
	self endon( "disconnect" );
	self endon( "zombified" );

	revivee = eObj.eEnt;

	ret = self waittill_either_return( "cancel_bot_objective", "completed_bot_objective" );

	if ( ret == "cancel_bot_objective" && isDefined( revivee ) && !revivee inLastStand() )
	{
		eObj.bWasSuccessful = true;
		eObj.sReason = "revived him!";
	}
}

GoDoRevive( eObj )
{
	self endon( "cancel_bot_objective" );

	revivee = eObj.eEnt;

	// go to guy
	self thread WatchToGoToGuy( revivee );
	self SetPriorityObjective();
	self SetScriptGoal( revivee.origin, 32 );

	result = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( result != "goal" )
	{
		eObj.sReason = "didn't go to guy";
		return;
	}

	if ( !self IsTouching( revivee.revivetrigger ) )
	{
		eObj.sReason = "not touching guy";
		return;
	}

	// ok we are touching guy, lets look at him
	self SetScriptAimPos( revivee.origin );

	// now lets hold use until he is up or otherwise
	self thread WatchForSuccessRevive( eObj );

	while ( self IsTouching( revivee.revivetrigger ) )
	{
		self thread BotPressUse( 0.15 );

		wait 0.1;
	}

	eObj.sReason = "not touching guy";
}
