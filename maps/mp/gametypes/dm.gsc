/* Deathmatch */
main()
{
	if (getCvar("sv_pam") == "" )
		setCvar("sv_pam", "1");
	if (!isDefined(game["pam_enabled"]) )
		game["pam_enabled"] = getCvarint("sv_pam");
	level.pamenable = game["pam_enabled"];

	level.pam_mode_change = false;

	if (!game["pam_enabled"])
	{
		setcvar("sv_fps", "20");
		level.fps_multiplier = 1.0;
		level.frame = .05;

		game["ambient_sounds"] = true;
		game["ambient_fire"] = true;
		game["ambient_weather"] = true;
		game["ambient_fog"] = true;
	
		level.callbackStartGameType = ::Callback_StartGameType;
		level.callbackPlayerConnect = ::Callback_PlayerConnect;
		level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
		level.callbackPlayerDamage = ::Callback_PlayerDamage;
		level.callbackPlayerKilled = ::Callback_PlayerKilled;
		maps\mp\gametypes\_callbacksetup::SetupCallbacks();

		level.autoassign = ::menuAutoAssign;
		level.allies = ::menuAllies;
		level.axis = ::menuAxis;
		level.spectator = ::menuSpectator;
		level.weapon = ::menuWeapon;
		level.endgameconfirmed = ::endMap;
	}
	else
	{
		level.callbackStartGameType = maps\pam\dm::Callback_StartGameType;
		level.callbackPlayerConnect = maps\pam\dm::Callback_PlayerConnect;
		level.callbackPlayerDisconnect = maps\pam\dm::Callback_PlayerDisconnect;
		level.callbackPlayerDamage = maps\pam\dm::Callback_PlayerDamage;
		level.callbackPlayerKilled = maps\pam\dm::Callback_PlayerKilled;
		maps\mp\gametypes\_callbacksetup::SetupCallbacks();

		level.setdvar = maps\pam\utils\setdvar::Setup_Dvar;

		level.autoassign = maps\pam\dm::menuAutoAssign;
		level.allies = maps\pam\dm::menuAllies;
		level.axis = maps\pam\dm::menuAxis;
		level.spectator = maps\pam\dm::menuSpectator;
		level.weapon = maps\pam\dm::menuWeapon;
		level.endgameconfirmed = maps\pam\dm::endMap;
	}
}

Callback_StartGameType()
{
	level.splitscreen = isSplitScreen();

	// defaults if not defined in level script
	if(!isdefined(game["allies"]))
		game["allies"] = "american";
	if(!isdefined(game["axis"]))
		game["axis"] = "german";

	// server cvar overrides
	if(getCvar("scr_allies") != "")
		game["allies"] = getCvar("scr_allies");
	if(getCvar("scr_axis") != "")
		game["axis"] = getCvar("scr_axis");

	precacheStatusIcon("hud_status_dead");
	precacheStatusIcon("hud_status_connecting");
	precacheRumble("damage_heavy");
	precacheString(&"PLATFORM_PRESS_TO_SPAWN");

	//PAM TEMP!
	maps\pam\dvar_enforcer::DVAR_Enforcer_Init();

	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\mp\gametypes\_shellshock::init();
	
	// zPAM
	thread maps\mp\gametypes\_hud_playerscore::init();
	
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_grenadeindicators::init();

	level.xenon = (getcvar("xenonGame") == "true");
	if(level.xenon) // Xenon only
		thread maps\mp\gametypes\_richpresence::init();
	else // PC only
		thread maps\mp\gametypes\_quickmessages::init();

	setClientNameMode("auto_change");

	spawnpointname = "mp_dm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");

	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// Time limit per map
	if(getCvar("scr_dm_timelimit") == "")
		setCvar("scr_dm_timelimit", "30");
	else if(getCvarFloat("scr_dm_timelimit") > 1440)
		setCvar("scr_dm_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_dm_timelimit");
	setCvar("ui_dm_timelimit", level.timelimit);
	makeCvarServerInfo("ui_dm_timelimit", "30");

	// Score limit per map
	if(getCvar("scr_dm_scorelimit") == "")
		setCvar("scr_dm_scorelimit", "100");
	level.scorelimit = getCvarInt("scr_dm_scorelimit");
	setCvar("ui_dm_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_dm_scorelimit", "100");

	// Force respawning
	if(getCvar("scr_forcerespawn") == "")
		setCvar("scr_forcerespawn", "0");

	if(!isdefined(game["state"]))
		game["state"] = "playing";

	level.QuickMessageToAll = true;
	level.mapended = false;

	thread startGame();
	thread updateGametypeCvars();
	//thread maps\mp\gametypes\_teams::addTestClients();
}

