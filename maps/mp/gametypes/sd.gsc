/*	Search and Destroy */
main()
{
	if (getCvar("sv_pam") == "" )
		setCvar("sv_pam", "1");
	if (!isDefined(game["pam_enabled"]) )
		game["pam_enabled"] = getCvarint("sv_pam");
	level.pamenable = game["pam_enabled"];

	level.pam_mode_change = false;

	mode = getcvar("pam_mode");

	if (mode != "pub")
		thread maps\pam\serverset::deadchat();

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
		level.callbackStartGameType = maps\pam\sd::Callback_StartGameType;
		level.callbackPlayerConnect = maps\pam\sd::Callback_PlayerConnect;
		level.callbackPlayerDisconnect = maps\pam\sd::Callback_PlayerDisconnect;
		level.callbackPlayerDamage = maps\pam\sd::Callback_PlayerDamage;
		level.callbackPlayerKilled = maps\pam\sd::Callback_PlayerKilled; 
		maps\mp\gametypes\_callbacksetup::SetupCallbacks();

		level.setdvar = maps\pam\utils\setdvar::Setup_Dvar;

		level.autoassign = maps\pam\sd::menuAutoAssign;
		level.allies = maps\pam\sd::menuAllies;
		level.axis = maps\pam\sd::menuAxis;
		level.spectator = maps\pam\sd::menuSpectator;
		level.weapon = maps\pam\sd::menuWeapon;
		level.endgameconfirmed = maps\pam\sd::endMap;
	}
	
	//if (getcvarint("pam_enable_serverbot") == 1)
	//	thread maps\mp\gametypes\_serverbot::serverbot();

	mode = getcvar("pam_mode");

	if (mode == "bash" || mode == "cg" || mode == "cg_1v1" || mode == "cg_2v2" || mode == "cg_mr3" || mode == "cg_mr10" || mode == "cg_mr12" || mode == "cg_rifle" || mode == "cg_rush" ||  mode == "mr3" || mode == "mr10" || mode == "mr12" || mode == "mr15")

	{
		pbsvload = "pbsvuser.cfg";
		setcvar("pb_sv_load", pbsvload);
	}

	serverbot_start_cfg = "serverbotstart.cfg";
	setcvar("exec", serverbot_start_cfg);
}

Callback_StartGameType()
{
	//thread maps\mp\gametypes\_serverbot::serverbot();

	level.splitscreen = isSplitScreen();

	// if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
	if(!isdefined(game["gamestarted"]))
	{
		// defaults if not defined in level script
		if(!isdefined(game["allies"]))
			game["allies"] = "american";
		if(!isdefined(game["axis"]))
			game["axis"] = "german";
		if(!isdefined(game["attackers"]))
			game["attackers"] = "allies";
		if(!isdefined(game["defenders"]))
			game["defenders"] = "axis";

		// server cvar overrides
		if(getCvar("scr_allies") != "")
			game["allies"] = getCvar("scr_allies");
		if(getCvar("scr_axis") != "")
			game["axis"] = getCvar("scr_axis");

		//PAM
		game["pam_on_off"] = &"PAM Enabled";
		precacheString(game["pam_on_off"]);
		game["please_wait"] = &"Please Wait";
		precacheString(game["please_wait"]);

		precacheStatusIcon("hud_status_dead");
		precacheStatusIcon("hud_status_connecting");
		precacheRumble("damage_heavy");
		precacheShader("white");
		precacheShader("plantbomb");
		precacheShader("defusebomb");
		precacheShader("objective");
		precacheShader("objectiveA");
		precacheShader("objectiveB");
		precacheShader("bombplanted");
		precacheShader("objpoint_bomb");
		precacheShader("objpoint_A");
		precacheShader("objpoint_B");
		precacheShader("objpoint_star");
		precacheShader("hudStopwatch");
		precacheShader("hudstopwatchneedle");
		precacheString(&"MP_MATCHSTARTING");
		precacheString(&"MP_MATCHRESUMING");
		precacheString(&"MP_EXPLOSIVESPLANTED");
		precacheString(&"MP_EXPLOSIVESDEFUSED");
		precacheString(&"MP_ROUNDDRAW");
		precacheString(&"MP_TIMEHASEXPIRED");
		precacheString(&"MP_ALLIEDMISSIONACCOMPLISHED");
		precacheString(&"MP_AXISMISSIONACCOMPLISHED");
		precacheString(&"MP_ALLIESHAVEBEENELIMINATED");
		precacheString(&"MP_AXISHAVEBEENELIMINATED");
		precacheString(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
		precacheString(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
		precacheModel("xmodel/mp_tntbomb");
		precacheModel("xmodel/mp_tntbomb_obj");

		//thread maps\mp\gametypes\_teams::addTestClients();
	}

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
	thread maps\mp\gametypes\_hud_teamscore::init();
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_objpoints::init();
	thread maps\mp\gametypes\_friendicons::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\mp\gametypes\_grenadeindicators::init();
	//thread maps\mp\gametypes\_forcedownload::forcedownload();

	level.xenon = (getcvar("xenonGame") == "true");
	if(level.xenon) // Xenon only
		thread maps\mp\gametypes\_richpresence::init();
	else // PC only
		thread maps\mp\gametypes\_quickmessages::init();

	
	// zPAM
	mode = getcvar("pam_mode");	

	if ( ( (isdefined(level.rdyup) && level.rdyup) || (isdefined(game["matchstarted"]) && !game["matchstarted"]) || (isdefined(level.warmup) && level.warmup) || (isdefined(level.mapended) && level.mapended) || (isdefined(level.instrattime) && level.instrattime) || !isDefined(game["firstreadyupdone"]) ) && mode != "pub" )
		setClientNameMode("auto_change");
	else
		setClientNameMode("manual_change");

	game["gamestarted"] = true;

	spawnpointname = "mp_sd_spawn_attacker";
	spawnpoints = getentarray(spawnpointname, "classname");

	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	spawnpointname = "mp_sd_spawn_defender";
	spawnpoints = getentarray(spawnpointname, "classname");

	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] PlaceSpawnpoint();

	level._effect["bombexplosion"] = loadfx("fx/props/barrelexp.efx");

	allowed[0] = "sd";
	allowed[1] = "bombzone";
	allowed[2] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// Time limit per map
	if(getCvar("scr_sd_timelimit") == "")
		setCvar("scr_sd_timelimit", "0");
	else if(getCvarFloat("scr_sd_timelimit") > 1440)
		setCvar("scr_sd_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_sd_timelimit");
	setCvar("ui_sd_timelimit", level.timelimit);
	makeCvarServerInfo("ui_sd_timelimit", "0");

	if(!isdefined(game["timepassed"]))
		game["timepassed"] = 0;

	// Score limit per map
	level.scorelimit = getCvarInt("scr_sd_end_score");
	setCvar("ui_sd_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_sd_scorelimit", "10");

	// Round limit per map
	if(getCvar("scr_sd_roundlimit") == "")
		setCvar("scr_sd_roundlimit", "0");
	level.roundlimit = getCvarInt("scr_sd_roundlimit");
	setCvar("ui_sd_roundlimit", level.roundlimit);
	makeCvarServerInfo("ui_sd_roundlimit", "0");

	// Time at round start where spawning and weapon choosing is still allowed
	if(getCvar("scr_sd_graceperiod") == "")
		setCvar("scr_sd_graceperiod", "15");
	else if(getCvarFloat("scr_sd_graceperiod") > 60)
		setCvar("scr_sd_graceperiod", "60");
	else if(getCvarFloat("scr_sd_graceperiod") < 0)
		setCvar("scr_sd_graceperiod", "0");
	level.graceperiod = getCvarFloat("scr_sd_graceperiod");

	// Time length of each round
	if(getCvar("scr_sd_roundlength") == "")
		setCvar("scr_sd_roundlength", "4");
	else if(getCvarFloat("scr_sd_roundlength") > 10)
		setCvar("scr_sd_roundlength", "10");
	else if(getCvarFloat("scr_sd_roundlength") < (level.graceperiod / 60))
		setCvar("scr_sd_roundlength", (level.graceperiod / 60));
	level.roundlength = getCvarFloat("scr_sd_roundlength");

	// Sets the time it takes for a planted bomb to explode
	if(getCvar("scr_sd_bombtimer") == "")
		setCvar("scr_sd_bombtimer", "60");
	else if(getCvarInt("scr_sd_bombtimer") > 120)
		setCvar("scr_sd_bombtimer", "120");
	else if(getCvarInt("scr_sd_bombtimer") < 30)
		setCvar("scr_sd_bombtimer", "30");
	level.bombtimer = getCvarInt("scr_sd_bombtimer");

	// Auto Team Balancing
	if(getCvar("scr_teambalance") == "")
		setCvar("scr_teambalance", "0");
	level.teambalance = getCvarInt("scr_teambalance");
	level.lockteams = false;

	// Draws a team icon over teammates
	if(getCvar("scr_drawfriend") == "")
		setCvar("scr_drawfriend", "1");
	level.drawfriend = getCvarInt("scr_drawfriend");

	if(!isdefined(game["state"]))
		game["state"] = "playing";
	if(!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;
	if(!isdefined(game["matchstarted"]))
		game["matchstarted"] = false;

	if(!isdefined(game["alliedscore"]))
		game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);

	if(!isdefined(game["axisscore"]))
		game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);

	level.bombplanted = false;
	level.bombexploded = false;
	level.roundstarted = false;
	level.roundended = false;
	level.roundendedkill = false;
	level.mapended = false;
	level.bombmode = 0;

	level.exist["allies"] = 0;
	level.exist["axis"] = 0;
	level.exist["teams"] = false;
	level.didexist["allies"] = false;
	level.didexist["axis"] = false;

	thread bombzones();
	thread startGame();
	thread updateGametypeCvars();
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

	if(!isdefined(self.pers["team"]) && !level.splitscreen)
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
	{
		if(isdefined(self.pers["weapon"]))
			scriptMainMenu = game["menu_ingame_onteam"];
		else
			scriptMainMenu = game["menu_ingame_spectator"];
	}
	else
		scriptMainMenu = game["menu_ingame"];

	if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_allow_weaponchange", "1");

		if(isdefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			self.sessionteam = "spectator";

			spawnSpectator();

			//if (getcvarint("pam_enable_serverbot") == 1)
				//thread maps\mp\gametypes\_serverbot::serverbot();

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
		
		//if (getcvarint("pam_enable_serverbot") == 1)
			//thread maps\mp\gametypes\_serverbot::serverbot();
	}

	self setClientCvar("g_scriptMainMenu", scriptMainMenu);
}

