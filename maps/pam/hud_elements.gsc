// Call Hud Elems by: [[level.pam_hud]]("elem");
// Kill Them by: [[level.pam_hud]]("kill_elem");
Hud_Elem(elem, time)
{
	if (!isDefined(time) ) time = 0;

	switch (elem)
	{
	case "header":
		thread PAM_HUD_Header();
		break;

	case "kill_header":
		level notify("kill_header");
		break;

	case "kill_all":
		level notify("kill_header");
		level notify("kill_team_swap");
		level notify("kill_scoreboard");
		level notify("kill_team_win");
		level notify("kill_match_over");
		level notify("kill_players_ready");
		level notify("kill_half_start");
		level notify("kill_next_round");
		level notify("kill_to");
		break;
	
	case "scoreboard":
		thread PAM_HUD_Scoreboard();
		break;
	
	case "kill_scoreboard":
		level notify("kill_scoreboard");
		break;

	case "team_win":
		thread Create_HUD_TeamWin();
		break;

	case "team_swap":
		thread Create_HUD_TeamSwap();
		break;

	case "kill_team_swap":
		level notify("kill_team_swap");
		break;
	
	case "kill_team_win":
		level notify("kill_team_win");
		break;

	case "match_over":
		thread Create_HUD_Matchover();
		break;

	case "players_ready":
		thread PAM_HUD_PlayersReady();
		break;
	
	case "kill_all_ready":
		level notify("kill_players_ready");
		break;

	case "half_start":
		thread PAM_HUD_Half_Start(time);
		break;

	case "kill_half_start":
		level notify("kill_half_start");
		break;

	case "next_round":
		thread PAM_HUD_NextRound(time);
		break;
	
	case "kill_next_round":
		level notify("kill_next_round");
		break;

	case "live":
		thread PAM_HUD_Live();
		break;
	}
}

PAM_HUD_Header()
{
	pamlogo = newHudElem();
	pamlogo.x = 575;
	pamlogo.y = 20;
	pamlogo.alignX = "center";
	pamlogo.alignY = "top";
	pamlogo.fontScale = 1.2;
	pamlogo.color = (.8, 1, 1);
	pamlogo setText(game["pamstring"]);

	pammode = newHudElem();
	if (getCvarInt("scr_clock_position") == 1)
	{
		pammode.x = 10;
		pammode.y = 2;
	}
	else
	{
		pammode.x = 50;
		pammode.y = 11;
	}
	pammode.alignX = "left";
	pammode.alignY = "top";
	pammode.fontScale = 1.2;
	pammode.color = (1, 1, 0);
	pammode setText(game["leaguestring"]);

	overtimemode = newHudElem();
	if (getCvarInt("scr_clock_position") == 1)
	{
		overtimemode.x = 10;
		overtimemode.y = 15;
	}
	else
	{
		overtimemode.x = 50;
		overtimemode.y = 24;
	}
	overtimemode.alignX = "left";
	overtimemode.alignY = "top";
	overtimemode.fontScale = 1.2;
	overtimemode.color = (1, 1, 0);
	if(getcvarint("g_ot_active") > 0)
		overtimemode setText(game["overtimemode"]);

	level waittill("kill_header");

	if(isdefined(pammode))
		pammode destroy();
	if(isdefined(pamlogo))
		pamlogo destroy();
	if(isdefined(overtimemode))
		overtimemode destroy();

}

