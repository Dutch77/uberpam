Dvar_Monitors()
{
	thread PAM_Server_DVAR_Monitor();
	thread PAM_Weapon_DVAR_Monitor();
	thread PAM_Gametype_DVAR_Monitors();
	thread PAM_Monitor();
}

PAM_Server_DVAR_Monitor()
{
	// General Settings
	o_spectatefree = getCvarInt("scr_spectatefree");
	o_spectateenemy = getCvarInt("scr_spectateenemy");
	o_allowvote = getCvar("g_allowvote");
	o_friendlyfire = getCvar("scr_friendlyfire");
	o_teambalance = getCvarInt("scr_teambalance");
	o_killcam = getCvarInt("scr_killcam");
	o_drawfriend = getCvarInt("scr_drawfriend");
	o_pure = getCvarInt("sv_pure");
	o_antilag = getCvarInt("g_antilag");

	// General MOD Settings
	o_minfall = getCvarInt("scr_fallDamageMinHeight");
	o_maxfall = getCvarInt("scr_fallDamageMaxHeight");
	o_shock = getCvarInt("scr_allow_shellshock");
	o_obj = getCvarInt("scr_show_objective_icons");
	o_blip = getCvarInt("scr_allow_hitblip");
	o_nade = getCvarInt("scr_show_grenade_icon");
	o_regen = getCvarInt("scr_allow_health_regen");
	o_regen_delay = getCvarInt("scr_regen_delay");
	o_hud_scoreboard = getCvarInt("scr_allow_hud_scoreboard");
	o_healthpacks = getCvarInt("scr_allow_healthpacks");
	o_sec_drop = getCvarInt("scr_allow_secondary_drop");

	while (1)
	{
		wait level.fps_multiplier * 1;

		// General Settings
		spectatefree = getCvarInt("scr_spectatefree");
		if(o_spectatefree != spectatefree)
			o_spectatefree = Dvar_Changed("scr_spectatefree", spectatefree, 1);

		spectateenemy = getCvarInt("scr_spectateenemy");
		if(o_spectateenemy != spectateenemy)
			o_spectateenemy = Dvar_Changed("scr_spectateenemy", spectateenemy, 1);

		g_allowvote = getCvar("g_allowvote");
		if(o_allowvote != g_allowvote)
			o_allowvote = Dvar_Changed("g_allowvote", g_allowvote);
	
		scr_friendlyfire = getCvar("scr_friendlyfire");
		if(o_friendlyfire != scr_friendlyfire)
			o_friendlyfire = Dvar_Changed("scr_friendlyfire", scr_friendlyfire);

		teambalance = getCvarInt("scr_teambalance");
		if(o_teambalance != teambalance)
			o_teambalance = Dvar_Changed("scr_teambalance", teambalance);

		killcam = getCvarInt("scr_killcam");
		if(o_killcam != killcam)
			o_killcam = Dvar_Changed("scr_killcam", killcam);

		drawfriend = getCvarInt("scr_drawfriend");
		if(o_drawfriend != drawfriend)
			o_drawfriend = Dvar_Changed("scr_drawfriend", drawfriend, 1);

		pure = getCvarInt("sv_pure");
		if (o_pure != pure)
			o_pure = Dvar_Changed("sv_pure", pure);

		antilag = getCvarInt("g_antilag");
		if (o_antilag != antilag)
			o_antilag = Dvar_Changed("g_antilag", antilag, 1);

		// General MOD Settings
		minfall = getCvarInt("scr_fallDamageMinHeight");
		if (o_minfall != minfall)
			o_minfall = Dvar_Changed("scr_fallDamageMinHeight", minfall, 1);

		maxfall = getCvarInt("scr_fallDamageMaxHeight");
		if (o_maxfall != maxfall)
			o_maxfall = Dvar_Changed("scr_fallDamageMaxHeight", maxfall, 1);

		shock = getCvarInt("scr_allow_shellshock");
		if (o_shock != shock)
		{
			level.allow_shellshock = shock;
			o_shock = Dvar_Changed("scr_allow_shellshock", shock);
		}

		obj = getCvarInt("scr_show_objective_icons");
		if (o_obj != obj)
		{
			level.objective_icon = obj;
			o_obj = Dvar_Changed("scr_show_objective_icons", obj, 1);
		}

		blip = getCvarInt("scr_allow_hitblip");
		if (o_blip != blip)
		{
			level.allow_hitblip = blip;
			o_blip = Dvar_Changed("scr_allow_hitblip", blip, 1);
		}

		nade = getCvarInt("scr_show_grenade_icon");
		if (o_nade != nade)
		{
			level.grenadeicon = nade;
			o_nade = Dvar_Changed("scr_show_grenade_icon", nade, 1);
		}

		regen = getCvarInt("scr_allow_health_regen");
		if (o_regen != regen)
		{
			o_regen = Dvar_Changed("scr_allow_health_regen", regen);
			iprintln("^2Map Restart Required to take effect"); 
		}

		hud_scoreboard = getCvarInt("scr_allow_hud_scoreboard");
		if (o_hud_scoreboard != hud_scoreboard)
		{
			level.allow_hud_scoreboard = hud_scoreboard;
			o_hud_scoreboard = Dvar_Changed("scr_allow_hud_scoreboard", hud_scoreboard, 1);
		}

		regen_delay = getCvarInt("scr_regen_delay");
		if (o_regen_delay != regen_delay)
		{
			if (level.regen_model)
				o_regen_delay = Dvar_Changed("scr_regen_delay", regen_delay);

			level.playerHealth_RegularRegenDelay = regen_delay;
		}

		healthpacks = getCvarInt("scr_allow_healthpacks");
		if (o_healthpacks != healthpacks)
		{
			o_healthpacks = Dvar_Changed("scr_allow_healthpacks", healthpacks);
			level.healthpacks = healthpacks;
		}

		sec_drop = getCvarInt("scr_allow_secondary_drop");
		if (o_sec_drop != sec_drop)
		{
			o_sec_drop =  Dvar_Changed("scr_allow_secondary_drop", sec_drop);
			level.allow_secondary_drop = sec_drop;
		}
	}
}