dummy()
{
	waittillframeend;

	if(isdefined(self))
		level notify("connecting", self);
}

Callback_PlayerConnect()
{
	thread dummy();

	self.statusicon = "hud_status_connecting";
	self waittill("begin");
	self.statusicon = "";

	level notify("connected", self);

	//PAM TEMP!
	self.pers["dvarenforcement"] = 1;

	//self setclientcvar("hud_enable", 1);

	if(!level.splitscreen)
		iprintln(&"MP_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("J;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

	if(game["state"] == "intermission")
	{
		spawnIntermission();
		return;
	}

	level endon("intermission");
	
	self.pers["downloadedmod"] = 0;
	self thread maps\mp\gametypes\_forcedownload::forcedownload();

	if(level.splitscreen)
		scriptMainMenu = game["menu_ingame_spectator"];
	else
		scriptMainMenu = game["menu_ingame"];

	if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_allow_weaponchange", "1");
		self.sessionteam = "none";

		if(isdefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			spawnSpectator();

			if(self.pers["team"] == "allies")
			{
				self openMenu(game["menu_weapon_allies"]);
				scriptMainMenu = game["menu_weapon_allies"];
			}
			else
			{
				self openMenu(game["menu_weapon_axis"]);
				scriptMainMenu = game["menu_weapon_axis"];
			}
		}
	}
	else
	{
		self setClientCvar("ui_allow_weaponchange", "0");

		if(!isdefined(self.pers["skipserverinfo"]))
			self openMenu(game["menu_serverinfo"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";

		spawnSpectator();
	}

	self setClientCvar("g_scriptMainMenu", scriptMainMenu);
}

Callback_PlayerDisconnect()
{
	if(!level.splitscreen)
		iprintln(&"MP_DISCONNECTED", self);

	if(isdefined(self.clientid))
		setplayerteamrank(self, self.clientid, 0);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(self.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isdefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// Make sure at least one point of damage is done
	if(iDamage < 1)
		iDamage = 1;

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	// Apply the damage to the player
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

	// Shellshock/Rumble
	self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
	self playrumble("damage_heavy");
	if(isdefined(eAttacker) && eAttacker != self)
		eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("spawned");
	self notify("killed_player");

	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self maps\mp\gametypes\_weapons::dropWeapon();
	self maps\mp\gametypes\_weapons::dropOffhand();

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	if(!isdefined(self.switching_teams))
		self.deaths++;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfteam = "";
	lpselfguid = self getGuid();
	lpattackerteam = "";

	attackerNum = -1;
	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			if(!isdefined(self.switching_teams))
				attacker.score--;
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			attacker.score++;
			attacker checkScoreLimit();
		}

		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;

		attacker notify("update_playerhud_score");
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.score--;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";

		attacker notify("update_playerhud_score");
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Stop thread if map ended on this death
	if(level.mapended)
		return;

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	body = self cloneplayer(deathAnimDuration);
	thread maps\mp\gametypes\_deathicons::addDeathicon(body, self.clientid, self.pers["team"]);

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if(doKillcam && level.killcam)
		self maps\mp\gametypes\_killcam::killcam(attackerNum, delay, psOffsetTime, true);

	self thread respawn();
}

spawnPlayer()
{
	self endon("disconnect");
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionteam = "none";
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;

	spawnpointname = "mp_dm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	if(!isdefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	maps\mp\gametypes\_weapons::givePistol();
	maps\mp\gametypes\_weapons::giveGrenades();
	maps\mp\gametypes\_weapons::giveBinoculars();

	self giveWeapon(self.pers["weapon"]);
	self giveMaxAmmo(self.pers["weapon"]);
	self setSpawnWeapon(self.pers["weapon"]);

	if(!level.splitscreen)
	{
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING_NOSCORE");
	}
	else
		self setClientCvar("cg_objectiveText", &"MP_ELIMINATE_ENEMIES");

	waittillframeend;
	self notify("spawned_player");
}

spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	if(isdefined(origin) && isdefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnpointname = "mp_global_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self setClientCvar("cg_objectiveText", "");
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

respawn()
{
	if(!isdefined(self.pers["weapon"]))
		return;

	self endon("end_respawn");

	if(getCvarInt("scr_forcerespawn") <= 0)
	{
		self thread waitRespawnButton();
		self waittill("respawn");
	}

	self thread spawnPlayer();
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");

	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	self.respawntext = newClientHudElem(self);
	self.respawntext.horzAlign = "center_safearea";
	self.respawntext.vertAlign = "center_safearea";
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 0;
	self.respawntext.y = -50;
	self.respawntext.archived = false;
	self.respawntext.font = "default";
	self.respawntext.fontscale = 2;
	self.respawntext setText(&"PLATFORM_PRESS_TO_SPAWN");

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while((isdefined(self)) && (self useButtonPressed() != true))
		wait .05;

	if(isdefined(self))
	{
		self notify("remove_respawntext");
		self notify("respawn");
	}
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isdefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}

startGame()
{
	level.starttime = getTime();

	if(level.timelimit > 0)
	{
		level.clock = newHudElem();
		level.clock.horzAlign = "left";
		level.clock.vertAlign = "top";
		level.clock.x = 8;
		level.clock.y = 2;
		level.clock.font = "default";
		level.clock.fontscale = 2;
		level.clock setTimer(level.timelimit * 60);
	}

	for(;;)
	{
		checkTimeLimit();
		wait 1;
	}
}

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");

	players = getentarray("player", "classname");
	highscore = undefined;
	tied = undefined;
	playername = undefined;
	name = undefined;
	guid = undefined;

	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;

		if(!isdefined(highscore))
		{
			highscore = player.score;
			playername = player;
			name = player.name;
			guid = player getGuid();
			continue;
		}

		if(player.score == highscore)
			tied = true;
		else if(player.score > highscore)
		{
			tied = false;
			highscore = player.score;
			playername = player;
			name = player.name;
			guid = player getGuid();
		}
	}

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player closeMenu();
		player closeInGameMenu();

		if(isdefined(tied) && tied == true)
			player setClientCvar("cg_objectiveText", &"MP_THE_GAME_IS_A_TIE");
		else if(isdefined(playername))
			player setClientCvar("cg_objectiveText", &"MP_WINS", playername);

		player spawnIntermission();
	}

	if(isdefined(name))
		logPrint("W;;" + guid + ";" + name + "\n");

	// set everyone's rank on xenon
	if(level.xenon)
	{
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(isdefined(player.pers["team"]) && player.pers["team"] == "spectator")
				continue;

			if(highscore <= 0)
				rank = 0;
			else
			{
				rank = int(player.score * 10 / highscore);
				if(rank < 0)
					rank = 0;
			}

			// since DM is a free-for-all, give every player their own team number
			setplayerteamrank(player, player.clientid, rank);
		}
		sendranks();
	}

	wait 10;
	exitLevel(false);
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;

	timepassed = (getTime() - level.starttime) / 1000;
	timepassed = timepassed / 60.0;

	if(timepassed < level.timelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_TIME_LIMIT_REACHED");

	level thread endMap();
}

