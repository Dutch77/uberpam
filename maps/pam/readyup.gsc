#include maps\mp\_utility;

onPlayer_Connect()
{
	self.pers["killer"] = 0;

	if (!isdefined(self.pers["was_spectator_once"]))
		self.pers["was_spectator_once"] = 0;

	if (!isdefined(self.pers["became_spectator_once"]))
		self.pers["became_spectator_once"] = 0;

	lpselfnum = self getEntityNumber();

	level.R_U_Name[lpselfnum] = self.name;
	level.R_U_State[lpselfnum] = "notready";
	self.R_U_Looping = 0;
	self.pers["readiness"] = "notinreadyup";

	level.limitingentered = 0;

	if (game["mode"] == "pub" || game["mode"] == "pub_rifle") return;

	if(isDefined(level.rdyup) && level.rdyup)
	{
		self.statusicon = "party_notready";
		self thread readyup(lpselfnum);
	}
}

onPlayer_Disconnect()
{
	lpselfnum = self getEntityNumber();

	level.R_U_Name[lpselfnum] = "disconnected";
	level.R_U_State[lpselfnum] = "disconnected";
	self.R_U_Looping = 0;

	if(level.rdyup == 1)
		thread Check_All_Ready();
	iprintln("oh noes someone disconnected");
}

Ready_UP()
{
	wait 0;
	level.rdyup = 1;
	setcvar("urupuu", 1);

	level.warmup = 0;
	setcvar("uwup", 0);	

	level.playersready = false;
	if (!isdefined(game["firstreadyupdone"]) )
		game["firstreadyupdone"] = 0;

	// Password Checker
	if(isDefined(game["halftimeflag"]) && !game["halftimeflag"])
		thread Password_Check();
	
	//ePAM
	if(isDefined(getcvarFloat("g_halftime_ready")))
		game["ht_length"] = getcvarFloat("g_halftime_ready");
	if(isDefined(game["halftimeflag"]) && game["halftimeflag"] == 1 && isDefined(game["ht_length"]) && game["ht_length"] > 0)
	{
		thread maps\pam\halftime::Auto_Resume();
	}
	


	//Remove MG nests
	deletePlacedEntity("misc_turret");
	deletePlacedEntity("misc_mg42");


	// Ready-Up Mode HUD
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
		player.pers["readiness"] = "notready";
		player.R_U_Looping = 0;

		player thread readyup(lpselfnum);
	}
	
	
	Waiting_On_Players();
		
	if(isdefined(level.waiting))
		level.waiting destroy();
	//ePAM
	level notify("rupover");
	if (isdefined(level.ht_resume))
		level.ht_resume destroy();
	if (isdefined(level.ht_resume_clock))
		level.ht_resume_clock destroy();

	setClientNameMode("auto_change");
	game["dolive"] = 1;
	level.rdyup = 0;
	setcvar("urupuu", 0);

	level.warmup = 1;
	//setcvar("uwup", 1);
	setcvar("matchstartingy", 1);

	Warn_Match_Start();
	[[level.pam_hud]]("kill_all");
}

Waiting_On_Players()
{
	wait 0;
	wait_on_timer = 0;

	level.waitingon = newHudElem(self);
	level.waitingon.x = 575;
	level.waitingon.y = 45;
	level.waitingon.alignX = "center";
	level.waitingon.alignY = "middle";
	level.waitingon.fontScale = 1.2;
	level.waitingon.font = "default";
	level.waitingon.color = (.8, 1, 1);
	level.waitingon setText(game["waitingon"]);

	level.playerstext = newHudElem(self);	
	level.playerstext.x = 575;
	level.playerstext.y = 85;
	level.playerstext.alignX = "center";
	level.playerstext.alignY = "middle";
	level.playerstext.fontScale = 1.2;
	level.playerstext.font = "default";
	level.playerstext.color = (.8, 1, 1);
	level.playerstext setText(game["playerstext"]);

	level.notreadyhud = newHudElem(self);
	level.notreadyhud.x = 575;
	level.notreadyhud.y = 65;
	level.notreadyhud.alignX = "center";
	level.notreadyhud.alignY = "middle";
	level.notreadyhud.fontScale = 1.2;
	level.notreadyhud.font = "default";
	level.notreadyhud.color = (.98, .98, .60);

	if (game["clockfirstrup"] == 0)
		thread clockrup();

	while(!level.playersready)
	{
		notready = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			lpselfnum = player getEntityNumber();
			if (level.R_U_State[lpselfnum] == "notready")
			{
				notready++;
				player.statusicon = "party_notready";
			}
		}

		level.notreadyhud setValue(notready);

		wait level.fps_multiplier * .5;
	}

	if(isdefined(level.notreadyhud))
		level.notreadyhud destroy();
	if(isdefined(level.waitingon))
		level.waitingon destroy();
	if(isdefined(level.playerstext))
		level.playerstext destroy();
}