PAM_Weapon_DVAR_Monitor()
{
	// Weapons Settings
	o_bolt = getCvarint("scr_force_boltaction");
	o_nd_bolt = getCvarInt("scr_boltaction_nades");
	o_nd_semi = getCvarInt("scr_semiautomatic_nades");
	o_nd_smg = getCvarInt("scr_smg_nades");
	o_nd_snip = getCvarInt("scr_sniper_nades");
	o_nd_mg = getCvarInt("scr_mg_nades");
	o_nd_shot = getCvarInt("scr_shotgun_nades");

	o_sm_bolt = getCvarInt("scr_boltaction_smokes");
	o_sm_semi = getCvarInt("scr_semiautomatic_smokes");
	o_sm_smg = getCvarInt("scr_smg_smokes");
	o_sm_snip = getCvarInt("scr_sniper_smokes");
	o_sm_mg = getCvarInt("scr_mg_smokes");
	o_sm_shot = getCvarInt("scr_shotgun_smokes");

	o_drop_nade = getCvarInt("scr_allow_weapondrop_nade");
	o_drop_snip = getCvarInt("scr_allow_weapondrop_sniper");
	o_drop_shot = getCvarInt("scr_allow_weapondrop_shotgun");

	o_limit_bolt = getCvarInt("scr_boltaction_limit");
	o_limit_snip = getCvarInt("scr_sniper_limit");
	o_limit_semi = getCvarInt("scr_semiautomatic_limit");
	o_limit_smg = getCvarInt("scr_smg_limit");
	o_limit_mg = getCvarInt("scr_mg_limit");
	o_limit_shot = getCvarInt("scr_shotgun_limit");

	while (1)
	{
		wait level.fps_multiplier * 3;

		// Weapons Settings
		bolt = getCvarint("scr_force_boltaction");
		if (o_bolt != bolt)
		{
			level.force_boltaction = bolt;
			o_bolt = Dvar_Changed("scr_force_boltaction", bolt);
		}

		nd_bolt = getCvarInt("scr_boltaction_nades");
		if (o_nd_bolt != nd_bolt)
		{
			level.boltactionnades = nd_bolt;
			o_nd_bolt = Dvar_Changed("scr_boltaction_nades", nd_bolt, 1);
		}

		nd_semi = getCvarInt("scr_semiautomatic_nades");
		if (o_nd_semi != nd_semi)
		{
			level.semiautonades = nd_semi;
			o_nd_semi = Dvar_Changed("scr_semiautomatic_nades", nd_semi, 1);
		}

		nd_smg = getCvarInt("scr_smg_nades");
		if (o_nd_smg != nd_smg)
		{
			level.smgnades = nd_smg;
			o_nd_smg = Dvar_Changed("scr_smg_nades", nd_smg, 1);
		}

		nd_snip = getCvarInt("scr_sniper_nades");
		if (o_nd_snip != nd_snip)
		{
			level.snipernades = nd_snip;
			o_nd_snip = Dvar_Changed("scr_sniper_nades", nd_snip, 1);
		}

		nd_mg = getCvarInt("scr_mg_nades");
		if (o_nd_mg != nd_mg)
		{
			level.mgnades = nd_mg;
			o_nd_mg = Dvar_Changed("scr_mg_nades", nd_mg, 1);
		}

		nd_shot = getCvarInt("scr_shotgun_nades");
		if (o_nd_shot != nd_shot)
		{
			level.shotgunnades = nd_shot;
			o_nd_shot = Dvar_Changed("scr_shotgun_nades", nd_shot, 1);
		}

		sm_bolt = getCvarInt("scr_boltaction_smokes");
		if (o_sm_bolt != sm_bolt)
		{
			level.boltactionsmokes = sm_bolt;
			o_sm_bolt = Dvar_Changed("scr_boltaction_smokes", sm_bolt, 1);
		}

		sm_semi = getCvarInt("scr_semiautomatic_smokes");
		if (o_sm_semi != sm_semi)
		{
			level.semiautosmokes = sm_semi;
			o_sm_semi = Dvar_Changed("scr_semiautomatic_smokes", sm_semi, 1);
		}

		sm_smg = getCvarInt("scr_smg_smokes");
		if (o_sm_smg != sm_smg)
		{
			level.smgsmokes = sm_smg;
			o_sm_smg = Dvar_Changed("scr_smg_smokes", sm_smg, 1);
		}

		sm_snip = getCvarInt("scr_sniper_smokes");
		if (o_sm_snip != sm_snip)
		{
			level.snipersmokes = sm_snip;
			o_sm_snip = Dvar_Changed("scr_sniper_smokes", sm_snip, 1);
		}

		sm_mg = getCvarInt("scr_mg_smokes");
		if (o_sm_mg != sm_mg)
		{
			level.mgsmokes = sm_mg;
			o_sm_mg = Dvar_Changed("scr_mg_smokes", sm_mg, 1);
		}

		sm_shot = getCvarInt("scr_shotgun_smokes");
		if (o_sm_shot != sm_shot)
		{
			level.shotgunsmokes = sm_shot;
			o_sm_shot = Dvar_Changed("scr_shotgun_smokes", sm_shot, 1);
		}

		drop_nade = getCvarInt("scr_allow_weapondrop_nade");
		if (o_drop_nade != drop_nade)
		{
			level.allow_nadedrops = drop_nade;
			o_drop_nade = Dvar_Changed("scr_allow_weapondrop_nade", drop_nade, 1);
		}

		drop_snip = getCvarInt("scr_allow_weapondrop_sniper");
		if (o_drop_snip != drop_snip)
		{
			level.allow_sniperdrops = drop_snip;
			o_drop_snip = Dvar_Changed("scr_allow_weapondrop_sniper", drop_snip, 1);
		}

		drop_shot = getCvarInt("scr_allow_weapondrop_shotgun");
		if (o_drop_shot != drop_shot)
		{
			level.allow_shotgundrops = drop_shot;
			o_drop_shot = Dvar_Changed("scr_allow_weapondrop_shotgun", drop_shot, 1);
		}

		limit_update = 0;

		limit_bolt = getCvarInt("scr_boltaction_limit");
		if (o_limit_bolt != limit_bolt)
		{
			level.weaponclass["boltaction"].limit = limit_bolt;
			o_limit_bolt = Dvar_Changed("scr_boltaction_limit", limit_bolt);
			limit_update = 1;
		}

		limit_snip = getCvarInt("scr_sniper_limit");
		if (o_limit_snip != limit_snip)
		{
			level.weaponclass["sniper"].limit = limit_snip;
			o_limit_snip = Dvar_Changed("scr_sniper_limit", limit_snip);
			limit_update = 1;
		}

		limit_semi = getCvarInt("scr_semiautomatic_limit");
		if (o_limit_semi != limit_semi)
		{
			level.weaponclass["semiautomatic"].limit = limit_semi;
			o_limit_semi = Dvar_Changed("scr_semiautomatic_limit", limit_semi);
			limit_update = 1;
		}

		limit_smg = getCvarInt("scr_smg_limit");
		if (o_limit_smg != limit_smg)
		{
			level.weaponclass["smg"].limit = limit_smg;
			o_limit_smg = Dvar_Changed("scr_smg_limit", limit_smg);
			limit_update = 1;
		}

		limit_mg = getCvarInt("scr_mg_limit");
		if (o_limit_mg != limit_mg)
		{
			level.weaponclass["mg"].limit = limit_mg;
			o_limit_mg = Dvar_Changed("scr_mg_limit", limit_mg);
			limit_update = 1;
		}

		limit_shot = getCvarInt("scr_shotgun_limit");
		if (o_limit_shot != limit_shot)
		{
			level.weaponclass["shotgun"].limit = limit_shot;
			o_limit_shot = Dvar_Changed("scr_shotgun_limit", limit_shot);
			limit_update = 1;
		}

		if (limit_update)
			thread maps\pam\weapon_limiter::Update_All_Weapon_Limits();
	}
}

