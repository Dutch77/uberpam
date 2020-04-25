/* Strat Mode */
main()
{
	//Strat
	setCvar("sv_pure", "1");
	setCvar("sv_cheats", "1");
	setCvar("scr_clock_position", "1");

	if (getCvar("sv_pam") == "" )
		setCvar("sv_pam", "1");
	if (!isDefined(game["pam_enabled"]) )
		game["pam_enabled"] = getCvarint("sv_pam");
	level.pamenable = game["pam_enabled"];

	level.pam_mode_change = false;
	
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

	level.setdvar = maps\pam\utils\setdvar::Setup_Dvar;
	
	setcvar("scr_friendlyfire", 1);
	setcvar("g_deadchat", 1);
	//setcvar("scr_remove_killtriggers", 0);

	//novo
	setcvar("smoke_fuse", 1);
	setcvar("scr_show_death_icons", 0);
	setcvar("scr_show_objective_icons", 0);
	
	setcvar("scr_remove_killtriggers", 1);
	setcvar("scr_teambalance", 0);
	
	// Nade Spawn Counts
	setcvar("scr_boltaction_nades", 1);
	setcvar("scr_semiautomatic_nades", 1);
	setcvar("scr_smg_nades", 1);
	setcvar("scr_sniper_nades", 1);
	setcvar("scr_mg_nades", 1);
	setcvar("scr_shotgun_nades", 1);

	// Smoke Spawn Counts
	setcvar("scr_boltaction_smokes", 1);
	setcvar("scr_semiautomatic_smokes", 1);
	setcvar("scr_smg_smokes", 1);
	setcvar("scr_sniper_smokes", 1);
	setcvar("scr_mg_smokes", 1);
	setcvar("scr_shotgun_smokes", 1);

	setcvar("scr_boltaction_limit", 99);
	setcvar("scr_sniper_limit", 99);
	setcvar("scr_semiautomatic_limit", 99);
	setcvar("scr_smg_limit", 99);
	setcvar("scr_mg_limit", 99);
	setcvar("scr_shotgun_limit", 99);
	
	setcvar("scr_allow_greasegun", 1);
	setcvar("scr_allow_m1carbine", 1);
	setcvar("scr_allow_m1garand", 1);
	setcvar("scr_allow_springfield", 1);
	setcvar("scr_allow_thompson", 1);
	setcvar("scr_allow_bar", 1);
	setcvar("scr_allow_sten", 1);
	setcvar("scr_allow_enfield", 1);
	setcvar("scr_allow_enfieldsniper", 1);
	setcvar("scr_allow_bren", 1);
	setcvar("scr_allow_pps42", 1);
	setcvar("scr_allow_nagant", 1);
	setcvar("scr_allow_svt40", 1);
	setcvar("scr_allow_nagantsniper", 1);
	setcvar("scr_allow_ppsh", 1);
	setcvar("scr_allow_mp40", 1);
	setcvar("scr_allow_kar98k", 1);
	setcvar("scr_allow_g43", 1);
	setcvar("scr_allow_kar98ksniper", 1);
	setcvar("scr_allow_mp44", 1);
	setcvar("scr_allow_shotgun", 1);
	setcvar("scr_allow_fraggrenades", 1);
	setcvar("scr_allow_smokegrenades", 1);
	setcvar("scr_allow_pistols", 1);
	setcvar("scr_allow_turrets", 1);	

	setcvar("scr_teambalance", 0);
	setcvar("scr_killcam", 0);

	thread maps\mp\gametypes\_sp_logo::showlogo(); //z0d

	// zPAM - Ambients
	setcvar("scr_allow_ambient_fog", 0);
	setcvar("scr_allow_ambient_sounds", 0);
	setcvar("scr_allow_ambient_fire", 0);
	setcvar("scr_allow_ambient_weather", 0);
	
	precachestring(&"Grenade training is ^1Disabled");
	precachestring(&"Grenade training is ^2Enabled");

	//precachestring(&"Hold ^9[{+melee_breath}] ^7to ^1Disable");
	//precachestring(&"Hold ^9[{+melee_breath}] ^7to ^2Enable");

	precachestring(&"Grenade explodes in");
	//precachestring(&"Smoke releases in");

	setcvar("scr_show_healthbar", 1);
	setcvar("scr_allow_shellshock", 0);
}