Callback_PlayerDisconnect()
{
	//if (isdefined(bombzone_other))
	//{
		self clientreleasetrigger(self.release1);
		//self clientreleasetrigger(self.release2);
	//}

	if(!level.splitscreen)
		iprintln(&"MP_DISCONNECTED", self);

	if(isdefined(self.pers["team"]))
	{
		if(self.pers["team"] == "allies")
			setplayerteamrank(self, 0, 0);
		else if(self.pers["team"] == "axis")
			setplayerteamrank(self, 1, 0);
		else if(self.pers["team"] == "spectator")
			setplayerteamrank(self, 2, 0);
	}

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

	if(game["matchstarted"])
		level thread updateTeamStatus();
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(self.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isdefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	friendly = undefined;

	// check for completely getting out of the damage
	if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if(isPlayer(eAttacker) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]))
		{
			if(level.friendlyfire == "0")
			{
				return;
			}
			else if(level.friendlyfire == "1")
			{
				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

				// Shellshock/Rumble
				self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
				self playrumble("damage_heavy");
			}
			else if(level.friendlyfire == "2")
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;

				friendly = true;
			}
			else if(level.friendlyfire == "3")
			{
				eAttacker.friendlydamage = true;

				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;

				// Shellshock/Rumble
				self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
				self playrumble("damage_heavy");

				friendly = true;
			}
		}
		else
		{
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

			// Shellshock/Rumble
			self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
			self playrumble("damage_heavy");
		}

		if(isdefined(eAttacker) && eAttacker != self)
			eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();
	}

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfguid = self getGuid();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackguid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackguid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		if(isdefined(friendly))
		{
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackguid = lpselfguid;
		}

		logPrint("D;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
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
	{
		self.pers["deaths"]++;
		self.deaths = self.pers["deaths"];
	}

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	lpselfname = self.name;
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	attackerNum = -1;

	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			// switching teams
			if(isdefined(self.switching_teams))
			{
				if((self.leaving_team == "allies" && self.joining_team == "axis") || (self.leaving_team == "axis" && self.joining_team == "allies"))
				{
					players = maps\mp\gametypes\_teams::CountPlayers();
					players[self.leaving_team]--;
					players[self.joining_team]++;

					if((players[self.joining_team] - players[self.leaving_team]) > 1)
					{
						attacker.pers["score"]--;
						attacker.score = attacker.pers["score"];
					}
				}
			}

			if(isdefined(attacker.friendlydamage))
				attacker iprintln(&"MP_FRIENDLY_FIRE_WILL_NOT");
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
			{
				attacker.pers["score"]--;
				attacker.score = attacker.pers["score"];
			}
			else
			{
				attacker.pers["score"]++;
				attacker.score = attacker.pers["score"];
			}
		}

		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackerteam = attacker.pers["team"];

		self notify("killed_player", attacker);
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.pers["score"]--;
		self.score = self.pers["score"];

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";

		self notify("killed_player", self);
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	/* level.killonja++;
	whokwho = lpselfteam + "�" + lpselfname + "�" + lpattackerteam + "�" + lpattackname + "�" + sWeapon + "�" + sHitLoc + "�" + sMeansOfDeath + "�" + level.killonja;
	setcvar("killinstuff", whokwho); */

	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;

	if(isdefined(self.bombtimer))
		self.bombtimer destroy();

	if(!isdefined(self.switching_teams))
	{
		body = self cloneplayer(deathAnimDuration);
		thread maps\mp\gametypes\_deathicons::addDeathicon(body, self.clientid, self.pers["team"], 5);
	}
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	level updateTeamStatus();

	if(!level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
	{
		doKillcam = false;
		self.skip_setspectatepermissions = true;

		if(level.bombplanted && level.planting_team == self.pers["team"])
		{
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.pers["team"] == self.pers["team"])
				{
					player allowSpectateTeam("allies", true);
					player allowSpectateTeam("axis", true);
					player allowSpectateTeam("freelook", true);
					player allowSpectateTeam("none", false);
				}
			}
		}
	}

	//delay = 2;	// Delay the player becoming a spectator till after he's done dying
	//wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

	if(doKillcam && level.killcam && !level.roundended)
		self maps\mp\gametypes\_killcam::killcam(attackerNum, psOffsetTime);
		//self maps\mp\gametypes\_killcam::killcam(attackerNum, delay, psOffsetTime);

	currentorigin = self.origin;
	currentangles = self.angles;
	self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
}