clockrup()
{
	//wait 0;
	//wait_on_timer = 0;
	
	game["clockfirstrup"] = 1;
	thread clockrup_check();

	mode = getcvar("pam_mode");

	level.timertext = newHudElem();
	level.timertext.x = 575;
	level.timertext.y = 220; //170
	level.timertext.alignX = "center";
	level.timertext.alignY = "middle";
	level.timertext.fontScale = 1.2;
	level.timertext.color = (.8, 1, 1);
	
	if (mode == "bash" || mode == "cg" || mode == "cg_1v1" || mode == "cg_2v2" || mode == "cg_mr3" || mode == "cg_mr10" || mode == "cg_mr12" || mode == "cg_rifle" || mode == "cg_rush" || mode == "mr3" || mode == "mr10" || mode == "mr12" || mode == "mr15")
	{
		//level.timertext SetText(game["cttcb"]);
		level.timertext SetText(game["ctt"]);

	} 
	else
	{
		level.timertext SetText(game["ctt"]);
	}
	
	//(isDefined(level.mapended) && level.mapended )
	//!isDefined(game["firstreadyupdone"]	
	//game["halftimeflag"]
	//game["in_timeout"]
	
	level.stim = newHudElem();
	level.stim.x = 575;
	level.stim.y = 235; // 185
	level.stim.alignX = "center";
	level.stim.alignY = "middle";
	level.stim.fontScale = 1.2;
	level.stim.color = (.98, .98, .60);
	
	if (mode == "bash" || mode == "cg" || mode == "cg_1v1" || mode == "cg_2v2" || mode == "cg_mr3" || mode == "cg_mr10" || mode == "cg_mr12" || mode == "cg_rifle" || mode == "cg_rush" || mode == "mr3" || mode == "mr10" || mode == "mr12" || mode == "mr15")
	{
		//level.stim SetTimer(300);
		//wait level.fps_multiplier * 300;
		//iprintlnbold ("^1Time is up^7, shouldn't this match start?");
		
		level.stim SetTimerUp(0.1);
		while(!level.playersready)
			{
				wait level.fps_multiplier * 300;
				iprintlnbold ("^7Shouldn't this match start?");
			}
	} 
}

clockrup_check()
{	
	while(!level.playersready)
	{
		notready = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			lpselfnum = player getEntityNumber();
			if (level.R_U_State[lpselfnum] == "notready")
			{
				notready++;
				player.statusicon = "party_notready";
			}
		}

		level.notreadyhud setValue(notready);

		wait level.fps_multiplier * .5;
	}
	
	if(isdefined(level.timertext))
		level.timertext destroy();
	if(isdefined(level.stim))
		level.stim destroy();
}

