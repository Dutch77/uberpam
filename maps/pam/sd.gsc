Callback_StartGameType()
{
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

		thread maps\mp\gametypes\_teams::addTestClients();
	}

	//PAM
	maps\pam\start_gametype::Init();
	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();

	mode = getcvar("pam_mode");
	
	if (mode == "cg_rifle" || mode == "pub_rifle")
		thread maps\pam\weapons_cbrifle::init();
	else
		thread maps\pam\weapons::init();

	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\pam\shellshock::init();
	thread maps\pam\hud_teamscore::init();
	thread maps\pam\deathicons::init();
	thread maps\pam\damagefeedback::init();
	thread maps\pam\healthoverlay::init();
	thread maps\pam\objpoints::init();
	//thread maps\mp\gametypes\_forcedownload::forcedownload();
	thread maps\mp\gametypes\_friendicons::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\pam\grenadeindicators::init();

	thread maps\pam\quickmessages::init();

	game["gamestarted"] = true;
	
	// ePAM
	halfround = getcvarInt("scr_sd_half_round");
	if (game["roundsplayed"] == halfround) // clean this up a bit
	{
		game["allies_tos_half"] = 0;
		game["axis_tos_half"] = 0;
	}
	//
	
	// zPAM
	mode = getcvar("pam_mode");	

	if ( ( (isdefined(level.rdyup) && level.rdyup) || (isdefined(game["matchstarted"]) && !game["matchstarted"]) || (isdefined(level.warmup) && level.warmup) || (isdefined(level.mapended) && level.mapended) || (isdefined(level.instrattime) && level.instrattime) || !isDefined(game["firstreadyupdone"]) ) && mode != "pub" )
		setClientNameMode("auto_change");
	else
		setClientNameMode("manual_change");

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

	setcvar("utimeu", 0);
	setcvar("bombplented2", 0);
	//setcvar("isstrattime2", 0);
	setcvar("endround3d", 0);
	setcvar("matchstartingy", 0);

	serverbot_start_cfg = "serverbotstart.cfg";
	setcvar("exec", serverbot_start_cfg);
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

	//self setclientcvar("hud_enable", 1);

	if(!isdefined(self.pers["team"]) && !level.splitscreen)
		iprintln(&"MP_CONNECTED", self.name);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("J;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

	// PAM
	self thread maps\pam\on_connect::onPlayer_Connect();

	if(game["state"] == "intermission")
	{
		spawnIntermission();
		return;
	}

	level endon("intermission");

	//self.pers["downloadedmod"] = 0;
	//self thread maps\mp\gametypes\_forcedownload::forcedownload();
	self zpam_connect_var();

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
			self setorigin((345.555, 2711.57, 557.636));

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

zpam_connect_var()
{
	// rifle MOD
	if (!isdefined(self.pers["downloadedmod"]))
	{
		self.pers["downloadedmod"] = 0;
		self thread maps\mp\gametypes\_forcedownload::forcedownload();
	}
	if (!isdefined(self.pers["dlchecked"]))
		self.pers["dlchecked"] = 0;

	// record window
	if (!isdefined(self.pers["abletoopen_record"]))
		self.pers["abletoopen_record"] = 0;
	if (!isdefined(self.pers["abletoopen_record_try"]))
	{
		self.pers["abletoopen_record_try"] = 0;

		rec_text = "record ";
		self setclientcvar("o_record_text", rec_text);
	}
	if (!isdefined(self.pers["first_ready"]))
		self.pers["first_ready"] = 0;

	// auto-readyup
	if (!isdefined(self.pers["became_spectator_once"]))
		self.pers["became_spectator_once"] = 0;
	if (!isdefined(self.pers["was_spectator_once"]))
		self.pers["was_spectator_once"] = 0;
	if (!isdefined(self.pers["specmenuopened"]))
		self.pers["specmenuopened"] = 0;

	// spectator screen and join message
	if (!isdefined(self.pers["beenspec"]))
		self.pers["beenspec"] = 0;
	if (!isdefined(self.pers["beenspecforonce"]))
		self.pers["beenspecforonce"] = 0;

	// serverbot variables
	if (!isdefined(self.pers["playerdefuses"]))
		self.pers["playerdefuses"] = 0;
	if (!isdefined(self.pers["playerplants"]))
		self.pers["playerplants"] = 0;
	
	getgametype12 = getcvar("g_gametype");

	if (getgametype12 == "hq")
	{
		if (!isdefined(self.pers["hqstoper"]))
			self.pers["hqstoper"] = 0;
		if (!isdefined(self.pers["stoppedat"]))
			self.pers["stoppedat"] = 0;
	}
	else if (getgametype12 == "strat")
	{
		if (!isdefined(self.usedgt))
			self.usedgt = 0;
		if (!isdefined(self.usedgt2))
			self.usedgt2 = 0;
		if (!isdefined(self.fdl))
			self.fdl = 0;
	}
}	

Callback_PlayerDisconnect()
{
	//if (isdefined(bombzone_other))
	//{
	if (isdefined(self.release1))
		self clientreleasetrigger(self.release1);
		//self clientreleasetrigger(self.release2);
	//}

	if(!level.splitscreen)
		iprintln(&"MP_DISCONNECTED", self.name);

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

	//PAM
	if (level.balance_ppsh && isDefined(sWeapon) && sWeapon == "ppsh_mp")
	{
		dist = distance(eAttacker.origin , self.origin);
		if (dist > 800)
			return;
	}

	prevent_damage = self maps\pam\on_player_damage::onPlayer_Damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime); //double provjerit
	if (prevent_damage) return;

	if (level.prevent_single_shot_pistol && isDefined(sWeapon) && maps\pam\weapons::isPistol(sWeapon) && isdefined(sHitLoc) && sHitLoc == "head")
	{
		// Prevents a pistol from killing in one shot if active
		iDamage = int(iDamage * .85);
	}

	if (level.prevent_single_shot_ppsh && isDefined(sWeapon) && sWeapon == "ppsh_mp" && isdefined(sHitLoc) && sHitLoc == "head")
	{
		// Prevents a ppsh from killing in one shot if active
		iDamage = int(iDamage * .9);
	}

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
				// PAM
				self thread maps\pam\shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
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
				// PAM
				self thread maps\pam\shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
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
			// PAM
			self thread maps\pam\shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
			self playrumble("damage_heavy");
		}

		if(isdefined(eAttacker) && eAttacker != self)
			eAttacker thread maps\pam\damagefeedback::updateDamageFeedback();
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
			
		if(!level.rdyup)
			logPrint("D;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("spawned");
	self notify("killed_player");

	if(self.sessionteam == "spectator")
		return;

	//PAM
	prevent_death = self maps\pam\on_player_killed::onPlayer_Killed(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	if (prevent_death) return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	/* Handle in PAM  
	self maps\pam\weapons::dropWeapon();
	self maps\pam\weapons::dropOffhand(); */

	self.sessionstate = "dead";
	//self.statusicon = "hud_status_dead"; //Handled in PAM

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
	
	if (level.rdyup)
	{
		self thread maps\pam\readyup::Ready_Up_Respawn(deathAnimDuration);
		return;
	}

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

	if(!level.rdyup)
		{
		logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
		
		game["killonja"]++;
		whokwho = lpselfteam + "¦" + lpselfname + "¦" + lpattackerteam + "¦" + lpattackname + "¦" + sWeapon + "¦" + sHitLoc + "¦" + sMeansOfDeath + "¦" + game["killonja"];
		setcvar("killinstuff", whokwho);
		}

	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	
	if(isdefined(self.bombtimer))
		self.bombtimer destroy();

	if(!isdefined(self.switching_teams))
	{
		body = self cloneplayer(deathAnimDuration);
		thread maps\pam\deathicons::addDeathicon(body, self.clientid, self.pers["team"], 5);
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

				if (player.pers["team"] == self.pers["team"])
				{
					player allowSpectateTeam("allies", true);
					player allowSpectateTeam("axis", true);
					player allowSpectateTeam("freelook", true);
					player allowSpectateTeam("none", false);
				}

			}
		}
	}

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait level.fps_multiplier * delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

	if(doKillcam && level.killcam && !level.roundended)
		self maps\mp\gametypes\_killcam::killcam(attackerNum, delay, psOffsetTime);

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
	
	if (self.pers["abletoopen_record_try"] == 0)
		self thread rec_win_checker();

	//PAM
	self thread maps\pam\on_spawn_player::onPlayer_Spawn();

	self.sessionteam = self.pers["team"];
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	//self.statusicon = "";
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

	maps\pam\weapons::givePistol();
	thread maps\pam\weapons::giveGrenades();
	maps\pam\weapons::giveBinoculars();

	mode = getcvar("pam_mode");

	if (mode == "bash")
	{
		self setClientCvar("ui_allow_weaponchange", "0");
	}
	self.usedweapons = false;
	//thread maps\mp\gametypes\_weapons::watchWeaponUsage();

	if(level.bombplanted)
		thread showPlayerBombTimer();
		
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