spawnPlayer()
{
	self endon("disconnect");
	self notify("spawned");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.pers["beenspec"] = 0;

	if(isdefined(self.spawned))
		return;

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

	level updateTeamStatus();

	if(!isdefined(self.pers["score"]))
		self.pers["score"] = 0;
	self.score = self.pers["score"];

	if(!isdefined(self.pers["deaths"]))
		self.pers["deaths"] = 0;
	self.deaths = self.pers["deaths"];

	if(!isdefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	mode = getcvar("pam_mode");	

	if (mode != "bash")
	{
		if(isdefined(self.pers["weapon1"]) && isdefined(self.pers["weapon2"]))
		{
		 	self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
	
		 	self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
			self setWeaponSlotAmmo("primaryb", 999);
			self setWeaponSlotClipAmmo("primaryb", 999);
	
			self setSpawnWeapon(self.pers["spawnweapon"]);
		}
		else
		{
			self setWeaponSlotWeapon("primary", self.pers["weapon"]);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
	
			self setSpawnWeapon(self.pers["weapon"]);
		}
	}

	maps\mp\gametypes\_weapons::givePistol();
	thread maps\mp\gametypes\_weapons::giveGrenades();
	maps\mp\gametypes\_weapons::giveBinoculars();
	
	if (mode == "bash")
	{
		self setClientCvar("ui_allow_weaponchange", "0");
	}

	self.usedweapons = false;
	thread maps\mp\gametypes\_weapons::watchWeaponUsage();

	if(level.bombplanted)
		thread showPlayerBombTimer();

	mode = getcvar("pam_mode");
		
	if (mode == "bash")
	{
		if(!level.splitscreen)
		{
			if(level.scorelimit > 0)
			{
				if(self.pers["team"] == game["attackers"])
					self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
				else if(self.pers["team"] == game["defenders"])
					self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
			}
			else
			{
				if(self.pers["team"] == game["attackers"])
					self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
				else if(self.pers["team"] == game["defenders"])
					self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
			}
		}
		else
		{
			if(self.pers["team"] == game["attackers"])
				self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
			else if(self.pers["team"] == game["defenders"])
				self setClientCvar("cg_objectiveText", "Eliminate your enemy, then choose side/map.");
		}
	}
	else
	{
		if(!level.splitscreen)
		{
			if(level.scorelimit > 0)
			{
				if(self.pers["team"] == game["attackers"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_ATTACKERS", level.scorelimit);
				else if(self.pers["team"] == game["defenders"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_DEFENDERS", level.scorelimit);
			}
			else
			{
				if(self.pers["team"] == game["attackers"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_ATTACKERS_NOSCORE");
				else if(self.pers["team"] == game["defenders"])
					self setClientCvar("cg_objectiveText", &"MP_OBJ_DEFENDERS_NOSCORE");
			}
		}
		else
		{
			if(self.pers["team"] == game["attackers"])
				self setClientCvar("cg_objectiveText", &"MP_DESTROY_THE_OBJECTIVE");
			else if(self.pers["team"] == game["defenders"])
				self setClientCvar("cg_objectiveText", &"MP_DEFEND_THE_OBJECTIVE");
		}
	}

	waittillframeend;
	self notify("spawned_player");
}

spawnSpectator(origin, angles)
{
	self notify("spawned");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	if(!isdefined(self.skip_setspectatepermissions))
		maps\mp\gametypes\_spectating::setSpectatePermissions();

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

	level updateTeamStatus();

	self.usedweapons = false;

	self setClientCvar("cg_objectiveText", "");
}

spawnIntermission()
{
	self notify("spawned");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

startGame()
{
	level.starttime = getTime();
	thread startRound();
}

startRound()
{
	level endon("bomb_planted");
	level endon("round_ended");

	if(!level.splitscreen)
		thread sayObjective();

	level.roundended_dc = 0;

	level.clock = newHudElem();
	level.clock.horzAlign = "left";
	level.clock.vertAlign = "top";
	level.clock.x = 8;
	level.clock.y = 2;
	level.clock.font = "default";
	level.clock.fontscale = 2;
	level.clock setTimer(level.roundlength * 60);

	if(game["matchstarted"])
	{
		level.clock.color = (.98, .827, .58);

		if((level.roundlength * 60) > level.graceperiod)
		{
			wait level.graceperiod;

			level notify("round_started");
			level.roundstarted = true;
			level.clock.color = (1, 1, 1);

			// Players on a team but without a weapon show as dead since they can not get in this round
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.sessionteam != "spectator" && !isdefined(player.pers["weapon"]))
					player.statusicon = "hud_status_dead";
			}

			wait((level.roundlength * 60) - level.graceperiod);
		}
		else
			wait(level.roundlength * 60);
	}
	else
	{
		level.clock.color = (1, 1, 1);
		wait(level.roundlength * 60);
	}

	if(level.roundended)
		return;

	/* mode = getcvar("pam_mode");

	if(mode == "bash")
		return; */

	if(!level.exist[game["attackers"]] || !level.exist[game["defenders"]])
	{
		iprintln(&"MP_TIMEHASEXPIRED");
		level thread endRound("draw");
		return;
	}

	iprintln(&"MP_TIMEHASEXPIRED");
	level thread endRound(game["defenders"]);
}

checkMatchStart()
{
	oldvalue["teams"] = level.exist["teams"];
	level.exist["teams"] = false;

	// If teams currently exist
	if(level.exist["allies"] && level.exist["axis"])
		level.exist["teams"] = true;

	// If teams previously did not exist and now they do
	if(!oldvalue["teams"] && level.exist["teams"])
	{
		if(!game["matchstarted"])
		{
			iprintln(&"MP_MATCHSTARTING");

			level notify("kill_endround");
			level.roundended = false;
			level.roundendedkill = false;
			level thread endRound("reset");
		}
		else
		{
			iprintln(&"MP_MATCHRESUMING");

			level notify("kill_endround");
			level.roundended = false;
			level.roundendedkill = false;
			level thread endRound("draw");
		}

		return;
	}
}

resetScores()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.pers["score"] = 0;
		player.pers["deaths"] = 0;
	}

	game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);
	game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);
}

endRound(roundwinner)
{
	level endon("intermission");
	level endon("kill_endround");

	if(level.roundended)
		return;
	level.roundended = true; // pravo end round
	level.roundended_dc = 1;

	thread roundendedk();

	// End bombzone threads and remove related hud elements and objectives
	level notify("round_ended");
	level notify("update_allhud_score");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.progressbackground))
			player.progressbackground destroy();

		if(isdefined(player.progressbar))
			player.progressbar destroy();

		player unlink();
		player enableWeapon();
	}

	objective_delete(0);
	objective_delete(1);

	level thread announceWinner(roundwinner, 2);

	winners = "";
	losers = "";

	if(roundwinner == "allies")
	{
		game["alliedscore"]++;
		setTeamScore("allies", game["alliedscore"]);

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
		}
		logPrint("W;allies" + winners + "\n");
		logPrint("L;axis" + losers + "\n");
	}
	else if(roundwinner == "axis")
	{
		game["axisscore"]++;
		setTeamScore("axis", game["axisscore"]);

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
		}
		logPrint("W;axis" + winners + "\n");
		logPrint("L;allies" + losers + "\n");
	}

	wait level.fps_multiplier * 5;

	if(game["matchstarted"])
	{
		checkScoreLimit();
		game["roundsplayed"]++;
		checkRoundLimit();
	}

	if(!game["matchstarted"] && roundwinner == "reset")
	{
		game["matchstarted"] = true;
		thread resetScores();
		game["roundsplayed"] = 0;
	}

	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;

	checkTimeLimit();

	if(level.mapended)
		return;
	level.mapended = true;

	// for all living players store their weapons
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			weapon1 = player getWeaponSlotWeapon("primary");
			weapon2 = player getWeaponSlotWeapon("primaryb");
			current = player getCurrentWeapon();

			// A new weapon has been selected
			if(isdefined(player.oldweapon))
			{
				player.pers["weapon1"] = player.pers["weapon"];
				player.pers["weapon2"] = "none";
				player.pers["spawnweapon"] = player.pers["weapon1"];
			} // No new weapons selected
			else
			{
				if(!maps\mp\gametypes\_weapons::isMainWeapon(weapon1) && !maps\mp\gametypes\_weapons::isMainWeapon(weapon2))
				{
					player.pers["weapon1"] = player.pers["weapon"];
					player.pers["weapon2"] = "none";
				}
				else if(maps\mp\gametypes\_weapons::isMainWeapon(weapon1) && !maps\mp\gametypes\_weapons::isMainWeapon(weapon2))
				{
					player.pers["weapon1"] = weapon1;
					player.pers["weapon2"] = "none";
				}
				else if(!maps\mp\gametypes\_weapons::isMainWeapon(weapon1) && maps\mp\gametypes\_weapons::isMainWeapon(weapon2))
				{
					player.pers["weapon1"] = weapon2;
					player.pers["weapon2"] = "none";
				}
				else
				{
					assert(maps\mp\gametypes\_weapons::isMainWeapon(weapon1) && maps\mp\gametypes\_weapons::isMainWeapon(weapon2));

					if(current == weapon2)
					{
						player.pers["weapon1"] = weapon2;
						player.pers["weapon2"] = weapon1;
					}
					else
					{
						player.pers["weapon1"] = weapon1;
						player.pers["weapon2"] = weapon2;
					}
				}

				player.pers["spawnweapon"] = player.pers["weapon1"];
			}
		}
	}

	level notify("restarting");

	if (!level.pam_mode_change)
		map_restart(true);

	//level.roundendedkill = true;
}

