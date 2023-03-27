
register_bot_personality_type( personality )
{
	if ( !isDefined( level.zbot_personalities ) )
	{
		level.zbot_personalities = [];
	}

	level.zbot_personalities[ personality ] = true;
}