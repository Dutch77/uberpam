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
					pam_timeoutcan = self.name + "¦" + self.pers["team"] + "¦" + game["timestoc"];
					setcvar("calledtimeoutcan2", pam_timeoutcan);
					level waittill("update_teamscore_hud");
				} else if (game["teamcalledto"] == self.pers["team"] && game["teamcalledto"] == "axis" && !level.instrattime && level.intimeout == 0 && gametype == "sd")
				{
					game["timeout"] = false;
					game["axis_tos"]--;
					game["axis_tos_half"]--;
					iprintln(self.name + " ^7canceled pause for team " + self.pers["team"]);
					game["timestoc"]++;
					pam_timeoutcan = self.name + "¦" + self.pers["team"] + "¦" + game["timestoc"];
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