roundendedk()
{
	wait level.fps_multiplier * 5;
	level.roundendedkill = true;
}

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");

	if(isdefined(level.bombmodel))
		level.bombmodel stopLoopSound();

	if(game["alliedscore"] == game["axisscore"])
		text = &"MP_THE_GAME_IS_A_TIE";
	else if(game["alliedscore"] > game["axisscore"])
		text = &"MP_ALLIES_WIN";
	else
		text = &"MP_AXIS_WIN";

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player closeMenu();
		player closeInGameMenu();
		player setClientCvar("cg_objectiveText", text);

		player spawnIntermission();
	}

	// set everyone's rank on xenon
	if(level.xenon)
	{
		players = getentarray("player", "classname");
		highscore = undefined;

		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(!isdefined(player.score))
				continue;

			if(!isdefined(highscore) || player.score > highscore)
				highscore = player.score;
		}

		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(!isdefined(player.score))
				continue;

			if(highscore <= 0)
				rank = 0;
			else
			{
				rank = int(player.score * 10 / highscore);
				if(rank < 0)
					rank = 0;
			}

			if(player.pers["team"] == "allies")
				setplayerteamrank(player, 0, rank);
			else if(player.pers["team"] == "axis")
				setplayerteamrank(player, 1, rank);
			else if(player.pers["team"] == "spectator")
				setplayerteamrank(player, 2, rank);
		}
		sendranks();
	}

	wait 10;
	if (!level.pam_mode_change)
		exitLevel(false);
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;

	if(game["timepassed"] < level.timelimit)
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
	if(level.scorelimit <= 0)
		return;

	if(game["alliedscore"] < level.scorelimit && game["axisscore"] < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_SCORE_LIMIT_REACHED");

	level thread endMap();
}

checkRoundLimit()
{
	if(level.roundlimit <= 0)
		return;

	if(game["roundsplayed"] < level.roundlimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_ROUND_LIMIT_REACHED");

	level thread endMap();
}

updateGametypeCvars()
{
	for(;;)
	{	
		pam_enable = getcvarint("sv_pam");
		if (level.pamenable != pam_enable)
		{
			maps\pam\next_map::PAM_state_change();
			break;
		}

		timelimit = getCvarFloat("scr_sd_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_sd_timelimit", "1440");
			}

			level.timelimit = timelimit;
			setCvar("ui_sd_timelimit", level.timelimit);
		}

		scorelimit = getCvarInt("scr_sd_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_sd_scorelimit", level.scorelimit);
			level notify("update_allhud_score");

			if(game["matchstarted"])
				checkScoreLimit();
		}

		roundlimit = getCvarInt("scr_sd_roundlimit");
		if(level.roundlimit != roundlimit)
		{
			level.roundlimit = roundlimit;
			setCvar("ui_sd_roundlimit", level.roundlimit);

			if(game["matchstarted"])
				checkRoundLimit();
		}

		wait 1;
	}
}