rec_win_checker()
{
	self.pers["abletoopen_record_try"] = 1;	

	self openMenu (game["menu_rec_win"]);
	self closeMenu (game["menu_rec_win"]);
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

	if(self.pers["team"] == "spectator" && !level.rdyup)
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
		{
			self spawn(spawnpoint.origin, spawnpoint.angles);
			if (!isdefined(self.pers["beenspecforonce"]))
				self.pers["beenspecforonce"] = 0;

			
			if (self.pers["beenspecforonce"] != 1)
			{
				whatmap = getcvar("mapname");
				switch (whatmap)
				{
					case "mp_toujane":
						self setorigin((-357.657, 337.226, 154.0639));
						self setplayerangles((0, -88.6871, 0));
						break;
					case "mp_matmata":
						self setorigin((6252.83, 6098.57, 81.6205));
						self setplayerangles((0, -2.38953, 0));
						break;
					case "mp_carentan":
						self setorigin((1603.24, 4169.41, 36.2461));
						self setplayerangles((0, -139.971, 0));
						break;
					case "mp_dawnville":
						self setorigin((-1796.69, -18102, 51.0781));
						self setplayerangles((0, 134.731, 0));
						break;
					case "mp_burgundy":
						self setorigin((1736.08, 983.117, 300.403));
						self setplayerangles((0, 9.95911, 0));
						break;
					case "mp_trainstation":
						self setorigin((8789.56, -3332.23, 104.3493));
						self setplayerangles((0, -89.3958, 0));
						break;
					case "mp_breakout":
						self setorigin((7416.01, 4508.81, 100.8282));
						self setplayerangles((0, -47.8894, 0));
						break;
					case "mp_rhine":
						self setorigin((6513.55, 17674.1, 567.474));
						self setplayerangles((0, 174.177, 0));
						break;
					case "mp_harbor":
						self setorigin((-7201.92, -6902.88, 138.125));
						self setplayerangles((0, 98.0585, 0));
						break;
					case "mp_downtown":
						self setorigin((3505.66, 1449.44, 291.956));
						self setplayerangles((0, 90.0165, 0));
						break;
					case "mp_leningrad":
						self setorigin((-711.441, 1204.21, 370.798));
  							self setplayerangles((0, 85.1001, 0));
						break;
					case "mp_brecourt":
						self setorigin((-4283.32, 1527.07, 166.061));
						self setplayerangles((0, 81.2164, 0));
						break;
					case "mp_railyard":
						self setorigin((-967.817, 247.464, 690.737));
						self setplayerangles((0, 139.12, 0));
						break;
					case "mp_decoy":
						self setorigin((5628.98, -10181.7, -260.161));
						self setplayerangles((0, 172.562, 0));
						break;
					case "mp_farmhouse":
						self setorigin((-862.36, 1790.54, 74.3109));
						self setplayerangles((0, 75.8606, 0));
						break;
					case "mp_vallente":
						self setorigin((-2669, 1448.87, 50.125));
						self setplayerangles((0, -65.6049, 0));
						break;
					case "rnr_neuville_beta2":
						self setorigin((-1570.43, -1272.64, -52.87511));
						self setplayerangles((0, -32.3657, 0));
						break;
					case "mp_chelm":
						self setorigin((-1501.96, 395.416, 20.812));
						self setplayerangles((0, 89.4177, 0));
						break;
					case "mp_powcamp":
						self setorigin((-1425.51, -2266.21, 129.762));
						self setplayerangles((0, 141.735, 0));
						break;
					case "mp_tobruk":
						self setorigin((1891.89, 1153.56, 306.963));
						self setplayerangles((0, -90.7965, 0));
						break;

				}
			}
		}
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	level updateTeamStatus();

	self.usedweapons = false;

	self setClientCvar("cg_objectiveText", "");

	self thread maps\mp\gametypes\_spectating_system::spectator_mode();
	//self thread maps\mp\gametypes\_hud::spectator_mode_hud();

	//PAM
	self thread maps\pam\on_spawn_spectator::onPlayer_Spawn_Spectator();
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
	{
		self spawn(spawnpoint.origin, spawnpoint.angles);

		whatmap = getcvar("mapname");
		switch (whatmap)
		{
			case "mp_toujane":
				self setorigin((-357.657, 337.226, 154.0639));
				self setplayerangles((0, -88.6871, 0));
				break;
			case "mp_matmata":
				self setorigin((6252.83, 6098.57, 81.6205));
				self setplayerangles((0, -2.38953, 0));
				break;
			case "mp_carentan":
				self setorigin((1603.24, 4169.41, 36.2461));
				self setplayerangles((0, -139.971, 0));
				break;
			case "mp_dawnville":
				self setorigin((-1796.69, -18102, 51.0781));
				self setplayerangles((0, 134.731, 0));
				break;
			case "mp_burgundy":
				self setorigin((1736.08, 983.117, 300.403));
				self setplayerangles((0, 9.95911, 0));
				break;
			case "mp_trainstation":
				self setorigin((8789.56, -3332.23, 104.3493));
				self setplayerangles((0, -89.3958, 0));
				break;
			case "mp_breakout":
				self setorigin((7416.01, 4508.81, 100.8282));
				self setplayerangles((0, -47.8894, 0));
				break;
			case "mp_rhine":
				self setorigin((6513.55, 17674.1, 567.474));
				self setplayerangles((0, 174.177, 0));
				break;
			case "mp_harbor":
				self setorigin((-7201.92, -6902.88, 138.125));
				self setplayerangles((0, 98.0585, 0));
				break;
			case "mp_downtown":
				self setorigin((3505.66, 1449.44, 291.956));
				self setplayerangles((0, 90.0165, 0));
				break;
			case "mp_leningrad":
				self setorigin((-711.441, 1204.21, 370.798));
  				self setplayerangles((0, 85.1001, 0));
				break;
			case "mp_brecourt":
				self setorigin((-4283.32, 1527.07, 166.061));
				self setplayerangles((0, 81.2164, 0));
				break;
			case "mp_railyard":
				self setorigin((-967.817, 247.464, 690.737));
				self setplayerangles((0, 139.12, 0));
				break;
			case "mp_decoy":
				self setorigin((5628.98, -10181.7, -260.161));
				self setplayerangles((0, 172.562, 0));
				break;
			case "mp_farmhouse":
				self setorigin((-862.36, 1790.54, 74.3109));
				self setplayerangles((0, 75.8606, 0));
				break;
			case "mp_vallente":
				self setorigin((-2669, 1448.87, 50.125));
				self setplayerangles((0, -65.6049, 0));
				break;
			case "rnr_neuville_beta2":
				self setorigin((-1570.43, -1272.64, -52.87511));
				self setplayerangles((0, -32.3657, 0));
				break;
			case "mp_chelm":
				self setorigin((-1501.96, 395.416, 20.812));
				self setplayerangles((0, 89.4177, 0));
				break;
			case "mp_powcamp":
				self setorigin((-1425.51, -2266.21, 129.762));
				self setplayerangles((0, 141.735, 0));
				break;
			case "mp_tobruk":
				self setorigin((1891.89, 1153.56, 306.963));
				self setplayerangles((0, -90.7965, 0));
				break;

		}
	}
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

}