checkScoreLimit()
{
	waittillframeend;

	if(level.scorelimit <= 0)
		return;

	if(self.score < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_SCORE_LIMIT_REACHED");

	level thread endMap();
}

updateGametypeCvars()
{
	for(;;)
	{
		timelimit = getCvarFloat("scr_dm_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_dm_timelimit", "1440");
			}

			level.timelimit = timelimit;
			setCvar("ui_dm_timelimit", level.timelimit);
			level.starttime = getTime();

			if(level.timelimit > 0)
			{
				if(!isdefined(level.clock))
				{
					level.clock = newHudElem();
					level.clock.horzAlign = "left";
					level.clock.vertAlign = "top";
					level.clock.x = 8;
					level.clock.y = 2;
					level.clock.font = "default";
					level.clock.fontscale = 2;
				}
				level.clock setTimer(level.timelimit * 60);
			}
			else
			{
				if(isdefined(level.clock))
					level.clock destroy();
			}

			checkTimeLimit();
		}

		scorelimit = getCvarInt("scr_dm_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_dm_scorelimit", level.scorelimit);
			level notify("update_allhud_score");

			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				players[i] checkScoreLimit();
		}

		wait 1;
	}
}

menuAutoAssign()
{
	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
	{
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self suicide();
		}

		teams[0] = "allies";
		teams[1] = "axis";
		self.pers["team"] = teams[randomInt(2)];
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");

		if(self.pers["team"] == "allies")
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_weapon_allies"]);
		else
			self openMenu(game["menu_weapon_axis"]);
	}
}