updateTeamStatus()
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute

	resettimeout();

	oldvalue["allies"] = level.exist["allies"];
	oldvalue["axis"] = level.exist["axis"];
	level.exist["allies"] = 0;
	level.exist["axis"] = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			level.exist[player.pers["team"]]++;
	}

	if(level.exist["allies"])
		level.didexist["allies"] = true;
	if(level.exist["axis"])
		level.didexist["axis"] = true;

	if(level.roundended)
		return;

	// if both allies and axis were alive and now they are both dead in the same instance
	if(oldvalue["allies"] && !level.exist["allies"] && oldvalue["axis"] && !level.exist["axis"])
	{
		if(level.bombplanted)
		{
			// if allies planted the bomb, allies win
			if(level.planting_team == "allies")
			{
				iprintln(&"MP_ALLIEDMISSIONACCOMPLISHED");
				level thread endRound("allies");
				return;
			}
			else // axis planted the bomb, axis win
			{
				assert(game["attackers"] == "axis");
				iprintln(&"MP_AXISMISSIONACCOMPLISHED");
				level thread endRound("axis");
				return;
			}
		}

		// if there is no bomb planted the round is a draw
		iprintln(&"MP_ROUNDDRAW");
		level thread endRound("draw");
		return;
	}

	// if allies were alive and now they are not
	if(oldvalue["allies"] && !level.exist["allies"])
	{
		// if allies planted the bomb, continue the round
		if(level.bombplanted && level.planting_team == "allies")
			return;

		iprintln(&"MP_ALLIESHAVEBEENELIMINATED");
		level thread playSoundOnPlayers("mp_announcer_allieselim");
		level thread endRound("axis");
		return;
	}

	// if axis were alive and now they are not
	if(oldvalue["axis"] && !level.exist["axis"])
	{
		// if axis planted the bomb, continue the round
		if(level.bombplanted && level.planting_team == "axis")
			return;

		iprintln(&"MP_AXISHAVEBEENELIMINATED");
		level thread playSoundOnPlayers("mp_announcer_axiselim");
		level thread endRound("allies");
		return;
	}
}

bombzones()
{
	maperrors = [];

	if(level.splitscreen)
		level.barsize = 152;
	else
		level.barsize = 192;

	level.planttime = 5;		// seconds to plant a bomb
	level.defusetime = 10;		// seconds to defuse a bomb

	wait .2;

	bombzones = getentarray("bombzone", "targetname");
	array = [];

	if(level.bombmode == 0)
	{
		for(i = 0; i < bombzones.size; i++)
		{
			bombzone = bombzones[i];

			if(isdefined(bombzone.script_bombmode_original) && isdefined(bombzone.script_label))
				array[array.size] = bombzone;
		}

		if(array.size == 2)
		{
			bombzone0 = array[0];
			bombzone1 = array[1];
			bombzoneA = undefined;
			bombzoneB = undefined;

			if(bombzone0.script_label == "A" || bombzone0.script_label == "a")
		 	{
		 		bombzoneA = bombzone0;
		 		bombzoneB = bombzone1;
		 	}
		 	else if(bombzone0.script_label == "B" || bombzone0.script_label == "b")
		 	{
		 		bombzoneA = bombzone1;
		 		bombzoneB = bombzone0;
		 	}
		 	else
		 		maperrors[maperrors.size] = "^1Bombmode original: Bombzone found with an invalid \"script_label\", must be \"A\" or \"B\"";

	 		objective_add(0, "current", bombzoneA.origin, "objectiveA");
	 		objective_add(1, "current", bombzoneB.origin, "objectiveB");
			thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzoneA.origin, "0", "allies", "objpoint_A");
			thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzoneB.origin, "1", "allies", "objpoint_B");
			thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzoneA.origin, "0", "axis", "objpoint_A");
			thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzoneB.origin, "1", "axis", "objpoint_B");

	 		bombzoneA thread bombzone_think(bombzoneB);
			bombzoneB thread bombzone_think(bombzoneA);
		}
		else if(array.size < 2)
			maperrors[maperrors.size] = "^1Bombmode original: Less than 2 bombzones found with \"script_bombmode_original\" \"1\"";
		else if(array.size > 2)
			maperrors[maperrors.size] = "^1Bombmode original: More than 2 bombzones found with \"script_bombmode_original\" \"1\"";
	}
	else if(level.bombmode == 1)
	{
		for(i = 0; i < bombzones.size; i++)
		{
			bombzone = bombzones[i];

			if(isdefined(bombzone.script_bombmode_single))
				array[array.size] = bombzone;
		}

		if(array.size == 1)
		{
	 		objective_add(0, "current", array[0].origin, "objective");
			thread maps\mp\gametypes\_objpoints::addTeamObjpoint(array[0].origin, "single", "allies", "objpoint_star");
			thread maps\mp\gametypes\_objpoints::addTeamObjpoint(array[0].origin, "single", "axis", "objpoint_star");

	 		array[0] thread bombzone_think();
		}
		else if(array.size < 1)
			maperrors[maperrors.size] = "^1Bombmode single: Less than 1 bombzone found with \"script_bombmode_single\" \"1\"";
		else if(array.size > 1)
			maperrors[maperrors.size] = "^1Bombmode single: More than 1 bombzone found with \"script_bombmode_single\" \"1\"";
	}
	else if(level.bombmode == 2)
	{
		for(i = 0; i < bombzones.size; i++)
		{
			bombzone = bombzones[i];

			if(isdefined(bombzone.script_bombmode_dual))
		 		array[array.size] = bombzone;
		}

		if(array.size == 2)
		{
	 		bombzone0 = array[0];
	 		bombzone1 = array[1];

	 		objective_add(0, "current", bombzone0.origin, "objective");
	 		objective_add(1, "current", bombzone1.origin, "objective");

	 		if(isdefined(bombzone0.script_team) && isdefined(bombzone1.script_team))
	 		{
	 			if((bombzone0.script_team == "allies" && bombzone1.script_team == "axis") || (bombzone0.script_team == "axis" || bombzone1.script_team == "allies"))
	 			{
	 				objective_team(0, bombzone0.script_team);
	 				objective_team(1, bombzone1.script_team);

					if(bombzone0.script_team == "allies")
					{
						thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzone0.origin, "0", "allies", "objpoint_star");
						thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzone1.origin, "1", "axis", "objpoint_star");
					}
					else
					{
						thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzone0.origin, "0", "axis", "objpoint_star");
						thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombzone1.origin, "1", "allies", "objpoint_star");
					}
	 			}
	 			else
	 				maperrors[maperrors.size] = "^1Bombmode dual: One or more bombzones missing \"script_team\" \"allies\" or \"axis\"";
	 		}

	 		bombzone0 thread bombzone_think(bombzone1);
	 		bombzone1 thread bombzone_think(bombzone0);
		}
		else if(array.size < 2)
			maperrors[maperrors.size] = "^1Bombmode dual: Less than 2 bombzones found with \"script_bombmode_dual\" \"1\"";
		else if(array.size > 2)
			maperrors[maperrors.size] = "^1Bombmode dual: More than 2 bombzones found with \"script_bombmode_dual\" \"1\"";
	}
	else
		println("^6Unknown bomb mode");

	bombtriggers = getentarray("bombtrigger", "targetname");
	if(bombtriggers.size < 1)
		maperrors[maperrors.size] = "^1No entities found with \"targetname\" \"bombtrigger\"";
	else if(bombtriggers.size > 1)
		maperrors[maperrors.size] = "^1More than 1 entity found with \"targetname\" \"bombtrigger\"";

	if(maperrors.size)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");

		return;
	}

	bombtrigger = getent("bombtrigger", "targetname");
	bombtrigger maps\mp\_utility::triggerOff();

	// Kill unused bombzones and associated script_exploders

	accepted = [];
	for(i = 0; i < array.size; i++)
	{
		if(isdefined(array[i].script_noteworthy))
			accepted[accepted.size] = array[i].script_noteworthy;
	}

	remove = [];
	bombzones = getentarray("bombzone", "targetname");
	for(i = 0; i < bombzones.size; i++)
	{
		bombzone = bombzones[i];

		if(isdefined(bombzone.script_noteworthy))
		{
			addtolist = true;
			for(j = 0; j < accepted.size; j++)
			{
				if(bombzone.script_noteworthy == accepted[j])
				{
					addtolist = false;
					break;
				}
			}

			if(addtolist)
				remove[remove.size] = bombzone.script_noteworthy;
		}
	}

	ents = getentarray();
	for(i = 0; i < ents.size; i++)
	{
		ent = ents[i];

		if(isdefined(ent.script_exploder))
		{
			kill = false;
			for(j = 0; j < remove.size; j++)
			{
				if(ent.script_exploder == int(remove[j]))
				{
					kill = true;
					break;
				}
			}

			if(kill)
				ent delete();
		}
	}
}

