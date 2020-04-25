Do_Half_Time()
{
	logPrint("HT\n");
	level.hithalftime = 1;
	level.warmup = 1;
	setcvar("uwup", 1);

	//display scores
	[[level.pam_hud]]("header");

	level.halftime = newHudElem();
	level.halftime.x = 570;
	level.halftime.y = 175;
	level.halftime.alignX = "center";
	level.halftime.alignY = "middle";
	level.halftime.fontScale = 1.2;
	level.halftime.color = (1, 1, 0);
	level.halftime setText(game["halftime"]);
	
	[[level.pam_hud]]("scoreboard");
	
	wait level.fps_multiplier * 1;

	[[level.pam_hud]]("team_swap");

	wait level.fps_multiplier * 7;
		
	[[level.pam_hud]]("kill_team_swap");

	game["halftimeflag"] = 1;
	level.halftimechange = 1;
	setcvar("halfooo", 1);

	//switch scores
	axistempscore = game["axisscore"];
	game["axisscore"] = game["alliedscore"];
	setTeamScore("axis", game["alliedscore"]);
	game["alliedscore"] = axistempscore;
	setTeamScore("allies", game["alliedscore"]);
	
	// ePAM
	//switch time-outs
	axistempto = game["axis_tos"];
	game["axis_tos"] = game["allies_tos"];
	game["allies_tos"] = axistempto;

	axissavedmodel = undefined;
	alliedsavedmodel = undefined;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{ 
		player = players[i];

		// Switch Teams
		if ( (isdefined (player.pers["team"])) && (player.pers["team"] == "axis") )
		{
			player.pers["team"] = "allies";
			axissavedmodel = player.pers["savedmodel"];
		}
		else if ( (isdefined (player.pers["team"])) && (player.pers["team"] == "allies") )
		{
			player.pers["team"] = "axis";
			alliedsavedmodel = player.pers["savedmodel"];
		}

		//Swap Models
		if ( (isdefined(player.pers["team"]) ) && (player.pers["team"] == "axis") )
			 player.pers["savedmodel"] = axissavedmodel;
		else if ( (isdefined(player.pers["team"])) && (player.pers["team"] == "allies") )
			player.pers["savedmodel"] = alliedsavedmodel;

		//drop weapons and make spec
		player.pers["weapon"] = undefined;
		player.pers["weapon1"] = undefined;
		player.pers["weapon2"] = "none";
		player.pers["spawnweapon"] = undefined;
		player.pers["selectedweapon"] = undefined;
		player.archivetime = 0;
		player.reflectdamage = undefined;

		player unlink();
		player enableWeapon();

		//change headicons
		if(level.drawfriend)
		{
			if(player.pers["team"] == "allies")
			{
				player.headicon = game["headicon_allies"];
				player.headiconteam = "allies";
			}
			else
			{
				player.headicon = game["headicon_axis"];
				player.headiconteam = "axis";
			}
		}
	}

	maps\pam\weapon_limiter::Update_All_Weapon_Limits();

	[[level.pam_hud]]("kill_all");

	if (game["mode"] == "match")
		game["Do_Ready_up"] = 1;

	if (!level.pam_mode_change)
	{
		level.exiting_map = true;
		map_restart(true);
	}

	return;
}

HalftimeSpawn()
{
	if (self.pers["team"] == "spectator")
		return;

	myteam = self.pers["team"];

	self closeMenu();

	if(self.pers["team"] == "allies")
	{
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		self openMenu(game["menu_weapon_allies"]);
	}
	else
	{
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		self openMenu(game["menu_weapon_axis"]);
	}

	while (!isdefined(self.pers["weapon"]) )
	{
		if(self.pers["team"] != myteam && self.pers["team"] != "spectator")
		{
			self.pers["team"] = myteam;
			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}

		if (self.pers["team"] == "spectator")
			return;

		wait level.fps_multiplier * .1;
	}

	if (isdefined(self.pers["weapon"]) )
	{
		self maps\pam\on_spawn_player::onPlayer_Spawn();

		self.sessionteam = self.pers["team"];
		self.sessionstate = "playing";
		self.spectatorclient = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		self.statusicon = "";
		self.maxhealth = 100;
		self.health = self.maxhealth;
		self.friendlydamage = undefined;
		self.spawned = true;

		if(self.pers["team"] == "allies")
			spawnpointname = "mp_sd_spawn_attacker";
		else
			spawnpointname = "mp_sd_spawn_defender";

		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

		if(!isdefined(self.pers["savedmodel"]))
			maps\mp\gametypes\_teams::model();
		else
			maps\mp\_utility::loadModel(self.pers["savedmodel"]);

		self setWeaponSlotWeapon("primaryb", "none");
		self maps\pam\weapons::givePistol();
	}
}

Reset_Pistols()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{ 
		player = players[i];

		if (player.pers["team"] == "spectator") return;

		if(player.pers["team"] == "allies")
		{
			switch(game["allies"])
			{
			case "american":
				pistoltype = "colt_mp";
				break;

			case "british":
				pistoltype = "webley_mp";
				break;

			default:
				pistoltype = "TT30_mp";
				break;
			}
		}
		else
			pistoltype = "luger_mp";

		player setWeaponSlotWeapon("primaryb", pistoltype);
		player giveMaxAmmo(pistoltype);
	}
}

// ePAM
Auto_Resume()
{
	level endon("rupover");
	
	level.ht_resume = newHudElem();
	level.ht_resume.x = 575;
	level.ht_resume.y = 220;
	level.ht_resume.color = (0.8, 0.3, 0);
	level.ht_resume.alignX = "center";
	level.ht_resume.alignY = "middle";
	level.ht_resume.font = "default";
	level.ht_resume.fontscale = 1.2;
	level.ht_resume setText(game["resuming"]);
	
	level.ht_resume_clock = newHudElem();
	level.ht_resume_clock.x = 575;
	level.ht_resume_clock.y = 235;
	level.ht_resume_clock.color = (.8, 1, 1);
	level.ht_resume_clock.alignX = "center";
	level.ht_resume_clock.alignY = "middle";
	level.ht_resume_clock.font = "default";
	level.ht_resume_clock.fontscale = 1.2;
	level.ht_resume_clock setTimer(game["ht_length"] * 60);
	
	wait level.fps_multiplier * game["ht_length"] * 60;
	
	level.playersready = true;
	if (isdefined(level.ht_resume))
		level.ht_resume destroy();
	if (isdefined(level.ht_resume_clock))
		level.ht_resume_clock destroy();


}