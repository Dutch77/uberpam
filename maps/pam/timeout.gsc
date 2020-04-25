#include maps\mp\_utility;

Validate_Timeout(playerEnt)
{
	if (!isDefined(game["allies_tos"]))
		game["allies_tos"] = 0;
	if (!isDefined(game["axis_tos"]))
		game["axis_tos"] = 0;
	if (!isDefined(game["allies_tos_half"]))
		game["allies_tos_half"] = 0;
	if (!isDefined(game["axis_tos_half"]))
		game["axis_tos_half"] = 0;
		
	/*iwds = getcvar("sv_referencediwds");
	iwdnames = getcvar("sv_referencediwdnames");
	iprintln(iwds);
	iprintln(iwdnames);*/
	if (game["timeout"])
	{
		return; // don't bother evaluating if it's already in TO
	}
	
	if(!isDefined(game["to"]) || game["to"] < 1)
	{
		playerEnt iprintln("Time-out is not supported by the rules");
		return;
	}
	
	gametype = getcvar("g_gametype");	

	if ((level.rdyup || !game["matchstarted"] || level.warmup || level.mapended || !isDefined(game["firstreadyupdone"])) && gametype != "strat" )
	{
		playerEnt iprintln("Can only call time-out once the match starts");
		return;
	}
	
	if (playerEnt.pers["team"] == "allies")
	{
		if (game["to"] > game["allies_tos"])
		{
			if (game["to_side"] > game["allies_tos_half"])
			{
				game["allies_tos"]++;
				game["allies_tos_half"]++;
			}
			else
			{
				playerEnt iprintln("No more time-outs permitted for allies in this half");
				return;
			}
		}
		else
		{
			playerEnt iprintln("No more time-outs permitted for allies");
			return;
		}
	}
	else
	{
		if (game["to"] > game["axis_tos"])
		{
			if (game["to_side"] > game["axis_tos_half"])
			{
				game["axis_tos"]++;
				game["axis_tos_half"]++;
			}
			else
			{
				playerEnt iprintln("No more time-outs permitted for axis in this half");
				return;
			}
			
		}
		else
		{
			playerEnt iprintln("No more time-outs permitted for axis");
			return;
		}
	}
	
	iprintln(playerEnt.name + " ^7called a time-out for team " + playerEnt.pers["team"]);

	game["teamcalledto"] = playerEnt.pers["team"];
	game["timesto"]++;
	pam_timeoutcalled_var = playerEnt.name + "¦" + playerEnt.pers["team"] + "¦" + game["timesto"];
	setcvar("pam_calledtimeout", pam_timeoutcalled_var);

	switch(level.gametype)
	{
		case "sd": TO_Round_Based();break;
		case "ctf": 
		case "tdm": TO_Time_Based(); break;
		case "dm": TO_Time_Based(); break;
		case "hq":
		default: playerEnt iprintln("Time-out is not supported in this gametype"); break;
	}
	logPrint("TOC;" + playerEnt.pers["team"] + ";" + playerEnt.name + "\n");
}

TO_Rup()
{
	level.intimeout = 1; //bilo na ++
	setcvar("utimeu", 1);
	level notify("timeoutcalled");
	game["timeout"] = true;
	setcvar("g_speed", 0);
	//display scores
	[[level.pam_hud]]("header");

	if(isDefined(level.clock))
		level.clock destroy();

	to = newHudElem();
	to.x = 575;
	to.y = 170;
	to.alignX = "center";
	to.alignY = "middle";
	to.fontScale = 1.2;
	to.color = (1, 1, 0);
	to setText(game["timeouthead"]);
	
	thread Handle_Weapons();
	wait level.fps_multiplier * 1;
	//[[level.pam_hud]]("scoreboard");

	level.rdyup = 1;
	setcvar("urupuu", 1);	

	level.warmup = 0;
	setcvar("uwup", 0);

	level.playersready = false;

	level.waiting = newHudElem();
	level.waiting.alignX = "center";
	level.waiting.alignY = "middle";
	level.waiting.color = (.8, 1, 1);
	level.waiting.x = 320;
	level.waiting.y = 370;
	level.waiting.fontScale = 1.5;
	level.waiting.font = "default";
	level.waiting setText(game["waiting"]);

	setClientNameMode("auto_change");
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player.pers["killer"] = 0;

		lpselfnum = player getEntityNumber();
		player.statusicon = "party_notready";
		level.R_U_Name[lpselfnum] = player.name;
		level.R_U_State[lpselfnum] = "notready";
		player.R_U_Looping = 0;

		player thread maps\pam\readyup::readyup(lpselfnum);
	}
	if(game["to_length"] != 0)
		thread TO_Clock();
	thread TO_Stats();

	maps\pam\readyup::Waiting_On_Players();

	if(isdefined(level.waiting))
		level.waiting destroy();
	if (isdefined(to))
		to destroy();
	if (isdefined(level.to_clock))
		level.to_clock destroy();
	if (isdefined(level.to_resume))
		level.to_resume destroy();
	if (isdefined(level.to_count_header))
		level.to_count_header destroy();
	if (isdefined(level.to_count_ax))
		level.to_count_ax destroy();
	if (isdefined(level.to_count_axtos))
		level.to_count_axtos destroy();
	if (isdefined(level.to_count_al))
		level.to_count_al destroy();
	if (isdefined(level.to_count_altos))
		level.to_count_altos destroy();

	setClientNameMode("auto_change");
	game["dolive"] = 1;
	level.rdyup = 0;
	setcvar("urupuu", 0);

	level.warmup = 0;
	setcvar("uwup", 0);

	[[level.pam_hud]]("kill_all");

	Match_Resume();
}