readyup(entity)
{
	wait level.fps_multiplier * .5; // Required or the "respawn" notify could happen before it's waittill has begun

	// Check to see if we have already have this player in the ready-up loop
	if (self.R_U_Looping == 1)
		return;

	self.R_U_Looping = 1;

	playername = level.R_U_Name[entity];

	self.pers["readiness"] = "notready";

	//Debug
	if (self.name == "bot0" ||
		self.name == "bot1" ||
		self.name == "bot2" ||
		self.name == "bot3" ||
		self.name == "bot4" ||
		self.name == "bot5" ||
		self.name == "bot6" ||
		self.name == "bot7" ||
		self.name == "bot8" ||
		self.name == "bot9")
	{
		level.R_U_State[entity] = "ready";
		return;
	}

	//TWL Warning
	//self TWL_Warning();

	if (!isdefined(self) || !isPlayer(self))
	{
		level.R_U_State[entity] = "disconnected";
		level.R_U_Name[entity] = "disconnected";
		wait level.fps_multiplier * 0.5;

		thread Check_All_Ready();
		return;
	}

	//Announce what Team the player is on
	if (!isDefined(game["firstreadyupdone"]))
		game["firstreadyupdone"] = 0;

	if ( (self.pers["team"] == "axis" && game["firstreadyupdone"]  == 0) || (self.pers["team"] == "allies" && game["firstreadyupdone"] != 0) )
		self iprintlnbold("^7You are on ^3Team Axis");
	else
		self iprintlnbold("^7You are on ^3Team Allies");
	
	self iprintlnbold("^7Press the ^3[{+activate}] ^7button to Ready-Up");

	status = newClientHudElem(self);
	status.x = 575;
	status.y = 120;
	status.alignX = "center";
	status.alignY = "middle";
	status.fontScale = 1.2;
	status.font = "default";
	status.color = (.8, 1, 1);
	status setText(game["status"]);

	readyhud = newClientHudElem(self);
	readyhud.x = 575;
	readyhud.y = 135;
	readyhud.alignX = "center";
	readyhud.alignY = "middle";
	readyhud.fontScale = 1.2;
	readyhud.font = "default";
	readyhud.color = (1, .66, .66);
	readyhud setText(game["notready"]);

	if(isDefined(game["timeout"]) && !game["timeout"])
		self thread Ready_Up_Kill_Counter();

	if(self.pers["became_spectator_once"] != 1)
		self thread become_spectator();

	self.spawnedd = 0;

	while(!level.playersready)
	{
		if (!isdefined(self) || !isPlayer(self))
		{
			level.R_U_State[entity] = "disconnected";
			level.R_U_Name[entity] = "disconnected";
			wait level.fps_multiplier * 0.5;

			thread Check_All_Ready();
			return;
		}

		if (self.pers["team"] == "spectator" && self.sessionstate != "playing")
		{
			if (self.pers["was_spectator_once"] != 1)
			{
				if (self.pers["became_spectator_once"] == 1)
				{		
					self.pers["was_spectator_once"] = 1;	
				}
				else
				{
					wait level.fps_multiplier * .1;	
					continue;
				}
			}
		} 

		if (self.pers["team"] == "spectator" && self.sessionstate != "playing")
		{
			level.R_U_State[entity] = "ready";
			self.statusicon = "";

			readyhud.color = (1, .66, .66);
			readyhud setText(game["ready"]);

			self.spawnedd = 1;

			wait level.fps_multiplier * 1;
			thread Check_All_Ready();			
			continue;
		}
		
		if (isdefined(self.spawnedd) && self.spawnedd == 1)
		{
			level.R_U_State[entity] = "notready";
			self.pers["readiness"] = "notready";
			self.statusicon = "party_notready";
			
			readyhud.color = (1, .66, .66);
			readyhud setText(game["notready"]);
			self.spawnedd = 0;

			wait level.fps_multiplier * 1;
		}
	
		if(self useButtonPressed() == true)
		{
			if (level.R_U_State[entity] == "notready")
			{
				level.R_U_State[entity] = "ready";
				self.pers["readiness"] = "ready";
				self.statusicon = "party_ready";
				//iprintln(playername + "^2 is Ready");
				logPrint(playername + ";" + " is Ready Logfile;" + "\n");

				// change players hud to indicate player not ready
				readyhud.color = (.73, .99, .73);
				readyhud setText(game["ready"]);

				if (self.pers["abletoopen_record"] && self.pers["first_ready"] == 0)
				{
					self.pers["first_ready"] = 1;
					self openmenu(game["rec_menu"]);
				}		

				wait level.fps_multiplier * 1;
				thread Check_All_Ready();

			}
			else if (level.R_U_State[entity] == "ready")
			{
				level.R_U_State[entity] = "notready";
				self.pers["readiness"] = "notready";
				self.statusicon = "party_notready";
				//iprintln(playername + "^1 is Not Ready");
				logPrint(playername + ";" + " is Not Ready Logfile;" + "\n");

				// change players hud to indicate player not ready
				readyhud.color = (1, .66, .66);
				readyhud setText(game["notready"]);
				
				wait level.fps_multiplier * 1;
			}
			while (self useButtonPressed() == true)
				wait level.frame;
		}
		else
			wait level.fps_multiplier * .1;

		if (level.R_U_State[entity] == "disconnected")
		{
			//self.R_U_Looping = 0;
			level.R_U_Name[entity] = "disconnected";
			return;
		}
	}

	if(isdefined(readyhud))
		readyhud destroy();
	if(isdefined(status))
		status destroy();
	wait level.fps_multiplier * 1;
	self.statusicon = "";
}

