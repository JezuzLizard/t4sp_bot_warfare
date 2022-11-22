#include common_scripts\utility;
#include maps\_utility;
#include scripts\sp\bots\_bot_utility;

/*
	When the bot connects to the game.
*/
connected()
{
	self endon( "disconnect" );

	self.killerLocation = undefined;
	self.lastKiller = undefined;
	self.bot_change_class = true;

	self thread difficulty();
	self thread onBotSpawned();
	self thread onSpawned();

	wait 0.1;
	self.challengeData = [];
}

/*
	When the bot spawned, after the difficulty wait. Start the logic for the bot.
*/
onBotSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );

	for ( ;; )
	{
		self waittill( "bot_spawned" );

		self thread start_bot_threads();
	}
}

/*
	Starts all the bot thinking
*/
start_bot_threads()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self endon( "death" );
	
	// inventory usage
	if ( getDvarInt( "bots_play_killstreak" ) )
		//self thread bot_killstreak_think();

	self thread bot_weapon_think();
	self thread doReloadCancel();

	// script targeting
	if ( getDvarInt( "bots_play_target_other" ) )
	{
		//self thread bot_target_vehicle();
		//self thread bot_kill_dog_think();
		//self thread bot_equipment_kill_think();
	}

	// awareness
	//self thread bot_revenge_think();
	//self thread bot_uav_think();
	//self thread bot_listen_to_steps();
	//self thread follow_target();

	// camp and follow
	if ( getDvarInt( "bots_play_camp" ) )
	{
		self thread bot_think_follow();
		self thread bot_think_camp();
	}

	// nades
	if ( getDvarInt( "bots_play_nade" ) )
	{
		//self thread bot_use_tube_think();
		//self thread bot_use_grenade_think();
		//self thread bot_use_equipment_think();
		//self thread bot_watch_think_mw2();
	}

	// obj
	if ( getDvarInt( "bots_play_obj" ) )
	{
		//self thread bot_dom_def_think();
		//self thread bot_dom_spawn_kill_think();

		//self thread bot_hq();

		//self thread bot_sab();

		//self thread bot_sd_defenders();
		//self thread bot_sd_attackers();

		//self thread bot_cap();

		//self thread bot_war();
	}

	self thread bot_revive_think();
}

/*
	Bot logic for switching weapons.
*/
bot_weapon_think_loop( data )
{
	self waittill_any_timeout( randomIntRange( 2, 4 ), "bot_force_check_switch" );

	if ( self BotIsFrozen() )
		return;

	if ( self InLastStand() )
		return;

	hasTarget = self hasThreat();
	curWeap = self GetCurrentWeapon();

	if ( data.first )
	{
		data.first = false;

		if ( randomInt( 100 ) > self.pers["bots"]["behavior"]["initswitch"] )
			return;
	}
	else
	{
		if ( curWeap != "none" && self getAmmoCount( curWeap ) && curWeap != "squadcommand_mp" )
		{
			if ( randomInt( 100 ) > self.pers["bots"]["behavior"]["switch"] )
				return;

			if ( hasTarget )
				return;
		}
	}

	weaponslist = self getweaponslist();
	weap = "";

	while ( weaponslist.size )
	{
		weapon = weaponslist[randomInt( weaponslist.size )];
		weaponslist = array_remove( weaponslist, weapon );

		if ( !self getAmmoCount( weapon ) )
			continue;
		/*
		if ( maps\mp\gametypes\_weapons::isHackWeapon( weapon ) )
			continue;

		if ( maps\mp\gametypes\_weapons::isGrenade( weapon ) )
			continue;
		*/
		if ( curWeap == weapon || weapon == "satchel_charge_mp" || weapon == "none" || weapon == "mine_bouncing_betty_mp" || weapon == "" || weapon == "squadcommand_mp" )
			continue;

		weap = weapon;
		break;
	}

	if ( weap == "" )
		return;

	self thread ChangeToWeapon( weap );
}

/*
	Bot logic for switching weapons.
*/
bot_weapon_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );

	data = spawnStruct();
	data.first = true;

	for ( ;; )
	{
		self bot_weapon_think_loop( data );
	}
}

/*
	Reload cancels
*/
doReloadCancel()
{
	self endon( "disconnect" );
	self endon( "death" );

	for ( ;; )
	{
		self doReloadCancel_loop();
	}
}

