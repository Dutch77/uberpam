deadchat()
{
	
	//na 1 se tekst vidi
	//na 0 se ne vidi

	//update_teamscore_hud level.roundended
	setcvar("g_deadchat", "1");
	for(;;)
	{	
		/*level.allies_tos = game["allies_tos"];
		level.axis_tos = game["axis_tos"];
		level.allies_tos_half = game["allies_tos_half"];
		level.axis_tos_half = game["axis_tos_half"];
		
		iprintln("game[allies_tos] " + level.allies_tos);
		iprintln("game[axis_tos] " + level.axis_tos);
		iprintln("game[allies_tos_half] " + level.allies_tos_half);
		iprintln("game[axis_tos_half] " + level.axis_tos_half);*/		

		dc = getcvarint("g_deadchat");
	
		if ( ((isDefined(level.rdyup) && level.rdyup) || (isDefined(level.warmup) && level.warmup) || (isDefined(level.mapended) && level.mapended) || (isDefined(level.intimeout) && level.intimeout)) && dc == 0)
			setcvar("g_deadchat", "1");
		
		if ((isDefined(level.instrattime) && level.instrattime) && dc == 1)
			setcvar("g_deadchat", "0");

		if ((isDefined(level.roundstarted) && level.roundstarted) && dc == 1 && !level.roundended_dc)
			setcvar("g_deadchat", "0");

		if ((isDefined(level.roundended_dc) && level.roundended_dc) && dc == 0)
			setcvar("g_deadchat", "1");

		level.kicklen = getcvar("pb_sv_kicklen");
		
		if (isdefined(level.kicklen) && level.kicklen != "0")
			setcvar("pb_sv_kicklen", "0");

		wait 1;	
	}
}

sset()
{
	setcvar("pb_sv_kicklen", "0");
	setcvar("g_deadchat", "1");
}

