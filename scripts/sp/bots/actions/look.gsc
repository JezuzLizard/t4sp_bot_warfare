#include scripts\sp\bots\bot_target_common;

bot_lookatobjective()
{

}

bot_lookatobjective_process_order()
{
	return 0;
}

bot_should_lookatobjective()
{
	return false;
}

bot_check_complete_lookatobjective()
{
	return false;
}

bot_set_complete_lookatobjective()
{

}

bot_lookatobjective_on_completion()
{

}

bot_lookatobjective_should_cancel()
{
	return false;
}

bot_lookatobjective_on_cancel()
{

}

bot_lookatobjective_should_postpone()
{
	return false;
}

bot_lookatobjective_on_postpone()
{

}

bot_lookatobjective_priority()
{
	return 0;
}

bot_lookattarget()
{
	self endon( "disconnect" );
	while ( self bot_has_target() && isAlive( self.zbot_current_target.target_ent ) )
	{
		target = self.zbot_current_target;
		target_ent = target.target_ent;
		self bot_lookat( target_ent getTagOrigin( "j_head" ) );
		wait 0.05;
	}
}

bot_lookattarget_process_order()
{
	return 0;
}

bot_should_lookattarget()
{
	return self bot_has_target();
}

bot_check_complete_lookattarget()
{
	return !self bot_has_target();
}

bot_set_complete_lookattarget()
{

}

bot_lookattarget_on_completion()
{

}

bot_lookattarget_should_cancel()
{
	return false;
}

bot_lookattarget_on_cancel()
{

}

bot_lookattarget_should_postpone()
{
	return false;
}

bot_lookattarget_on_postpone()
{

}

bot_lookattarget_priority()
{
	return 0;
}

bot_lookatgoal()
{

}

bot_lookatgoal_process_order()
{
	return 0;
}

bot_should_lookatgoal()
{
	return false;
}

bot_check_complete_lookatgoal()
{
	return false;
}

bot_set_complete_lookatgoal()
{

}

bot_lookatgoal_on_completion()
{

}

bot_lookatgoal_should_cancel()
{
	return false;
}

bot_lookatgoal_on_cancel()
{

}

bot_lookatgoal_should_postpone()
{
	return false;
}

bot_lookatgoal_on_postpone()
{

}

bot_lookatgoal_priority()
{
	return 0;
}

bot_lookat( pos, time, vel, doAimPredict )
{
	self notify( "bots_aim_overlap" );
	self endon( "bots_aim_overlap" );
	self endon( "disconnect" );
	self endon( "player_downed" );
	level endon( "end_game" );

	if ( !isDefined( pos ) )
		return;

	if ( !isDefined( doAimPredict ) )
		doAimPredict = false;

	if ( !isDefined( time ) )
		time = 0.05;

	if ( !isDefined( vel ) )
		vel = ( 0, 0, 0 );

	steps = int( time * 20 );

	if ( steps < 1 )
		steps = 1;

	myEye = self scripts\sp\bots\_bot_utility::GetEyePos(); // get our eye pos

	if ( doAimPredict )
	{
		myEye += ( self getVelocity() * 0.05 ) * ( steps - 1 ); // account for our velocity

		pos += ( vel * 0.05 ) * ( steps - 1 ); // add the velocity vector
	}

	myAngle = self getPlayerAngles();
	angles = VectorToAngles( ( pos - myEye ) - anglesToForward( myAngle ) );

	X = AngleClamp180( angles[0] - myAngle[0] );
	X = X / steps;

	Y = AngleClamp180( angles[1] - myAngle[1] );
	Y = Y / steps;

	for ( i = 0; i < steps; i++ )
	{
		myAngle = ( AngleClamp180(myAngle[0] + X), AngleClamp180(myAngle[1] + Y), 0 );
		self setPlayerAngles( myAngle );
		wait 0.05;
	}
}