Callback_StartGameType()
{
	level.splitscreen = isSplitScreen();

	//Strat
	setCvar("sv_pure", "1");
	setCvar("sv_cheats", "1");
	setcvar("cg_training_nade_fly_mode", 1); //zar //pogledati //self
	
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

	level.compassflag_allies = "compass_flag_" + game["allies"];
	level.compassflag_axis = "compass_flag_" + game["axis"];
	level.objpointflag_allies = "objpoint_flagpatch1_" + game["allies"];
	level.objpointflag_axis = "objpoint_flagpatch1_" + game["axis"];
	level.objpointflagmissing_allies = "objpoint_flagmissing_" + game["allies"];
	level.objpointflagmissing_axis = "objpoint_flagmissing_" + game["axis"];

	level.hudflagflash_allies = "hud_flagflash_" + game["allies"];
	level.hudflagflash_axis = "hud_flagflash_" + game["axis"];

	level.hudflag_allies = "compass_flag_" + game["allies"];
	level.hudflag_axis = "compass_flag_" + game["axis"];

	// Players Left
	game["axis_hud_text"] = &"Axis Left";
	precacheString(game["axis_hud_text"]);
	game["allies_hud_text"] = &"Allies Left";
	precacheString(game["allies_hud_text"]);

	precacheStatusIcon("hud_status_dead");
	precacheStatusIcon("hud_status_connecting");
	precacheRumble("damage_heavy");
	precacheString(&"PLATFORM_PRESS_TO_SPAWN");

	precacheShader(level.compassflag_allies);
	precacheShader(level.compassflag_axis);
	precacheShader(level.objpointflag_allies);
	precacheShader(level.objpointflag_axis);
	precacheShader(level.hudflag_allies);
	precacheShader(level.hudflag_axis);
	precacheShader(level.hudflagflash_allies);
	precacheShader(level.hudflagflash_axis);
	precacheShader(level.objpointflag_allies);
	precacheShader(level.objpointflag_axis);
	precacheShader(level.objpointflagmissing_allies);
	precacheShader(level.objpointflagmissing_axis);
	/*precacheModel("xmodel/prop_flag_" + game["allies"]);
	precacheModel("xmodel/prop_flag_" + game["axis"]);
	precacheModel("xmodel/prop_flag_" + game["allies"] + "_carry");
	precacheModel("xmodel/prop_flag_" + game["axis"] + "_carry");*/

	//PAM
	maps\pam\start_gametype::Init();

	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\pam\weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\pam\shellshock::init();
	//thread maps\pam\hud_teamscore::init();
	thread maps\pam\deathicons::init();
	thread maps\pam\damagefeedback::init();
	//thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\pam\healthoverlay::init(); 
	thread maps\mp\gametypes\_friendicons::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\pam\grenadeindicators::init();

	level.xenon = false;
	thread maps\mp\gametypes\_quickmessages::init();

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

	//allowed[0] = "tdm";
	//allowed[1] = "ctf";
	allowed[0] = "sd";
	allowed[1] = "bombzone";
	//allowed[3] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.scorelimit = 1;

	// Force respawning
	if(getCvar("scr_forcerespawn") == "")
		setCvar("scr_forcerespawn", "0");

	if(!isDefined(game["state"]))
		game["state"] = "playing";

	level.mapended = false;

	level.team["allies"] = 0;
	level.team["axis"] = 0;

	//thread startGame();
	//thread updateGametypeCvars();
	level thread Unlimited_Ammo();
	thread initFlags();
	thread sv_cheats();
	
	if(!isdefined(game["gamestarted"]))
		thread maps\mp\gametypes\_teams::addTestClients();

	game["gamestarted"] = true;

	thread maps\pam\players_left::Init();
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

	if(level.splitscreen)
		scriptMainMenu = game["menu_ingame_spectator"];
	else
		scriptMainMenu = game["menu_ingame"];

	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_allow_weaponchange", "1");
		self.sessionteam = "none"; //z0d

		if(self.pers["team"] == "allies")
			self.sessionteam = "allies";
		else
			self.sessionteam = "axis";

		if(isDefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			self notify("end_saveposition_threads"); //z0d		
			self notify("end_training_nade_fly_mode_threads"); //z0d
			
			self thread maps\_nade_training::nadecounter();	
			//self thread maps\_nade_training::smokecounter();	
			
			spawnSpectator();

			self thread maps\_nade_training::nc();
			
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
			self openMenu(game["menu_team"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";
		
		self notify("end_saveposition_threads"); //z0d
		self notify("end_training_nade_fly_mode_threads"); //z00d

		self thread maps\_nade_training::nadecounter();
		//self thread maps\_nade_training::smokecounter();		

		spawnSpectator();

		self thread maps\_nade_training::nc();
	}

	self setClientCvar("g_scriptMainMenu", scriptMainMenu);
	self.connectresolution = getcvar("r_mode");	
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

	if(isdefined(eAttacker) && isPlayer(eAttacker))
	{
		if (eAttacker != self)
		{
			// Attacker damage notice
			eAttacker iprintln("^2Hit ^7" + self.name + "^2 for ^1" + iDamage + " ^2 damage^7");
		}
		
		// Hit Player damage notice
		self iprintln("^1Hit by ^7" + eAttacker.name + "^1 for ^3" + iDamage + " ^1 damage^7");
	}	

	if (isdefined(self.mygodmode) && self.mygodmode == 1)
		return;

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
			eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();

		/* if(isdefined(eAttacker) && isPlayer(eAttacker))
		{
			if (eAttacker != self)
			{
				// Attacker damage notice
				eAttacker iprintln("^2Hit ^7" + self.name + "^2 for ^1" + iDamage + " ^2 damage^7");
			}
			
			// Hit Player damage notice
			self iprintln("^1Hit by ^7" + eAttacker.name + "^1 for ^3" + iDamage + " ^1 damage^7");
		} */
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

		//logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self notify("end_saveposition_threads"); //z0d
	self notify("end_training_nade_fly_mode_threads"); //z0d
	
	self endon("spawned");
	self notify("killed_player");

	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self.sessionstate = "dead";

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfguid = self getGuid();
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	attackerNum = -1;

	doKillcam = false;

	lpattacknum = -1;
	lpattackname = "";
	lpattackguid = "";
	lpattackerteam = "world";

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	body = self cloneplayer(deathAnimDuration);

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

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

	self thread maps\mp\gametypes\_sp_logo::_MeleeKey(); //z0d
	self thread maps\mp\gametypes\_sp_logo::_UseKey(); //z0d
	
	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	maps\pam\weapons::givePistol();
	maps\pam\weapons::giveGrenades();
	Refill_Nades();
	
	//self setWeaponClipAmmo(grenadetype, 3);
	//self setweaponClipAmmo(smokegrenadetype, 3);
	maps\pam\weapons::giveBinoculars();

	self giveWeapon(self.pers["weapon"]);
	self giveMaxAmmo(self.pers["weapon"]);
	self setSpawnWeapon(self.pers["weapon"]);

	if(!level.splitscreen)
	{
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", "Special mode used for practicing grenades or smoke, strategic plan making, jump learning and overall game testing.");
		else
			self setClientCvar("cg_objectiveText", "Special mode used for practicing grenades or smoke, strategic plan making, jump learning and overall game testing.");
	}
	else
		self setClientCvar("cg_objectiveText", "Special mode used for practicing grenades or smoke, strategic plan making, jump learning and overall game testing.");		

		/*if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING1", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING1_NOSCORE");
	}
	else
		self setClientCvar("cg_objectiveText", &"MP_ELIMINATE_THE_ENEMY");*/

	waittillframeend;
	self notify("spawned_player");

	// * Nade Training Script by Matthias Lorenz *
	if (self.usedgt2 == 0)
	{
		self thread maps\_nade_training::_training();	 //z0d	
		self.usedgt2 = 1;
	}

	if (self.usedgt == 0)
	{
		self thread maps\_nade_training::go();	//pogledati
		self.usedgt = 1;
	}
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
		wait .05;

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

/*
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
		thread maps\pam\check_match_start::checkMatchStart();
		return;
	}

	if (game["dolive"])
		level thread [[level.pam_hud]]("live");

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
		wait 1;
	}
}
*/

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

	//PAM
	maps\pam\next_map::Next_Map_Select();

	if (!level.pam_mode_change)
		exitLevel(false);
}

/*
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

	// Is it a score-based Halftime? 
	if(!game["halftimeflag"] && level.halfscore > 0)
	{
		if(game["half_1_allies_score"] >= level.halfscore || game["half_1_axis_score"] >= level.halfscore)
		{ 
			maps\pam\halftime::Do_Half_Time();
			return;
		}
	}


	// 2nd-Half Score Limit Check 
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

	// Match Score Check 
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
	for(;;)
	{
		timelimit = getCvarFloat("scr_tdm_timelimit");
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

		scorelimit = getCvarInt("scr_tdm_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_tdm_scorelimit", level.scorelimit);
			level notify("update_allhud_score");
		}
		checkScoreLimit();

		wait 1;
	}
}
*/

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
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

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

	if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isdefined(self.pers["weapon1"]))
		return;

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
			maps\pam\weapons::giveGrenades();
			Refill_Nades();
			//self setWeaponClipAmmo(grenadetype, 3);
			//self setweaponClipAmmo(smokegrenadetype, 3);

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
			maps\pam\weapons::giveGrenades();
			Refill_Nades();
			//self setWeaponClipAmmo(grenadetype, 3);
			//self setweaponClipAmmo(smokegrenadetype, 3);

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
	else if(!level.roundstarted && !self.usedweapons)
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
			maps\pam\weapons::giveGrenades();
			Refill_Nades();
			//self setWeaponClipAmmo(grenadetype, 3);
			//self setweaponClipAmmo(smokegrenadetype, 3);

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

					maps\pam\weapons::givePistol();
					maps\pam\weapons::giveGrenades();
					Refill_Nades();
					//self setWeaponClipAmmo(grenadetype, 3);
					//self setweaponClipAmmo(smokegrenadetype, 3);
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
			//level checkMatchStart();
		} // else you will spawn with selected weapon next round
		else
		{
			weaponname = maps\pam\weapons::getWeaponName(self.pers["weapon"]);

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


Unlimited_Ammo()
{
	while(1)
	{
		wait 1; 

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(!isDefined(player.pers["team"]) || (player.pers["team"] != "allies" && player.pers["team"] != "axis") )
				continue;

			if(isDefined(player.sessionstate) && player.sessionstate == "dead")
				continue;

			weapon1 = player getweaponslotweapon("primary");
			weapon2 = player getweaponslotweapon("primaryb");

			if (isDefined(weapon1) && weapon1 != "none")
				player giveMaxAmmo(weapon1);
			if (isDefined(weapon2) && weapon2 != "none")
				player giveMaxAmmo(weapon2);

			player thread Refill_Nades();

		}
	}
}

