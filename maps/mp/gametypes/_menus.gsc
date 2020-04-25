init()
{
	mode = getcvar("pam_mode");
	gametype = getcvar("g_gametype");

	//if (mode == "cg_rifle" || mode == "pub_rifle")
	//	game["menu_ingame"] = "ingamer";
	//else
		game["menu_ingame"] = "ingame";

	game["menu_team"] = "team_" + game["allies"] + game["axis"];
	
	if ((mode == "cg_rifle" || mode == "pub_rifle") && gametype != "strat")
	{
		game["menu_weapon_allies"] = "weaponr_" + game["allies"];
		game["menu_weapon_axis"] = "weaponr_" + game["axis"];
	}
	else if (gametype == "strat" || (mode != "cg_rifle" && mode != "pub_rifle"))
	{
		game["menu_weapon_allies"] = "weapon_" + game["allies"];
		game["menu_weapon_axis"] = "weapon_" + game["axis"];
	}

	precacheMenu(game["menu_ingame"]);
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_weapon_allies"]);
	precacheMenu(game["menu_weapon_axis"]);

	if(!level.xenon)
	{
		if (gametype == "sd" && (mode == "cg_rifle" || mode == "pub_rifle"))
			game["menu_serverinfo"] = "serverinfor_sd";
		else if (gametype == "tdm" && (mode == "cg_rifle" || mode == "pub_rifle"))
			game["menu_serverinfo"] = "serverinfor_tdm";
		else if (gametype == "dm" && (mode == "cg_rifle" || mode == "pub_rifle"))
			game["menu_serverinfo"] = "serverinfor_tdm";
		else if ((mode != "cg_rifle" && mode != "pub_rifle") || gametype == "strat")		
			game["menu_serverinfo"] = "serverinfo_" + getCvar("g_gametype");

		game["menu_callvote"] = "callvote";
		game["menu_muteplayer"] = "muteplayer";

		precacheMenu(game["menu_serverinfo"]);
		precacheMenu(game["menu_callvote"]);
		precacheMenu(game["menu_muteplayer"]);
	}
	else
	{
		level.splitscreen = isSplitScreen();
		if(level.splitscreen)
		{
			game["menu_team"] += "_splitscreen";
			game["menu_weapon_allies"] += "_splitscreen";
			game["menu_weapon_axis"] += "_splitscreen";
			game["menu_ingame_onteam"] = "ingame_onteam_splitscreen";
			game["menu_ingame_spectator"] = "ingame_spectator_splitscreen";

			precacheMenu(game["menu_team"]);
			precacheMenu(game["menu_weapon_allies"]);
			precacheMenu(game["menu_weapon_axis"]);
			precacheMenu(game["menu_ingame_onteam"]);
			precacheMenu(game["menu_ingame_spectator"]);
		}
	}

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onMenuResponse();
	}
}