PAM_Gametype_DVAR_Monitors()
{
	switch (level.gametype)
	{
	case "sd":
		PAM_SD_DVAR_Monitor(); break;
	case "hq":
		PAM_HQ_DVAR_Monitor(); break;
	case "ctf":
		PAM_CTF_DVAR_Monitor(); break;
	case "tdm":
		PAM_TDM_DVAR_Monitor(); break;
	case "dm":
		PAM_DM_DVAR_Monitor(); break;
	}
}


PAM_SD_DVAR_Monitor()
{
	o_halfround = getcvarint("scr_sd_half_round");
	o_halfscore = getcvarint("scr_sd_half_score");
	o_matchround = getcvarint("scr_sd_end_round");
	o_matchscore1 = getcvarint("scr_sd_end_score");
	o_matchscore2 = getcvarint("scr_sd_end_half2score");
	o_countdraws = getcvarint("scr_sd_count_draws");

	o_plant_time = getcvarint("scr_sd_PlantTime");
	o_defuse_time = getcvarint("scr_sd_DefuseTime");

	//Stock Stuff
	o_bombtimer = getCvarInt("scr_sd_bombtimer");
	//o_timelimit = getCvarFloat("scr_sd_timelimit");
	o_scorelimit = getCvarInt("scr_sd_scorelimit");
	o_roundlimit = getCvarInt("scr_sd_roundlimit");
	o_graceperiod = getCvarFloat("scr_sd_graceperiod");
	o_roundlength = getCvarFloat("scr_sd_roundlength");
	o_bombclock = getCvarInt("scr_show_bombtimer");

	while (1)
	{
		wait level.fps_multiplier * 5;

		roundlimit = getCvarFloat("scr_sd_roundlimit");
		if (o_roundlimit != roundlimit)
			o_roundlimit = Dvar_Changed("scr_sd_roundlimit", roundlimit);

		graceperiod = getCvarFloat("scr_sd_graceperiod");
		if (o_graceperiod != graceperiod)
			o_graceperiod = Dvar_Changed("scr_sd_graceperiod", graceperiod, 1);

		roundlength = getCvarFloat("scr_sd_roundlength");
		if (o_roundlength != roundlength)
			o_roundlength = Dvar_Changed("scr_sd_roundlength", roundlength, 1);

		halfround = getcvarint("scr_sd_half_round");
		if (o_halfround != halfround)
		{
			level.halfround = halfround;
			o_halfround = Dvar_Changed("scr_sd_halfround", halfround);
		}

		halfscore = getcvarint("scr_sd_half_score");
		if (o_halfscore != halfscore)
		{
			level.halfscore = halfscore;
			o_halfscore = Dvar_Changed("scr_sd_half_score", halfscore);
		}

		matchround = getcvarint("scr_sd_end_round");
		if (o_matchround != matchround)
		{
			level.matchround = matchround;
			o_matchround = Dvar_Changed("scr_sd_end_round", matchround);
		}

		matchscore1 = getcvarint("scr_sd_end_score");
		if (o_matchscore1 != matchscore1)
		{
			level.matchscore1 = matchscore1;
			level.scorelimit = matchscore1;
			o_matchscore1 = Dvar_Changed("scr_sd_end_score", matchscore1);
		}

		matchscore2 = getcvarint("scr_sd_end_half2score");
		if (o_matchscore2 != matchscore2)
		{
			level.matchscore2 = matchscore2;
			o_matchscore2 = Dvar_Changed("scr_sd_end_half2score", matchscore2);
		}

		countdraws = getcvarint("scr_sd_count_draws");
		if (o_countdraws != countdraws)
		{
			level.countdraws = countdraws;
			o_countdraws = Dvar_Changed("scr_sd_count_draws", countdraws, 1);
		}

		bombtimer = getcvarint("scr_sd_bombtimer");
		if (o_bombtimer != bombtimer)
		{
			level.bombtimer = bombtimer;
			o_bombtimer = Dvar_Changed("scr_sd_bombtimer", bombtimer, 1);
		}

		plant_time = getcvarint("scr_sd_PlantTime");
		if (o_plant_time != plant_time)
		{
			level.plant_time = plant_time;
			o_plant_time = Dvar_Changed("scr_sd_PlantTime", plant_time, 1);
		}

		defuse_time = getcvarint("scr_sd_DefuseTime");
		if (o_defuse_time != defuse_time)
		{
			level.defuse_time = defuse_time;
			o_defuse_time = Dvar_Changed("scr_sd_DefuseTime", defuse_time, 1);
		}

		bombclock = getCvarInt("scr_show_bombtimer");
		if (o_bombclock != bombclock)
		{
			level.show_bombtimer = bombclock;
			o_bombclock = Dvar_Changed("scr_show_bombtimer", bombclock, 1);
		}
	}
}