rec_window_opener()
{
	
}

become_spectator()
{
	self endon ("im_real_spectator");
	self endon ("disconnect");
	//level endon ("round_started");

	for(;;)
	{	
		if ((isdefined(self.pers["specmenuopened"]) && self.pers["specmenuopened"] == 1) || (isdefined(self.specmenu) && self.specmenu == 1))
		{
			self.pers["became_spectator_once"] = 1;
			level notify("im_real_spectator");
			break;
		}	
		wait 0.05;
	}
}

Check_All_Ready()
{
	wait level.fps_multiplier * .1;
	checkready = true;

	// Check to see if all players are looping
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		lpselfnum = player getEntityNumber();

		if (!isdefined(player.R_U_Looping) )
		{
			level.R_U_Name[lpselfnum] = self.name;
			level.R_U_State[lpselfnum] = "notready";
			player.R_U_Looping = 0;
		}
			
		if (player.R_U_Looping == 0)
		{
			player thread readyup(lpselfnum);
			return;
		}

		//Player is looping, now see if he is ready
		if (level.R_U_State[lpselfnum] == "notready")
			checkready = false;
	}

	// See if checkready is still true
	if (checkready == true)
		level.playersready = true;
}

Match_Mode_Readyup()
{
	thread [[level.pam_hud]]("header");

	Ready_UP();

	// get rid of warmup weapons
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{ 
		//drop other weapons
		player = players[i];

		player.pers["weapon1"] = undefined;
		player.pers["weapon2"] = undefined;
		player setWeaponSlotWeapon("primaryb", "none");
		player maps\pam\weapons::givePistol();
		player.pers["spawnweapon"] = player.pers["selectedweapon"];

		player unlink();
	}

	game["matchstarted"] = true;

	if (!game["halftimeflag"])
	{
		reset_ALL_Scores();
		logPrint("MS\n");
	}

	game["Do_Ready_up"] = 0;

	if (!level.pam_mode_change)
		map_restart(true);
}

reset_ALL_Scores()
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

Warn_Match_Start()
{
	if (!isDefined(level.half_start_timer))
		level.half_start_timer = 10;

	thread [[level.pam_hud]]("players_ready");

	self.pers["readiness"] = "notinreadyup";

	wait level.fps_multiplier * 3;
	
	thread [[level.pam_hud]]("half_start", level.half_start_timer);
	wait level.fps_multiplier * level.half_start_timer;
}


