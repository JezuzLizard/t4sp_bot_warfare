#include common_scripts\utility;
#include maps\_utility;
#include maps\bots\_bot_utility;
#include maps\bots\script_objectives\_obj_common;

store_powerups_dropped()
{
	level endon( "end_game" );

	level thread free_powerups_dropped();

	level.zbots_powerups = [];
	while ( true )
	{
		level waittill( "powerup_dropped", powerup );
		waittillframeend;
		if ( !isDefined( powerup ) )
		{
			continue;
		}
		add_possible_bot_objective( "powerup", powerup, true );
		//maps\bots\_bot_utility::assign_priority_to_powerup( powerup );
		//level.zbots_powerups = maps\bots\_bot_utility::sort_array_by_priority_field( level.zbots_powerups, powerup );
	}
}

free_powerups_dropped()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "powerup_freed", powerup );
		free_bot_objective( "powerup", powerup );
	}
}

watch_for_downed_players()
{
	level endon( "end_game" );

	while ( true )
	{
		level waittill( "player_entered_laststand", player );
		if ( !isDefined( player ) )
		{
			continue;
		}
		add_possible_bot_objective( "revive", player, true );
		player thread free_revive_objective_when_needed();
	}
}

free_revive_objective_when_needed()
{
	level endon( "end_game" );

	id = self.id;
	while ( isDefined( self ) && isDefined( self.revivetrigger ) )
	{
		wait 0.05;
	}

	free_bot_objective( "revive", self, id );
}

bot_valid_pump()
{
	level endon( "end_game" );

	obj_sav = undefined;

	while ( true )
	{
		obj_sav = self.zbot_current_objective;
		wait 0.5;
		if ( !maps\so\zm_common\_zm_utility::is_player_valid( self ) )
		{
			if ( isDefined( self ) )
			{
				self notify( "bot_in_invalid_state" );
				self bot_clear_objective();
			}
			else if ( isDefined( obj_sav ) )
			{
				//set_bot_global_shared_objective_owner_by_ent( obj_sav.group, obj_sav.target_ent, undefined );
			}

			while ( isDefined( self ) && !maps\so\zm_common\_zm_utility::is_player_valid( self ) )
			{
				wait 0.5;
			}
			if ( !isDefined( self ) )
			{
				return;
			}
		}
	}
}

bot_objective_inaccessible_pump()
{
	self endon( "disconnect" );
	level endon( "end_game" );

	while ( true )
	{
		invalid_obj = false;
		wait 0.5;
		while ( !self bot_has_objective() )
		{
			wait 0.5;
		}
		
		while ( self bot_has_objective() )
		{
			wait 1;
			obj = self bot_get_objective();
			
			if ( !isDefined( obj ) || !isDefined( obj.target_ent ) )
			{
				invalid_obj = true;
			}
			else if ( !isDefined( generatePath( self.origin, obj.target_ent.origin, self.team, level.bot_allowed_negotiation_links ) ) )
			{
				invalid_obj = true;
			}
			if ( invalid_obj )
			{
				self notify( "bot_objective_inaccessible" );
				self.bot.path_inaccessible = true;
				break;
			}
		}
	}
}

watch_magicbox_objectives()
{
	level endon( "end_game" );

	level waittill( "connected", player );

	prev_magicbox = maps\so\zm_common\_zm_magicbox::get_active_magicbox();
	while ( true )
	{
		cur_magicbox = maps\so\zm_common\_zm_magicbox::get_active_magicbox();
		if ( prev_magicbox != cur_magicbox )
		{
			add_possible_bot_objective( "magicbox", cur_magicbox, false );
			free_bot_objective( "magicbox", prev_magicbox );
			prev_magicbox = cur_magicbox;
		}
		wait 1;
	}
}

bot_on_powerup_grab( powerup )
{
	bot_objective_print( "powerup", powerup getEntityNumber(), "Bot <" + self.playername + "> grabbed powerup" );
	self.successfully_grabbed_powerup = true;
}

bot_on_revive_success( revivee )
{
	bot_objective_print( "revive", revivee getEntityNumber(), "Bot <" + self.playername + "> revived <" + revivee.playername + ">" );
	self.successfully_revived_player = true;
}