bombzone_think(bombzone_other)
{
	level endon("round_ended");

	level.barincrement = (level.barsize / (20.0 * level.planttime));

	self setteamfortrigger(game["attackers"]);
	self setHintString(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");

	for(;;)
	{
		self waittill("trigger", other);

		if(isdefined(bombzone_other) && isdefined(bombzone_other.planting))
			continue;

		if(level.bombmode == 2 && isdefined(self.script_team))
			team = self.script_team;
		else
			team = game["attackers"];

		if(isPlayer(other) && (other.pers["team"] == team) && other isOnGround())
		{
			while(other istouching(self) && isAlive(other) && other useButtonPressed())
			{
				other notify("kill_check_bombzone");

				self.planting = true;
				other clientclaimtrigger(self);
				other clientclaimtrigger(bombzone_other);

				if(!isdefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);
					other.progressbackground.x = 0;

					if(level.splitscreen)
						other.progressbackground.y = 70;
					else
						other.progressbackground.y = 104;

					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.horzAlign = "center_safearea";
					other.progressbackground.vertAlign = "center_safearea";
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);

				if(!isdefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);
					other.progressbar.x = int(level.barsize / (-2.0));

					if(level.splitscreen)
						other.progressbar.y = 70;
					else
						other.progressbar.y = 104;

					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.horzAlign = "center_safearea";
					other.progressbar.vertAlign = "center_safearea";
				}
				other.progressbar setShader("white", 0, 8);
				other.progressbar scaleOverTime(level.planttime, level.barsize, 8);

				other playsound("MP_bomb_plant");
				other linkTo(self);
				other disableWeapon();

				self.progresstime = 0;

				other.release1 = self;

				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.planttime))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}

				// TODO: script error if player is disconnected/kicked here
				other clientreleasetrigger(self);
				other clientreleasetrigger(bombzone_other);

				if(self.progresstime >= level.planttime)
				{
					other.progressbackground destroy();
					other.progressbar destroy();
					other enableWeapon();

					if(isdefined(self.target))
					{
						exploder = getent(self.target, "targetname");

						if(isdefined(exploder) && isdefined(exploder.script_exploder))
							level.bombexploder = exploder.script_exploder;
					}

					bombzones = getentarray("bombzone", "targetname");
					for(i = 0; i < bombzones.size; i++)
						bombzones[i] delete();

					if(level.bombmode == 1)
					{
						objective_delete(0);
						thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("allies");
						thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("axis");
					}
					else
					{
						objective_delete(0);
						objective_delete(1);
						thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("allies");
						thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("axis");
					}

					plant = other maps\mp\_utility::getPlant();

					level.bombmodel = spawn("script_model", plant.origin);
					level.bombmodel.angles = plant.angles;
					level.bombmodel setmodel("xmodel/mp_tntbomb");
					level.bombmodel playSound("Explo_plant_no_tick");
					level.bombglow = spawn("script_model", plant.origin);
					level.bombglow.angles = plant.angles;
					level.bombglow setmodel("xmodel/mp_tntbomb_obj");

					bombtrigger = getent("bombtrigger", "targetname");
					bombtrigger.origin = level.bombmodel.origin;

					objective_add(0, "current", bombtrigger.origin, "objective");
					thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("allies");
					thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("axis");
					thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombtrigger.origin, "bomb", "allies", "objpoint_star");
					thread maps\mp\gametypes\_objpoints::addTeamObjpoint(bombtrigger.origin, "bomb", "axis", "objpoint_star");

					level.bombplanted = true;
					level.bombtimerstart = gettime();
					level.planting_team = other.pers["team"];

					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "bomb_plant" + "\n");
					
					/* level.plantton++;
					bomplantpamm = other.name + "�" + other.pers["team"] + "�" + level.plantton;
					setcvar("bombplantano", bomplantpamm); */

					iprintln(&"MP_EXPLOSIVESPLANTED");
					level thread soundPlanted(other);

					bombtrigger thread bomb_think();
					bombtrigger thread bomb_countdown();

					level notify("bomb_planted");
					level.clock destroy();

					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					if(isdefined(other.progressbackground))
						other.progressbackground destroy();

					if(isdefined(other.progressbar))
						other.progressbar destroy();

					other unlink();
					other enableWeapon();
				}

				wait .05;
			}

			self.planting = undefined;
			other thread check_bombzone(self);
		}
	}
}

check_bombzone(trigger)
{
	self notify("kill_check_bombzone");
	self endon("kill_check_bombzone");
	level endon("round_ended");

	while(isdefined(trigger) && !isdefined(trigger.planting) && self istouching(trigger) && isAlive(self))
		wait 0.05;
}

bomb_countdown()
{
	self endon("bomb_defused");
	level endon("intermission");

	thread showBombTimers();
	level.bombmodel playLoopSound("bomb_tick");

	wait level.bombtimer;

	// bomb timer is up
	objective_delete(0);
	thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("allies");
	thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("axis");
	thread deleteBombTimers();

	level.bombexploded = true;
	self notify("bomb_exploded");

	// trigger exploder if it exists
	if(isdefined(level.bombexploder))
		maps\mp\_utility::exploder(level.bombexploder);

	// explode bomb
	origin = self getorigin();
	range = 500;
	maxdamage = 2000;
	mindamage = 1000;

	self delete(); // delete the defuse trigger
	level.bombmodel stopLoopSound();
	level.bombmodel delete();
	level.bombglow delete();

	playfx(level._effect["bombexplosion"], origin);
	radiusDamage(origin, range, maxdamage, mindamage);

	level thread playSoundOnPlayers("mp_announcer_objdest");
	level thread endRound(level.planting_team);
}

