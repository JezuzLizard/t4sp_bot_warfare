bot_movetoobjective()
{
	action_id = self.action_queue[ "objective" ][ 0 ].action_id;
	at_obj_distance_sq = 48 * 48;
	while ( isDefined( self.action_queue[ "objective" ][ 0 ] ) && action_id == self.action_queue[ "objective" ][ 0 ].action_id )
	{
		if ( distanceSquared( self.origin, self.target_pos ) < at_obj_distance_sq )
		{
			self bot_set_complete_movetoobjective();
			break;
		}
		wait 0.2;
	}
}

bot_movetoobjective_process_order()
{
	return 0;
}

bot_should_movetoobjective()
{
	if ( isDefined( self.action_queue[ "objective" ][ 0 ] ) )
	{
		return true;
	}
	return false;
}

bot_check_complete_movetoobjective()
{
	return self.successfully_moved_to_objective;
}

bot_set_complete_movetoobjective()
{
	self.successfully_moved_to_objective = true;
}

bot_movetoobjective_on_completion()
{
	self.successfully_moved_to_objective = false;
	self.can_do_objective_now = true;
}

bot_movetoobjective_should_cancel()
{
	return false;
}

bot_movetoobjective_on_cancel()
{
	self.successfully_moved_to_objective = false;
	self.can_do_objective_now = false;
}

bot_movetoobjective_should_postpone()
{
	if ( self bot_should_flee() )
	{
		return true;
	}
	return false;
}

bot_movetoobjective_on_postpone()
{
	self.successfully_moved_to_objective = false;
	self.can_do_objective_now = false;
}

bot_movetoobjective_priority()
{
	return 0;
}

bot_train()
{

}

bot_train_process_order()
{
	return 0;
}

bot_should_train()
{
	return false;
}

bot_check_complete_train()
{
	return false;
}

bot_set_complete_train()
{

}

bot_train_on_completion()
{

}

bot_train_should_cancel()
{
	return false;
}

bot_train_on_cancel()
{

}

bot_train_should_postpone()
{
	return false;
}

bot_train_on_postpone()
{

}

bot_train_priority()
{
	return 0;
}

bot_camp()
{

}

bot_camp_process_order()
{
	return 0;
}

bot_should_camp()
{
	return false;
}

bot_check_complete_camp()
{
	return false;
}

bot_set_complete_camp()
{

}

bot_camp_on_completion()
{

}

bot_camp_should_cancel()
{
	return false;
}

bot_camp_on_cancel()
{

}

bot_camp_should_postpone()
{
	return false;
}

bot_camp_on_postpone()
{

}

bot_camp_priority()
{
	return 0;
}

bot_flee()
{

}

bot_flee_process_order()
{
	return 0;
}

bot_should_flee()
{
	return false;
}

bot_check_complete_flee()
{
	return false;
}

bot_set_complete_flee()
{

}

bot_flee_on_completion()
{

}

bot_flee_should_cancel()
{
	return false;
}

bot_flee_on_cancel()
{

}

bot_flee_should_postpone()
{
	return false;
}

bot_flee_on_postpone()
{

}

bot_flee_priority()
{
	return 0;
}