PAM_HQ_DVAR_Monitor()
{
}

PAM_DM_DVAR_Monitor()
{
}

PAM_CTF_DVAR_Monitor()
{
	//setcvar("scr_ctf_timelimit", 15); 
	//setcvar("scr_ctf_timelimit_halftime", 1);
	//setcvar("scr_ctf_half_score", 0);
	//setcvar("scr_ctf_end_score", 0);
	//setcvar("scr_ctf_end_half2score", 0);

	o_matchscore1 = getcvarint("scr_ctf_end_score");
	o_matchscore2 = getcvarint("scr_ctf_end_half2score");
	o_timelimit = getcvarint("scr_ctf_timelimit");
	o_time_halftime = getcvarint("scr_ctf_timelimit_halftime");
	o_halfscore = getcvarint("scr_ctf_half_score");

	while (1)
	{
		wait level.fps_multiplier * 5;

		matchscore1 = getcvarint("scr_ctf_end_score");
		if (o_matchscore1 != matchscore1)
		{
			level.matchscore1 = matchscore1;
			level.scorelimit = matchscore1;
			o_matchscore1 = Dvar_Changed("scr_ctf_end_score", matchscore1);
		}

		matchscore2 = getcvarint("scr_ctf_end_half2score");
		if (o_matchscore2 != matchscore2)
		{
			level.matchscore2 = matchscore2;
			o_matchscore2 = Dvar_Changed("scr_ctf_end_half2score", matchscore2);
		}

		timelimit = getcvarint("scr_ctf_timelimit");
		if (o_timelimit != timelimit)
		{
			level.timelimit = timelimit;
			o_timelimit = Dvar_Changed("scr_ctf_timelimit", timelimit);
		}

		time_halftime = getcvarint("scr_ctf_timelimit_halftime");
		if (o_time_halftime != time_halftime)
		{
			level.do_halftime = time_halftime;
			o_time_halftime = Dvar_Changed("scr_ctf_timelimit_halftime", time_halftime);
		}

		halfscore = getcvarint("scr_ctf_half_score");
		if (o_halfscore != halfscore)
		{
			level.halfscore = halfscore;
			o_halfscore = Dvar_Changed("scr_ctf_half_score", halfscore);
		}
	}


}