Ready_Up_Respawn(deathAnimDuration)
{
	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;

	if(!isdefined(self.switching_teams))
	{
		body = self cloneplayer(deathAnimDuration);
		thread maps\pam\deathicons::addDeathicon(body, self.clientid, self.pers["team"], 5); // tu
	}
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	wait level.fps_multiplier * 2;	// required for Callback_PlayerKilled to complete before killcam can execute

	self stopShellshock();
	self stoprumble("damage_heavy");

	if (self.pers["team"] == "spectator")
		return;

	if ( isDefined(self.pers["weapon"]) && !isAlive(self) )
	{
		gametype = getcvar("g_gametype");	
		
		if (gametype != "dm")
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
	
		if (gametype == "dm")
		{
			if(self.pers["team"] == "allies")
				spawnpointname = "mp_dm_spawn";
			else
				spawnpointname = "mp_dm_spawn";
		} else {
			if(self.pers["team"] == "allies")
				spawnpointname = "mp_sd_spawn_attacker";
		else
				spawnpointname = "mp_sd_spawn_defender";
		}


		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

		if(!isdefined(self.pers["savedmodel"])) // tu
			maps\mp\gametypes\_teams::model();
		else
			maps\mp\_utility::loadModel(self.pers["savedmodel"]);

		self setWeaponSlotWeapon("primary", self.pers["weapon"]);
		if (getcvar("g_gametype") != "bash")
		{
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);

			self setSpawnWeapon(self.pers["weapon"]);

			maps\pam\weapons::givePistol();
			maps\pam\weapons::giveGrenades();
			maps\pam\weapons::giveBinoculars();
		}
		else
		{
			self setWeaponSlotAmmo("primary", 0);
			self setWeaponSlotClipAmmo("primary", 0);

			self setSpawnWeapon(self.pers["weapon"]);

			if (level.bash_pistols)
			{
				maps\mp\gametypes\_weapons::givePistol();
				self setWeaponSlotAmmo("primaryb", 0);
				self setWeaponSlotClipAmmo("primaryb", 0);
			}
		}

		self.usedweapons = false;
	}
}

Password_Check()
{
	if (getcvar("g_password") != "")
		return;

	no_pass = newHudElem();
	no_pass.x = 320;
	no_pass.y = 50;
	no_pass.alignX = "center";
	no_pass.alignY = "top";
	no_pass.fontScale = 1.2;
	no_pass.color = (1, 1, 0);
	no_pass setText(game["no_password"]);

	while ( getcvar("g_password") == "" )
		wait level.fps_multiplier * .75;

	if ( isDefined(no_pass) )
		no_pass destroy();
}

Ready_Up_Kill_Counter()
{
	self endon("timeoutover");
	self endon("disconnect");

	if (!isdefined(self))
		return;

	self.ru_kills = 0;

	killstext = newClientHudElem(self);
	killstext.x = 575;
	killstext.y = 170; //220
	killstext.alignX = "center";
	killstext.alignY = "middle";
	killstext.fontScale = 1.2;
	killstext.color = (.8, 1, 1);
	killstext SetText(game["killingt"]);	

	ru_kill_count = newClientHudElem(self);
	ru_kill_count.x = 575;
	ru_kill_count.y = 185; //235
	ru_kill_count.alignX = "center";
	ru_kill_count.alignY = "middle";
	ru_kill_count.fontScale = 1.2;
	ru_kill_count.font = "default";
	ru_kill_count.color = (1, .66, .66);
	ru_kill_count SetText(game["kdisabled"]);

	changed = 0;
	while(!level.playersready)
	{
		wait level.fps_multiplier * .5;

		if (!isdefined(self))
			return;

		if(!changed)
		{
			if(self.pers["killer"])
			{
				//ru_kill_count.color = (1, .84, .84);
				changed = 1;
				ru_kill_count setValue(self.ru_kills);
				killstext SetText(game["killstextrup"]);
			}
		}
		else
			ru_kill_count setValue(self.ru_kills);
	}
	if (isDefined(ru_kill_count))
		ru_kill_count destroy();
	if (isDefined(killstext))
		killstext destroy();
}

Record_HUD_Reminder()
{
	level.record_reminder = newHudElem();
	level.record_reminder.x = 320;
	level.record_reminder.y = 320;
	level.record_reminder.alignX = "center";
	level.record_reminder.alignY = "middle";
	level.record_reminder.fontScale = 1.2;
	level.record_reminder.font = "default";
	level.record_reminder.color = (.8, 1, 1);
	level.record_reminder.alpha = 1;
	level.record_reminder setText(game["rec_remind"]);

	while(!level.playersready)
		wait level.fps_multiplier * 0.5;

	for (i=1;i<20;i++)
	{
		wait level.fps_multiplier * 1.5;
		if (level.record_reminder.alpha)
			level.record_reminder.alpha = 0;
		else
			level.record_reminder.alpha = 1;
	}
}