/*
	Reload cancels
*/
doReloadCancel_loop()
{
	ret = self waittill_any_return( "reload", "weapon_change" );

	if ( self BotIsFrozen() )
		return;

	if ( self InLastStand() )
		return;

	curWeap = self GetCurrentWeapon();
	/*
	if ( !maps\mp\gametypes\_weapons::isSideArm( curWeap ) && !maps\mp\gametypes\_weapons::isPrimaryWeapon( curWeap ) )
		return;
	*/
	if ( ret == "reload" )
	{
		// check single reloads
		if ( self GetWeaponAmmoClip( curWeap ) < WeaponClipSize( curWeap ) )
			return;
	}

	// check difficulty
	if ( self.pers["bots"]["skill"]["base"] <= 3 )
		return;

	// check if got another weapon
	weaponslist = self GetWeaponsListPrimaries();
	weap = "";

	while ( weaponslist.size )
	{
		weapon = weaponslist[randomInt( weaponslist.size )];
		weaponslist = array_remove( weaponslist, weapon );

		/*
		if ( !maps\mp\gametypes\_weapons::isSideArm( weapon ) && !maps\mp\gametypes\_weapons::isPrimaryWeapon( weapon ) )
			continue;
		*/
		if ( curWeap == weapon || weapon == "none" || weapon == "" )
			continue;

		weap = weapon;
		break;
	}

	if ( weap == "" )
		return;

	// do the cancel
	wait 0.1;
	self thread ChangeToWeapon( weap );
	wait 0.25;
	self thread ChangeToWeapon( curWeap );
	wait 2;
}

