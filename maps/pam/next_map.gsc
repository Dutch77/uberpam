Next_Map_Select()
{
	if (game["mode"] == "match")
	{
		logPrint("ME\n");
		Fast_Restart();
	}
}

PAM_state_change()
{
	level.mapended = true;
	level.pam_mode_change = true;

	pam = newHudElem();
	pam.x = 320;
	pam.y = 70;
	pam.alignX = "center";
	pam.alignY = "middle";
	pam.fontScale = 1.5;
	pam.color = (.98, .827, .58);
	pam setText(game["pam_on_off"]);

	pls_wait = newHudElem();
	pls_wait.x = 320;
	pls_wait.y = 85;
	pls_wait.alignX = "center";
	pls_wait.alignY = "middle";
	pls_wait.fontScale = 1.5;
	pls_wait.color = (.98, .827, .58);
	pls_wait setText(game["please_wait"]);

	game["pam_enabled"] = getCvarint("sv_pam");

	wait level.fps_multiplier * 4;

	//Rotate_to_Same_Map();

	//exitLevel(false);

	thread Fast_Restart();
}

PAM_mode_change(mode)
{
	level.mapended = true;
	level.pam_mode_change = true;

	wait level.fps_multiplier * 1;

	iprintlnbold("^3zPAM mode changing to ^2" + mode);
	iprintlnbold("^3Please wait...");

	wait level.fps_multiplier * 4;

	//Rotate_to_Same_Map();

	//exitLevel(false);

	thread Fast_Restart();
}

Rotate_to_Same_Map()
{
	repeat = getcvar("mapname");
	current = getcvar("sv_maprotationcurrent");

	new_rotation = "map " + repeat + " " + current;

	setcvar("sv_maprotationcurrent", new_rotation);
}

Fast_Restart()
{
	level.exiting_map = true;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] thread Reset_Player_Info();
	}

	game["ambient_sounds"] = undefined;
	game["ambient_fire"] = undefined;
	game["ambient_weather"] = undefined;
	game["ambient_fog"] = undefined;

	game["gamestarted"] = undefined;
	game["matchstarted"] = undefined;
	game["firstreadyupdone"] = undefined;
	game["ruleset"] = undefined;
	game["mode"] = undefined;
	game["allies"] = undefined;
	game["axis"] = undefined;
	game["attackers"] = undefined;
	game["defenders"] = undefined;
	game["mc_current_msg"] = undefined;
	game["timepassed"] = undefined;
	game["state"] = undefined;
	game["roundsplayed"] = undefined;
	game["switchprevent"] = undefined;

	pers["beenspecforonce"] = 0;
	pers["beenspec"] = 0;
	pers["was_spectator_once"] = 0;
	pers["became_spectator_once"] = 0;
	pers["specmenuopened"] = 0;
	pers["hqstoper"] = 0;
	pers["stoppedat"] = 0;
	
	setcvar("matchstartingy", 0);
	setcvar("endround3d", 0);
	
	game["waiterspawn"] = 0;
	game["clockfirstrup"] = 0;
	game["teamcalledto"] = "default";
	game["timesto"] = 0;
	game["timestoc"] = 0;
	game["plantton"] = 0;
	game["defannono"] = 0;
	game["killonja"] = 0;
	game["timowo"] = 0;
	game["timeout"] = false;

	level.intimeout = 0;
	level.roundended_dc = 0;
	level.al_sniplimited = 0;
	level.ax_sniplimited = 0;
	level.limitingentered = 0;
	level.halftimechange = 0;

	setcvar("utimeu", 0);
	setcvar("bombplented2", 0);
	setcvar("halfooo", 0);
	setcvar("isstrattime2", 0);

	game["dolive"] = 0;
	game["halftimeflag"] = 0;
	game["alliedscore"] = 0;
	game["axisscore"] = 0;
	game["half_1_allies_score"] = 0;
	game["half_1_axis_score"] = 0; 
	game["half_2_allies_score"] = 0;
	game["half_2_axis_score"] = 0;
	game["Team_1_Score"] = 0;
	game["Team_2_Score"] = 0;
	game["roundsplayed"] = 0;
	game["DoReadyUp"] = false;
	game["Do_Ready_up"] = 0;
	
	game["allies_tos"] = 0;
	game["axis_tos"] = 0;
	game["allies_tos_half"] = 0;
	game["axis_tos_half"] = 0;

	mode = getcvar("pam_mode");
	mapn = getcvar("mapname");

	if (mode == "bash" || mode == "cg" || mode == "cg_1v1" || mode == "cg_2v2" || mode == "cg_mr3" || mode == "cg_mr10" || mode == "cg_mr12" || mode == "cg_rifle" || mode == "cg_rush" || mode == "mr3" || mode == "mr10" || mode == "mr12" || mode == "mr15")
	{
		pbsvload = "pbsvuser.cfg";
		setcvar("pb_sv_load", pbsvload);
	}
	else if (mode == "pub" || mode == "pub_rifle")
	{	
		pbsvload1 = "undefined";
		setcvar("pb_sv_load", pbsvload1);
	}

	if (mapn == "mp_harbor" || mapn == "mp_leningrad" || mapn == "mp_downtown" || mapn == "mp_railyard" || mode == "cg_rifle" || level.previousmode == "cg_rifle" || level.previousmode == "pub_rifle" || mode == "pub_rifle")
		map (getcvar("mapname"), true);
	else 
		map_restart(true);

}

Reset_Player_Info()
{
	self.pers["dvarenforcement"] = undefined;
	self.pers["team"] = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self.pers["deaths"] = undefined;
	self.pers["score"] = undefined;
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["skipserverinfo"] = undefined;
	self.pers["tkcount"] = 0;
	self.pers["tktimer"] = 0;
	self.pers["tker_reflect"] = 0;

	// zPAM
	self.pers["playerdefuses"] = 0;
	self.pers["beenspecforonce"] = 0;
	self.pers["beenspec"] = 0;
	self.pers["was_spectator_once"] = 0;
	self.pers["became_spectator_once"] = 0;
	self.pers["specmenuopened"] = 0;
	self.pers["stoppedat"] = 0;
	self.pers["hqstoper"] = 0;
	self.pers["playerplants"] = 0;

	self.usedgt = 0;
	self.usedgt2 = 0;
	self.fdl = 0;
}