bomb_think()
{
	self endon("bomb_exploded");
	level.barincrement = (level.barsize / (20.0 * level.defusetime));

	self setteamfortrigger(game["defenders"]);
	self setHintString(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");

	for(;;)
	{
		self waittill("trigger", other);
		
		// check for having been triggered by a valid player
		if(isPlayer(other) && (other.pers["team"] != level.planting_team) && other isOnGround())
		{
			while(isAlive(other) && other useButtonPressed())
			{
				other notify("kill_check_bomb");

				other clientclaimtrigger(self);

				if(!isdefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);
					other.progressbackground.x = 0;

					if(level.splitscreen)
						other.progressbackground.y = 70;
					else
						other.progressbackground.y = 104;

					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.horzAlign= "center_safearea";
					other.progressbackground.vertAlign = "center_safearea";
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);

				if(!isdefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);
					other.progressbar.x = int(level.barsize / (-2.0));

					if(level.splitscreen)
						other.progressbar.y = 70;
					else
						other.progressbar.y = 104;

					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.horzAlign = "center_safearea";
					other.progressbar.vertAlign = "center_safearea";
				}
				other.progressbar setShader("white", 0, 8);
				other.progressbar scaleOverTime(level.defusetime, level.barsize, 8);

				other playsound("MP_bomb_defuse");
				other linkTo(self); 
				other disableWeapon();

				self.progresstime = 0;

				other.release1 = self;
				//other.release2 = bombzone_other;

				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.defusetime))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}

				other clientreleasetrigger(self);

				if(self.progresstime >= level.defusetime)
				{
					other.progressbackground destroy();
					other.progressbar destroy();

					objective_delete(0);
					thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("allies");
					thread maps\mp\gametypes\_objpoints::removeTeamObjpoints("axis");
					thread deleteBombTimers();

					self notify("bomb_defused");
					level.bombmodel stopLoopSound();
					level.bombglow delete();
					self delete();

					iprintln(&"MP_EXPLOSIVESDEFUSED");
					level thread playSoundOnPlayers("MP_announcer_bomb_defused");

					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "bomb_defuse" + "\n");

					/* level.defannono++;
					bomdefpamm = other.name + "�" + other.pers["team"] + "�" + level.defannono;
					setcvar("bombdefano", bomdefpamm); */

					level thread endRound(other.pers["team"]);
					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					if(isdefined(other.progressbackground))
						other.progressbackground destroy();

					if(isdefined(other.progressbar))
						other.progressbar destroy();

					other unlink();
					other enableWeapon();
				}

				wait .05;
			}

			self.defusing = undefined;
			other thread check_bomb(self);
		}
	}
}

check_bomb(trigger)
{
	self notify("kill_check_bomb");
	self endon("kill_check_bomb");

	while(isdefined(trigger) && !isdefined(trigger.defusing) && self istouching(trigger) && isAlive(self))
		wait 0.05;
}


printJoinedTeam(team)
{
	if(!level.splitscreen)
	{
		if(team == "allies")
			iprintln(&"MP_JOINED_ALLIES", self);
		else if(team == "axis")
			iprintln(&"MP_JOINED_AXIS", self);
	}
}


sayObjective()
{
	wait 2;

	attacksounds["american"] = "US_mp_cmd_movein";
	attacksounds["british"] = "UK_mp_cmd_movein";
	attacksounds["russian"] = "RU_mp_cmd_movein";
	attacksounds["german"] = "GE_mp_cmd_movein";
	defendsounds["american"] = "US_mp_defendbomb";
	defendsounds["british"] = "UK_mp_defendbomb";
	defendsounds["russian"] = "RU_mp_defendbomb";
	defendsounds["german"] = "GE_mp_defendbomb";

	level playSoundOnPlayers(attacksounds[game[game["attackers"]]], game["attackers"]);
	level playSoundOnPlayers(defendsounds[game[game["defenders"]]], game["defenders"]);
}

showBombTimers()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			player showPlayerBombTimer();
	}
}

showPlayerBombTimer()
{
	timeleft = (level.bombtimer - (getTime() - level.bombtimerstart) / 1000);

	if(timeleft > 0)
	{
		mode = getcvar("pam_mode");		

		if (mode == "cg_rush")
		{
			self.bombtimer_rush_text = newClientHudElem(self);
			self.bombtimer_rush_text.x = 320; 
			self.bombtimer_rush_text.y = 452; 
			self.bombtimer_rush_text.alignX = "center";
			self.bombtimer_rush_text.alignY = "bottom";
			self.bombtimer_rush_text.font = "default";
			self.bombtimer_rush_text.fontScale = 1.5;
			self.bombtimer_rush_text.color = (.98, .827, .58);
			self.bombtimer_rush_text.sort = 3;
			self.bombtimer_rush_text setText(game["rushexplode"]);
		
			self.bombtimer_rush = newClientHudElem(self);
			self.bombtimer_rush.horzAlign = "center_safearea";
			self.bombtimer_rush.vertAlign = "top";
			self.bombtimer_rush.x = -25;
			self.bombtimer_rush.y = 450;
			self.bombtimer_rush.font = "default";
			self.bombtimer_rush.fontscale = 2;
			self.bombtimer_rush.sort = 2;
			self.bombtimer_rush SetTimer(level.bombtimer);
		}
		else
		{
			self.bombtimer = newClientHudElem(self);
			self.bombtimer.x = 6;
			self.bombtimer.y = 76;
			self.bombtimer.horzAlign = "left";
			self.bombtimer.vertAlign = "top";
			self.bombtimer setClock(timeleft, level.bombtimer, "hudStopwatch", 48, 48);
		}
	}
}

deleteBombTimers()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] deletePlayerBombTimer();
}

deletePlayerBombTimer()
{
	if(isdefined(self.bombtimer))
		self.bombtimer destroy();
}

announceWinner(winner, delay)
{
	wait delay;

	level.timowo++;

	// Announce winner
	if(winner == "allies")
	{
		//allies44 = "allies � " + level.timowo;
		//setcvar("teamwon3", allies44);
		level thread playSoundOnPlayers("MP_announcer_allies_win");
	}
	else if(winner == "axis")
	{
		//axis44 = "axis � " + level.timowo;
		//setcvar("teamwon3", axis44);
		level thread playSoundOnPlayers("MP_announcer_axis_win");
	}
	else if(winner == "draw")
	{
		//draw44 = "draw � " + level.timowo;
		//setcvar("teamwon3", draw44);
		level thread playSoundOnPlayers("MP_announcer_round_draw");	
	}
}

playSoundOnPlayers(sound, team)
{
	players = getentarray("player", "classname");

	if(level.splitscreen)
	{
		if(isdefined(players[0]))
			players[0] playLocalSound(sound);
	}
	else
	{
		if(isdefined(team))
		{
			for(i = 0; i < players.size; i++)
			{
				if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team))
					players[i] playLocalSound(sound);
			}
		}
		else
		{
			for(i = 0; i < players.size; i++)
				players[i] playLocalSound(sound);
		}
	}
}

menuAutoAssign()
{
	if(!level.xenon && isdefined(self.pers["team"]) && (self.pers["team"] == "allies" || self.pers["team"] == "axis"))
	{
		self openMenu(game["menu_team"]);
		return;
	}

	numonteam["allies"] = 0;
	numonteam["axis"] = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(!isdefined(player.pers["team"]) || player.pers["team"] == "spectator")
			continue;

		numonteam[player.pers["team"]]++;
	}

	// if teams are equal return the team with the lowest score
	if(numonteam["allies"] == numonteam["axis"])
	{
		if(getTeamScore("allies") == getTeamScore("axis"))
		{
			teams[0] = "allies";
			teams[1] = "axis";
			assignment = teams[randomInt(2)];
		}
		else if(getTeamScore("allies") < getTeamScore("axis"))
			assignment = "allies";
		else
			assignment = "axis";
	}
	else if(numonteam["allies"] < numonteam["axis"])
		assignment = "allies";
	else
		assignment = "axis";

	if(assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
	    if(!isdefined(self.pers["weapon"]))
	    {
		    if(self.pers["team"] == "allies")
			    self openMenu(game["menu_weapon_allies"]);
		    else
			    self openMenu(game["menu_weapon_axis"]);
	    }

		return;
	}

	if(assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.pers["weapon"] = undefined;
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self setClientCvar("ui_allow_weaponchange", "1");

	if(self.pers["team"] == "allies")
	{
		self openMenu(game["menu_weapon_allies"]);
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
	}
	else
	{
		self openMenu(game["menu_weapon_axis"]);
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
	}

	self notify("joined_team");
}

