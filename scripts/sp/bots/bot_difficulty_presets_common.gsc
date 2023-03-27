register_bot_difficulty( difficulty )
{
	if ( !isDefined( level.zbot_difficulties ) )
	{
		level.zbot_difficulties = [];
	}

	level.zbot_difficulties[ difficulty ] = true;
}