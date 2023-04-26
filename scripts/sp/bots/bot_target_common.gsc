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

set_target_for_bot( target_group, id )
{
	possible_targets = level.zbot_target_glob[ primary_target_group ].active_targets;

	target = possible_targets[ "targ_id_" + id ];

	target_exists = isDefined( primary_target );

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

	target.damaged_by = undefined;
	target.targeted_by = undefined;

	target = undefined;
}