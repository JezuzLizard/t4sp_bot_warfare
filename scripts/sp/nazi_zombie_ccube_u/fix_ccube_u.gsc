#include common_scripts\utility;
#include maps\_utility;

main()
{
	// kek
	replacefunc( getFunction( "maps/nazi_zombie_ccube_u", "anti_cheat" ), ::noop );

	// this is BAD gsc, use new impl
	replacefunc( getFunction( "maps/nazi_zombie_ccube_u", "damage_test" ), ::noop );
}

noop()
{
}

init()
{
	// fixes points for hotjoiners
	level thread onPlayerConnect();

	// our impl of memes
	level thread damage_goo();
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );

		player thread onConnect();
	}
}

onConnect()
{
	self endon( "disconnect" );

	self.mk1_suit = 0;
	self.mk3_suit = 0;
	self.mk4_suit = 0;
	self.mk5_suit = 0;
	self.mk6_suit = 0;
	self.mk16_suit = 0;
	self.is_cloaked = false; //needed for Mark 16
	self.is_authorized = false; //needed for Mark 16
	self.wm_suit = 0;
	self.part_hud = [];
	self.used_suit = undefined;
	self disableInvulnerability();
	self setClientDvar( "ui_hud_hardcore", 0 );
}

damage_goo()
{
	//damage_trig = getEnt("damage_trig", "targetname");
	cheese_bottom = getEnt( "cheese_bottom", "targetname" );
	level.quick_revive_ending_game = 0;
	//cheese_bottom notSolid();

	while ( 1 )
	{
		wait .05;

		players = get_players();

		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			player thread check_goo_damage( cheese_bottom );
		}
	}
}

check_goo_damage( cheese_bottom )
{
	self endon( "disconnect" );

	players = get_players();

	if ( self IsTouching( cheese_bottom ) && self.sessionstate != "intermission" && self.sessionstate != "spectator" )
	{
		if ( self hasPerk( "specialty_quickrevive" ) && players.size == 1 )
		{
			level.quick_revive_ending_game = 1;
			self DoDamage( self.health + 666, self.origin );
			wait .5;
			iprintln( "Quick Revive has no power against the dark side of the cheese" );
			level notify( "end_game" );
			wait 3.5;
			iprintln( self.playername + " has touched the dark side of the cheese" );
		}

		if ( !( self hasPerk( "specialty_quickrevive" ) ) && players.size == 1 )
		{
			self DoDamage( self.health + 666, self.origin );
			level notify( "end_game" );
			iprintln( self.playername + " has touched the dark side of the cheese" );
			wait 4;
		}
		else
		{
			self DoDamage( self.health + 666, self.origin );
			iprintln( self.playername + " has touched the dark side of the cheese" );
			//RadiusDamage(self.origin,10,self.health+666,self.health+666);
			wait 5;
		}

		for ( i = 0; i < players.size; i++ )
		{
			players[i] disableInvulnerability();
			wait .1;
		}
	}
}