startGame()
{
	level.starttime = getTime();

	// PAM
	if (isDefined(game["Do_Ready_up"]) && game["Do_Ready_up"])
	{
		thread maps\pam\readyup::Match_Mode_Readyup();
		return;
	}

	if (!isDefined(game["matchstarted"]) || !game["matchstarted"])
	{
		thread checkMatchStart();
		return;
	}

	thread startRound();
}

startRound()
{	
	level endon("bomb_planted");
	level endon("round_ended");
	level endon("timeoutcalled");

	logPrint("RS\n");

	level.clock = newHudElem();

	level.roundended_dc = 0;
	setcvar("bombplented2", 0);
	setcvar("endround3d", 0);
		
	//PAM
	if (getCvarInt("scr_clock_position") > 0)
	{
		level.clock.horzAlign = "center_safearea";
		level.clock.vertAlign = "top";
		level.clock.x = -25;
		level.clock.y = 450;
	}
	else
	{
		level.clock.horzAlign = "left";
		level.clock.vertAlign = "top";
		level.clock.x = 8;
		level.clock.y = 2;
	}

	thread bash_checker();

	level.clock.font = "default";
	level.clock.fontscale = 2;
	//level.clock setTimer(level.roundlength * 60);
	level.clock setTimer(level.graceperiod);

	if(game["matchstarted"])
	{
		if (game["dolive"])
			level thread [[level.pam_hud]]("live");

		level.clock.color = (.98, .827, .58);
		
		// PAM
		if (game["mode"] == "match")
			game["switchprevent"] = true;

		if (getcvar("pam_mode") == "bash_round")
		{
			//TO DO thread Bash_Round();
			return;
		}

		if (isDefined(level.strat_time) && level.strat_time)
			 thread Hold_All_Players();
		else
		{
			level.clock setTimer(level.roundlength * 60);
			thread sayObjective();
		}
		// END PAM
	
		if((level.roundlength * 60) > level.graceperiod)
		{
			setcvar("isstrattime2", 1);
			wait(level.fps_multiplier * level.graceperiod);
			setcvar("isstrattime2", 0);
			thread dowaiter();

			level notify("round_started");
			level.roundstarted = true; //true
			level.clock.color = (1, 1, 1);


			// PAM
			if (level.strat_time)
				level.clock setTimer(level.roundlength * 60);
			// END PAM

			// Players on a team but without a weapon show as dead since they can not get in this round
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.sessionteam != "spectator" && !isdefined(player.pers["weapon"]))
					player.statusicon = "hud_status_dead";
			}

			// PAM
			if (level.strat_time)
				timer = level.roundlength * 60;
				//wait(level.fps_multiplier * level.roundlength * 60);
			else
				timer = (level.roundlength * 60) - level.graceperiod;
				//wait( level.fps_multiplier * ((level.roundlength * 60) - level.graceperiod));
			// END PAM
		}
		else
			timer = level.roundlength * 60;
			//wait(level.fps_multiplier * level.roundlength * 60);
	}
	else
	{
		level.clock.color = (1, 1, 1);
		timer = level.roundlength * 60;
		//wait(level.fps_multiplier * level.roundlength * 60);
	}

	level.Round_starttime = getTime();
	level.check_time = 0.3;
	
	for(;;)
	{
		checkRoundTimeLimit(timer);
		wait level.fps_multiplier * level.check_time;
		if(level.roundended || level.warmup) // 2kill
			return;
	}
}