PAM_HUD_Scoreboard()
{
	scoreboardy = 197;
	teamsy = scoreboardy + 15;
	half1y = scoreboardy + 28;
	half2y = scoreboardy + 45;
	matchy = scoreboardy + 65;

	//level.roundendedkill = true;

	// Display TEAMS
	level.scorebd = newHudElem();
	level.scorebd.x = 570;
	level.scorebd.y = scoreboardy;
	level.scorebd.alignX = "center";
	level.scorebd.alignY = "middle";
	level.scorebd.fontScale = 1.2;
	level.scorebd.font = "default";
	level.scorebd.color = (.98, .827, .58);
	level.scorebd setText(game["scorebd"]);

	level.team1 = newHudElem();
	
	if (isDefined(game["halftimeflag"]) && game["halftimeflag"] == 1)
	{
		level.team1.x = 610;
		level.team1.color = (.85, .99, .99);
	}
	else
	{
		level.team1.x = 530;
		level.team1.color = (.73, .99, .73);
	}

	level.team1.y = teamsy;
	level.team1.alignX = "center";
	level.team1.alignY = "middle";
	level.team1.fontScale = 1.2;
	level.team1.font = "default";
	level.team1 setText(game["dspteam1"]);

	level.team2 = newHudElem();
	
	if (isDefined(game["halftimeflag"]) && game["halftimeflag"] == 1)
	{
		level.team2.x = 530;
		level.team2.color = (.73, .99, .73);
	}
	else
	{
		level.team2.x = 610;
		level.team2.color = (.85, .99, .99);
	}

	level.team2.y = teamsy;
	level.team2.alignX = "center";
	level.team2.alignY = "middle";
	level.team2.fontScale = 1.2;
	level.team2.font = "default";
	level.team2 setText(game["dspteam2"]);

	// First Half Score Display
	level.firhalfscore = newHudElem();
	level.firhalfscore.x = 570;
	level.firhalfscore.y = half1y;
	level.firhalfscore.alignX = "center";
	level.firhalfscore.alignY = "middle";
	level.firhalfscore.fontScale = 1.2;
	level.firhalfscore.font = "default";
	level.firhalfscore.color = (.98, .827, .58);
	level.firhalfscore setText(game["1sthalf"]);

	level.firhalfaxisscorenum = newHudElem();
	level.firhalfaxisscorenum.x = 527;
	level.firhalfaxisscorenum.y = half1y;
	level.firhalfaxisscorenum.alignX = "center";
	level.firhalfaxisscorenum.alignY = "middle";
	level.firhalfaxisscorenum.fontScale = 1.2;
	level.firhalfaxisscorenum.font = "default";
	level.firhalfaxisscorenum.color = (.73, .99, .75);
	level.firhalfaxisscorenum setValue(game["half_1_axis_score"]);

	level.firhalfalliesscorenum = newHudElem();
	level.firhalfalliesscorenum.x = 613;
	level.firhalfalliesscorenum.y = half1y;
	level.firhalfalliesscorenum.alignX = "center";
	level.firhalfalliesscorenum.alignY = "middle";
	level.firhalfalliesscorenum.fontScale = 1.2;
	level.firhalfalliesscorenum.font = "default";
	level.firhalfalliesscorenum.color = (.85, .99, .99);
	level.firhalfalliesscorenum setValue(game["half_1_allies_score"]);

	// Second Half Score Display
	level.sechalfscore = newHudElem();
	level.sechalfscore.x = 570;
	level.sechalfscore.y = half2y;
	level.sechalfscore.alignX = "center";
	level.sechalfscore.alignY = "middle";
	level.sechalfscore.fontScale = 1.2;
	level.sechalfscore.font = "default";
	level.sechalfscore.color = (.98, .827, .58);
	level.sechalfscore setText(game["2ndhalf"]);
			
	level.sechalfaxisscorenum = newHudElem();
	level.sechalfaxisscorenum.x = 613;
	level.sechalfaxisscorenum.y = half2y;
	level.sechalfaxisscorenum.alignX = "center";
	level.sechalfaxisscorenum.alignY = "middle";
	level.sechalfaxisscorenum.fontScale = 1.2;
	level.sechalfaxisscorenum.font = "default";
	level.sechalfaxisscorenum.color = (.85, .99, .99);
	level.sechalfaxisscorenum setValue(game["half_2_axis_score"]);

	level.sechalfalliesscorenum = newHudElem();
	level.sechalfalliesscorenum.x = 527;
	level.sechalfalliesscorenum.y = half2y;
	level.sechalfalliesscorenum.alignX = "center";
	level.sechalfalliesscorenum.alignY = "middle";
	level.sechalfalliesscorenum.fontScale = 1.2;
	level.sechalfalliesscorenum.font = "default";
	level.sechalfalliesscorenum.color = (.73, .99, .75);
	level.sechalfalliesscorenum setValue(game["half_2_allies_score"]);
			
	// Match Score Display
	level.matchscore = newHudElem();
	level.matchscore.x = 570;
	level.matchscore.y = matchy;
	level.matchscore.alignX = "center";
	level.matchscore.alignY = "middle";
	level.matchscore.fontScale = 1.2;
	level.matchscore.font = "default";
	level.matchscore.color = (.98, .827, .58);
	level.matchscore setText(game["matchscore2"]);

	level.matchaxisscorenum = newHudElem();
	level.matchaxisscorenum.x = 527;
	level.matchaxisscorenum.color = (.73, .99, .75);
	level.matchaxisscorenum.y = matchy;
	level.matchaxisscorenum.alignX = "center";
	level.matchaxisscorenum.alignY = "middle";
	level.matchaxisscorenum.fontScale = 1.2;
	level.matchaxisscorenum.font = "default";
	level.matchaxisscorenum setValue(game["Team_1_Score"]);

	level.matchalliesscorenum = newHudElem();
	level.matchalliesscorenum.x = 613;
	level.matchalliesscorenum.color = (.85, .99, .99);
	level.matchalliesscorenum.y = matchy;
	level.matchalliesscorenum.alignX = "center";
	level.matchalliesscorenum.alignY = "middle";
	level.matchalliesscorenum.fontScale = 1.2;
	level.matchalliesscorenum.font = "default";
	level.matchalliesscorenum setValue(game["Team_2_Score"]);

	level waittill("kill_scoreboard");

	if(isdefined(level.scorebd))
		level.scorebd destroy();
	if(isdefined(level.team1))
		level.team1 destroy();
	if(isdefined(level.team2))
		level.team2 destroy();

	if(isdefined(level.firhalfscore))
		level.firhalfscore destroy();
	if(isdefined(level.firhalfaxisscore))
		level.firhalfaxisscore destroy();
	if(isdefined(level.firhalfalliesscore))
		level.firhalfalliesscore destroy();
	if(isdefined(level.firhalfaxisscorenum))
		level.firhalfaxisscorenum destroy();
	if(isdefined(level.firhalfalliesscorenum))
		level.firhalfalliesscorenum destroy();

	if(isdefined(level.sechalfscore))
		level.sechalfscore destroy();
	if(isdefined(level.sechalfaxisscore))
		level.sechalfaxisscore destroy();
	if(isdefined(level.sechalfalliesscore))
		level.sechalfalliesscore destroy();
	if(isdefined(level.sechalfaxisscorenum))
		level.sechalfaxisscorenum destroy();
	if(isdefined(level.sechalfalliesscorenum))
		level.sechalfalliesscorenum destroy();

	if(isdefined(level.matchscore))
		level.matchscore destroy();
	if(isdefined(level.matchaxisscorenum))
		level.matchaxisscorenum destroy();
	if(isdefined(level.matchalliesscorenum))
		level.matchalliesscorenum destroy();
}

