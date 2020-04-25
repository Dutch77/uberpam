serverbot()
{
	level.onepointzero = 1.0;
	
	wait level.onepointzero * 1;

	mode = getcvar("pam_mode");
	
	if (mode != "pub")
	{
		thread serverbot_actions();

		logprint("ServerBOT has been loaded \n");
		wait level.onepointzero * 300;
		iprintln("ServerBOT has been loaded");
	}
	else
	{
		wait level.onepointzero * 300;
		iprintln("Cannot load ServerBOT");
	}
}

serverbot_actions()
{
	// start of PLAYER_information() variables
	pam_player_name = [];
	pam_player_position = [];
	pam_player_angle = [];
	pam_player_health = [];
	pam_player_score = [];
	pam_player_deaths = [];
	pam_player_weapon = [];
	pam_player_team = [];
	pam_player_readiness = [];
	pam_player_id = [];
	pam_player_state = [];
	pam_player_defuses = [];
	pam_player_plants = [];	
	// end of PLAYER_information() variables

	for(;;)
	{
		// start of SD_events()
		pam_sd_event_plantedbomb = getcvar("bombplantano");
		pam_sd_event_defusedbomb = getcvar("bombdefano");
		pam_sd_event_kill = getcvar("killinstuff");
		pam_sd_event_calledtimeout = getcvar("pam_calledtimeout");
		pam_sd_event_canceledtimeout = getcvar("calledtimeoutcan2");
		pam_sd_event_wonround = getcvar("teamwon3");
		
		pam_sd_event = pam_sd_event_calledtimeout + "/" + pam_sd_event_canceledtimeout + "/" + pam_sd_event_wonround + "/" + pam_sd_event_defusedbomb + "/" + pam_sd_event_plantedbomb + "/" + pam_sd_event_kill;
		setcvar("pam_sd_info_event", pam_sd_event);
		// end of SD_events()

		// start of SD_information_static()
		pam_sd_gametype = getcvar("g_gametype");
		pam_sd_map = getcvar("mapname");
		pam_sd_roundlength = getcvar("scr_sd_roundlength"); //x60 length of round
		pam_sd_strattime = getcvar("scr_sd_strat_time") + 2;
		pam_sd_halftimelength = getcvar("g_halftime_ready"); //x60 length of halftime
		pam_sd_timeoutlength = getcvar("g_to_length"); //length of timeout
		pam_sd_timeoutmatch = getcvar("g_to"); //timeouts per match
		pam_sd_timeoutside = getcvar("g_to_side"); //timeouts per side
		pam_sd_bombexplodes = getcvar("scr_sd_bombtimer"); // bomb explodes in - nema x60
		pam_sd_halftimerounds = getcvar("scr_sd_half_round"); // rounds per side
		pam_sd_maxrounds = getcvar("scr_sd_end_round"); // max rounds per map
		pam_sd_endscore = getcvar("scr_sd_end_score"); // needed score to finish map
		pam_sd_ruleset = getcvar("pam_mode"); //what ruleset
	
		pam_sd_static = pam_sd_gametype + "/" + pam_sd_roundlength + "/" + pam_sd_halftimelength + "/" + pam_sd_timeoutlength + "/" + pam_sd_timeoutmatch + "/" + pam_sd_timeoutside + "/" + pam_sd_bombexplodes + "/" + pam_sd_halftimerounds + "/" + pam_sd_maxrounds + "/" + pam_sd_endscore + "/" + pam_sd_ruleset + "/" + pam_sd_map + "/" + pam_sd_strattime;
		setcvar("pam_sd_info_static", pam_sd_static);
		// end of SD_information_static()

		// start of SD_information_dynamic()
		pam_sd_alliedscore = getTeamScore("allies");
		pam_sd_axisscore = getTeamScore("axis");		
		pam_sd_isintimeout = getcvar("utimeu");
		pam_sd_ishalftime = getcvar("halfooo");
		pam_sd_isinreadyup = getcvar("urupuu"); 
		pam_sd_isinwarmup = getcvar("uwup");
		pam_sd_isbombplanted = getcvar("bombplented2");
		pam_sd_isstrattime = getcvarint("isstrattime2");
		pam_sd_roundended = getcvar("endround3d");
		pam_sd_matchstarting = getcvar("matchstartingy");
			
		pam_sd_dynamic = pam_sd_alliedscore + "/" + pam_sd_axisscore + "/" + pam_sd_isintimeout + "/" + pam_sd_isinreadyup + "/" + pam_sd_isinwarmup + "/" + pam_sd_ishalftime + "/" + pam_sd_isbombplanted + "/" + pam_sd_isstrattime + "/" + pam_sd_roundended + "/" + pam_sd_matchstarting;
		setcvar("pam_sd_info_dynamic", pam_sd_dynamic);
		// end of SD_information_dynamic()

		// start of PLAYER_information()
		pam_player0 = "empty";
		pam_player1 = "empty";
		pam_player2 = "empty";
		pam_player3 = "empty";
		pam_player4 = "empty";
		pam_player5 = "empty";
		pam_player6 = "empty";
		pam_player7 = "empty";
		pam_player8 = "empty";
		pam_player9 = "empty";	

		setcvar("pam_info_player0", pam_player0);
		setcvar("pam_info_player1", pam_player1);
		setcvar("pam_info_player2", pam_player2);
		setcvar("pam_info_player3", pam_player3);
		setcvar("pam_info_player4", pam_player4);
		setcvar("pam_info_player5", pam_player5);
		setcvar("pam_info_player6", pam_player6);
		setcvar("pam_info_player7", pam_player7);
		setcvar("pam_info_player8", pam_player8);
		setcvar("pam_info_player9", pam_player9);
	
		players = getentarray("player", "classname");
	
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
				
			if (player.pers["team"] != "spectator")
			{
				pam_player_name[i] = player.name;
				pam_player_position[i] = player.origin;
				pam_player_angle[i] = player.angles;
				pam_player_health[i] = player.health;
				pam_player_score[i] = player.score;
				pam_player_deaths[i] = player.deaths;
				pam_player_weapon[i] = player GetCurrentWeapon();
				pam_player_team[i] = player.pers["team"];
				pam_player_readiness[i] = player.pers["readiness"];
				pam_player_id[i] = player getEntityNumber();
				pam_player_state[i] = player.sessionstate;
				pam_player_defuses[i] = player.pers["playerdefuses"];
				pam_player_plants[i] = player.pers["playerplants"];
		
				pam_player[i] = pam_player_position[i] + "/" + pam_player_angle[i] + "/" + pam_player_name[i] + "/" + pam_player_health[i] + "/" + pam_player_score[i] + "/" + pam_player_deaths[i] + "/" + pam_player_team[i] + "/" + pam_player_weapon[i] + "/" + pam_player_readiness[i] + "/" + pam_player_id[i] + "/" + pam_player_defuses[i] + "/" + pam_player_plants[i] + "/" + pam_player_state[i];
					
				if (i == 0)
					setcvar("pam_info_player0", pam_player[i]);
				else if (i == 1)
					setcvar("pam_info_player1", pam_player[i]);
				else if (i == 2)	
					setcvar("pam_info_player2", pam_player[i]);
				else if (i == 3)
					setcvar("pam_info_player3", pam_player[i]);
				else if (i == 4)
					setcvar("pam_info_player4", pam_player[i]);
				else if (i == 5)
					setcvar("pam_info_player5", pam_player[i]);
				else if (i == 6)
					setcvar("pam_info_player6", pam_player[i]);
				else if (i == 7)
					setcvar("pam_info_player7", pam_player[i]);
				else if (i == 8)
					setcvar("pam_info_player8", pam_player[i]);
				else if (i == 9)
					setcvar("pam_info_player9", pam_player[i]);
			}
		}
		// end of PLAYER_information()

		// start of event restart
		re_event = getcvarint("pam_serverbot_event_restart");

		if (isdefined(re_event) && re_event == 1)
		{
			game["timesto"] = 0;
			game["timestoc"] = 0;
			game["plantton"] = 0;
			game["defannono"] = 0;
			game["killonja"] = 0;
			game["timowo"] = 0;
			
			restart_event = "/////";
			setcvar("pam_sd_info_event", restart_event);
			setcvar("pam_serverbot_event_restart", 0);

			logprint("ServerBOT has been restarted \n");

			iprintln("ServerBOT has been restarted");
		}
		// end of event restart
		
		// start of wait
		level.pam_refreshtime_serverbot = getcvarfloat("pam_serverbot_refreshtime");

		if(isdefined(level.pam_refreshtime_serverbot) && level.pam_refreshtime_serverbot > 0)
			wait level.onepointzero * level.pam_refreshtime_serverbot;
		else
			wait level.onepointzero * 0.2;
		// end of wait
	}
}	