/*
	Updates the bot's difficulty variables.
*/
difficulty()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		if ( GetDvarInt( "bots_skill" ) != 9 )
		{
			switch ( self.pers["bots"]["skill"]["base"] )
			{
				case 1:
					self.pers["bots"]["skill"]["aim_time"] = 0.6;
					self.pers["bots"]["skill"]["init_react_time"] = 1500;
					self.pers["bots"]["skill"]["reaction_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 500;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 600;
					self.pers["bots"]["skill"]["remember_time"] = 750;
					self.pers["bots"]["skill"]["fov"] = 0.7;
					self.pers["bots"]["skill"]["dist_max"] = 2500;
					self.pers["bots"]["skill"]["dist_start"] = 1000;
					self.pers["bots"]["skill"]["spawn_time"] = 0.75;
					self.pers["bots"]["skill"]["help_dist"] = 0;
					self.pers["bots"]["skill"]["semi_time"] = 0.9;
					self.pers["bots"]["skill"]["shoot_after_time"] = 1;
					self.pers["bots"]["skill"]["aim_offset_time"] = 1.5;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 4;
					self.pers["bots"]["skill"]["bone_update_interval"] = 2;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_ankle_le,j_ankle_ri";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 0;
					self.pers["bots"]["behavior"]["nade"] = 10;
					self.pers["bots"]["behavior"]["sprint"] = 30;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 20;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 0;
					break;

				case 2:
					self.pers["bots"]["skill"]["aim_time"] = 0.55;
					self.pers["bots"]["skill"]["init_react_time"] = 1000;
					self.pers["bots"]["skill"]["reaction_time"] = 800;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 1250;
					self.pers["bots"]["skill"]["remember_time"] = 1500;
					self.pers["bots"]["skill"]["fov"] = 0.65;
					self.pers["bots"]["skill"]["dist_max"] = 3000;
					self.pers["bots"]["skill"]["dist_start"] = 1500;
					self.pers["bots"]["skill"]["spawn_time"] = 0.65;
					self.pers["bots"]["skill"]["help_dist"] = 500;
					self.pers["bots"]["skill"]["semi_time"] = 0.75;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.75;
					self.pers["bots"]["skill"]["aim_offset_time"] = 1;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 3;
					self.pers["bots"]["skill"]["bone_update_interval"] = 1.5;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_ankle_le,j_ankle_ri,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 10;
					self.pers["bots"]["behavior"]["nade"] = 15;
					self.pers["bots"]["behavior"]["sprint"] = 45;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 15;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 10;
					break;

				case 3:
					self.pers["bots"]["skill"]["aim_time"] = 0.4;
					self.pers["bots"]["skill"]["init_react_time"] = 750;
					self.pers["bots"]["skill"]["reaction_time"] = 500;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 1500;
					self.pers["bots"]["skill"]["remember_time"] = 2000;
					self.pers["bots"]["skill"]["fov"] = 0.6;
					self.pers["bots"]["skill"]["dist_max"] = 4000;
					self.pers["bots"]["skill"]["dist_start"] = 2250;
					self.pers["bots"]["skill"]["spawn_time"] = 0.5;
					self.pers["bots"]["skill"]["help_dist"] = 750;
					self.pers["bots"]["skill"]["semi_time"] = 0.65;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.65;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.75;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 2.5;
					self.pers["bots"]["skill"]["bone_update_interval"] = 1;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_spineupper,j_ankle_le,j_ankle_ri,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 20;
					self.pers["bots"]["behavior"]["nade"] = 20;
					self.pers["bots"]["behavior"]["sprint"] = 50;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 25;
					break;

				case 4:
					self.pers["bots"]["skill"]["aim_time"] = 0.3;
					self.pers["bots"]["skill"]["init_react_time"] = 600;
					self.pers["bots"]["skill"]["reaction_time"] = 400;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 1500;
					self.pers["bots"]["skill"]["remember_time"] = 3000;
					self.pers["bots"]["skill"]["fov"] = 0.55;
					self.pers["bots"]["skill"]["dist_max"] = 5000;
					self.pers["bots"]["skill"]["dist_start"] = 3350;
					self.pers["bots"]["skill"]["spawn_time"] = 0.35;
					self.pers["bots"]["skill"]["help_dist"] = 1000;
					self.pers["bots"]["skill"]["semi_time"] = 0.5;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.5;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.5;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 2;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.75;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_spineupper,j_ankle_le,j_ankle_ri,j_head,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 30;
					self.pers["bots"]["behavior"]["nade"] = 25;
					self.pers["bots"]["behavior"]["sprint"] = 55;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 35;
					break;

				case 5:
					self.pers["bots"]["skill"]["aim_time"] = 0.25;
					self.pers["bots"]["skill"]["init_react_time"] = 500;
					self.pers["bots"]["skill"]["reaction_time"] = 300;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 1500;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 2000;
					self.pers["bots"]["skill"]["remember_time"] = 4000;
					self.pers["bots"]["skill"]["fov"] = 0.5;
					self.pers["bots"]["skill"]["dist_max"] = 7500;
					self.pers["bots"]["skill"]["dist_start"] = 5000;
					self.pers["bots"]["skill"]["spawn_time"] = 0.25;
					self.pers["bots"]["skill"]["help_dist"] = 1500;
					self.pers["bots"]["skill"]["semi_time"] = 0.4;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.35;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.35;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 1.5;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.5;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 40;
					self.pers["bots"]["behavior"]["nade"] = 35;
					self.pers["bots"]["behavior"]["sprint"] = 60;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 50;
					break;

				case 6:
					self.pers["bots"]["skill"]["aim_time"] = 0.2;
					self.pers["bots"]["skill"]["init_react_time"] = 250;
					self.pers["bots"]["skill"]["reaction_time"] = 150;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 2000;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 3000;
					self.pers["bots"]["skill"]["remember_time"] = 5000;
					self.pers["bots"]["skill"]["fov"] = 0.45;
					self.pers["bots"]["skill"]["dist_max"] = 10000;
					self.pers["bots"]["skill"]["dist_start"] = 7500;
					self.pers["bots"]["skill"]["spawn_time"] = 0.2;
					self.pers["bots"]["skill"]["help_dist"] = 2000;
					self.pers["bots"]["skill"]["semi_time"] = 0.25;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0.25;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0.25;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 1;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.25;
					self.pers["bots"]["skill"]["bones"] = "j_spineupper,j_head,j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 50;
					self.pers["bots"]["behavior"]["nade"] = 45;
					self.pers["bots"]["behavior"]["sprint"] = 65;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 10;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 75;
					break;

				case 7:
					self.pers["bots"]["skill"]["aim_time"] = 0.1;
					self.pers["bots"]["skill"]["init_react_time"] = 100;
					self.pers["bots"]["skill"]["reaction_time"] = 50;
					self.pers["bots"]["skill"]["no_trace_ads_time"] = 2500;
					self.pers["bots"]["skill"]["no_trace_look_time"] = 4000;
					self.pers["bots"]["skill"]["remember_time"] = 7500;
					self.pers["bots"]["skill"]["fov"] = 0.4;
					self.pers["bots"]["skill"]["dist_max"] = 15000;
					self.pers["bots"]["skill"]["dist_start"] = 10000;
					self.pers["bots"]["skill"]["spawn_time"] = 0.05;
					self.pers["bots"]["skill"]["help_dist"] = 3000;
					self.pers["bots"]["skill"]["semi_time"] = 0.1;
					self.pers["bots"]["skill"]["shoot_after_time"] = 0;
					self.pers["bots"]["skill"]["aim_offset_time"] = 0;
					self.pers["bots"]["skill"]["aim_offset_amount"] = 0;
					self.pers["bots"]["skill"]["bone_update_interval"] = 0.05;
					self.pers["bots"]["skill"]["bones"] = "j_head";
					self.pers["bots"]["skill"]["ads_fov_multi"] = 0.5;
					self.pers["bots"]["skill"]["ads_aimspeed_multi"] = 0.5;

					self.pers["bots"]["behavior"]["strafe"] = 65;
					self.pers["bots"]["behavior"]["nade"] = 65;
					self.pers["bots"]["behavior"]["sprint"] = 70;
					self.pers["bots"]["behavior"]["camp"] = 5;
					self.pers["bots"]["behavior"]["follow"] = 5;
					self.pers["bots"]["behavior"]["crouch"] = 5;
					self.pers["bots"]["behavior"]["switch"] = 2;
					self.pers["bots"]["behavior"]["class"] = 2;
					self.pers["bots"]["behavior"]["jump"] = 90;
					break;
			}
		}

		wait 5;
	}
}