PAM_HUD_NextRound(time)
{
	if ( time < 3 )
		time = 3;

	level.round = newHudElem();
	level.round.x = 540;
	level.round.y = 295;
	level.round.alignX = "center";
	level.round.alignY = "middle";
	level.round.fontScale = 1.2;
	level.round.color = (1, 1, 0);
	level.round setText(game["round"]);		
		
	level.roundnum = newHudElem();
	level.roundnum.x = 540;
	level.roundnum.y = 315;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "middle";
	level.roundnum.fontScale = 1.2;
	level.roundnum.color = (1, 1, 0);
	round = game["roundsplayed"]+1;
	level.roundnum setValue(round);

	level.starting = newHudElem();
	level.starting.x = 540;
	level.starting.y = 335;
	level.starting.alignX = "center";
	level.starting.alignY = "middle";
	level.starting.fontScale = 1.2;
	level.starting.color = (1, 1, 0);
	level.starting setText(game["starting"]);

	// Give all players a count-down stopwatch
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player thread stopwatch_start("match_start", time);
	}
	
	wait (level.fps_multiplier * time);

	if(isdefined(level.round))
		level.round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.starting))
		level.starting destroy();
}

Create_HUD_TeamWin()
{
	mode = getcvar("pam_mode");	

	teamwin = newHudElem();
	teamwin.x = 570;
	teamwin.y = 155;
	teamwin.alignX = "center";
	teamwin.alignY = "middle";
	teamwin.fontScale = 1.2;

	if (game["Team_1_Score"] == game["Team_2_Score"])
	{
		teamwin.color = (1, 1, 0);
		teamwin setText(game["dsptie"]);
	}
	else if (game["Team_2_Score"] > game["Team_1_Score"])
	{
		teamwin.color = (1, 1, 0);
		
		if (mode == "bash")
			teamwin setText(game["team1win"]);
		else
			teamwin setText(game["team2win"]);
	}
	else
	{
		teamwin.color = (1, 1, 0);
		
		if (mode == "bash")
			teamwin setText(game["team2win"]);
		else
			teamwin setText(game["team1win"]);
	}
	
	level waittill("kill_team_win");

	if(isdefined(teamwin))
		teamwin destroy();
}


