init()
{
	level.bot_builtins[ "printconsole" ] = ::do_printconsole;
	level.bot_builtins[ "botaction" ] = ::do_botaction;
	level.bot_builtins[ "botstop" ] = ::do_botstop;
	level.bot_builtins[ "botmovement" ] = ::do_botmovement;
	level.bot_builtins[ "botmeleeparams" ] = ::do_botmeleeparams;
	level.bot_builtins[ "isbot" ] = ::do_isbot;
	level.bot_builtins[ "generatepath" ] = ::do_generatepath;
	level.bot_builtins[ "getfunction" ] = ::do_getfunction;
	level.bot_builtins[ "getmins" ] = ::do_getmins;
	level.bot_builtins[ "getmaxs" ] = ::do_getmaxs;
	level.bot_builtins[ "getguid" ] = ::do_getguid;
	level.bot_builtins[ "setallowedtraversals" ] = ::do_setallowedtraversals;
	level.bot_builtins[ "setignoredlinks" ] = ::do_setignoredlinks;
	level.bot_builtins[ "getnodenumber" ] = ::do_getnodenumber;
	level.bot_builtins[ "getlinkednodes" ] = ::do_getlinkednodes;
	level.bot_builtins[ "addtestclient" ] = ::do_addtestclient;
	level.bot_builtins[ "notifyonplayercommand" ] = ::do_notifyonplayercommand;
	level.bot_builtins[ "cmdexec" ] = ::do_cmdexec;
	level.bot_builtins[ "ishost" ] = ::do_ishost;
}

do_printconsole( s )
{
	printconsole( s );
}

do_botaction( action )
{
	self botaction( action );
}

do_botstop()
{
	self botstop();
}

do_botmovement( left, forward )
{
	self botmovement( left, forward );
}

do_botmeleeparams( yaw, dist )
{
	// self botmeleeparams( yaw, dist );
}

do_isbot()
{
	return self isbot();
}

do_generatepath( from, to, team, best_effort )
{
	return generatepath( from, to, team, best_effort );
}

do_getfunction( file, threadname )
{
	return getfunction( file, threadname );
}

do_getmins()
{
	return self getmins();
}

do_getmaxs()
{
	return self getmaxs();
}

do_getguid()
{
	return self getguid();
}

do_setallowedtraversals( a )
{
	setallowedtraversals( a );
}

do_setignoredlinks( a )
{
	setignoredlinks( a );
}

do_getnodenumber()
{
	return self getnodenumber();
}

do_getlinkednodes()
{
	return self getlinkednodes();
}

do_addtestclient()
{
	return addtestclient();
}

do_notifyonplayercommand( a, b )
{
	self notifyonplayercommand( a, b );
}

do_cmdexec( a )
{
	cmdexec( a );
}

do_ishost()
{
	return self ishost();
}
