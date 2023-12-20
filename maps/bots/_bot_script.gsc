#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;

/*
	Initialize bot script level functions
*/
bot_script_init()
{
	level thread maps\bots\objectives\_manager::init();
}

/*
	When the bot gets added into the game.
*/
added()
{
	self endon( "disconnect" );

	self set_diff();
}

/*
	When the bot connects to the game.
*/
connected()
{
	self endon( "disconnect" );

	self thread difficulty();
	self thread onBotSpawned();
	self thread onSpawned();

	self thread maps\bots\objectives\_manager::connected();
}

/*
	The callback for when the bot gets damaged.
*/
onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if ( !isdefined( self ) || !isdefined( self.team ) )
	{
		return;
	}

	if ( !isalive( self ) )
	{
		return;
	}

	if ( sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_SUICIDE" )
	{
		return;
	}

	if ( iDamage <= 0 )
	{
		return;
	}

	if ( !isdefined( eAttacker ) || !isdefined( eAttacker.team ) )
	{
		return;
	}

	if ( eAttacker == self )
	{
		return;
	}

	if ( !isalive( eAttacker ) )
	{
		return;
	}

	self SetAttacker( eAttacker );
}

/*
	Updates the bot's difficulty variables.
*/
difficulty()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		if ( getdvarint( "bots_skill" ) != 9 )
		{
			switch ( self.pers[ "bots" ][ "skill" ][ "base" ] )
			{
				case 1:
					self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.6;
					self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 1500;
					self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 1000;
					self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 500;
					self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 600;
					self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 750;
					self.pers[ "bots" ][ "skill" ][ "fov" ] = 0.7;
					self.pers[ "bots" ][ "skill" ][ "dist_max" ] = 2500;
					self.pers[ "bots" ][ "skill" ][ "dist_start" ] = 1000;
					self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.75;
					self.pers[ "bots" ][ "skill" ][ "help_dist" ] = 0;
					self.pers[ "bots" ][ "skill" ][ "semi_time" ] = 0.9;
					self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = 1;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = 1.5;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = 4;
					self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = 2;
					self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_spineupper,j_ankle_le,j_ankle_ri";
					self.pers[ "bots" ][ "skill" ][ "ads_fov_multi" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "ads_aimspeed_multi" ] = 0.5;

					self.pers[ "bots" ][ "behavior" ][ "strafe" ] = 0;
					self.pers[ "bots" ][ "behavior" ][ "nade" ] = 10;
					self.pers[ "bots" ][ "behavior" ][ "sprint" ] = 30;
					self.pers[ "bots" ][ "behavior" ][ "camp" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "follow" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "crouch" ] = 20;
					self.pers[ "bots" ][ "behavior" ][ "switch" ] = 2;
					self.pers[ "bots" ][ "behavior" ][ "jump" ] = 0;
					break;

				case 2:
					self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.55;
					self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 1000;
					self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 800;
					self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 1000;
					self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 1250;
					self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 1500;
					self.pers[ "bots" ][ "skill" ][ "fov" ] = 0.65;
					self.pers[ "bots" ][ "skill" ][ "dist_max" ] = 3000;
					self.pers[ "bots" ][ "skill" ][ "dist_start" ] = 1500;
					self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.65;
					self.pers[ "bots" ][ "skill" ][ "help_dist" ] = 500;
					self.pers[ "bots" ][ "skill" ][ "semi_time" ] = 0.75;
					self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = 0.75;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = 1;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = 3;
					self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = 1.5;
					self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_spineupper,j_ankle_le,j_ankle_ri,j_head";
					self.pers[ "bots" ][ "skill" ][ "ads_fov_multi" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "ads_aimspeed_multi" ] = 0.5;

					self.pers[ "bots" ][ "behavior" ][ "strafe" ] = 10;
					self.pers[ "bots" ][ "behavior" ][ "nade" ] = 15;
					self.pers[ "bots" ][ "behavior" ][ "sprint" ] = 45;
					self.pers[ "bots" ][ "behavior" ][ "camp" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "follow" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "crouch" ] = 15;
					self.pers[ "bots" ][ "behavior" ][ "switch" ] = 2;
					self.pers[ "bots" ][ "behavior" ][ "jump" ] = 10;
					break;

				case 3:
					self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.4;
					self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 750;
					self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 500;
					self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 1000;
					self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 1500;
					self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 2000;
					self.pers[ "bots" ][ "skill" ][ "fov" ] = 0.6;
					self.pers[ "bots" ][ "skill" ][ "dist_max" ] = 4000;
					self.pers[ "bots" ][ "skill" ][ "dist_start" ] = 2250;
					self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "help_dist" ] = 750;
					self.pers[ "bots" ][ "skill" ][ "semi_time" ] = 0.65;
					self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = 0.65;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = 0.75;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = 2.5;
					self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = 1;
					self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_spineupper,j_spineupper,j_ankle_le,j_ankle_ri,j_head";
					self.pers[ "bots" ][ "skill" ][ "ads_fov_multi" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "ads_aimspeed_multi" ] = 0.5;

					self.pers[ "bots" ][ "behavior" ][ "strafe" ] = 20;
					self.pers[ "bots" ][ "behavior" ][ "nade" ] = 20;
					self.pers[ "bots" ][ "behavior" ][ "sprint" ] = 50;
					self.pers[ "bots" ][ "behavior" ][ "camp" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "follow" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "crouch" ] = 10;
					self.pers[ "bots" ][ "behavior" ][ "switch" ] = 2;
					self.pers[ "bots" ][ "behavior" ][ "jump" ] = 25;
					break;

				case 4:
					self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.3;
					self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 600;
					self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 400;
					self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 1000;
					self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 1500;
					self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 3000;
					self.pers[ "bots" ][ "skill" ][ "fov" ] = 0.55;
					self.pers[ "bots" ][ "skill" ][ "dist_max" ] = 5000;
					self.pers[ "bots" ][ "skill" ][ "dist_start" ] = 3350;
					self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.35;
					self.pers[ "bots" ][ "skill" ][ "help_dist" ] = 1000;
					self.pers[ "bots" ][ "skill" ][ "semi_time" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = 2;
					self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = 0.75;
					self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_spineupper,j_spineupper,j_ankle_le,j_ankle_ri,j_head,j_head";
					self.pers[ "bots" ][ "skill" ][ "ads_fov_multi" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "ads_aimspeed_multi" ] = 0.5;

					self.pers[ "bots" ][ "behavior" ][ "strafe" ] = 30;
					self.pers[ "bots" ][ "behavior" ][ "nade" ] = 25;
					self.pers[ "bots" ][ "behavior" ][ "sprint" ] = 55;
					self.pers[ "bots" ][ "behavior" ][ "camp" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "follow" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "crouch" ] = 10;
					self.pers[ "bots" ][ "behavior" ][ "switch" ] = 2;
					self.pers[ "bots" ][ "behavior" ][ "jump" ] = 35;
					break;

				case 5:
					self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.25;
					self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 500;
					self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 300;
					self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 1500;
					self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 2000;
					self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 4000;
					self.pers[ "bots" ][ "skill" ][ "fov" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "dist_max" ] = 7500;
					self.pers[ "bots" ][ "skill" ][ "dist_start" ] = 5000;
					self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.25;
					self.pers[ "bots" ][ "skill" ][ "help_dist" ] = 1500;
					self.pers[ "bots" ][ "skill" ][ "semi_time" ] = 0.4;
					self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = 0.35;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = 0.35;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = 1.5;
					self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_spineupper,j_head";
					self.pers[ "bots" ][ "skill" ][ "ads_fov_multi" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "ads_aimspeed_multi" ] = 0.5;

					self.pers[ "bots" ][ "behavior" ][ "strafe" ] = 40;
					self.pers[ "bots" ][ "behavior" ][ "nade" ] = 35;
					self.pers[ "bots" ][ "behavior" ][ "sprint" ] = 60;
					self.pers[ "bots" ][ "behavior" ][ "camp" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "follow" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "crouch" ] = 10;
					self.pers[ "bots" ][ "behavior" ][ "switch" ] = 2;
					self.pers[ "bots" ][ "behavior" ][ "jump" ] = 50;
					break;

				case 6:
					self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.2;
					self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 250;
					self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 150;
					self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 2000;
					self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 3000;
					self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 5000;
					self.pers[ "bots" ][ "skill" ][ "fov" ] = 0.45;
					self.pers[ "bots" ][ "skill" ][ "dist_max" ] = 10000;
					self.pers[ "bots" ][ "skill" ][ "dist_start" ] = 7500;
					self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.2;
					self.pers[ "bots" ][ "skill" ][ "help_dist" ] = 2000;
					self.pers[ "bots" ][ "skill" ][ "semi_time" ] = 0.25;
					self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = 0.25;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = 0.25;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = 1;
					self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = 0.25;
					self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_spineupper,j_head,j_head";
					self.pers[ "bots" ][ "skill" ][ "ads_fov_multi" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "ads_aimspeed_multi" ] = 0.5;

					self.pers[ "bots" ][ "behavior" ][ "strafe" ] = 50;
					self.pers[ "bots" ][ "behavior" ][ "nade" ] = 45;
					self.pers[ "bots" ][ "behavior" ][ "sprint" ] = 65;
					self.pers[ "bots" ][ "behavior" ][ "camp" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "follow" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "crouch" ] = 10;
					self.pers[ "bots" ][ "behavior" ][ "switch" ] = 2;
					self.pers[ "bots" ][ "behavior" ][ "jump" ] = 75;
					break;

				case 7:
					self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.1;
					self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 100;
					self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 50;
					self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 2500;
					self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 4000;
					self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 7500;
					self.pers[ "bots" ][ "skill" ][ "fov" ] = 0.4;
					self.pers[ "bots" ][ "skill" ][ "dist_max" ] = 15000;
					self.pers[ "bots" ][ "skill" ][ "dist_start" ] = 10000;
					self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.05;
					self.pers[ "bots" ][ "skill" ][ "help_dist" ] = 3000;
					self.pers[ "bots" ][ "skill" ][ "semi_time" ] = 0.1;
					self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = 0;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = 0;
					self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = 0;
					self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = 0.05;
					self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_head";
					self.pers[ "bots" ][ "skill" ][ "ads_fov_multi" ] = 0.5;
					self.pers[ "bots" ][ "skill" ][ "ads_aimspeed_multi" ] = 0.5;

					self.pers[ "bots" ][ "behavior" ][ "strafe" ] = 65;
					self.pers[ "bots" ][ "behavior" ][ "nade" ] = 65;
					self.pers[ "bots" ][ "behavior" ][ "sprint" ] = 70;
					self.pers[ "bots" ][ "behavior" ][ "camp" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "follow" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "crouch" ] = 5;
					self.pers[ "bots" ][ "behavior" ][ "switch" ] = 2;
					self.pers[ "bots" ][ "behavior" ][ "jump" ] = 90;
					break;
			}
		}

		wait 5;
	}
}