/*
	The callback for when the bot gets damaged.
*/
onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
	if ( !IsDefined( self ) || !isDefined( self.team ) )
		return;

	if ( !isAlive( self ) )
		return;

	if ( sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_SUICIDE" )
		return;

	if ( iDamage <= 0 )
		return;

	if ( !IsDefined( eAttacker ) || !isDefined( eAttacker.team ) )
		return;

	if ( eAttacker == self )
		return;

	if ( level.teamBased && eAttacker.team == self.team )
		return;

	if ( !IsDefined( eInflictor ) || eInflictor.classname != "player" )
		return;

	if ( !isAlive( eAttacker ) )
		return;

	if ( !isSubStr( sWeapon, "silenced_" ) && !isSubStr( sWeapon, "flash_" ) )
		//self bot_cry_for_help( eAttacker );

	self SetAttacker( eAttacker );
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

		if ( randomInt( 100 ) <= self.pers["bots"]["behavior"]["class"] )
			self.bot_change_class = undefined;

		self.bot_lock_goal = false;
		self.help_time = undefined;
		self.bot_was_follow_script_update = undefined;
	}
}

/*
	Wait for the revive to complete
*/
bot_revive_wait( revive )
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "bot_try_use_fail" );
	self endon( "bot_try_use_success" );

	timer = 0;

	for ( reviveTime = GetDvarInt( "revive_time_taken" ); timer < reviveTime; timer += 0.05 )
	{
		wait 0.05;

		if ( !isDefined( revive ) || !isDefined( revive.revivetrigger ) )
		{
			self notify( "bot_try_use_fail" );
			return;
		}
	}

	self notify( "bot_try_use_success" );
}

/*
	Bots revive
*/
bots_use_revive( revive )
{
	level endon( "game_ended" );

	self.revivingTeammate = true;
	revive.currentlyBeingRevived = true;
	self BotFreezeControls( true );

	self.previousprimary = self GetCurrentWeapon();
	self GiveWeapon( "syrette_mp" );
	self thread ChangeToWeapon( "syrette_mp" );
	self SetWeaponAmmoStock( "syrette_mp", 1 );

	self thread bot_revive_wait( revive );

	result = self waittill_any_return( "death", "disconnect", "bot_try_use_fail", "bot_try_use_success" );

	if ( isDefined( self ) )
	{
		self TakeWeapon( "syrette_mp" );

		if ( isdefined ( self.previousPrimary ) && self.previousPrimary != "none" )
			self thread changeToWeapon( self.previousPrimary );

		self.previousprimary = undefined;
		self notify( "completedRevive" );
		self.revivingTeammate = false;

		self BotFreezeControls( false );
	}

	if ( isDefined( revive ) )
	{
		revive.currentlyBeingRevived = false;
	}

	if ( result == "bot_try_use_success" )
	{
		revive.thisPlayerIsInLastStand = false;
		
		if ( isdefined ( revive.previousPrimary ) && revive.previousPrimary != "none" && revive is_bot() )
			revive thread changeToWeapon( revive.previousPrimary );
	}
}

/*
	Changes to the weap
*/
changeToWeapon( weap )
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "game_ended" );

	if ( !self HasWeapon( weap ) )
		return false;

	self BotChangeToWeapon( weap );

	if ( self GetCurrentWeapon() == weap )
		return true;

	self waittill_any_timeout( 5, "weapon_change" );

	return ( self GetCurrentWeapon() == weap );
}

