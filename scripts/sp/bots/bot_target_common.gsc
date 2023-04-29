#include common_scripts\utility;
#include scripts\sp\bots\_bot_utility;

register_bot_target_type( target_group )
{
	if ( !isDefined( level.zbot_target_glob ) )
	{
		level.zbot_target_glob = [];
		level.zbot_target_glob_ids = [];
	}
	if ( !isDefined( level.zbot_target_glob[ target_group ] ) )
	{
		level.zbot_target_glob_ids[ target_group ] = 0;
		level.zbot_target_glob[ target_group ] = spawnStruct();
		level.zbot_target_glob[ target_group ].active_targets = [];
	}
}

add_possible_bot_target( target_group, id, target_ent )
{
	assert( isDefined( level.zbot_target_glob ), "Trying to add target before calling register_bot_target_type" );

	assert( isDefined( level.zbot_target_glob[ target_group ] ), "Trying to add target to group " + target_group + " before calling register_bot_target_type" );

	target_struct = spawnStruct();
	target_struct.group = target_group;
	target_struct.target_id = id;
	target_struct.damaged_by = [];
	target_struct.targeted_by = [];
	target_struct.target_ent = target_ent;
	target_struct.is_target = true;

	level.zbot_target_glob[ target_group ].active_targets[ "targ_id_" + id ] = target_struct;
}

get_bot_target_by_id( target_group, id )
{
	active_targets = level.zbot_target_glob[ target_group ].active_targets;

	target = active_targets[ "targ_id_" + id ];

	assert( isDefined( target ), "Target with " + id + " id does not point to a target in group " + target_group );

	return target;
}

get_all_targets_for_group( target_group )
{
	return level.zbot_target_glob[ target_group ].active_targets;
}

get_all_groups_for_targets()
{
	return getArrayKeys( level.zbot_target_glob );
}

bot_has_target()
{
	return isDefined( self.zbot_current_target );
}

set_target_for_bot( target_group, id )
{
	possible_targets = level.zbot_target_glob[ target_group ].active_targets;

	target = possible_targets[ "targ_id_" + id ];

	target_exists = isDefined( target );

	assert( target_exists, "Target with " + id + " id does not point to a target in group " + target_group );
	if ( !target_exists )
	{
		return;
	}

	self.zbot_current_target = target;

	for ( i = 0; i < target.targeted_by.size; i++ )
	{
		if ( target.targeted_by[ i ] == self )
		{
			return;
		}
	}

	target.targeted_by[ target.targeted_by.size ] = self;
}

clear_target_for_bot( target_group, id )
{
	possible_targets = level.zbot_target_glob[ target_group ].active_targets;

	target = possible_targets[ "targ_id_" + id ];

	target_exists = isDefined( target );

	assert( target_exists, "Target with " + id + " id does not point to a target in group " + target_group );
	if ( !target_exists )
	{
		return;
	}

	for ( i = 0; i < target.targeted_by.size; i++ )
	{
		if ( target.targeted_by[ i ] == self )
		{
			target.targeted_by[ i ] = undefined;
			return;
		}
	}

	self.zbot_current_target = undefined;
}

set_target_damaged_by( target_group, id )
{
	possible_targets = level.zbot_target_glob[ target_group ].active_targets;

	target = possible_targets[ "targ_id_" + id ];

	target_exists = isDefined( target );

	assert( target_exists, "Target with " + id + " id does not point to a target in group " + target_group );
	if ( !target_exists )
	{
		return;
	}

	for ( i = 0; i < target.damaged_by.size; i++ )
	{
		if ( target.damaged_by[ i ] == self )
		{
			return;
		}
	}

	target.damaged_by[ target.damaged_by.size ] = self;
}

clear_target_damaged_by( target_group, id )
{
	possible_targets = level.zbot_target_glob[ target_group ].active_targets;

	target = possible_targets[ "targ_id_" + id ];

	target_exists = isDefined( target );

	assert( target_exists, "Target with " + id + " id does not point to a target in group " + target_group );
	if ( !target_exists )
	{
		return;
	}

	for ( i = 0; i < target.damaged_by.size; i++ )
	{
		if ( target.damaged_by[ i ] == self )
		{
			target.damaged_by[ i ] = undefined;
			return;
		}
	}
}

free_bot_target( target_group, id )
{
	active_targets = level.zbot_global_shared_target_glob[ target_group ].active_targets;

	target = active_targets[ "targ_id_" + id ];

	target_exists = isDefined( target );

	assert( target_exists, "Target with " + id + " id number does not point to a target in group " + target_group );
	if ( !target_exists )
	{
		return;
	}

	players = getPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ].pers[ "isBot" ] )
		{
			if ( players[ i ].zbot_current_target == target )
			{
				players[ i ].zbot_current_target = undefined;
			}
		}
	}

	target.damaged_by = undefined;
	target.targeted_by = undefined;

	target = undefined;
}

/*
	The main target thread, will update the bot's main target. Will auto target enemy players and handle script targets.
*/
/*
bot_pick_target()
{
	myEye = self GetEyePos();
	myAngles = self GetPlayerAngles();
	myFov = 90;
	hasTarget = self bot_has_target();
	adsAmount = self PlayerADS();
	adsFovFact = 1;

	// reduce fov if ads'ing
	if ( adsAmount > 0 )
	{
		myFov *= 1 - adsFovFact * adsAmount;
	}

	groups = get_all_groups_for_targets();

	ents = [];
	for ( i = 0; i < groups.size; i++ )
	{
		targets = level.zbot_target_glob[ groups[ i ] ].active_targets;
		for ( j = 0; j < targets; j++ )
		{
			ents[ ents.size ] = targets[ j ].target_ent;
		}
	}

	ents = get_array_of_closest( self.origin, ents );

	for ( i = 0; i < ents.size; i++ )
	{
		ent = ents[ i ];
		targetHead = ent getTagOrigin( "j_head" );
		targetAnkleLeft = ent getTagOrigin( "j_ankle_le" );
		targetAnkleRight = ent getTagOrigin( "j_ankle_ri" );

		traceHead = bulletTrace( myEye, targetHead, false, undefined );
		traceAnkleLeft = bulletTrace( myEye, targetAnkleLeft, false, undefined );
		traceAnkleRight = bulletTrace( myEye, targetAnkleRight, false, undefined );

		canTargetEnt = ( ( sightTracePassed( myEye, targetHead, false, undefined ) ||
							  sightTracePassed( myEye, targetAnkleLeft, false, undefined ) ||
							  sightTracePassed( myEye, targetAnkleRight, false, undefined ) )

							&& ( traceHead["fraction"] >= 1.0 ||
								 traceAnkleLeft["fraction"] >= 1.0 ||
								 traceAnkleRight["fraction"] >= 1.0 )

							&& ( getConeDot( ent.origin, self.origin, myAngles ) >= myFov ||
								( isObjDef && obj.trace_time ) ) );
		if ( canTargetEnt )
		{
			self set_target_for_bot( ent.targetname, ent.target_id );
			break;
		}
	}
}
*/