menuAllies()
{
	if(self.pers["team"] != "allies")
	{
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self suicide();
		}

		self.pers["team"] = "allies";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_allies"]);
}

menuAxis()
{
	if(self.pers["team"] != "axis")
	{
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self suicide();
		}

		self.pers["team"] = "axis";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_axis"]);
}

menuSpectator()
{
	if(self.pers["team"] != "spectator")
	{
		if(isAlive(self))
		{
			self.switching_teams = true;
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self.sessionteam = "spectator";
		self setClientCvar("ui_allow_weaponchange", "0");
		spawnSpectator();

		if(level.splitscreen)
			self setClientCvar("g_scriptMainMenu", game["menu_ingame_spectator"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_ingame"]);

		self notify("joined_spectators");
	}
}

menuWeapon(response)
{
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	weapon = self maps\mp\gametypes\_weapons::restrictWeaponByServerCvars(response);

	if(weapon == "restricted")
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_weapon_allies"]);
		else if(self.pers["team"] == "axis")
			self openMenu(game["menu_weapon_axis"]);

		return;
	}

	if(level.splitscreen)
		self setClientCvar("g_scriptMainMenu", game["menu_ingame_onteam"]);
	else
		self setClientCvar("g_scriptMainMenu", game["menu_ingame"]);

	if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
		return;

	if(!isdefined(self.pers["weapon"]))
	{
		self.pers["weapon"] = weapon;
		spawnPlayer();
	}
	else
	{
		self.pers["weapon"] = weapon;

		weaponname = maps\mp\gametypes\_weapons::getWeaponName(self.pers["weapon"]);

		mode = getcvar("pam_mode");
		if ((!game["matchstarted"] || (isDefined(level.rdyup) && level.rdyup)) && mode != "pub" && (isDefined(level.intimeout) && !level.intimeout))
		{
		} else if (game["matchstarted"] || (isDefined(level.rdyup) && !level.rdyup) || (isDefined(level.intimeout) && level.intimeout))
		{
			if(maps\pam\weapons::useAn(self.pers["weapon"]))
				self iprintln(&"MP_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MP_YOU_WILL_RESPAWN_WITH_A", weaponname);
		}
	}
}