/*
	Sets the bot difficulty.
*/
set_diff()
{
	rankVar = getdvarint( "bots_skill" );

	switch ( rankVar )
	{
		case 0:
			self.pers[ "bots" ][ "skill" ][ "base" ] = Round( random_normal_distribution( 3.5, 1.75, 1, 7 ) );
			break;

		case 8:
			break;

		case 9:
			self.pers[ "bots" ][ "skill" ][ "base" ] = randomintrange( 1, 7 );
			self.pers[ "bots" ][ "skill" ][ "aim_time" ] = 0.05 * randomintrange( 1, 20 );
			self.pers[ "bots" ][ "skill" ][ "init_react_time" ] = 50 * randomint( 100 );
			self.pers[ "bots" ][ "skill" ][ "reaction_time" ] = 50 * randomint( 100 );
			self.pers[ "bots" ][ "skill" ][ "no_trace_ads_time" ] = 50 * randomint( 100 );
			self.pers[ "bots" ][ "skill" ][ "no_trace_look_time" ] = 50 * randomint( 100 );
			self.pers[ "bots" ][ "skill" ][ "remember_time" ] = 50 * randomint( 100 );
			self.pers[ "bots" ][ "skill" ][ "fov" ] = randomfloatrange( -1, 1 );

			randomNum = randomintrange( 500, 25000 );
			self.pers[ "bots" ][ "skill" ][ "dist_start" ] = randomNum;
			self.pers[ "bots" ][ "skill" ][ "dist_max" ] = randomNum * 2;

			self.pers[ "bots" ][ "skill" ][ "spawn_time" ] = 0.05 * randomint( 20 );
			self.pers[ "bots" ][ "skill" ][ "help_dist" ] = randomintrange( 500, 25000 );
			self.pers[ "bots" ][ "skill" ][ "semi_time" ] = randomfloatrange( 0.05, 1 );
			self.pers[ "bots" ][ "skill" ][ "shoot_after_time" ] = randomfloatrange( 0.05, 1 );
			self.pers[ "bots" ][ "skill" ][ "aim_offset_time" ] = randomfloatrange( 0.05, 1 );
			self.pers[ "bots" ][ "skill" ][ "aim_offset_amount" ] = randomfloatrange( 0.05, 1 );
			self.pers[ "bots" ][ "skill" ][ "bone_update_interval" ] = randomfloatrange( 0.05, 1 );
			self.pers[ "bots" ][ "skill" ][ "bones" ] = "j_head,j_spineupper,j_ankle_ri,j_ankle_le";

			self.pers[ "bots" ][ "behavior" ][ "strafe" ] = randomint( 100 );
			self.pers[ "bots" ][ "behavior" ][ "nade" ] = randomint( 100 );
			self.pers[ "bots" ][ "behavior" ][ "sprint" ] = randomint( 100 );
			self.pers[ "bots" ][ "behavior" ][ "camp" ] = randomint( 100 );
			self.pers[ "bots" ][ "behavior" ][ "follow" ] = randomint( 100 );
			self.pers[ "bots" ][ "behavior" ][ "crouch" ] = randomint( 100 );
			self.pers[ "bots" ][ "behavior" ][ "switch" ] = randomint( 100 );
			self.pers[ "bots" ][ "behavior" ][ "jump" ] = randomint( 100 );
			break;

		default:
			self.pers[ "bots" ][ "skill" ][ "base" ] = rankVar;
			break;
	}
}

