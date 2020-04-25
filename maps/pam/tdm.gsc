/* Team Deathmatch */
Callback_StartGameType()
{
	level.splitscreen = isSplitScreen();

	// defaults if not defined in level script
	if(!isDefined(game["allies"]))
		game["allies"] = "american";
	if(!isDefined(game["axis"]))
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
	thread maps\mp\gametypes\_friendicons::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\pam\grenadeindicators::init();

	level.xenon = false;

	thread maps\pam\quickmessages::init();

	setClientNameMode("auto_change");

	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");

	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	allowed[0] = "tdm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// Time limit per map
	if(getCvar("scr_tdm_timelimit") == "")
		setCvar("scr_tdm_timelimit", "30");
	else if(getCvarFloat("scr_tdm_timelimit") > 1440)
		setCvar("scr_tdm_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_tdm_timelimit");
	level.timeleft = undefined;
	setCvar("ui_tdm_timelimit", level.timelimit);
	makeCvarServerInfo("ui_tdm_timelimit", "30");

	// Score limit per map
	level.scorelimit = getCvarInt("scr_tdm_end_score");
	setCvar("ui_tdm_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_tdm_scorelimit", "300");

	// Force respawning
	if(getCvar("scr_forcerespawn") == "")
		setCvar("scr_forcerespawn", "0");

	if(!isDefined(game["state"]))
		game["state"] = "playing";

	if (game["halftimeflag"])
	{
		game["alliedscore"] = game["Team_1_Score"];
		game["axisscore"] = game["Team_2_Score"];
		setTeamScore("allies", game["Team_1_Score"]);
		setTeamScore("axis", game["Team_2_Score"]);
	}

	level.mapended = false;

	level.team["allies"] = 0;
	level.team["axis"] = 0;

	thread startGame();
	thread updateGametypeCvars();
	
	if(!isdefined(game["gamestarted"]))
		thread maps\mp\gametypes\_teams::addTestClients();

	game["gamestarted"] = true;
	// ePAM
	game["allies_tos_half"] = 0;
	game["axis_tos_half"] = 0;
	thread maps\pam\timeout::Time();
	//
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

	if(!level.splitscreen)
		iprintln(&"MP_CONNECTED", self.name);

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	// PAM
	self thread maps\pam\on_connect::onPlayer_Connect();

	if(game["state"] == "intermission")
	{
		spawnIntermission();
		return;
	}

	level endon("intermission");

	self zpam_connect_var();
	
	//self.pers["downloadedmod"] = 0;
	//self thread maps\mp\gametypes\_forcedownload::forcedownload();

	if(level.splitscreen)
		scriptMainMenu = game["menu_ingame_spectator"];
	else
		scriptMainMenu = game["menu_ingame"];

	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_allow_weaponchange", "1");

		if(self.pers["team"] == "allies")
			self.sessionteam = "allies";
		else
			self.sessionteam = "axis";

		if(isDefined(self.pers["weapon"]))
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

		if(!isDefined(self.pers["skipserverinfo"]))
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

rec_win_checker()
{
	self.pers["abletoopen_record_try"] = 1;	

	self openMenu (game["menu_rec_win"]);
	self closeMenu (game["menu_rec_win"]);
}

Callback_PlayerDisconnect()
{
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
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
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

	prevent_damage = self maps\pam\on_player_damage::onPlayer_Damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
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
	if(!isDefined(vDir))
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

		if(isDefined(friendly))
		{
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackGuid = lpselfGuid;
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

	//PAM
	prevent_death = self maps\pam\on_player_killed::onPlayer_Killed(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	if (prevent_death) return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	/* Handle in PAM 
	self maps\mp\gametypes\_weapons::dropWeapon();
	self maps\mp\gametypes\_weapons::dropOffhand();
	*/

	self.sessionstate = "dead";
	//self.statusicon = "hud_status_dead"; //Handled in PAM

	if(!isdefined(self.switching_teams))
		self.deaths++;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfguid = self getGuid();
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
			self.score--;

			// switching teams
			if(isdefined(self.switching_teams))
			{
				if((self.leaving_team == "allies" && self.joining_team == "axis") || (self.leaving_team == "axis" && self.joining_team == "allies"))
				{
					players = maps\mp\gametypes\_teams::CountPlayers();
					players[self.leaving_team]--;
					players[self.joining_team]++;
				
					if((players[self.joining_team] - players[self.leaving_team]) > 1)
						attacker.score--;
					else
						attacker.score++; //undoes the scoring penalty for killing self if switching team
				}
			}
			else if (level.tdm_tk_scoring && !level.mapended)
				self TDM_Team_Scoring(-1);

			if(isdefined(attacker.friendlydamage))
				attacker iprintln(&"MP_FRIENDLY_FIRE_WILL_NOT");
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
			{
				attacker.score--;

				if (level.tdm_tk_scoring)
					self TDM_Team_Scoring(-1);
			}
			else
			{
				attacker.score++;

				// PAM Scoring
				//teamscore = getTeamScore(attacker.pers["team"]);
				//teamscore++;
				//setTeamScore(attacker.pers["team"], teamscore);
				attacker TDM_Team_Scoring(1);

				checkScoreLimit();
			}
		}

		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackerteam = attacker.pers["team"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.score--;
		if (level.tdm_tk_scoring)
			self TDM_Team_Scoring(-1);

		lpattacknum = -1;
		lpattackname = "";
		lpattackguid = "";
		lpattackerteam = "world";
	}

	level notify("update_allhud_score");

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Stop thread if map ended on this death
	if(level.mapended)
		return;

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	body = self cloneplayer(deathAnimDuration);
	thread maps\pam\deathicons::addDeathicon(body, self.clientid, self.pers["team"], 5);

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait level.fps_multiplier * delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

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

	if (self.pers["abletoopen_record_try"] == 0)
		self thread rec_win_checker();

	//PAM
	self thread maps\pam\on_spawn_player::onPlayer_Spawn();

	self.sessionteam = self.pers["team"];
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	self.friendlydamage = undefined;

	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	maps\pam\weapons::givePistol();
	maps\pam\weapons::giveGrenades();
	maps\pam\weapons::giveBinoculars();

	self giveWeapon(self.pers["weapon"]);
	self giveMaxAmmo(self.pers["weapon"]);
	self setSpawnWeapon(self.pers["weapon"]);

	if(!level.splitscreen)
	{
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING1", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING1_NOSCORE");
	}
	else
		self setClientCvar("cg_objectiveText", &"MP_ELIMINATE_THE_ENEMY");

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
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	maps\mp\gametypes\_spectating::setSpectatePermissions();

	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnpointname = "mp_global_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self setClientCvar("cg_objectiveText", "");
	
	self thread maps\mp\gametypes\_spectating_system::spectator_mode();

	//PAM
	self thread maps\pam\on_spawn_spectator::onPlayer_Spawn_Spectator();
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
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

respawn()
{
	if(!isDefined(self.pers["weapon"]))
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
	self endon("disconnect");
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

	while(self useButtonPressed() != true)
		wait level.frame;

	self notify("remove_respawntext");

	self notify("respawn");
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isDefined(self.respawntext))
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
	// ePAM
	level endon("timeoutcalled");
	if (isDefined(level.timeleft))
	{
		level.timelimit = level.timeleft;
		level.timeleft = undefined;
	}
	//
	level.starttime = getTime();

	// PAM
	if (isDefined(game["Do_Ready_up"]) && game["Do_Ready_up"])
	{
		thread maps\pam\readyup::Match_Mode_Readyup();
		return;
	}

	if (!isDefined(game["matchstarted"]) || !game["matchstarted"])
	{
		thread maps\pam\check_match_start::checkMatchStart();
		return;
	}

	if (game["dolive"])
		level thread [[level.pam_hud]]("live");
	// ePAM
	thread maps\pam\timeout::Time();
	if(level.timelimit > 0)
	{
		level.clock = newHudElem();

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

		level.clock.font = "default";
		level.clock.fontscale = 2;
		level.clock setTimer(level.timelimit * 60);
	}

	for(;;)
	{
		checkTimeLimit();
		wait level.fps_multiplier * 1;
	}
}

endMap()
{
	//PAM
	if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
		maps\pam\end_of_map::Prepare_map_Tie();
	else
		setCvar("g_ot_active", "0");

	maps\pam\end_of_map::End_Match_Scoreboard();

	game["state"] = "intermission";
	level notify("intermission");

	alliedscore = getTeamScore("allies");
	axisscore = getTeamScore("axis");

	if(alliedscore == axisscore)
	{
		winningteam = "tie";
		losingteam = "tie";
		text = "MP_THE_GAME_IS_A_TIE";
	}
	else if(alliedscore > axisscore)
	{
		winningteam = "allies";
		losingteam = "axis";
		text = &"MP_ALLIES_WIN";
	}
	else
	{
		winningteam = "axis";
		losingteam = "allies";
		text = &"MP_AXIS_WIN";
	}

	winners = "";
	losers = "";

	if(winningteam == "allies")
		level thread playSoundOnPlayers("MP_announcer_allies_win");
	else if(winningteam == "axis")
		level thread playSoundOnPlayers("MP_announcer_axis_win");
	else
		level thread playSoundOnPlayers("MP_announcer_round_draw");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if((winningteam == "allies") || (winningteam == "axis"))
		{
			lpGuid = player getGuid();
			if((isDefined(player.pers["team"])) && (player.pers["team"] == winningteam))
					winners = (winners + ";" + lpGuid + ";" + player.name);
			else if((isDefined(player.pers["team"])) && (player.pers["team"] == losingteam))
					losers = (losers + ";" + lpGuid + ";" + player.name);
		}

		player closeMenu();
		player closeInGameMenu();
		player setClientCvar("cg_objectiveText", text);
		
		player spawnIntermission();
	}

	if((winningteam == "allies") || (winningteam == "axis"))
	{
		logPrint("W;" + winningteam + winners + "\n");
		logPrint("L;" + losingteam + losers + "\n");
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

	//PAM
	if (level.do_halftime && !game["halftimeflag"])
	{
		thread maps\pam\halftime::Do_Half_Time();
		return;
	}
		
	level thread endMap();
}

checkScoreLimit()
{
	waittillframeend;

	/* Is it a score-based Halftime? */
	if(!game["halftimeflag"] && level.halfscore > 0)
	{
		if(game["half_1_allies_score"] >= level.halfscore || game["half_1_axis_score"] >= level.halfscore)
		{ 
			maps\pam\halftime::Do_Half_Time();
			return;
		}
	}


	/* 2nd-Half Score Limit Check */
	if (game["halftimeflag"] && level.matchscore2 > 0)
	{
		if ( game["half_2_axis_score"] >= level.matchscore2 || game["half_2_allies_score"] >= level.matchscore2)
		{
			iprintln(&"MP_SCORE_LIMIT_REACHED");

			if(game["Team_1_Score"] == game["Team_2_Score"] && game["mode"] == "match" && getcvarint("g_ot") == 1)  // have a tie and overtime mode is on
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
	if (level.matchscore1 > 0)
	{
		if(game["Team_1_Score"] < level.matchscore1 && game["Team_2_Score"] < level.matchscore1)
			return;

		iprintln(&"MP_SCORE_LIMIT_REACHED");

		if(game["Team_1_Score"] == game["Team_2_Score"] && game["mode"] == "match" && getcvarint("g_ot") == 1)  // have a tie and overtime mode is on
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

updateGametypeCvars()
{
	// ePAM
	level endon("timeoutcalled");
	timelimit = getCvarFloat("scr_tdm_timelimit");
	if (level.timelimit < timelimit)
	{
		timelimit = level.timelimit;
	}
	//
	for(;;)
	{
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_tdm_timelimit", "1440");
			}

			level.timelimit = timelimit;
			setCvar("ui_tdm_timelimit", level.timelimit);
			level.starttime = getTime();

			if(level.timelimit > 0)
			{
				if(!isDefined(level.clock))
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
				if(isDefined(level.clock))
					level.clock destroy();
			}

			checkTimeLimit();
		}

		/*
		scorelimit = getCvarInt("scr_tdm_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_tdm_scorelimit", level.scorelimit);
			level notify("update_allhud_score");
		}
		checkScoreLimit();
		*/

		wait level.fps_multiplier * 1;
	}
}

printJoinedTeam(team)
{
	if(!level.splitscreen)
	{
		if(team == "allies")
			iprintln(&"MP_JOINED_ALLIES", self.name);
		else if(team == "axis")
			iprintln(&"MP_JOINED_AXIS", self.name);
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

		if(!isDefined(player.pers["team"]) || player.pers["team"] == "spectator")
			continue;

		numonteam[player.pers["team"]]++;
	}

	// If teams are equal return the team with the lowest score
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
	self notify("end_respawn");
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
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
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
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	mode = getcvar("pam_mode");
	
	if (mode == "cg_rifle" || mode == "pub_rifle")
		weapon = self maps\pam\weapons_cbrifle::restrictWeaponByServerCvars(response);
	else
		weapon = self maps\pam\weapons::restrictWeaponByServerCvars(response);

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

	if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
		return;

	
	mode = getcvar("pam_mode");
	if (mode != "pub")
	{
	if ((isDefined(level.rdyup) && level.rdyup) && (isDefined(level.intimeout) && !level.intimeout))
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
			maps\pam\weapons::giveGrenades();

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
	
	if(!game["matchstarted"] && (isDefined(level.intimeout) && !level.intimeout))
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
			maps\pam\weapons::giveGrenades();

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
	}

	
	/*if (isDefined(level.rdyup) && level.rdyup)
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

			maps\pam\weapons::givePistol();
			maps\pam\weapons::giveGrenades();

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
	}*/

	if(!isDefined(self.pers["weapon"]))
	{
		self.pers["weapon"] = weapon;

		maps\pam\weapon_limiter::Update_All_Weapon_Limits();

		spawnPlayer();
		//self thread printJoinedTeam(self.pers["team"]);
	}
	else
	{
		self.pers["weapon"] = weapon;

		maps\pam\weapon_limiter::Update_All_Weapon_Limits();

		if (mode == "cg_rifle" || mode == "pub_rifle")
				weaponname = maps\pam\weapons_cbrifle::getWeaponName(self.pers["weapon"]);
			else
				weaponname = maps\pam\weapons::getWeaponName(self.pers["weapon"]);

		
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

	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
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

TDM_Team_Scoring(score)
{
	if (self.pers["team"] == "allies")
	{
		if (game["halftimeflag"])
			game["half_2_allies_score"] += score;
		else
			game["half_1_allies_score"] += score;
	}
	else if (self.pers["team"] == "axis")
	{
		if (game["halftimeflag"])
			game["half_2_axis_score"] += score;
		else
			game["half_1_axis_score"] += score;
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
}