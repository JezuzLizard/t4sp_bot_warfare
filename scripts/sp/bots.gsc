#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;

init()
{
	level thread maps\bots\_bot::init();

	setDvar( "player_debug_bots", 1 );
	thread test_bot_pathing();
}

test_bot_pathing()
{
	if ( !getDvarInt( "player_debug_bots" ) )
		return;

	level waittill( "connected", player );

	while ( !player is_bot() )
		level waittill( "connected", player );

	player endon( "disconnect" );

	while ( true )
	{
		wait 0.05;

		if ( !player UseButtonPressed() )
			continue;

		bots = getBotArray();

		if ( player AttackButtonPressed() )
		{
			player iprintln( "Telling bots to go to you" );

			for ( i = 0; i < bots.size; i++ )
			{
				bots[i] SetScriptGoal( player.origin );
			}

			continue;
		}

		if ( player AdsButtonPressed() )
		{
			player iprintln( "Telling bots to ROAM" );

			for ( i = 0; i < bots.size; i++ )
			{
				bots[i] ClearScriptGoal();
			}

			continue;
		}
	}
}