Refill_Nades()
{
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])
		{
		case "american":
			grenadetype = "frag_grenade_american_mp";
			smokegrenadetype = "smoke_grenade_american_mp";
			break;

		case "british":
			grenadetype = "frag_grenade_british_mp";
			smokegrenadetype = "smoke_grenade_british_mp";
			break;

		default:
			grenadetype = "frag_grenade_russian_mp";
			smokegrenadetype = "smoke_grenade_russian_mp";
			break;
		}
	}
	else
		grenadetype = "frag_grenade_german_mp";
		smokegrenadetype = "smoke_grenade_german_mp";

	self setWeaponClipAmmo(grenadetype, 3);
	self setweaponClipAmmo(smokegrenadetype, 1);
}


initFlags()
{
	maperrors = [];

	allied_flags = getentarray("allied_flag", "targetname");
	if(allied_flags.size < 1)
		maperrors[maperrors.size] = "^1No entities found with \"targetname\" \"allied_flag\"";
	else if(allied_flags.size > 1)
		maperrors[maperrors.size] = "^1More than 1 entity found with \"targetname\" \"allied_flag\"";

	axis_flags = getentarray("axis_flag", "targetname");
	if(axis_flags.size < 1)
		maperrors[maperrors.size] = "^1No entities found with \"targetname\" \"axis_flag\"";
	else if(axis_flags.size > 1)
		maperrors[maperrors.size] = "^1More than 1 entity found with \"targetname\" \"axis_flag\"";

	if(maperrors.size)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");

		return;
	}

	/*allied_flag = getent("allied_flag", "targetname");
	allied_flag.home_origin = allied_flag.origin;
	allied_flag.home_angles = allied_flag.angles;
	allied_flag.flagmodel = spawn("script_model", allied_flag.home_origin);
	allied_flag.flagmodel.angles = allied_flag.home_angles;
	allied_flag.flagmodel setmodel("xmodel/prop_flag_" + game["allies"]);
	allied_flag.basemodel = spawn("script_model", allied_flag.home_origin);
	allied_flag.basemodel.angles = allied_flag.home_angles;
	allied_flag.basemodel setmodel("xmodel/prop_flag_base");
	allied_flag.team = "allies";
	allied_flag.atbase = true;
	allied_flag.objective = 0;
	allied_flag.compassflag = level.compassflag_allies;
	allied_flag.objpointflag = level.objpointflag_allies;
	allied_flag.objpointflagmissing = level.objpointflagmissing_allies;
	//allied_flag thread flag();

	axis_flag = getent("axis_flag", "targetname");
	axis_flag.home_origin = axis_flag.origin;
	axis_flag.home_angles = axis_flag.angles;
	axis_flag.flagmodel = spawn("script_model", axis_flag.home_origin);
	axis_flag.flagmodel.angles = axis_flag.home_angles;
	axis_flag.flagmodel setmodel("xmodel/prop_flag_" + game["axis"]);
	axis_flag.basemodel = spawn("script_model", axis_flag.home_origin);
	axis_flag.basemodel.angles = axis_flag.home_angles;
	axis_flag.basemodel setmodel("xmodel/prop_flag_base");
	axis_flag.team = "axis";
	axis_flag.atbase = true;
	axis_flag.objective = 1;
	axis_flag.compassflag = level.compassflag_axis;
	axis_flag.objpointflag = level.objpointflag_axis;
	axis_flag.objpointflagmissing = level.objpointflagmissing_axis;*/
	//axis_flag thread flag();
}

sv_cheats()
{
	wait 2;
	setCvar("sv_cheats", "1");
}