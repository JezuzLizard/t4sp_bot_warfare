#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\objectives\_utility;

init()
{
	level.bot_objectives = [];
	level.bot_objectives[level.bot_objectives.size] = CreateObjectiveForManger( "revive", maps\bots\objectives\_revive::Finder, maps\bots\objectives\_revive::Priority, maps\bots\objectives\_revive::Executer, 1000 );
	level.bot_objectives[level.bot_objectives.size] = CreateObjectiveForManger( "powerup", maps\bots\objectives\_powerup::Finder, maps\bots\objectives\_powerup::Priority, maps\bots\objectives\_powerup::Executer, 2500 );
	level.bot_objectives[level.bot_objectives.size] = CreateObjectiveForManger( "wallweapon", maps\bots\objectives\_wallweapon::Finder, maps\bots\objectives\_wallweapon::Priority, maps\bots\objectives\_wallweapon::Executer, 7500 );
	level.bot_objectives[level.bot_objectives.size] = CreateObjectiveForManger( "treasurechest", maps\bots\objectives\_treasurechest::Finder, maps\bots\objectives\_treasurechest::Priority, maps\bots\objectives\_treasurechest::Executer, 7000 );
}

connected()
{
	self.bot_current_objective = undefined;
}

spawned()
{
	self.bot_current_objective = undefined;

	self thread clean_objective_on_completion();
	self thread watch_for_objective_canceled();
}

watch_for_objective_canceled()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );

	for ( ;; )
	{
		self waittill( "cancel_bot_objective", reason );

		obj_name = "undefined";

		if ( isDefined( self.bot_current_objective ) )
		{
			obj_name = self.bot_current_objective.sName;
		}

		self BotNotifyBotEvent( "debug", "watch_for_objective_canceled: " + obj_name + ": " + reason );
	}
}

clean_objective_on_completion()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );

	for ( ;; )
	{
		self waittill( "completed_bot_objective", successful, reason );

		obj_name = "undefined";

		if ( isDefined( self.bot_current_objective ) )
		{
			obj_name = self.bot_current_objective.sName;

			self.bot_current_objective.eParentObj.aBotProcessTimes[self GetEntityNumber() + ""] = getTime();
		}

		self BotNotifyBotEvent( "debug", "clean_objective_on_completion: " + obj_name + ": " + successful + ": " + reason );

		waittillframeend;
		self.bot_current_objective = undefined;
	}
}

start_bot_threads()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );

	self thread bot_objective_think();
}

bot_objective_think()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );

	for ( ;; )
	{
		wait 1;

		// find all avail objectives
		objectives = [];
		now = getTime();
		our_key = self GetEntityNumber() + "";

		for ( i = 0; i < level.bot_objectives.size; i++ )
		{
			objective = level.bot_objectives[i];

			// check the process rate
			if ( isDefined( objective.aBotProcessTimes[our_key] ) && now - objective.aBotProcessTimes[our_key] < objective.iProcessRate )
			{
				continue;
			}

			objectives = array_merge( objectives, self [[objective.fpFinder]]( objective ) );
			objective.aBotProcessTimes[our_key] = now;
		}

		if ( objectives.size <= 0 )
		{
			continue;
		}

		// sort according to priority
		heap = NewHeap( ::HeapPriority );

		for ( i = 0; i < objectives.size; i++ )
		{
			if ( objectives[i].fPriority <= -100 )
			{
				continue;
			}

			heap HeapInsert( objectives[i] );
		}

		// pop the top!
		best_prio = heap.data[0];

		if ( !isDefined( best_prio ) )
		{
			continue;
		}

		// already on a better obj
		if ( self HasBotObjective() && ( best_prio.GUID == self.bot_current_objective.GUID || best_prio.fPriority < self [[self.bot_current_objective.eParentObj.fpPriorty]]( self.bot_current_objective.eParentObj, self.bot_current_objective.eEnt ) ) )
		{
			continue;
		}

		// DO THE OBJ
		// cancel the old obj
		if ( self HasBotObjective() )
		{
			// cancel it
			self CancelObjective( "new obj: " + best_prio.sName );

			// wait for it to clean up
			self waittill( "completed_bot_objective" );

			// redo the loop, should do the obj next iteration
			best_prio.eParentObj.aBotProcessTimes[our_key] = undefined;
			continue;
		}

		// ready to execute
		self BotNotifyBotEvent( "debug", "bot_objective_think: " + best_prio.sName );

		self.bot_current_objective = best_prio;
		self thread [[best_prio.eParentObj.fpExecuter]]( best_prio );
	}
}