dowaiter()
{
	game["waiterspawn"] = 1;
	
	wait level.fps_multiplier * 2;

	game["waiterspawn"] = 0;
}


bash_checker()
{
	level endon("round_ended");	

	mode = getcvar("pam_mode");
	
	if (mode == "bash")
	{
		for(;;)
		{
			if (isdefined(level.instrattime) && level.instrattime == 0)
			{
				level.clock destroy();	
			}
		wait 0.1;
		}
	}
	else 
		return;
}

checkRoundTimeLimit(timer)
{
	if(level.roundended || level.warmup) // 2kill
		return;

	mode = getcvar("pam_mode");

	if(mode == "bash")
		return;
	
	timepassed = (getTime() - level.Round_starttime) / 1000;

	timeleft = timer - timepassed;
	if (timeleft < 1)
		level.check_time = 0.05;

	if(timepassed < timer)
		return;

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

	if (!isDefined(game["matchstarted"]))
		game["matchstarted"] = false;

	level.warmup = 1;
	setcvar("uwup", 1);

	[[level.pam_hud]]("header");

	//Check to see if we even have 2 teams to start
	level.exist["teams"] = 0;

	while(!level.exist["teams"])
	{
		level.exist["allies"] = 0;
		level.exist["axis"] = 0;

		players = getentarray("player", "classname");
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
	if (game["mode"] == "match")
		game["Do_Ready_up"] = 1;

	iprintln(&"MP_MATCHSTARTING");

	level notify("kill_endround");
	level.roundended = false;
	level.roundendedkill = false;
	level thread endRound("reset");

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

	game["half_1_allies_score"] = 0;
	game["half_1_axis_score"] = 0; 
	game["half_2_allies_score"] = 0;
	game["half_2_axis_score"] = 0;
	game["Team_1_Score"] = 0;
	game["Team_2_Score"] = 0;
}

endRound(roundwinner)
{
	level endon("intermission");
	level endon("kill_endround");

	logPrint("RE\n");

	if(level.roundended) // 2kill
		return;
 	level.roundended = true;  //round ended pravo
	level.roundended_dc = 1;
	setcvar("endround3d", 1);

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
		if (game["halftimeflag"])
			game["half_2_allies_score"]++;
		else
			game["half_1_allies_score"]++;

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
		if (game["halftimeflag"])
			game["half_2_axis_score"]++;
		else
			game["half_1_axis_score"]++;

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

	// Team Scores:
	game["Team_1_Score"] = game["half_1_axis_score"] + game["half_2_allies_score"];
	game["Team_2_Score"] = game["half_2_axis_score"] + game["half_1_allies_score"];

	if (game["halftimeflag"])
	{
		game["alliedscore"] = game["Team_1_Score"];
		game["axisscore"] = game["Team_2_Score"];
		setTeamScore("allies", game["Team_1_Score"]);
		setTeamScore("axis", game["Team_2_Score"]);
	}
	else
	{
		game["alliedscore"] = game["Team_2_Score"];
		game["axisscore"] = game["Team_1_Score"];
		setTeamScore("allies", game["Team_2_Score"]);
		setTeamScore("axis", game["Team_1_Score"]);
	}

	al_score = getTeamScore("allies");
	ax_score = getTeamScore("axis");
	logPrint("S;allies;" + al_score + ";axis;" + ax_score + "\n");

	wait level.fps_multiplier * 5;

	if(!game["matchstarted"] && roundwinner == "reset")
	{
		game["matchstarted"] = true;
		thread resetScores();
		game["roundsplayed"] = 0;
	}

	if(game["matchstarted"])
	{
		checkMatchScoreLimit();

		if (roundwinner == "draw" && level.countdraws)
			game["roundsplayed"]++;
		else if (roundwinner != "reset")
			game["roundsplayed"]++;

		checkMatchRoundLimit();
	}	

	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;

	checkTimeLimit();

	if (level.hithalftime)
		return;

	if(level.mapended)
		return;

	level.mapended = true;

	
	if((getCvarInt("g_roundwarmuptime") > 0) && game["roundsplayed"] > 0 && !level.hithalftime)
	{
		level.warmup = 1;
		//setcvar("uwup", 1);

		//display scores
		thread [[level.pam_hud]]("header");

		thread [[level.pam_hud]]("scoreboard");

		[[level.pam_hud]]("next_round", level.round_start_timer);
		wait level.fps_multiplier * level.round_start_timer;

		[[level.pam_hud]]("kill_all");
	}

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
				if (player.pers["weapon"] == weapon2)
				{
					player.pers["weapon1"] = player.pers["weapon"];
					player.pers["weapon2"] = weapon1;
					player.pers["spawnweapon"] = player.pers["weapon1"];
				}
				else
				{
					player.pers["weapon1"] = player.pers["weapon"];
					if (maps\mp\gametypes\_weapons::isMainWeapon(weapon2))
						player.pers["weapon2"] = weapon2;
					//player.pers["weapon2"] = "none"; //WORM THIS IS CULPRIT
					player.pers["spawnweapon"] = player.pers["weapon1"];
				}
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

					/* Exploitable
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
					*/
					player.pers["weapon1"] = weapon1;
					player.pers["weapon2"] = weapon2;
				}

				if (maps\mp\gametypes\_weapons::isMainWeapon(current))
					player.pers["spawnweapon"] = current;
				else
					player.pers["spawnweapon"] = player.pers["weapon1"];
			}
		}
	}

	level notify("restarting");

	if (!level.pam_mode_change)
	{
		level.exiting_map = true;
		map_restart(true);
	}

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

	/*	
	if(game["alliedscore"] == game["axisscore"])
		text = &"MP_THE_GAME_IS_A_TIE";
	else if(game["alliedscore"] > game["axisscore"])
		text = &"MP_ALLIES_WIN";
	else
		text = &"MP_AXIS_WIN";
	*/

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player closeMenu();
		player closeInGameMenu();
		//player setClientCvar("cg_objectiveText", text);

		player spawnIntermission();
	}

	wait level.fps_multiplier * 10;

	//PAM
	maps\pam\next_map::Next_Map_Select();
	
	if (!level.pam_mode_change && !level.exiting_map)
	{
		level.exiting_map = true;
		exitLevel(false);
	}
}