PAM_HUD_PlayersReady()
{

	/*allready = newHudElem();
	allready.x = 320;
	allready.y = 350;
	allready.alignX = "center";
	allready.alignY = "middle";
	allready.fontScale = 1.2;
	allready.color = (0, 1, 0);
	allready setText(game["allready"]);*/

	/*if (!game["halftimeflag"])
	{
		halfstart = newHudElem();
		halfstart.x = 320;
		halfstart.y = 370;
		halfstart.alignX = "center";
		halfstart.alignY = "middle";
		halfstart.fontScale = 1.2;
		halfstart.color = (0, 1, 0);
		halfstart setText(game["start1sthalf"]); 
	}
	else
	{
		halfstart = newHudElem();
		halfstart.x = 320;
		halfstart.y = 370;
		halfstart.alignX = "center";
		halfstart.alignY = "middle";
		halfstart.fontScale = 1.2;
		halfstart.color = (0, 1, 0);
		halfstart setText(game["start2ndhalf"]);
	}*/
			
	//thread maps\pam\sd::playsoundstart();

	blackbg = newHudElem();
	blackbg.horzAlign = "fullscreen";
	blackbg.vertAlign = "fullscreen";
	blackbg.alignx = "left";
	blackbg.aligny = "top";
	blackbg.alpha = 0;
	blackbg FadeOverTime(2.5);  
	blackbg.alpha = 0.75;
	blackbg.sort = -3;
	blackbg.foreground = true;
	blackbg SetShader("black", 640, 480);

	gametype = getcvar("g_gametype");

	blackbgtimer = newHudElem();
	blackbgtimer.alignx = "center";
	blackbgtimer.aligny = "top";
	blackbgtimer.x = 320;
	blackbgtimer.y = 239;
	blackbgtimer.fontscale = 1.3;
	blackbgtimer.alpha = 0;
	blackbgtimer FadeOverTime(2.5);  
	blackbgtimer.alpha = 1;
	blackbgtimer.sort = -1;
	blackbgtimer.foreground = true;
	blackbgtimer settimer(level.half_start_timer + 2.5);

	blackbgtimertext = newHudElem();
	blackbgtimertext.alignx = "center";
	blackbgtimertext.aligny = "top";
	blackbgtimertext.x = 320;
	blackbgtimertext.y = 223;
	blackbgtimertext.fontscale = 1.3;
	blackbgtimertext.alpha = 0;
	blackbgtimertext FadeOverTime(2.5);  
	blackbgtimertext.alpha = 1;
	blackbgtimertext.sort = -2;
	blackbgtimertext.foreground = true;
	blackbgtimertext SetText(game["start_time"]);
	
	level waittill("kill_players_ready");
}

PAM_HUD_Half_Start(time)
{
	if ( time < 3 )
		time = 3;

	round = newHudElem();
	round.x = 540;
	round.y = 295;
	round.alignX = "center";
	round.alignY = "middle";
	round.fontScale = 1.2;
	round.color = (1, 1, 0);
	if (!game["halftimeflag"])
		round setText(game["first"]);	
	else
		round setText(game["second"]);	
		
	roundnum = newHudElem();
	roundnum.x = 540;
	roundnum.y = 315;
	roundnum.alignX = "center";
	roundnum.alignY = "middle";
	roundnum.fontScale = 1.2;
	roundnum.color = (1, 1, 0);
	roundnum setText(game["half"]);

	starting = newHudElem();
	starting.x = 540;
	starting.y = 335;
	starting.alignX = "center";
	starting.alignY = "middle";
	starting.fontScale = 1.2;
	starting.color = (1, 1, 0);
	starting setText(game["starting"]);

	// Give all players a count-down stopwatch
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;

		player thread stopwatch_start("match_start", time);
	}
	
	wait (level.fps_multiplier * time);

	if(isdefined(round))
		round destroy();
	if(isdefined(roundnum))
		roundnum destroy();
	if(isdefined(level.starting))
		starting destroy();
}

