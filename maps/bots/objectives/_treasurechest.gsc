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
	
	weapons = self getweaponslist();
	
	// TODO check if need a new weapon, rate weapons too is better then current etc
	chests = level.chests;
	
	if ( !isdefined( chests ) )
	{
		chests = getentarray( "treasure_chest_use", "targetname" );
	}
	
	if ( !isdefined( chests ) || chests.size <= 0 )
	{
		return answer;
	}
	
	for ( i = 0; i < chests.size; i ++ )
	{
		chest = chests[ i ];
		
		// not active chest
		if ( isdefined( chest.disabled ) && chest.disabled )
		{
			continue;
		}
		
		// box is waiting for someone to grab weapon
		if ( isdefined( chest.grab_weapon_hint ) && chest.grab_weapon_hint )
		{
			continue;
		}
		
		cost = 950;
		
		if ( isdefined( level.zombie_treasure_chest_cost ) )
		{
			cost = level.zombie_treasure_chest_cost;
		}
		else if ( isdefined( chest.zombie_cost ) )
		{
			cost = chest.zombie_cost;
		}
		
		// check cost
		if ( self.score < cost )
		{
			continue;
		}
		
		lid = getent( chest.target, "targetname" );
		
		if ( !isdefined( lid ) )
		{
			continue;
		}
		
		weapon_spawn_org = getent( lid.target, "targetname" );
		
		if ( !isdefined( weapon_spawn_org ) )
		{
			continue;
		}
		
		org = self getOffset( lid );
		
		if ( GetPathIsInaccessible( self.origin, org ) )
		{
			continue;
		}
		
		answer[ answer.size ] = self CreateFinderObjectiveEZ( eObj, chest );
	}
	
	return answer;
}

getOffset( model )
{
	org = model get_angle_offset_node( 52, ( 0, 90, 0 ), ( 0, 0, 1 ) );
	
	return org;
}

Priority( eObj, eEnt )
{
	base_priority = 1;
	base_priority += ClampLerp( get_path_dist( self.origin, eEnt.origin ), 600, 1800, 2, 0 );
	
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
	
	chest = eObj.eent;
	
	self thread WatchForCancel( chest );
	
	self GoDoTreasureChest( eObj );
	
	self WatchForCancelCleanup();
	self ClearScriptAimPos();
	self ClearScriptGoal();
	self ClearPriorityObjective();
	
	self CompletedObjective( eObj.bwassuccessful, eObj.sreason );
}

WatchForCancelCleanup()
{
	self notify( "WatchForCancelTreasurechest" );
}

WatchForCancel( chest )
{
	self endon( "disconnect" );
	self endon( "zombified" );
	self endon( "WatchForCancelTreasurechest" );
	
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

WatchToGoToChest( chest )
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
		
		if ( self istouching( chest ) || chest PointInsideUseTrigger( self.origin ) )
		{
			self notify( "goal" );
			break; // is this needed?
		}
		
		if ( isdefined( chest.disabled ) && chest.disabled )
		{
			self notify( "bad_path" );
			break; // is this needed?
		}
	}
}

GoDoTreasureChest( eObj )
{
	self endon( "cancel_bot_objective" );
	
	chest = eObj.eent;
	lid = getent( chest.target, "targetname" );
	weapon_spawn_org = getent( lid.target, "targetname" );
	org = self getOffset( lid );
	
	weap = self getcurrentweapon();
	
	if ( weap == "none" || !self getammocount( weap ) )
	{
		self SetPriorityObjective();
	}
	
	// go to box
	self thread WatchToGoToChest( chest );
	self SetScriptGoal( org, 32 );
	
	result = self waittill_any_return( "goal", "bad_path", "new_goal" );
	
	if ( result != "goal" )
	{
		eObj.sreason = "didn't go to chest";
		return;
	}
	
	if ( !self istouching( chest ) && !chest PointInsideUseTrigger( self.origin ) )
	{
		eObj.sreason = "not touching chest";
		return;
	}
	
	// ok we are touching weapon, lets look at it
	self SetScriptAimPos( chest.origin );
	
	// wait to look at it
	wait 1;
	
	// press use
	self thread BotPressUse( 0.15 );
	wait 0.25;
	
	// ok we pressed use, wait for randomization to complete
	self ClearScriptAimPos();
	self ClearPriorityObjective();
	
	// randomization isnt happening...
	if ( !isdefined( chest.disabled ) || !chest.disabled )
	{
		eObj.sreason = "chest isnt randomizing";
		return;
	}
	
	ret = weapon_spawn_org waittill_any_timeout( 5, "randomization_done" );
	
	if ( ret == "timeout" )
	{
		eObj.sreason = "randomization_done timed out";
		return;
	}
	
	if ( isdefined( level.flag[ "moving_chest_now" ] ) && flag( "moving_chest_now" ) )
	{
		eObj.sreason = "chest is moving!";
		return;
	}
	
	waittillframeend;
	weap = weapon_spawn_org.weapon_string;
	// weapon is done cooking, grabit!
	self SetPriorityObjective();
	
	// go to box
	self thread WatchToGoToChest( chest );
	self SetScriptGoal( org, 32 );
	
	result = self waittill_any_return( "goal", "bad_path", "new_goal" );
	
	if ( result != "goal" )
	{
		eObj.sreason = "didn't go to chest";
		return;
	}
	
	if ( !self istouching( chest ) && !chest PointInsideUseTrigger( self.origin ) )
	{
		eObj.sreason = "not touching chest";
		return;
	}
	
	// ok we are touching weapon, lets look at it
	self SetScriptAimPos( chest.origin );
	
	// wait to look at it
	wait 1;
	
	// press use
	self thread BotPressUse( 0.15 );
	wait 0.1;
	
	// complete!
	eObj.sreason = "completed " + weap;
	eObj.bwassuccessful = true;
}