checkTimeLimit()
{
	//PAM - Disables Timelimit
	//if(level.timelimit <= 0)
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


checkMatchRoundLimit()
{
	if(level.warmup)
		return;
		
	/*  Is it a round-base halftime? */
	if (level.halfround != 0  && game["halftimeflag"] == 0)
	{
		if(game["roundsplayed"] >= level.halfround)
		{ 
			maps\pam\halftime::Do_Half_Time();
			return;
		}
	}
	
	/*  End of Map Roundlimit! */
	if (level.matchround != 0)
	{
		if (game["roundsplayed"] >= level.matchround)
		{
			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
				maps\pam\end_of_map::Prepare_map_Tie();
			else
				setCvar("g_ot_active", "0");
				
			thread end_map_sound();
			maps\pam\end_of_map::End_Match_Scoreboard();

			if(level.mapended)
				return;
			level.mapended = true;

			thread endMap();
		}
	}
	// ePAM
	if(game["timeout"])
	{
		maps\pam\timeout::TO_Rup();
		return;
	}
	//
}


checkMatchScoreLimit()
{
	if(level.warmup)
		return;

	/* Is it a score-based Halftime? */
	if(game["halftimeflag"] == 0 && level.halfscore != 0)
	{
		if(game["half_1_allies_score"] >= level.halfscore || game["half_1_axis_score"] >= level.halfscore)
		{ 
			maps\pam\halftime::Do_Half_Time();
			return;
		}
	}
	

	/* 2nd-Half Score Limit Check */
	if (level.matchscore2 != 0)
	{
		if ( game["half_2_axis_score"] >= level.matchscore2 || game["half_2_allies_score"] >= level.matchscore2)
		{

			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
				maps\pam\end_of_map::Prepare_map_Tie();
			else
				setCvar("g_ot_active", "0");

			maps\pam\end_of_map::End_Match_Scoreboard();

			if(level.mapended)
				return;
			level.mapended = true;

			thread endMap();
		}
	}

	/* Match Score Check */
	if (level.matchscore1 != 0)
	{
		if(game["alliedscore"] < level.matchscore1 && game["axisscore"] < level.matchscore1)
			return;

		if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
				maps\pam\end_of_map::Prepare_map_Tie();
			else
				setCvar("g_ot_active", "0");

		maps\pam\end_of_map::End_Match_Scoreboard();

		if(level.mapended)
			return;
		level.mapended = true;

		thread endMap();

	}
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

		/*
		scorelimit = getCvarInt("scr_sd_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_sd_scorelimit", level.scorelimit);
			level notify("update_allhud_score");

			if(game["matchstarted"])
				checkScoreLimit();
		}
		*/

		roundlimit = getCvarInt("scr_sd_roundlimit");
		if(level.roundlimit != roundlimit)
		{
			level.roundlimit = roundlimit;
			setCvar("ui_sd_roundlimit", level.roundlimit);

			if(game["matchstarted"])
				checkRoundLimit();
		}

		wait level.fps_multiplier * 1;
	}
}

