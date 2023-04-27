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
	target_struct.id = id;
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
target_loop()
{
	myEye = self GetEyePos();
	theTime = getTime();
	myAngles = self GetPlayerAngles();
	myFov = self.pers["bots"]["skill"]["fov"];
	bestTargets = [];
	bestTime = 2147483647;
	rememberTime = self.pers["bots"]["skill"]["remember_time"];
	initReactTime = self.pers["bots"]["skill"]["init_react_time"];
	hasTarget = isDefined( self.bot.target );
	adsAmount = self PlayerADS();
	adsFovFact = self.pers["bots"]["skill"]["ads_fov_multi"];

	if ( hasTarget && !isDefined( self.bot.target.entity ) )
	{
		self.bot.target = undefined;
		hasTarget = false;
	}

	// reduce fov if ads'ing
	if ( adsAmount > 0 )
	{
		myFov *= 1 - adsFovFact * adsAmount;
	}

	playercount = level.players.size;

	for ( i = -1; i < playercount; i++ )
	{
		obj = undefined;

		if ( i == -1 )
		{
			if ( !isDefined( self.bot.script_target ) )
				continue;

			ent = self.bot.script_target;
			key = ent getEntityNumber() + "";
			daDist = distanceSquared( self.origin, ent.origin );
			obj = self.bot.targets[key];
			isObjDef = isDefined( obj );
			entOrigin = ent.origin;

			if ( isDefined( self.bot.script_target_offset ) )
				entOrigin += self.bot.script_target_offset;

			if ( SmokeTrace( myEye, entOrigin, level.smokeRadius ) && bulletTracePassed( myEye, entOrigin, false, ent ) )
			{
				if ( !isObjDef )
				{
					obj = self createTargetObj( ent, theTime );
					obj.offset = self.bot.script_target_offset;

					self.bot.targets[key] = obj;
				}

				self targetObjUpdateTraced( obj, daDist, ent, theTime, true );
			}
			else
			{
				if ( !isObjDef )
					continue;

				self targetObjUpdateNoTrace( obj );

				if ( obj.no_trace_time > rememberTime )
				{
					self.bot.targets[key] = undefined;
					continue;
				}
			}
		}
		else
		{
			player = level.players[i];

			if ( !player IsPlayerModelOK() )
				continue;

			if ( player == self )
				continue;

			key = player getEntityNumber() + "";
			obj = self.bot.targets[key];
			daDist = distanceSquared( self.origin, player.origin );
			isObjDef = isDefined( obj );

			if ( ( level.teamBased && self.team == player.team ) || player.sessionstate != "playing" || !isAlive( player ) )
			{
				if ( isObjDef )
					self.bot.targets[key] = undefined;

				continue;
			}

			targetHead = player getTagOrigin( "j_head" );
			targetAnkleLeft = player getTagOrigin( "j_ankle_le" );
			targetAnkleRight = player getTagOrigin( "j_ankle_ri" );

			traceHead = bulletTrace( myEye, targetHead, false, undefined );
			traceAnkleLeft = bulletTrace( myEye, targetAnkleLeft, false, undefined );
			traceAnkleRight = bulletTrace( myEye, targetAnkleRight, false, undefined );

			canTargetPlayer = ( ( sightTracePassed( myEye, targetHead, false, undefined ) ||
			            sightTracePassed( myEye, targetAnkleLeft, false, undefined ) ||
			            sightTracePassed( myEye, targetAnkleRight, false, undefined ) )

			        && ( ( traceHead["fraction"] >= 1.0 || traceHead["surfacetype"] == "glass" ) ||
			            ( traceAnkleLeft["fraction"] >= 1.0 || traceAnkleLeft["surfacetype"] == "glass" ) ||
			            ( traceAnkleRight["fraction"] >= 1.0 || traceAnkleRight["surfacetype"] == "glass" ) )

			        && ( SmokeTrace( myEye, player.origin, level.smokeRadius ) ||
			            daDist < level.bots_maxKnifeDistance * 4 )

			        && ( getConeDot( player.origin, self.origin, myAngles ) >= myFov ||
			            ( isObjDef && obj.trace_time ) ) );

			if ( isDefined( self.bot.target_this_frame ) && self.bot.target_this_frame == player )
			{
				self.bot.target_this_frame = undefined;

				canTargetPlayer = true;
			}

			if ( canTargetPlayer )
			{
				if ( !isObjDef )
				{
					obj = self createTargetObj( player, theTime );

					self.bot.targets[key] = obj;
				}

				self targetObjUpdateTraced( obj, daDist, player, theTime, false );
			}
			else
			{
				if ( !isObjDef )
					continue;

				self targetObjUpdateNoTrace( obj );

				if ( obj.no_trace_time > rememberTime )
				{
					self.bot.targets[key] = undefined;
					continue;
				}
			}
		}

		if ( !isdefined( obj ) )
			continue;

		if ( theTime - obj.time < initReactTime )
			continue;

		timeDiff = theTime - obj.trace_time_time;

		if ( timeDiff < bestTime )
		{
			bestTargets = [];
			bestTime = timeDiff;
		}

		if ( timeDiff == bestTime )
			bestTargets[key] = obj;
	}

	if ( hasTarget && isDefined( bestTargets[self.bot.target.entity getEntityNumber() + ""] ) )
		return;

	closest = 2147483647;
	toBeTarget = undefined;

	bestKeys = getArrayKeys( bestTargets );

	for ( i = bestKeys.size - 1; i >= 0; i-- )
	{
		theDist = bestTargets[bestKeys[i]].dist;

		if ( theDist > closest )
			continue;

		closest = theDist;
		toBeTarget = bestTargets[bestKeys[i]];
	}

	beforeTargetID = -1;
	newTargetID = -1;

	if ( hasTarget && isDefined( self.bot.target.entity ) )
		beforeTargetID = self.bot.target.entity getEntityNumber();

	if ( isDefined( toBeTarget ) && isDefined( toBeTarget.entity ) )
		newTargetID = toBeTarget.entity getEntityNumber();

	if ( beforeTargetID != newTargetID )
	{
		self.bot.target = toBeTarget;
		self notify( "new_enemy" );
	}
}