#include maps\_utility;
#include common_scripts\utility;

main()
{
	replaceFunc( GetFunction( "maps/_utility", "wait_network_frame" ), ::wait_network_frame_func );
}

wait_network_frame_func()
{
	wait 0.05;
}

init()
{
	level thread print_new_rounds();
	level thread onPlayerConnect();
	level thread spitOutTime();

	if ( getDvar( "killtest_bot_debug" ) == "" )
		setDvar( "killtest_bot_debug", 1 );

	level thread addBot();

	level thread setupcallbacks();
}

setupcallbacks()
{
	wait 1;

	level.killtestoldoverrideplayerdamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::killtestoverrideplayerdamage;

	level.killtestoldoverrideactordamage = level.callbackActorDamage;
	level.callbackActorDamage = ::killtestoverrideactordamage;
}

killtestoverrideactordamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset )
{
	if ( isDefined( eAttacker ) && isPlayer( eAttacker ) )
	{
		if ( sWeapon == "zombie_doublebarrel" )
			iDamage = 1;
	}

	setDvar( "aa_player_damage_dealt", 0 );

	if ( sMeansOfDeath == "MOD_MELEE" )
		iDamage = 100000000;

	self [[level.killtestoldoverrideactordamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset );
}

killtestoverrideplayerdamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if ( self isBot() )
	{
		if ( isDefined( eAttacker ) && eAttacker == self )
			return;

		iDamage = 5;
	}

	PrintConsole( self GetPlayerName() + " took " + iDamage );

	self [[level.killtestoldoverrideplayerdamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
}

print_new_rounds()
{
	while ( 1 )
	{
		level waittill( "new_zombie_round", round_num );

		PrintConsole( "New zombie round!: " + round_num );
	}
}

spitOutTime()
{
	startTime = GetTime();

	for ( ;; )
	{
		wait 60;
		PrintConsole( "TIME: " + ( GetTime() - startTime ) );
	}
}

/*  botMoveTo( to )
    {
	self.moveTo = to;
    }

    walk_to_player()
    {
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		wait 0.05;

		// stop bot moving
		self botMoveTo( self.origin );

		// get a player
		non_bot_player = undefined;
		players = getPlayers();

		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( player isBot() )
				continue;

			non_bot_player = player;
		}

		if ( !isdefined( non_bot_player ) )
			continue;

		// generate a path to the player
		goal = non_bot_player.origin;
		path = generatePath( self.origin, goal, "free", false );

		if ( !isdefined( path ) )
			continue;

		// traverse each node in the path
		for ( i = path.size - 1; i >= 0; i-- )
		{
			path_num = path[i];

			if ( path_num <= -1 )
				continue;

			path_node = getNodeByNumber( path_num );

			if ( !isDefined( path_node ) )
				continue;

			while ( distance2d( self.origin, path_node.origin ) >= 7 )
			{
				wait 0.05;

				self botMoveTo( path_node.origin );
			}
		}

		// blindly go to player after traversing each path node
		while ( distance2d( self.origin, goal ) >= 10 )
		{
			wait 0.05;

			self botMoveTo( goal );
		}

		// done
	}
    }

    do_move()
    {
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		wait 0.05;
		waittillframeend;

		move_To = self.moveTo;
		angles = self GetPlayerAngles();
		dir = ( 0, 0, 0 );

		if ( DistanceSquared( self.origin, move_To ) >= 49 )
		{
			cosa = cos( 0 - angles[1] );
			sina = sin( 0 - angles[1] );

			// get the direction
			dir = move_To - self.origin;

			// rotate our direction according to our angles
			dir = ( dir[0] * cosa - dir[1] * sina,
			        dir[0] * sina + dir[1] * cosa,
			        0 );

			// make the length 127
			dir = VectorNormalize( dir ) * 127;

			// invert the second component as the engine requires this
			dir = ( dir[0], 0 - dir[1], 0 );
		}

		self botMovement( int( dir[0] ), int( dir[1] ) );
	}
    }*/

addBot()
{
	if ( !getDvarInt( "killtest_bot_debug" ) )
		return;

	// level waittill("connected", player);
	wait 5;

	guy = addTestClient();

	if ( !isDefined( guy ) )
		return;

	guy endon( "disconnect" );

	guy botStop();

	wait 5;

	if ( !isDefined( guy ) )
		return;

	// guy.killingAll = true;
	weapon = "ray_gun";
	guy giveWeapon( weapon ); // ptrs41_zombie zombie_doublebarrel
	guy switchToWeapon( weapon ); // colt_dirty_harry

	//guy thread walk_to_player();
	//guy thread do_move();

	/*
	while ( isDefined( guy ) )
	{
		if ( isDefined( level.isPlayerDead ) && [[level.isPlayerDead]]( guy ) )
		{
			wait 2.5;
			guy removeTestClient();
			break;
		}

		guy giveMaxAmmo( weapon );

		wait 0.05;
	}
	*/
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );

		player thread onSpawned();
	}
}

onSpawned()
{
	self endon( "disconnect" );

	self.killingAll = false;

	for ( ;; )
	{
		self waittill( "spawned_player" );

		self thread killAllZombsWithBullets();
		self thread watchKillAllButton();

		if ( !self isBot() )
			self thread moveBot();
	}
}

EyeTraceForward()
{
	origin = self getTagOrigin( "tag_eye" );
	angles = self GetPlayerAngles();
	forward = AnglesToForward( angles );
	endpoint = origin + forward * 15000;

	res = BulletTrace( origin, endpoint, false, undefined );

	return res["position"];
}

moveBot()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		wait 0.05;

		if ( self MeleeButtonPressed() && self AdsButtonPressed() )
		{
			players = get_players();

			for ( i = 0; i < players.size; i++ )
			{
				player = players[i];

				if ( !player isBot() )
					continue;

				if ( self AttackButtonPressed() && isDefined( player.bot.moveTo ) )
					player SetOrigin( player.bot.moveTo );
				else
					player SetOrigin( self EyeTraceForward() );
			}
		}
	}
}

watchKillAllButton()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	wait 5;

	self notifyOnPlayerCommand( "+smoke", "toggle_killall" );

	for ( ;; )
	{
		self waittill( "toggle_killall" );

		self.killingAll = !self.killingAll;
		self iPrintLn( "Killing all: " + self.killingAll );
	}
}

do_magic_bullets()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	myeye = self getTagOrigin( "tag_eye" );

	if ( !isDefined( myeye ) )
		return;

	zombies = GetAiSpeciesArray( "axis", "all" );
	weap = self GetCurrentWeapon();

	for ( i = 0; i < zombies.size; i++ )
	{
		zombie = zombies[i];

		if ( isDefined( zombie ) )
		{
			/*
			    if ( zombie.maxhealth != 2147483647 )
			    {
				zombie.maxhealth = 2147483647;
				zombie.health = zombie.maxhealth;
			    }
			    else
			    {
				zombie DoDamage( zombie.health + 666, zombie.origin, self, 0, "headshot" );
			    }
			*/

			hit_loc = undefined;

			if ( randomint( 2 ) )
				hit_loc = zombie getTagOrigin( "j_head" );
			else
				hit_loc = zombie getTagOrigin( "j_spine4" );

			if ( isDefined( hit_loc ) )
			{
				if ( sighttracepassed( myeye, hit_loc, false, self ) )
				{
					magicbullet( weap, myeye, hit_loc, self );
				}
			}
		}
	}
}

killAllZombsWithBullets()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		wait 0.05;

		if ( !self.killingAll )
			continue;

		self thread do_magic_bullets();
	}
}