PAM_HUD_Bomb_Planted()
{
	level.hudplanted = newHudElem();
	level.hudplanted.x = 320;
	level.hudplanted.y = 460; //390
	level.hudplanted.alignX = "center";
	level.hudplanted.alignY = "middle";
	level.hudplanted.fontScale = 1;
	level.hudplanted.color = (1, 1, 0);
	level.hudplanted setText(game["planted"]);
}

Destroy_HUD_Planted()
{
	wait level.fps_multiplier * 6;
	level.hudplanted destroy();
}

Create_HUD_TeamSwap()
{
	switching = newHudElem();
	switching.x = 570;
	switching.y = 280;
	switching.alignX = "center";
	switching.alignY = "middle";
	switching.fontScale = 1.2;
	switching.color = (1, 1, 0);
	switching setText(game["switching"]);

	switching2 = newHudElem();
	switching2.x = 570;
	switching2.y = 300;
	switching2.alignX = "center";
	switching2.alignY = "middle";
	switching2.fontScale = 1.2;
	switching2.color = (1, 1, 0);
	switching2 setText(game["switching2"]);

	level waittill("kill_team_swap");

	if(isdefined(switching))
		switching destroy();
	if(isdefined(switching2))
		switching2 destroy();
}

Destroy_HUD_TeamSwap()
{
	if(isdefined(level.switching))
		level.switching destroy();
	if(isdefined(level.switching2))
		level.switching2 destroy();
}

Create_HUD_Matchover()
{
	matchover = newHudElem();
	matchover.x = 570;
	matchover.y = 175;
	matchover.alignX = "center";
	matchover.alignY = "middle";
	matchover.fontScale = 1.2;
	matchover.color = (1, 1, 0);
	if(getcvarint("g_ot_active") > 0)
		matchover setText(game["overtime"]);
	else
		matchover setText(game["matchover"]);

	level waittill("kill_match_over");

	if (isDefined(matchover))
		matchover destroy();
}

stopwatch_start(reason, time)
{
	if(isDefined(self.stopwatch))
		self.stopwatch destroy();
		
	self.stopwatch = newClientHudElem(self);
	self.stopwatch.x = 590; // 590;
	self.stopwatch.y = 315; // 380;
	self.stopwatch.alignX = "center";
	self.stopwatch.alignY = "middle";
	self.stopwatch.sort = 4;
	self.stopwatch setClock(time, 60, "hudStopwatch", 64, 64); // count down for 5 of 60 seconds, size is 64x64
	self.stopwatch.archived = false;
	
	wait (level.fps_multiplier * time);

	if(isDefined(self.stopwatch)) 
		self.stopwatch destroy();
}

PAM_HUD_Live()
{
	//gametype = getcvar("g_gametype");

	level.onepointnotzero = 1.0;

	if(((game["roundsplayed"] == 0) || (game["roundsplayed"] == level.halfround)) && !level.intimeout) 
	{
		blackbg2 = newHudElem();
		blackbg2.horzAlign = "fullscreen";
		blackbg2.vertAlign = "fullscreen";
		blackbg2.alignx = "left";
		blackbg2.aligny = "top";
		blackbg2.alpha = 0.75;
		blackbg2 FadeOverTime(2.5);  
		blackbg2.alpha = 0;
		blackbg2.sort = -1;
		blackbg2.foreground = true;
		//preCacheShader("black");
		blackbg2 SetShader("black", 640, 480);
	
		wait level.onepointnotzero * 5;
			
		if(isDefined(blackbg2)) 
			blackbg2 destroy();
	}


	/*game["dolive"] = 0;

	live = newHudElem();
	live.x = 320;
	live.y = 370;
	live.alignX = "center";
	live.alignY = "middle";
	live.fontScale = 2;
	live.color = (0, 1, 0);
	live.alpha = 1;
	live setText(game["livemsg"]);

	for (i=1;i<7;i++)
	{
		wait level.fps_multiplier * 1.5;
		if (live.alpha)
			live.alpha = 0;
		else
			live.alpha = 1;
	}

	if(isDefined(live)) 
		live destroy();*/
}