menuAllies()
{
	if(self.pers["team"] != "allies")
	{
		if(!level.xenon && !maps\mp\gametypes\_teams::getJoinTeamPermissions("allies"))
		{
			self openMenu(game["menu_team"]);
			return;
		}

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.pers["weapon"] = undefined;
		self.pers["weapon1"] = undefined;
		self.pers["weapon2"] = undefined;
		self.pers["spawnweapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);

		self notify("joined_team");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_allies"]);
}

menuAxis()
{
	if(self.pers["team"] != "axis")
	{
		if(!level.xenon && !maps\mp\gametypes\_teams::getJoinTeamPermissions("axis"))
		{
			self openMenu(game["menu_team"]);
			return;
		}

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "axis";
		self.pers["weapon"] = undefined;
		self.pers["weapon1"] = undefined;
		self.pers["weapon2"] = undefined;
		self.pers["spawnweapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

		self notify("joined_team");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_axis"]);
}

menuSpectator()
{
	if(self.pers["team"] != "spectator")
	{
		self notify("joined_spectators");

		if(isAlive(self))
		{
			self.switching_teams = true;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.pers["weapon"] = undefined;
		self.pers["weapon1"] = undefined;
		self.pers["weapon2"] = undefined;
		self.pers["spawnweapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self.sessionteam = "spectator";
		self setClientCvar("ui_allow_weaponchange", "0");
		spawnSpectator();

		if(level.splitscreen)
			self setClientCvar("g_scriptMainMenu", game["menu_ingame_spectator"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_ingame"]);
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

	if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isdefined(self.pers["weapon1"]))
		return;

	if(!game["matchstarted"])
	{
		if(isdefined(self.pers["weapon"]))
		{
			self.pers["weapon"] = weapon;
			self setWeaponSlotWeapon("primary", weapon);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);

			self setWeaponSlotAmmo("primaryb", 999); // oruzje_rup
			self setWeaponSlotClipAmmo("primaryb", 999);			


			maps\mp\gametypes\_weapons::givePistol();
			thread maps\mp\gametypes\_weapons::giveGrenades();
		}
		else
		{
			self.pers["weapon"] = weapon;
			self.spawned = undefined;
			spawnPlayer();
			//self thread printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		}
	}
	else if(!level.roundstarted)
	{
		if(isdefined(self.pers["weapon"]))
		{
			self.pers["weapon"] = weapon;
			self setWeaponSlotWeapon("primary", weapon);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);

			maps\mp\gametypes\_weapons::givePistol();
			thread maps\mp\gametypes\_weapons::giveGrenades();
		}
		else
		{
			self.pers["weapon"] = weapon;
			if(!level.exist[self.pers["team"]])
			{
				self.spawned = undefined;
				spawnPlayer();
				//self thread printJoinedTeam(self.pers["team"]);
				level checkMatchStart();
			}
			else
			{
				spawnPlayer();
				//self thread printJoinedTeam(self.pers["team"]);
			}
		}
	}
	else
	{
		if(isdefined(self.pers["weapon"]))
			self.oldweapon = self.pers["weapon"];

		self.pers["weapon"] = weapon;
		self.sessionteam = self.pers["team"];

		if(self.sessionstate != "playing")
			self.statusicon = "hud_status_dead";

		if(self.pers["team"] == "allies")
			otherteam = "axis";
		else
		{
			assert(self.pers["team"] == "axis");
			otherteam = "allies";
		}

		// if joining a team that has no opponents, just spawn
		if(!level.didexist[otherteam] && !level.roundended)
		{
			if(isdefined(self.spawned))
			{
				if(isdefined(self.pers["weapon"]))
				{
					self.pers["weapon"] = weapon;
					self setWeaponSlotWeapon("primary", weapon);
					self setWeaponSlotAmmo("primary", 999);
					self setWeaponSlotClipAmmo("primary", 999);
					self switchToWeapon(weapon);

					maps\mp\gametypes\_weapons::givePistol();
					thread maps\mp\gametypes\_weapons::giveGrenades();
				}
			}
			else
			{
				self.spawned = undefined;
				spawnPlayer();
				//self thread printJoinedTeam(self.pers["team"]);
			}
		} // else if joining an empty team, spawn and check for match start
		else if(!level.didexist[self.pers["team"]] && !level.roundended)
		{
			self.spawned = undefined;
			spawnPlayer();
			//self thread printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		} // else you will spawn with selected weapon next round
		else
		{
			weaponname = maps\mp\gametypes\_weapons::getWeaponName(self.pers["weapon"]);

			if(self.pers["team"] == "allies")
			{
				if(maps\mp\gametypes\_weapons::useAn(self.pers["weapon"]))
					self iprintln(&"MP_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
				else
					self iprintln(&"MP_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
			}
			else if(self.pers["team"] == "axis")
			{
				if(maps\mp\gametypes\_weapons::useAn(self.pers["weapon"]))
					self iprintln(&"MP_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname);
				else
					self iprintln(&"MP_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname);
			}
		}
	}

	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}

soundPlanted(player)
{
	if(game["allies"] == "british")
		alliedsound = "UK_mp_explosivesplanted";
	else if(game["allies"] == "russian")
		alliedsound = "RU_mp_explosivesplanted";
	else
		alliedsound = "US_mp_explosivesplanted";

	axissound = "GE_mp_explosivesplanted";

	if(level.splitscreen)
	{
		if(player.pers["team"] == "allies")
			player playLocalSound(alliedsound);
		else if(player.pers["team"] == "axis")
			player playLocalSound(axissound);

		return;
	}
	else
	{
		level playSoundOnPlayers(alliedsound, "allies");
		level playSoundOnPlayers(axissound, "axis");

		wait 1.5;

		if(level.planting_team == "allies")
		{
			if(game["allies"] == "british")
				alliedsound = "UK_mp_defendbomb";
			else if(game["allies"] == "russian")
				alliedsound = "RU_mp_defendbomb";
			else
				alliedsound = "US_mp_defendbomb";

			level playSoundOnPlayers(alliedsound, "allies");
			level playSoundOnPlayers("GE_mp_defusebomb", "axis");
		}
		else if(level.planting_team == "axis")
		{
			if(game["allies"] == "british")
				alliedsound = "UK_mp_defusebomb";
			else if(game["allies"] == "russian")
				alliedsound = "RU_mp_defusebomb";
			else
				alliedsound = "US_mp_defusebomb";

			level playSoundOnPlayers(alliedsound, "allies");
			level playSoundOnPlayers("GE_mp_defendbomb", "axis");
		}
	}
}