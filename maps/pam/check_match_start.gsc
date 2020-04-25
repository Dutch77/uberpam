// For non-Round-based only!
checkMatchStart()
{
	[[level.pam_hud]]("header");

	//Check to see if we even have 2 teams to start
	level.exist["teams"] = 0;	
	
	while(!level.exist["teams"])
	{
		gametype = getcvar("g_gametype");
		players = getentarray("player", "classname");
		
		if (gametype == "dm" && players.size >= 2) 
			{		
			level.exist["allies"] = 1;
			level.exist["axis"] = 1;
		} else {
			level.exist["allies"] = 0;
			level.exist["axis"] = 0;
		}

		//players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		
	
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
				level.exist[player.pers["team"]]++;
		}

		if (level.exist["allies"] && level.exist["axis"])
			level.exist["teams"] = 1;

		if (getcvar("scr_debug_gt") == "1")
			level.exist["teams"] = 1;

		wait level.fps_multiplier * 1;
	}

	game["matchstarted"] = true;

	// We HAVE teams, lets get started!
	game["Do_Ready_up"] = 1;

	iprintln(&"MP_MATCHSTARTING");

	wait level.fps_multiplier * 6;

	if (!level.pam_mode_change)
	{
		level.exiting_map = true;
		map_restart(true);
	}
}