TO_Clock()
{
	level endon("timeoutover");
		
	to_header = 320;
	to_teamsy = to_header + 15;
	//to_county = to_header + 28;

	level.to_resume = newHudElem();
	level.to_resume.x = 575;
	//level.to_resume.y = to_header;
	level.to_resume.y = 245;
	level.to_resume.color = (0.8, 0.3, 0);
	level.to_resume.alignX = "center";
	level.to_resume.alignY = "middle";
	level.to_resume.font = "default";
	level.to_resume.fontscale = 1.2;
	level.to_resume setText(game["resuming"]);
	
	level.to_clock = newHudElem();
	level.to_clock.x = 575;
	//level.to_clock.y = to_teamsy;
	level.to_clock.y = 260;
	level.to_clock.alignX = "center";
	level.to_clock.alignY = "middle";
	level.to_clock.font = "default";
	level.to_clock.fontscale = 1.2;
	level.to_clock setTimer(game["to_length"] * 60);
		
	wait 1;
	
	wait level.fps_multiplier * game["to_length"] * 60;
	
	level.playersready = true;
	if (isdefined(level.to_clock))
		level.to_clock destroy();
	if (isdefined(level.to_resume))
		level.to_resume destroy();
	
	setClientNameMode("auto_change");
	game["dolive"] = 1;
	level.rdyup = 0;
	setcvar("urupuu", 0);

	level.warmup = 0;
	setcvar("uwup", 0);

	[[level.pam_hud]]("kill_all");

	Match_Resume();
}

TO_Stats()
{
	// osd stats for how many time-outs were called
	level endon("timeoutover");
	
	level.to_count_header = newHudElem();
	level.to_count_header.x = 575;
	level.to_count_header.y = 185;
	level.to_count_header.color = (.98, .827, .58);
	level.to_count_header.alignX = "center";
	level.to_count_header.alignY = "middle";
	level.to_count_header.font = "default";
	level.to_count_header.fontscale = 1.2;
	level.to_count_header setText(game["timeoutcount"]);
	
	level.to_count_ax = newHudElem();
	level.to_count_ax.x = 532;
	level.to_count_ax.y = 205;
	level.to_count_ax.color = (.73, .99, .73);
	level.to_count_ax.alignX = "center";
	level.to_count_ax.alignY = "middle";
	level.to_count_ax.font = "default";
	level.to_count_ax.fontscale = 1.2;
	level.to_count_ax setText(game["axis_text"]);
	
	level.to_count_axtos = newHudElem();
	level.to_count_axtos.x = 532;
	level.to_count_axtos.y = 225;
	level.to_count_axtos.alignX = "center";
	level.to_count_axtos.alignY = "middle";
	level.to_count_axtos.font = "default";
	level.to_count_axtos.fontscale = 1.2;
	level.to_count_axtos setValue(game["axis_tos"]);
	
	
	level.to_count_al = newHudElem();
	level.to_count_al.x = 612;
	level.to_count_al.y = 205;
	level.to_count_al.color = (.73, .99, .73);
	level.to_count_al.alignX = "center";
	level.to_count_al.alignY = "middle";
	level.to_count_al.font = "default";
	level.to_count_al.fontscale = 1.2;
	level.to_count_al setText(game["allies_text"]);
	
	level.to_count_altos = newHudElem();
	level.to_count_altos.x = 612;
	level.to_count_altos.y = 225;
	level.to_count_altos.alignX = "center";
	level.to_count_altos.alignY = "middle";
	level.to_count_altos.font = "default";
	level.to_count_altos.fontscale = 1.2;
	level.to_count_altos setValue(game["allies_tos"]);
	
}