/*
	Bots revive the player
*/
bot_use_revive_thread( revivePlayer )
{
	self thread bots_use_revive( revivePlayer );
	self waittill_any( "bot_try_use_fail", "bot_try_use_success" );
}

/*
	Bots think to go revive
*/
bot_revive_think_loop()
{
	revivePlayer = undefined;

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		if ( !isDefined( player.pers["team"] ) )
			continue;

		if ( player == self )
			continue;

		if ( self.pers["team"] != player.pers["team"] )
			continue;

		if ( !isDefined( player.revivetrigger ) )
			continue;

		if ( isDefined( player.currentlyBeingRevived ) && player.currentlyBeingRevived )
			continue;

		if ( !isDefined( player.revivetrigger.bots ) )
			player.revivetrigger.bots = 0;

		if ( player.revivetrigger.bots > 2 )
			continue;

		revivePlayer = player;
	}

	if ( !isDefined( revivePlayer ) )
		return;

	self BotNotifyBotEvent( "revive", "go", revivePlayer );

	self.bot_lock_goal = true;

	self SetScriptGoal( revivePlayer.origin, 1 );
	self thread bot_inc_bots( revivePlayer.revivetrigger, true );
	self thread bot_go_revive( revivePlayer );

	event = self waittill_any_return( "goal", "bad_path", "new_goal" );

	if ( event != "new_goal" )
		self ClearScriptGoal();

	if ( event != "goal" || !isDefined( revivePlayer ) || ( isDefined( revivePlayer.currentlyBeingRevived ) && revivePlayer.currentlyBeingRevived ) || !self isTouching( revivePlayer.revivetrigger ) || self InLastStand() )
	{
		self.bot_lock_goal = false;
		return;
	}

	self BotNotifyBotEvent( "revive", "start", revivePlayer );

	self SetScriptGoal( self.origin, 64 );

	self bot_use_revive_thread( revivePlayer );
	wait 1;
	self ClearScriptGoal();
	self.bot_lock_goal = false;

	self BotNotifyBotEvent( "revive", "stop", revivePlayer );
}

/*
	Increments the number of bots approching the obj, decrements when needed
	Used for preventing too many bots going to one obj, or unreachable objs
*/
bot_inc_bots( obj, unreach )
{
	level endon( "game_ended" );
	self endon( "bot_inc_bots" );

	if ( !isDefined( obj ) )
		return;

	if ( !isDefined( obj.bots ) )
		obj.bots = 0;

	obj.bots++;

	ret = self waittill_any_return( "death", "disconnect", "bad_path", "goal", "new_goal" );

	if ( isDefined( obj ) && ( ret != "bad_path" || !isDefined( unreach ) ) )
		obj.bots--;
}

/*
	Bots think to go revive
*/
bot_revive_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		wait randomintrange( 2, 5 );

		if ( !level.teamBased )
			continue;

		if ( !self.canreviveothers )
			continue;

		if ( self HasScriptGoal() || self.bot_lock_goal )
			continue;

		if ( self inLastStand() )
			continue;

		self bot_revive_think_loop();
	}
}

/*
	Bots go to the revive
*/
bot_go_revive( revive )
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	self endon( "goal" );
	self endon( "bad_path" );
	self endon( "new_goal" );

	for ( ;; )
	{
		wait 1;

		if ( !isDefined( revive ) )
			break;

		if ( !isDefined( revive.revivetrigger ) )
			break;

		if ( self isTouching( revive.revivetrigger ) )
			break;
	}

	if ( !isDefined( revive ) || !isDefined( revive.revivetrigger ) )
		self notify( "bad_path" );
	else
		self notify( "goal" );
}

/*
	Bot logic for bot determining to camp.
*/
bot_think_camp_loop()
{
	campSpot = getWaypointForIndex( PickRandom( self waypointsNear( getWaypointsOfType( "camp" ), 1024 ) ) );

	if ( !isDefined( campSpot ) )
		return;

	self SetScriptGoal( campSpot.origin, 16 );

	time = randomIntRange( 10, 20 );

	self BotNotifyBotEvent( "camp", "go", campSpot, time );

	ret = self waittill_any_return( "new_goal", "goal", "bad_path" );

	if ( ret != "new_goal" )
		self ClearScriptGoal();

	if ( ret != "goal" )
		return;

	self BotNotifyBotEvent( "camp", "start", campSpot, time );

	self thread killCampAfterTime( time );
	self CampAtSpot( campSpot.origin, campSpot.origin + AnglesToForward( campSpot.angles ) * 2048 );

	self BotNotifyBotEvent( "camp", "stop", campSpot, time );
}

