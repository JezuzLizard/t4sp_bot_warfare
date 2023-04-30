#include maps\_utility;
#include common_scripts\utility;

main()
{
	level.callbackActorDamage = ::Callback_ActorDamage;
	level.callbackActorKilled = ::Callback_ActorKilled;
}

init()
{
	level thread watchRoundChanges();
}

watchRoundChanges()
{
	current_round = 0;
	setDvar( "sv_zombieRoundNumber", current_round );

	flag_wait( "all_players_connected" );
	waittillframeend;

	for ( ;; )
	{
		while ( !isDefined( level.round_number ) || current_round == level.round_number )
			wait 0.05;

		current_round = level.round_number;
		setDvar( "sv_zombieRoundNumber", current_round );
		level notify( "new_zombie_round", current_round );
	}
}

Callback_ActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset )
{
/*
	PrintConsole( "Callback_ActorDamage:" );
	PrintConsole( "self.classname: " + self.classname );
	PrintConsole( "eInflictor.classname: " + eInflictor.classname );
	PrintConsole( "eAttacker.classname: " + eAttacker.classname );
	PrintConsole( "iDamage: " + iDamage );
	PrintConsole( "iDFlags: " + iDFlags );
	PrintConsole( "sMeansOfDeath: " + sMeansOfDeath );
	PrintConsole( "sWeapon: " + sWeapon );
	PrintConsole( "vPoint: " + vPoint );
	PrintConsole( "vDir: " + vDir );
	PrintConsole( "sHitLoc: " + sHitLoc );
	PrintConsole( "iModelIndex: " + iModelIndex );
	PrintConsole( "iTimeOffset: " + iTimeOffset );
	PrintConsole( "" );
*/

	self FinishActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset );
}

Callback_ActorKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, iTimeOffset )
{
/*
	PrintConsole( "Callback_ActorKilled:" );
	PrintConsole( "self.classname: " + self.classname );
	PrintConsole( "eInflictor.classname: " + eInflictor.classname );
	PrintConsole( "eAttacker.classname: " + eAttacker.classname );
	PrintConsole( "iDamage: " + iDamage );
	PrintConsole( "sMeansOfDeath: " + sMeansOfDeath );
	PrintConsole( "sWeapon: " + sWeapon );
	PrintConsole( "vDir: " + vDir );
	PrintConsole( "sHitLoc: " + sHitLoc );
	PrintConsole( "iTimeOffset: " + iTimeOffset );
	PrintConsole( "" );
*/
}

CodeCallback_ActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset )
{
	self [[level.callbackActorDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, iModelIndex, iTimeOffset );
}

CodeCallback_ActorKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, iTimeOffset )
{
	self [[level.callbackActorKilled]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, iTimeOffset );
}
