#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;

CreateObjectiveForManger( sName, fpFinder, fpPriorty, fpExecuter, iProcessRate )
{
	Answer = SpawnStruct();

	Answer.sName = sName;
	Answer.fpFinder = fpFinder;
	Answer.fpExecuter = fpExecuter;
	Answer.fpPriorty = fpPriorty;

	Answer.aBotProcessTimes = [];
	Answer.iProcessRate = iProcessRate;

	return Answer;
}

CreateFinderObjectiveEZ( eObj, eEnt )
{
	return self CreateFinderObjective( eObj, eObj.sName + "_" + eEnt GetEntityNumber(), eEnt, self [[eObj.fpPriorty]]( eObj, eEnt ) );
}

CreateFinderObjective( eObj, sName, eEnt, fPriority )
{
	Answer = SpawnStruct();

	Answer.eParentObj = eObj;
	Answer.sName = sName;
	Answer.eEnt = eEnt;
	Answer.fPriority = fPriority;
	Answer.GUID = eEnt GetEntityNumber();

	Answer.bWasSuccessful = false;
	Answer.sReason = "canceled";

	return Answer;
}

GetBotsAmountForEntity( eEnt )
{
	if ( !isDefined( eEnt.bots ) )
	{
		eEnt.bots = 0;
	}

	return eEnt.bots;
}

IncrementBotsForEntity( eEnt )
{
	self endon( "bots_for_entity_cleanup" );

	eEnt.bots++;

	self waittill_either( "disconnect", "zombified" );

	if ( isDefined( eEnt ) )
	{
		eEnt.bots--;
	}
}

DecrementBotsForEntity( eEnt )
{
	self notify( "bots_for_entity_cleanup" );

	if ( isDefined( eEnt ) )
	{
		eEnt.bots--;
	}
}

CleanupBotsForEntity( eEnt )
{
	self notify( "bots_for_entity_cleanup" );
}

CancelObjective( reason )
{
	self notify( "cancel_bot_objective", reason );
}

CompletedObjective( successful, reason )
{
	self notify( "completed_bot_objective", successful, reason );
}

GetBotObjectiveEnt()
{
	if ( !self HasBotObjective() )
	{
		return undefined;
	}

	return self GetBotObjective().eEnt;
}

/*
	Gets bot objective
*/
GetBotObjective()
{
	return self.bot_current_objective;
}

/*
	Does the bot have an objective?
*/
HasBotObjective()
{
	return isDefined( self GetBotObjective() );
}
