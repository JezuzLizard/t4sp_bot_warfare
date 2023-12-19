#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;

CreateObjectiveForManger( sName, fpFinder, fpPriorty, fpExecuter, iProcessRate )
{
	Answer = spawnstruct();

	Answer.sname = sName;
	Answer.fpfinder = fpFinder;
	Answer.fpexecuter = fpExecuter;
	Answer.fppriorty = fpPriorty;

	Answer.abotprocesstimes = [];
	Answer.iprocessrate = iProcessRate;

	return Answer;
}

CreateFinderObjectiveEZ( eObj, eEnt )
{
	return self CreateFinderObjective( eObj, eObj.sname + "_" + eEnt getentitynumber(), eEnt, self [[eObj.fppriorty]]( eObj, eEnt ) );
}

CreateFinderObjective( eObj, sName, eEnt, fPriority )
{
	Answer = spawnstruct();

	Answer.eparentobj = eObj;
	Answer.sname = sName;
	Answer.eent = eEnt;
	Answer.fpriority = fPriority;
	Answer.guid = eEnt getentitynumber();

	Answer.bwassuccessful = false;
	Answer.sreason = "canceled";

	return Answer;
}

GetBotsAmountForEntity( eEnt )
{
	if ( !isdefined( eEnt.bots ) )
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

	if ( isdefined( eEnt ) )
	{
		eEnt.bots--;
	}
}

DecrementBotsForEntity( eEnt )
{
	self notify( "bots_for_entity_cleanup" );

	if ( isdefined( eEnt ) )
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

	return self GetBotObjective().eent;
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
	return isdefined( self GetBotObjective() );
}