/*
	Bot logic for bot determining to camp.
*/
bot_think_camp()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		wait randomintrange( 4, 7 );

		if ( self HasScriptGoal() || self.bot_lock_goal || self HasScriptAimPos() )
			continue;

		if ( randomInt( 100 ) > self.pers["bots"]["behavior"]["camp"] )
			continue;

		self bot_think_camp_loop();
	}
}

/*
	Kills the camping thread when time
*/
killCampAfterTime( time )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "kill_camp_bot" );

	wait time + 0.05;
	self ClearScriptGoal();
	self ClearScriptAimPos();

	self notify( "kill_camp_bot" );
}

/*
	Kills the camping thread when ent gone
*/
killCampAfterEntGone( ent )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "kill_camp_bot" );

	for ( ;; )
	{
		wait 0.05;

		if ( !isDefined( ent ) )
			break;
	}

	self ClearScriptGoal();
	self ClearScriptAimPos();

	self notify( "kill_camp_bot" );
}

/*
	Camps at the spot
*/
CampAtSpot( origin, anglePos )
{
	self endon( "kill_camp_bot" );

	self SetScriptGoal( origin, 64 );

	if ( isDefined( anglePos ) )
	{
		self SetScriptAimPos( anglePos );
	}

	self waittill( "new_goal" );
	self ClearScriptAimPos();

	self notify( "kill_camp_bot" );
}

/*
	Bot logic for bot determining to follow another player.
*/
bot_think_follow_loop()
{
	follows = [];
	distSq = self.pers["bots"]["skill"]["help_dist"] * self.pers["bots"]["skill"]["help_dist"];

	for ( i = level.players.size - 1; i >= 0; i-- )
	{
		player = level.players[i];

		if ( player == self )
			continue;

		if ( !isAlive( player ) )
			continue;

		if ( player.team != self.team )
			continue;

		if ( DistanceSquared( player.origin, self.origin ) > distSq )
			continue;

		follows[follows.size] = player;
	}

	toFollow = PickRandom( follows );

	if ( !isDefined( toFollow ) )
		return;

	time = randomIntRange( 10, 20 );

	self BotNotifyBotEvent( "follow", "start", toFollow, time );

	self thread killFollowAfterTime( time );
	self followPlayer( toFollow );

	self BotNotifyBotEvent( "follow", "stop", toFollow, time );
}

/*
	Bot logic for bot determining to follow another player.
*/
bot_think_follow()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		wait randomIntRange( 3, 5 );

		if ( self HasScriptGoal() || self.bot_lock_goal || self HasScriptAimPos() )
			continue;

		if ( randomInt( 100 ) > self.pers["bots"]["behavior"]["follow"] )
			continue;

		if ( !level.teamBased )
			continue;

		self bot_think_follow_loop();
	}
}

/*
	Kills follow when new goal
*/
watchForFollowNewGoal()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "kill_follow_bot" );

	for ( ;; )
	{
		self waittill( "new_goal" );

		if ( !isDefined( self.bot_was_follow_script_update ) )
			break;
	}

	self ClearScriptAimPos();
	self notify( "kill_follow_bot" );
}

/*
	Kills follow when time
*/
killFollowAfterTime( time )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "kill_follow_bot" );

	wait time;

	self ClearScriptGoal();
	self ClearScriptAimPos();
	self notify( "kill_follow_bot" );
}

/*
	Determine bot to follow a player
*/
followPlayer( who )
{
	self endon( "kill_follow_bot" );

	self thread watchForFollowNewGoal();

	for ( ;; )
	{
		wait 0.05;

		if ( !isDefined( who ) || !isAlive( who ) )
			break;

		self SetScriptAimPos( who.origin + ( 0, 0, 42 ) );
		myGoal = self GetScriptGoal();

		if ( isDefined( myGoal ) && DistanceSquared( myGoal, who.origin ) < 64 * 64 )
			continue;

		self.bot_was_follow_script_update = true;
		self SetScriptGoal( who.origin, 32 );
		waittillframeend;
		self.bot_was_follow_script_update = undefined;

		self waittill_either( "goal", "bad_path" );
	}

	self ClearScriptGoal();
	self ClearScriptAimPos();

	self notify( "kill_follow_bot" );
}