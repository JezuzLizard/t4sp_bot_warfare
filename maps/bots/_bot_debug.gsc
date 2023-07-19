/*
	_bot_debug
	Author: INeedGames
	Date: 07/09/2023
	The ingame waypoint visualizer. Designed to be ran on the client (not the server)
*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\bots\_bot_utility;

init()
{
	if ( getDvar( "bots_main_debug" ) == "" )
		setDvar( "bots_main_debug", 0 );

	if ( !getDVarint( "bots_main_debug" ) || !getDVarint( "bots_main_debug_wp_vis" ) )
		return;

	if ( !getDVarint( "developer" ) )
	{
		setdvar( "developer_script", 1 );
		setdvar( "developer", 2 );

		setdvar( "sv_mapRotation", "map " + getDvar( "mapname" ) );
		exitLevel( false );
		return;
	}

	setDvar( "bots_main", false );
	setdvar( "bots_main_menu", false );
	setdvar( "bots_manage_fill_mode", 0 );
	setdvar( "bots_manage_fill", 0 );
	setdvar( "bots_manage_add", 0 );
	setdvar( "bots_manage_fill_kick", true );
	setDvar( "bots_manage_fill_spec", true );

	if ( getDvar( "bots_main_debug_distance" ) == "" )
		setDvar( "bots_main_debug_distance", 512.0 );

	if ( getDvar( "bots_main_debug_cone" ) == "" )
		setDvar( "bots_main_debug_cone", 0.65 );

	if ( getDvar( "bots_main_debug_minDist" ) == "" )
		setDvar( "bots_main_debug_minDist", 32.0 );

	if ( getDvar( "bots_main_debug_drawThrough" ) == "" )
		setDvar( "bots_main_debug_drawThrough", false );

	thread load_waypoints();

	level waittill( "connected", player );
	player thread onPlayerSpawned();
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );
		self thread beginDebug();
	}
}

beginDebug()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	self thread debug();
	self thread textScroll( "^1xDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD" );
}

debug()
{
	self endon( "disconnect" );
	self endon( "zombified" );

	for ( ;; )
	{
		wait 0.05;

		closest = -1;
		myEye = self getTagOrigin( "j_head" );
		myAngles = self GetPlayerAngles();

		for ( i = 0; i < level.waypointCount; i++ )
		{
			if ( closest == -1 || closer( self.origin, level.waypoints[i].origin, level.waypoints[closest].origin ) )
				closest = i;

			wpOrg = level.waypoints[i].origin + ( 0, 0, 25 );

			if ( distance( level.waypoints[i].origin, self.origin ) < getDvarFloat( "bots_main_debug_distance" ) && ( sightTracePassed( myEye, wpOrg, false, self ) || getDVarint( "bots_main_debug_drawThrough" ) ) && getConeDot( wpOrg, myEye, myAngles ) > getDvarFloat( "bots_main_debug_cone" ) )
			{
				linked = level.waypoints[i] getLinkedNodes();
				node_num_str = level.waypoints[i] getNodeNumber() + "";

				for ( h = linked.size - 1; h >= 0; h-- )
				{
					if ( isDefined( level.bot_ignore_links[node_num_str] ) )
					{
						found = false;
						this_node_num = linked[h] getNodeNumber();

						for ( j = 0; j < level.bot_ignore_links[node_num_str].size; j++ )
						{
							if ( level.bot_ignore_links[node_num_str][j] == this_node_num )
							{
								found = true;
								break;
							}
						}

						if ( found )
							continue;
					}

					line( wpOrg, linked[h].origin + ( 0, 0, 25 ), ( 1, 0, 1 ) );
				}

				print3d( wpOrg, node_num_str, ( 1, 0, 0 ), 2 );

				if ( isDefined( level.waypoints[i].animscript ) )
				{
					line( wpOrg, wpOrg + AnglesToForward( level.waypoints[i].angles ) * 64, ( 1, 1, 1 ) );
					print3d( wpOrg + ( 0, 0, 15 ), level.waypoints[i].animscript, ( 1, 0, 0 ), 2 );
				}
			}
		}
	}
}

destroyOnDeath( hud )
{
	hud endon( "death" );
	self waittill_either( "zombified", "disconnect" );
	hud destroy();
}

textScroll( string )
{
	self endon( "zombified" );
	self endon( "disconnect" );
	//thanks ActionScript

	back = createBar( ( 0, 0, 0 ), 1000, 30 );
	back setPoint( "CENTER", undefined, 0, 220 );
	self thread destroyOnDeath( back );

	text = createFontString( "default", 1.5 );
	text setText( string );
	self thread destroyOnDeath( text );

	for ( ;; )
	{
		text setPoint( "CENTER", undefined, 1200, 220 );
		text setPoint( "CENTER", undefined, -1200, 220, 20 );
		wait 20;
	}
}