onMenuResponse()
{	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		//iprintln("^6", response);
		if(response == "back")
		{
			self closeMenu();
			self closeInGameMenu();

			if(menu == game["menu_team"])
			{
				if(level.splitscreen)
				{
					if(self.pers["team"] == "spectator")
					{	
						self openMenu(game["menu_ingame_spectator"]);
					}
					else
					{
						self openMenu(game["menu_ingame_onteam"]);
					}
				}
				else
					self openMenu(game["menu_ingame"]);
			}
			else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
				self openMenu(game["menu_team"]);
				
			continue;
		}

		if(response == "moddownloaded")
		{
			self.pers["downloadedmod"] = 1;
			continue;
		}

		if (response == "open_rec_win")
		{
			self.pers["abletoopen_record"] = 1;
			continue;
		}

		if(response == "endgame")
		{
			if(level.splitscreen)
			{
				level thread [[level.endgameconfirmed]]();
			}
			else if (level.xenon)
			{
				endparty();
				level thread [[level.endgameconfirmed]]();
			}
				
			continue;
		}

		if(response == "endround")
		{
			//ePAM
			if(level.splitscreen)
			{
				level thread [[level.endgameconfirmed]]();
			}
			
			continue;
		}
		
		if (response == "cvarlistloaded")
		{
			wait (2);
			self iprintln ("CVAR & MD5Tool checks should now be loaded. If not, check your rcon login.");
			continue;			
		}
		
		if (response == "about")
		{
			thread maps\pam\about::aboutmodserver();
			continue;
		}

		if(getCvarInt("scr_uber") == 1) {

            // 1. Rampage

            if (response == "uber__rampage__shield")
            {
                thread uber\uber::shield();
                continue;
            }

            if (response == "uber__rampage__turret")
            {
                thread uber\uber::turret();
                continue;
            }

            if (response == "uber__rampage__panzerschreck")
            {
                thread uber\uber::panzerschreck();
                continue;
            }

            if (response == "uber__rampage__toggle_hide")
            {
                thread uber\uber::hidden();
                continue;
            }

            if (response == "uber__rampage__third_person")
            {
                thread uber\uber::thirdperson();
                continue;
            }

            // 2. weapons

            if (response == "uber__weapon__springfield")
            {
                thread uber\uber_weapon::springfield();
                continue;
            }

            if (response == "uber__weapon__kar98")
            {
                thread uber\uber_weapon::kar98();
                continue;
            }

            if (response == "uber__weapon__mp44")
            {
                thread uber\uber_weapon::mp44();
                continue;
            }

            if (response == "uber__weapon__m1_garand")
            {
                thread uber\uber_weapon::m1Garand();
                continue;
            }

            if (response == "uber__weapon__thompson")
            {
                thread uber\uber_weapon::thompson();
                continue;
            }

            if (response == "uber__weapon__ppsh")
            {
                thread uber\uber_weapon::ppsh();
                continue;
            }

            if (response == "uber__weapon__shotgun")
            {
                thread uber\uber_weapon::shotgun();
                continue;
            }

            if (response == "uber__weapon__grenade")
            {
                thread uber\uber_weapon::grenade();
                continue;
            }

            if (response == "uber__weapon__smoke")
            {
                thread uber\uber_weapon::smoke();
                continue;
            }

            // 3. Transform

            if (response == "uber__transform__plane")
            {
                thread uber\uber::plane();
                continue;
            }

            if (response == "uber__transform__tank")
            {
                thread uber\uber::tank();
                continue;
            }

            if (response == "uber__transform__lamp")
            {
                thread uber\uber::lamp();
                continue;
            }

            if (response == "uber__transform__crate")
            {
                thread uber\uber::crate();
                continue;
            }

            if (response == "uber__transform__potato")
            {
                thread uber\uber::potato();
                continue;
            }

            if (response == "uber__transform__grenade")
            {
                thread uber\uber::grenade();
                continue;
            }

            if (response == "uber__transform__weaponmp44")
            {
                thread uber\uber::weaponmp44();
                continue;
            }

            if (response == "uber__transform__bush")
            {
                thread uber\uber::bush();
                continue;
            }

            if (response == "uber__transform__tree")
            {
                thread uber\uber::tree();
                continue;
            }

            if (response == "uber__transform__chair")
            {
                thread uber\uber::chair();
                continue;
            }

            if (response == "uber__transform__desk")
            {
                thread uber\uber::desk();
                continue;
            }

            if (response == "uber__transform__grass")
            {
                thread uber\uber::grass();
                continue;
            }

            if (response == "uber__transform__radio")
            {
                thread uber\uber::radio();
                continue;
            }

            if (response == "uber__transform__bomb")
            {
                thread uber\uber::bomb();
                continue;
            }

            if (response == "uber__transform__deadcow")
            {
                thread uber\uber::deadcow();
                continue;
            }

            if (response == "uber__transform__bear")
            {
                thread uber\uber::bear();
                continue;
            }

            if (response == "uber__transform__brush_desertshrubgroup01")
            {
                thread uber\uber::brush_desertshrubgroup01();
                continue;
            }

            if (response == "uber__transform__brush_egypt_desert_1")
            {
                thread uber\uber::brush_egypt_desert_1();
                continue;
            }

            if (response == "uber__transform__brush_egypt_desert_2")
            {
                thread uber\uber::brush_egypt_desert_2();
                continue;
            }

            if (response == "uber__transform__brush_snowbushweed01")
            {
                thread uber\uber::brush_snowbushweed01();
                continue;
            }

            if (response == "uber__transform__brush_snowbushweed02")
            {
                thread uber\uber::brush_snowbushweed02();
                continue;
            }

            if (response == "uber__transform__brush_toujanebigbushy")
            {
                thread uber\uber::brush_toujanebigbushy();
                continue;
            }

            if (response == "uber__transform__caen_bush_full_01")
            {
                thread uber\uber::caen_bush_full_01();
                continue;
            }

            if (response == "uber__transform__caen_spikeybush_01")
            {
                thread uber\uber::caen_spikeybush_01();
                continue;
            }

            if (response == "uber__transform__tree_desertbushy")
            {
                thread uber\uber::tree_desertbushy();
                continue;
            }

            if (response == "uber__transform__tree_desertpalm01")
            {
                thread uber\uber::tree_desertpalm01();
                continue;
            }

            if (response == "uber__transform__tree_desertpalm02")
            {
                thread uber\uber::tree_desertpalm02();
                continue;
            }

            if (response == "uber__transform__tree_destoyed_trunk_a")
            {
                thread uber\uber::tree_destoyed_trunk_a();
                continue;
            }

            if (response == "uber__transform__tree_destoyed_trunk_b")
            {
                thread uber\uber::tree_destoyed_trunk_b();
                continue;
            }

            if (response == "uber__transform__tree_destoyed_snow_trunk_a")
            {
                thread uber\uber::tree_destoyed_snow_trunk_a();
                continue;
            }

            if (response == "uber__transform__tree_destoyed_snow_trunk_b")
            {
                thread uber\uber::tree_destoyed_snow_trunk_b();
                continue;
            }

            if (response == "uber__transform__tree_grey_oak_sm_a")
            {
                thread uber\uber::tree_grey_oak_sm_a();
                continue;
            }

            if (response == "uber__transform__car")
            {
                thread uber\uber_transform::transform("xmodel/civiliancar_intact_blue", "250");
                continue;
            }

            if (response == "uber__transform__bridge")
            {
                thread uber\uber_transform::transform("xmodel/gully_bridge01", "500");
                continue;
            }

            if (response == "uber__transform__head")
            {
                thread uber\uber_transform::transform("xmodel/head_british_price", "150", (0,0,20), (-90,0,-90));
                continue;
            }

            // 4. bomb

            if (response == "uber__bomb__5")
            {
                thread uber\uber::bomb5();
                continue;
            }

            if (response == "uber__bomb__10")
            {
                thread uber\uber::bomb10();
                continue;
            }

            if (response == "uber__bomb__30")
            {
                thread uber\uber::bomb30();
                continue;
            }

            if (response == "uber__bomb__remote")
            {
                thread uber\uber::bombremote();
                continue;
            }

            // 5. Respawn

            if (response == "uber__spawn__respawn")
            {
                thread uber\uber_spawn::respawn();
                continue;
            }

            if (response == "uber__spawn__respawn_hidden")
            {
                thread uber\uber_spawn::respawnHidden();
                continue;
            }

            if (response == "uber__spawn__respawn_switch")
            {
                thread uber\uber_spawn::respawnSwitch();
                continue;
            }

            if (response == "uber__spawn__respawn_switch_hidden")
            {
                thread uber\uber_spawn::respawnSwitchHidden();
                continue;
            }

            // 6. Teleport

            if (response == "uber__teleport__teleport")
            {
                thread uber\uber_teleport::teleport();
                continue;
            }

            if (response == "uber__teleport__save_position")
            {
                thread uber\uber_teleport::savePosition();
                continue;
            }

            if (response == "uber__teleport__load_position")
            {
                thread uber\uber_teleport::loadPosition();
                continue;
            }
        }

		//ePAM
		
		gametype = getcvar("g_gametype");		

		if (response == "timeout")
		{
			if ((self.pers["team"] == "axis" || self.pers["team"] == "allies"))
			{
				if (!game["timeout"]) {
					thread maps\pam\timeout::Validate_Timeout(self);
				} else if (game["teamcalledto"] == self.pers["team"] && game["teamcalledto"] == "allies" && !level.instrattime && level.intimeout == 0 && gametype == "sd") 
				{
					game["timeout"] = false;
					game["allies_tos"]--;
					game["allies_tos_half"]--;
					iprintln(self.name + " ^7canceled pause for team " + self.pers["team"]);
					game["timestoc"]++;
					pam_timeoutcan = self.name + "�" + self.pers["team"] + "�" + game["timestoc"];
					setcvar("calledtimeoutcan2", pam_timeoutcan);
					level waittill("update_teamscore_hud");
				} else if (game["teamcalledto"] == self.pers["team"] && game["teamcalledto"] == "axis" && !level.instrattime && level.intimeout == 0 && gametype == "sd")
				{
					game["timeout"] = false;
					game["axis_tos"]--;
					game["axis_tos_half"]--;
					iprintln(self.name + " ^7canceled pause for team " + self.pers["team"]);
					game["timestoc"]++;
					pam_timeoutcan = self.name + "�" + self.pers["team"] + "�" + game["timestoc"];
					setcvar("calledtimeoutcan2", pam_timeoutcan);
					level waittill("update_teamscore_hud");
				} else {
					self iprintln("Time-out already called / already in time-out");
				}
			}
			continue;
		}


		if(menu == game["menu_ingame"] || (level.splitscreen && (menu == game["menu_ingame_onteam"] || menu == game["menu_ingame_spectator"])))
		{
			switch(response)
			{
			case "changeweapon":
				self closeMenu();
				self closeInGameMenu();
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;	

			case "changeteam":
				self closeMenu();
				self closeInGameMenu();
				self openMenu(game["menu_team"]);
				break;

			case "muteplayer":
				if(!level.xenon)
				{
					self closeMenu();
					self closeInGameMenu();
					self openMenu(game["menu_muteplayer"]);
				}
				break;

			case "callvote":
				if(!level.xenon)
				{
					self closeMenu();
					self closeInGameMenu();
					self openMenu(game["menu_callvote"]);
				}
				break;
			}
		}
		
		else if(menu == game["menu_team"])
		{
			teambool = self.pers["team"];
			mode = getcvar("pam_mode");
			switch(response)
			{
			case "allies":
				self closeMenu();
				self closeInGameMenu();
				self [[level.allies]]();
				if(teambool != "allies")
				{
					iprintln(&"MP_JOINED_ALLIES", self.name);
				}
				teambool = "allies";
				break;

			case "axis":
				self closeMenu();
				self closeInGameMenu();
				self [[level.axis]]();
				if(teambool != "axis")
				{
					iprintln(&"MP_JOINED_AXIS", self.name);
				}
				teambool = "axis";
				break;

			case "autoassign":
				self closeMenu();
				self closeInGameMenu();
				self [[level.autoassign]]();
				if(self.pers["team"] == "allies" && teambool != "allies")
				{
					iprintln(&"MP_JOINED_ALLIES", self.name);
				}
				else if(self.pers["team"] == "axis" && teambool != "axis")
				{
					iprintln(&"MP_JOINED_AXIS", self.name);
				}
				break;

			case "spectator":
				self.specmenu = 1;
				self.pers["specmenuopened"] = 1;
				if (self.pers["beenspec"] != 1)
				{
					iprintln(self.name + " Joined Spectators");
					self.pers["beenspec"] = 1;	
					self.pers["beenspecforonce"] = 1;
				}
				else if(teambool != "spectator")
				{
					iprintln(self.name + " Joined Spectators");
				}
				self closeMenu();
				self closeInGameMenu();
				self [[level.spectator]]();
				teambool = "spectator";
				break;
			}
		}
		else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
		{
			self closeMenu();
			self closeInGameMenu();
			self [[level.weapon]](response);
		}
		else if(!level.xenon)
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
			else if(menu == game["menu_serverinfo"] && response == "close")
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu(game["menu_team"]);
				self.pers["skipserverinfo"] = true;
			}
		}
	}
}