updateTeamStatus() //pogledat
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute

	resettimeout();

	//PAM - Dont want a round to end during readyup
	if (level.rdyup || level.warmup)
		return;

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

		thread teamWinner("allies");
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

		thread teamWinner("axis");
		level thread playSoundOnPlayers("mp_announcer_axiselim");
		level thread endRound("allies");
		return;
	}
}

teamWinner(team) {
	wait level.fps_multiplier * .1;	

	if (team == "axis") {
		iprintln(&"MP_AXISHAVEBEENELIMINATED");
	} else if (team == "allies") {
		iprintln(&"MP_ALLIESHAVEBEENELIMINATED");
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
	if(getcvarFloat("scr_sd_PlantTime"))
		level.planttime = getcvarFloat("scr_sd_PlantTime");
	level.defusetime = 10;		// seconds to defuse a bomb
	if(getcvarFloat("scr_sd_DefuseTime"))
		level.defusetime = getcvarFloat("scr_sd_DefuseTime");

	wait level.fps_multiplier * .2;

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
			thread maps\pam\objpoints::addTeamObjpoint(bombzoneA.origin, "0", "allies", "objpoint_A");
			thread maps\pam\objpoints::addTeamObjpoint(bombzoneB.origin, "1", "allies", "objpoint_B");
			thread maps\pam\objpoints::addTeamObjpoint(bombzoneA.origin, "0", "axis", "objpoint_A");
			thread maps\pam\objpoints::addTeamObjpoint(bombzoneB.origin, "1", "axis", "objpoint_B");

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
			thread maps\pam\objpoints::addTeamObjpoint(array[0].origin, "single", "allies", "objpoint_star");
			thread maps\pam\objpoints::addTeamObjpoint(array[0].origin, "single", "axis", "objpoint_star");

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
						thread maps\pam\objpoints::addTeamObjpoint(bombzone0.origin, "0", "allies", "objpoint_star");
						thread maps\pam\objpoints::addTeamObjpoint(bombzone1.origin, "1", "axis", "objpoint_star");
					}
					else
					{
						thread maps\pam\objpoints::addTeamObjpoint(bombzone0.origin, "0", "axis", "objpoint_star");
						thread maps\pam\objpoints::addTeamObjpoint(bombzone1.origin, "1", "allies", "objpoint_star");
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

		//PAM - Prevents bomb plants before 1st round
		if(level.rdyup)
			return;

		if ( !isDefined(game["matchstarted"]) || !game["matchstarted"])
			return;

		if (!level.roundstarted) //moguce da zeza
			return;

		//if (!game["dolive"])
		//	return;

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
				//PAM
				other.bombinteraction = 1;

				self.progresstime = 0;

				other.release1 = self;

				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.planttime))
				{
					self.progresstime += level.frame;
					wait level.frame;
				}

				//PAM
				other.bombinteraction = 0;

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
						thread maps\pam\objpoints::removeTeamObjpoints("allies");
						thread maps\pam\objpoints::removeTeamObjpoints("axis");
					}
					else
					{
						objective_delete(0);
						objective_delete(1);
						thread maps\pam\objpoints::removeTeamObjpoints("allies");
						thread maps\pam\objpoints::removeTeamObjpoints("axis");
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
					thread maps\pam\objpoints::removeTeamObjpoints("allies");
					thread maps\pam\objpoints::removeTeamObjpoints("axis");
					thread maps\pam\objpoints::addTeamObjpoint(bombtrigger.origin, "bomb", "allies", "objpoint_star");
					thread maps\pam\objpoints::addTeamObjpoint(bombtrigger.origin, "bomb", "axis", "objpoint_star");

					level.bombplanted = true;
					level.bombtimerstart = gettime();
					level.planting_team = other.pers["team"];

					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "bomb_plant" + "\n");

					game["plantton"]++;
					bomplantpamm = other.name + "¦" + other.pers["team"] + "¦" + game["plantton"];
					setcvar("bombplantano", bomplantpamm);

					if (level.bomb_plant_points)
					{
						other.pers["score"] = other.pers["score"] + level.bomb_plant_points;
						other.score = other.pers["score"];
					}

					other.pers["playerplants"]++;
						
					iprintln(&"MP_EXPLOSIVESPLANTED");

					setcvar("bombplented2", 1);
					level thread soundPlanted(other);

					bombtrigger thread bomb_think();
					bombtrigger thread bomb_countdown();

					level notify("bomb_planted");
					if (isDefined(level.clock)) //PAM2
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

				wait level.frame;
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
		wait level.frame;
}

