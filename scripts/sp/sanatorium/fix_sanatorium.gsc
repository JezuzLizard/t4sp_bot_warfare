#include common_scripts\utility;
#include maps\_utility;

main()
{
	replaceFunc( getFunction( "maps/sanatorium", "ch_ds" ), ::noop );
	replaceFunc( getFunction( "maps/sanatorium", "wurst" ), ::noop );
	replaceFunc( getFunction( "maps/sanatorium", "staminup" ), ::noop );

	replaceFunc( getFunction( "maps/_zombiemode_weap_zombie_shield", "shield_destroy_player_model" ), ::fix_shield_destroy_player_model );
	replaceFunc( getFunction( "maps/altmelee_mod", "get_galvaknuckles" ), ::fix_get_galvaknuckles );
	replaceFunc( getFunction( "maps/_zombiemode_weap_zombie_shield", "shield_bowie_watcher" ), ::fix_shield_bowie_watcher );
	replaceFunc( getFunction( "maps/walking_anim", "walk_main" ), ::fix_walk_main );
	replaceFunc( getFunction( "maps/walking_anim", "rot_main" ), ::fix_rot_main );
	replaceFunc( getFunction( "maps/walking_anim", "prone_checks" ), ::fix_prone_checks );
	replaceFunc( getFunction( "maps/sanatorium", "staminup_sprint" ), ::fix_staminup_sprint );
}

fix_staminup_sprint()
{
	self endon( "disconnect" );

	func = getFunction( "maps/sanatorium", "staminup_sprint" );
	disableDetourOnce( func );
	self [[func]]();
}

fix_walk_main()
{
	self endon( "disconnect" );

	func = getFunction( "maps/walking_anim", "walk_main" );
	disableDetourOnce( func );
	self [[func]]();
}

fix_prone_checks()
{
	self endon( "disconnect" );

	func = getFunction( "maps/walking_anim", "prone_checks" );
	disableDetourOnce( func );
	self [[func]]();
}

fix_rot_main()
{
	self endon( "disconnect" );

	func = getFunction( "maps/walking_anim", "rot_main" );
	disableDetourOnce( func );
	self [[func]]();
}

fix_shield_destroy_player_model()
{
	if ( !isDefined( self ) )
		return;

	temp_size = self getAttachSize();

	if ( !isDefined( temp_size ) )
		return;

	func = getFunction( "maps/_zombiemode_weap_zombie_shield", "shield_destroy_player_model" );
	disableDetourOnce( func );
	self [[func]]();
}

fix_get_galvaknuckles()
{
	galva_trig = getent( "galvaknuckles", "targetname" );

	if ( !isDefined( galva_trig ) )
		return;

	func = getFunction( "maps/altmelee_mod", "get_galvaknuckles" );
	disableDetourOnce( func );
	self [[func]]();
}

fix_shield_bowie_watcher()
{
	self endon( "disconnect" );

	func = getFunction( "maps/_zombiemode_weap_zombie_shield", "shield_bowie_watcher" );
	disableDetourOnce( func );
	self [[func]]();
}

noop()
{
}