TO_Round_Based()
{
	if ((!game["halftimeflag"] && game["roundsplayed"] >= (level.halfround - 1)) || (game["halftimeflag"] && game["roundsplayed"] >= (level.matchround - 1 )) && (isDefined(level.instrattime) && !level.instrattime))
	{
		iprintln("Time-out ignored. Last (half/match) round detected");
		return;
	}		
	
	game["timeout"] = true;

	if (isDefined(level.instrattime) && level.instrattime)
	{
		iprintln("Going to time-out mode now");
		//if (game["timeout"]) 
		//{
			TO_Rup();
			map_restart(true);
		//}
	}
	else 
	{
		iprintln("Going to time-out mode at the end of the round");
		level waittill("update_teamscore_hud");
		//level waittill("round_ended");
		if (game["timeout"]) {
			//level.intimeout++;
			TO_Rup();
		}
	}	
}



TO_Time_Based()
{
	game["timeout"] = true;

	goingtoo = newHudElem();
	goingtoo.x = 320;
	goingtoo.y = 15; //220
	goingtoo.alignX = "center";
	goingtoo.alignY = "top";
	goingtoo.fontScale = 1.3;
	goingtoo.color = (.8, 1, 1);
	goingtoo SetText(game["goingtoo"]);	

	ttb = newHudElem();
	ttb.x = 320;
	ttb.y = 35; //220
	ttb.alignX = "center";
	ttb.alignY = "top";
	ttb.fontScale = 1.2;
	ttb.color = (1, 1, 0);
	ttb SetTimer(20);
	wait level.fps_multiplier * 20;	
	
	if (isDefined(ttb))
		ttb destroy();
	if (isDefined(goingtoo))
		goingtoo destroy();
	TO_Rup();
}

Match_Resume()
{
	level notify("timeoutover");
	game["timeout"] = false;
	logPrint("TOO;\n");
	setcvar("g_speed", 190);
	Handle_Weapons();
	switch (level.gametype)
	{
	case "ctf":
		thread maps\pam\ctf::startGame();
		thread maps\pam\ctf::updateGametypeCvars();
		if (isDefined(level.rogueflag["axis"]) && level.rogueflag["axis"])
		{
			axis_flag = getent("axis_flag", "targetname");
			axis_flag thread maps\pam\ctf::autoReturn();
		}
		if (isDefined(level.rogueflag["allies"]) && level.rogueflag["allies"])
		{
			allied_flag = getent("allied_flag", "targetname");
			allied_flag thread maps\pam\ctf::autoReturn();
		}
		break;
	case "dm":
		thread maps\pam\dm::startGame();
		//wait 1;
		thread maps\pam\dm::updateGametypeCvars();
		break;
	case "tdm":
		thread maps\pam\tdm::startGame();
		//wait 1;
		thread maps\pam\tdm::updateGametypeCvars();
		break;
	case "sd":
		if (level.intimeout == 1) 
			level.intimeout = 0; // bilo na --
		setcvar("utimeu", 0);
		//thread maps\pam\sd::startRound();
		break;
	}
}

Handle_Weapons()
{
	players = getentarray("player", "classname");
	while(game["timeout"])
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			player = players[i];
			player disableWeapon();
		}
		wait 1;
	}
	for(i=0;i<players.size;i++)
	{
		player = players[i];
		player enableWeapon();
	}
}


Time()
{
	self endon("timeoutcalled");
	self endon("intermission");

	time = getCvarFloat("scr_"+level.gametype+"_timelimit");
	if (time == 0)
		return;
	if (level.timelimit < time)
		time = level.timelimit;

 	start = getTime();

   	while (!game["timeout"])
   	{
		passed = (getTime() - start) / 1000;
		level.timeleft = ((time * 60) - (passed)) / 60;
		wait level.fps_multiplier * 1;
        }
}