bomb_countdown()
{
	self endon("bomb_defused");
	level endon("intermission");

	//PAM
	if (level.show_bombtimer)
		thread showBombTimers();
	level.bombmodel playLoopSound("bomb_tick");

	wait level.fps_multiplier * level.bombtimer;

	// bomb timer is up
	objective_delete(0);
	thread maps\pam\objpoints::removeTeamObjpoints("allies");
	thread maps\pam\objpoints::removeTeamObjpoints("axis");
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
				//zPAM
				other.bombinteraction = 1;

				self.progresstime = 0;

				other.release1 = self;		

				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.defusetime))
				{
					self.progresstime += level.frame;
					wait level.frame;
				}

				//PAM
				other.bombinteraction = 0;

				other clientreleasetrigger(self);

				if(self.progresstime >= level.defusetime)
				{
					other.progressbackground destroy();
					other.progressbar destroy();

					objective_delete(0);
					thread maps\pam\objpoints::removeTeamObjpoints("allies");
					thread maps\pam\objpoints::removeTeamObjpoints("axis");
					thread deleteBombTimers();

					self notify("bomb_defused");
					level.bombmodel stopLoopSound();
					level.bombglow delete();
					self delete();

					iprintln(&"MP_EXPLOSIVESDEFUSED");
					setcvar("bombplented2", 2);
					level thread playSoundOnPlayers("MP_announcer_bomb_defused");

					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "bomb_defuse" + "\n");
						
					game["defannono"]++;
					bomdefpamm = other.name + "¦" + other.pers["team"] + "¦" + game["defannono"];
					setcvar("bombdefano", bomdefpamm);
					other.pers["playerdefuses"]++;
	
					if (level.bomb_defuse_points)
					{
						other.pers["score"] = other.pers["score"] + level.bomb_defuse_points;
						other.score = other.pers["score"];
					}

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

				wait level.frame;
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
		wait level.frame;
}

printJoinedTeam(team, playername)
{
	if(!level.splitscreen)
	{
		if(team == "allies")
			iprintln(&"MP_JOINED_ALLIES", self.name);
		else if(team == "axis")
			iprintln(&"MP_JOINED_AXIS", self.name);
		else if(team == "spectator")
			iprintln(playername + " Joined Spectators");
	}
}

