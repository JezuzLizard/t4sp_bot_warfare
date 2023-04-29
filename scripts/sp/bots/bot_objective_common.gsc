register_bot_objective( objective_group )
{
	if ( !isDefined( level.zbot_objective_glob ) )
	{
		level.zbot_objective_glob = [];
	}
	if ( !isDefined( level.zbot_objective_glob[ objective_group ] ) )
	{
		level.zbot_objective_glob[ objective_group ] = spawnStruct();
		level.zbot_objective_glob[ objective_group ].active_objectives = [];
	}
}

add_possible_bot_objective( objective_group, id, is_global_shared, target_ent )
{
	assert( isDefined( level.zbot_objective_glob ), "Trying to add objective before calling register_bot_objective" );

	assert( isDefined( level.zbot_objective_glob[ objective_group ] ), "Trying to add objective to group " + objective_group + " before calling register_bot_objective" );

	objective_struct = spawnStruct();
	objective_struct.group = objective_group;
	objective_struct.id = id;
	objective_struct.is_global_shared = is_global_shared;
	objective_struct.target_ent = target_ent;
	objective_struct.owner = undefined;
	objective_struct.is_objective = true;

	level.zbot_objective_glob[ objective_group ].active_objectives[ "obj_id_" + id ] = objective_struct;
}

get_bot_objective_by_id( objective_group, id )
{
	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	assert( isDefined( objective ), "Objective with " + id + " id does not point to a objective in group " + objective_group );

	return objective;
}

get_all_objectives_for_group( objective_group )
{
	return level.zbot_objective_glob[ objective_group ].active_objectives;
}

set_objective_for_bot( objective_group, id )
{
	possible_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = possible_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );

	assert( objective_exists, "Objective with " + id + " id does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	self.zbot_current_objective = objective;
}

clear_objective_for_bot()
{
	self.zbot_current_objective = undefined;
}

set_bot_objective_blocked_by_objective( primary_objective_group, primary_id, blocked_by_objective_group, blocked_by_id )
{
	primary_active_objectives = level.zbot_objective_glob[ primary_objective_group ].active_objectives;

	primary_objective = primary_active_objectives[ "obj_id_" + primary_id ];

	primary_objective_exists = isDefined( primary_objective );

	assert( primary_objective_exists, "Objective with " + primary_id + " id does not point to a objective in group " + primary_objective_group );
	if ( !primary_objective_exists )
	{
		return;
	}
	if ( primary_objective_group == blocked_by_objective_group )
	{
		assert( primary_id != blocked_by_id, "Objective with " + primary_id + " id should not be the same as the blocked_by_id if the objectives are in the same group of " + primary_objective_group );
		if ( primary_id == blocked_by_id )
		{
			return;
		}

		blocking_objective = primary_active_objectives[ "obj_id_" + blocked_by_id ];

		blocking_objective_exists = isDefined( blocking_objective );

		assert( blocking_objective_exists, "Objective with " + blocked_by_id + " id does not point to a objective in group " + blocked_by_objective_group );
		if ( !blocking_objective_exists )
		{
			return;
		}

		primary_objective.blocking_objective = blocking_objective;
	}
	else 
	{
		secondary_active_objectives = level.zbot_objective_glob[ blocked_by_objective_group ].active_objectives;

		blocking_objective = secondary_active_objectives[ "obj_id_" + blocked_by_id ];

		blocking_objective_exists = isDefined( blocking_objective );

		assert( blocking_objective_exists, "Objective with " + blocked_by_id + " id does not point to a objective in group " + blocked_by_objective_group );
		if ( !blocking_objective_exists )
		{
			return;
		}

		primary_objective.blocking_objective = blocking_objective;
	}
}

set_bot_global_shared_objective_owner_by_id( objective_group, id, new_owner )
{
	active_objectives = level.zbot_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	assert( objective_exists, "Objective with " + id + " id number does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	assert( objective.is_global_shared, "Objective with " + id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
	if ( !objective.is_global_shared )
	{
		return;
	}

	objective.owner = new_owner;
}

set_bot_global_shared_objective_owner_by_reference( objective_group, objective, new_owner )
{
	is_objective = isDefined( objective.is_objective );
	assert( is_objective, "Objective arg is not a valid objective object" );
	if ( !is_objective )
	{
		return;
	}
	assert( objective.is_global_shared, "Objective with " + objective.id + " id number cannot be set to have an owner because is_global_shared field is false in group " + objective_group );
	if ( !objective.is_global_shared )
	{
		return;
	}

	objective.owner = new_owner;
}

free_bot_objective( objective_group, id )
{
	active_objectives = level.zbot_global_shared_objective_glob[ objective_group ].active_objectives;

	objective = active_objectives[ "obj_id_" + id ];

	objective_exists = isDefined( objective );
	assert( objective_exists, "Objective with " + id + " id number does not point to a objective in group " + objective_group );
	if ( !objective_exists )
	{
		return;
	}

	players = getPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ].pers[ "isBot" ] )
		{
			if ( players[ i ].zbot_current_objective == objective )
			{
				players[ i ].zbot_current_objective = undefined;
			}
		}
	}

	objective = undefined;
}