PAM_TDM_DVAR_Monitor()
{
}

PAM_Monitor()
{
	o_mode = getCvar("pam_mode");

	level.previousmode = o_mode;

	while (1)
	{
		wait level.fps_multiplier * 3;

		pam_enable = getcvarint("sv_pam");
		if (pam_enable == 0)
		{
			maps\pam\next_map::PAM_state_change();
			break;
		}

		mode = getCvar("pam_mode");
		if (o_mode != mode)
		{
			Dvar_Changed("pam_mode", mode);

			if(game["ruleset"] == mode)
			{
				o_mode = mode;
				continue;
			}

			valid_mode = maps\pam\pam_version_utils::isValid_PAM_Mode();
			if (valid_mode)
			{
				maps\pam\next_map::PAM_mode_change(mode);
				break;
			}
			else
				o_mode = mode;
			
		}
	}
}

Dvar_Changed(dvar, value, match_mode_only, hidden)
{
	if (!isDefined(match_mode_only))
		match_mode_only = 0;
	if (!isDefined(hidden))
		hidden = 0;

	if (game["mode"] != "match" && match_mode_only)
		return value;
		
	if (hidden != 0)
		iprintln("^1zPAM: ^3DVAR change detected: ^2" + dvar + " ^3--> ^2" + "*HIDDEN*");
	else
		iprintln("^1zPAM: ^3DVAR change detected: ^2" + dvar + " ^3--> ^2" + value);

	return value;
}