sayObjective()
{
	wait level.fps_multiplier * 2;

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
			//self.bombtimer setClock(timeleft, level.bombtimer, "hudStopwatch", 48, 48);
			self.bombtimer setClock(level.bombtimer, 60, "hudStopwatch", 48, 48);
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
	wait level.fps_multiplier * delay;
	
	game["timowo"]++;

	// Announce winner
	if(winner == "allies")
	{
		allies44 = "allies¦" + game["timowo"];
		setcvar("teamwon3", allies44);
		level thread playSoundOnPlayers("MP_announcer_allies_win");
	}
	else if(winner == "axis")
	{
		axis44 = "axis¦" + game["timowo"];
		setcvar("teamwon3", axis44);
		level thread playSoundOnPlayers("MP_announcer_axis_win");
	}
	else if(winner == "draw")
	{
		draw44 = "draw¦" + game["timowo"];
		setcvar("teamwon3", draw44);
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
	else
	{
		whatmap = getcvar("mapname");
		switch (whatmap)
		{
			case "mp_toujane":
				self setorigin((-170, 1008, 456));
				self setplayerangles((0, 34, 0));
				break;
			case "mp_matmata":
				self setorigin((2616, 5096, 96));
				self setplayerangles((0, 60, 0));
				break;
			case "mp_carentan":
				self setorigin((384, -248, 280));
				self setplayerangles((0, 90, 0));
				break;
			case "mp_dawnville":
				self setorigin((-829, -16166, 369));
				self setplayerangles((10.5882, 16.1, -0.659181));
				break;
			case "mp_burgundy":
				self setorigin((1094, 1001, 282));
				self setplayerangles((0, 162.9, 0));
				break;
			case "mp_trainstation":
				self setorigin((7816, -3480, 264));
				self setplayerangles((0, 143.8, 0));
				break;
			case "mp_breakout":
				self setorigin((3920, 5328, 475));
				self setplayerangles((0, 315, 0));
				break;
			case "mp_rhine":
				self setorigin((3165, 15418, 463));
				self setplayerangles((0, 62.9, 0));
				break;
			case "mp_harbor":
				self setorigin((-11736, -7472, 232));
				self setplayerangles((0, 2.50448000006, 0));
				break;
			case "mp_downtown":
				self setorigin((166, -733, 694));
				self setplayerangles((0, 0, 0));
				break;
			case "mp_leningrad":
				self setorigin((330, 818, 200));
  				self setplayerangles((0, 248, 0));
				break;
			case "mp_brecourt":
				self setorigin((-2779, 1585, 640));
				self setplayerangles((0, 315, 0));
				break;
			case "mp_railyard":
				self setorigin((96, -1032, 600));
				self setplayerangles((0, 137, 0));
				break;
			case "mp_decoy":
				self setorigin((5762, -13836, -259));
				self setplayerangles((0, 18.4, 0));
				break;
			case "mp_farmhouse":
				self setorigin((-336, -1464, 576));
				self setplayerangles((0, 135, 0));
				break;
			case "mp_vallente":
				self setorigin((-6, -1590, 1352));
				self setplayerangles((24, 90, 1.0186700006));
				break;
			case "rnr_neuville_beta2":
				self setorigin((191, -484, 249));
				self setplayerangles((0, 126.9, 0));
				break;
			case "mp_chelm":
				self setorigin((-1360, -412, 156));
				self setplayerangles((0, 180, 0));
				break;
			case "mp_powcamp":
				self setorigin((1584, 1256, 304));
				self setplayerangles((1.13141, 225.009, 1.13159));
				break;
			case "mp_tobruk":
				self setorigin((-1424, -712, 176));
				self setplayerangles((0, 75, 0));
				break;
		}
	}
}

menuWeapon(response)
{
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	mode = getcvar("pam_mode");
	
	if (mode == "cg_rifle" || mode == "pub_rifle")
		weapon = self maps\pam\weapons_cbrifle::restrictWeaponByServerCvars(response);
	else
	{
		weapon = self maps\pam\weapons::restrictWeaponByServerCvars(response);
		self.pers["newwep"] = weapon;
	}

	//weapon = self maps\pam\weapons::restrictWeaponByServerCvars(response);

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

	level notify("weapon_change");

	if (isDefined(level.rdyup) && level.rdyup)
	{
		if(isdefined(self.pers["weapon"]))
			self.oldweapon = self.pers["weapon"];

		self.pers["weapon"] = weapon;
		self.sessionteam = self.pers["team"];

		maps\pam\weapon_limiter::Update_All_Weapon_Limits();

		if( isAlive(self) )
		{
			self.pers["weapon"] = weapon;
			self setWeaponSlotWeapon("primary", weapon);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);

			self setWeaponSlotAmmo("primaryb", 999); // oruzje_rup
			self setWeaponSlotClipAmmo("primaryb", 999);			


			maps\pam\weapons::givePistol();
			thread maps\pam\weapons::giveGrenades();

			self thread maps\mp\gametypes\_spectating::setSpectatePermissions();

			return;
		}
		else
		{
			self.spawned = undefined;
			spawnPlayer();
			//self thread printJoinedTeam(self.pers["team"]);

			self thread maps\mp\gametypes\_spectating::setSpectatePermissions();

			return;
		}
	}

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


			maps\pam\weapons::givePistol();
			thread maps\pam\weapons::giveGrenades();

			maps\pam\weapon_limiter::Update_All_Weapon_Limits();
		}
		else
		{
			self.pers["weapon"] = weapon;
			self.spawned = undefined;
			spawnPlayer();
			//self thread printJoinedTeam(self.pers["team"]);

			maps\pam\weapon_limiter::Update_All_Weapon_Limits();
			///level checkMatchStart();
		}
	}
	else if(!level.roundstarted)
	{
		if( isDefined(self.pers["weapon1"]) && weapon == self.pers["weapon1"])
			self switchToWeapon(weapon);
		else if( isDefined(self.pers["weapon2"]) && weapon == self.pers["weapon2"])
			self switchToWeapon(weapon);
		else if(isdefined(self.pers["weapon"]))
		{
			self.pers["weapon"] = weapon;
			self setWeaponSlotWeapon("primary", weapon);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);

			maps\pam\weapons::givePistol();
			thread maps\pam\weapons::giveGrenades();

			maps\pam\weapon_limiter::Update_All_Weapon_Limits();
		}
		else
		{
			self.pers["weapon"] = weapon;

			maps\pam\weapon_limiter::Update_All_Weapon_Limits();
			if(!level.exist[self.pers["team"]])
			{
				self.spawned = undefined;
				spawnPlayer();
				//self thread printJoinedTeam(self.pers["team"]);
				//level checkMatchStart();
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

		maps\pam\weapon_limiter::Update_All_Weapon_Limits();

		if(self.sessionstate != "playing")
			self.statusicon = "hud_status_dead";

		if(self.pers["team"] == "allies")
			otherteam = "axis";
		else
		{
			assert(self.pers["team"] == "axis");
			otherteam = "allies";
		}

		// if joining a team that has no opponents, just spawn ako je drugi team
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

					maps\pam\weapons::givePistol();
					thread maps\pam\weapons::giveGrenades();
				}
			}
			else
			{
				self.spawned = undefined;
				spawnPlayer();
				//self thread printJoinedTeam(self.pers["team"]);
			}
		} // else if joining an empty team, spawn and check for match start ak je moj tim prazan
		else if(!level.didexist[self.pers["team"]] && !level.roundended)
		{
			self.spawned = undefined;
			spawnPlayer();
			//self thread printJoinedTeam(self.pers["team"]);
			//level checkMatchStart();
		} // else you will spawn with selected weapon next round
		else if (game["waiterspawn"] == 1 && self.sessionstate != "playing")
		{
			self.spawned = undefined;
			spawnPlayer();
			self.statusicon = "";
			//self thread printJoinedTeam(self.pers["team"]);
		}	
		else
		{
			if (mode == "cg_rifle" || mode == "pub_rifle")
				weaponname = maps\pam\weapons_cbrifle::getWeaponName(self.pers["weapon"]);
			else
				weaponname = maps\pam\weapons::getWeaponName(self.pers["weapon"]);

			//weaponname = maps\pam\weapons::getWeaponName(self.pers["weapon"]);

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

		wait level.fps_multiplier * 1.5;

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

Hold_All_Players()
{
	// Allow damage or death yet
	level.instrattime = true;
	setcvar("matchstartingy", 0);
	//setcvar("isstrattime2", 1);

	// Strat Time HUD
	strattime = newHudElem();
	strattime.x = 320; 
	strattime.y = 455; 
	strattime.alignX = "center";
	strattime.alignY = "bottom";
	strattime.font = "default";
	strattime.fontScale = 2;
	strattime.color = (.98, .827, .58);
	strattime.sort = 3;
	strattime setText(game["strattime"]);

	setcvar("g_speed", 0);

	wait level.fps_multiplier * level.graceperiod;

	if(isdefined(strattime))
		strattime destroy();

	setcvar("g_speed", 190);
	//setcvar("isstrattime2", 0);

	level.instrattime = false;
	thread sayObjective();

	thread Strat_Time_Dead_Watch();
}

Strat_Time_Dead_Watch()
{
	wait level.fps_multiplier * .5;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if (players[i].health <= 0)
			players[i].statusicon = "hud_status_dead";
	}
}

playsoundstart()
{
	//wait level.fps_multiplier * 1;

	level playSoundonplayers("ridge88_main_music");
	//level playSoundonplayers("hill400_assault_gr5_letsgoget");
}

end_map_sound()
{
	level playSoundonplayers("soviet_victory_light01");
}