/*
	When the bot spawned, after the difficulty wait. Start the logic for the bot.
*/
onBotSpawned()
{
	self endon( "disconnect" );
	level endon( "intermission" );

	for ( ;; )
	{
		self waittill( "bot_spawned" );

		self thread start_bot_threads();
	}
}

/*
	When the bot spawns.
*/
onSpawned()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );

		self thread maps\bots\objectives\_manager::spawned();
	}
}

/*
	Starts all the bot thinking
*/
start_bot_threads()
{
	self endon( "disconnect" );
	level endon( "intermission" );
	self endon( "zombified" );

	self thread doReloadCancel();

	self thread maps\bots\objectives\_manager::start_bot_threads();
}

/*
	Changes to the weap
*/
changeToWeapon( weap )
{
	self endon( "disconnect" );
	self endon( "zombified" );
	level endon( "game_ended" );

	if ( !self hasweapon( weap ) )
	{
		return false;
	}

	self switchtoweapon( weap );

	if ( self getcurrentweapon() == weap )
	{
		return true;
	}

	self waittill_any_timeout( 5, "weapon_change" );

	return ( self getcurrentweapon() == weap );
}

/*
	Reload cancels
*/
doReloadCancel_loop()
{
	ret = self waittill_any_return( "reload", "weapon_change" );

	if ( self BotIsFrozen() )
	{
		return;
	}

	if ( self usebuttonpressed() )
	{
		return;
	}

	if ( self inLastStand() )
	{
		return;
	}

	curWeap = self getcurrentweapon();

	if ( !self isWeaponPrimary( curWeap ) )
	{
		return;
	}

	if ( ret == "reload" )
	{
		// check single reloads
		if ( self getweaponammoclip( curWeap ) < weaponclipsize( curWeap ) )
		{
			return;
		}
	}

	// check difficulty
	if ( self.pers[ "bots" ][ "skill" ][ "base" ] <= 3 )
	{
		return;
	}

	// check if got another weapon
	weaponslist = self getweaponslistprimaries();
	weap = "";

	while ( weaponslist.size )
	{
		weapon = weaponslist[ randomint( weaponslist.size ) ];
		weaponslist = array_remove( weaponslist, weapon );

		if ( !self isWeaponPrimary( weapon ) )
		{
			continue;
		}

		if ( curWeap == weapon || weapon == "none" || weapon == "" )
		{
			continue;
		}

		weap = weapon;
		break;
	}

	if ( weap == "" )
	{
		return;
	}

	// do the cancel
	wait 0.1;
	self thread changeToWeapon( weap );
	wait 0.25;
	self thread changeToWeapon( curWeap );
	wait 2;
}

/*
	Reload cancels
*/
doReloadCancel()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		self doReloadCancel_loop();
	}
}
