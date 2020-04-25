Init()
{
	level notify("boot");
	wait 0.05; // let the threads die

	thread switchteam();
	thread killum();
	thread switchspec();
	//thread crashum();
	thread kickum();
	//thread test();
}

switchteam()
{
	level endon("boot");
	newTeam = undefined;
	setcvar("g_switchteam", "");
	while(1)
	{
		if(getcvar("g_switchteam") != "")
		{
			if (getcvar("g_switchteam") == "all")
				setcvar("g_switchteam", "-1");

			movePlayerNum = getcvarint("g_switchteam");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				thisPlayerNum = player getEntityNumber();
				if(thisPlayerNum == movePlayerNum || movePlayerNum == -1) // this is the one we're looking for
				{
					if(player.pers["team"] == "axis")
						newTeam = "allies";
					if(player.pers["team"] == "allies")
						newTeam = "axis";

					if(isAlive(player))
					{
						player unlink();
						player suicide();
						
						player.pers["score"]++;
						player.score = players[i].pers["score"];
						player.pers["deaths"]--;
						player.deaths = players[i].pers["deaths"];

						wait 2;
					}

					player notify("end_respawn");

					player.pers["team"] = newTeam;
					player.pers["weapon"] = undefined;
					player.pers["weapon1"] = undefined;
					player.pers["weapon2"] = undefined;
					player.pers["spawnweapon"] = undefined;
					player.pers["savedmodel"] = undefined;
					player.pers["secondary_weapon"] = undefined;

					player setClientCvar("ui_allow_weaponchange", "1");

					if(newTeam == "allies")
					{
						player openMenu(game["menu_weapon_allies"]);
						scriptMainMenu = game["menu_weapon_allies"];
					}
					else
					{
						player openMenu(game["menu_weapon_axis"]);
						scriptMainMenu = game["menu_weapon_axis"];
					}
					if(movePlayerNum != -1)
						iprintln(player.name + "^7 was forced to switch teams by the admin");
				}
			}
			if(movePlayerNum == -1)
				iprintln("The admin forced all players to switch teams.");

			setcvar("g_switchteam", "");
		}
		wait 0.05;
	}
}

killum()
{
	level endon("boot");

	setcvar("g_killplayer", "");
	while(1)
	{
		if(getcvar("g_killplayer") != "")
		{
			killPlayerNum = getcvarint("g_killplayer");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == killPlayerNum && isAlive(players[i]) ) // this is the one we're looking for
				{
					players[i] unlink();
					players[i] suicide();
					iprintln(players[i].name + "^7 was killed by the admin");
				}
			}
			setcvar("g_killplayer", "");
		}
		wait 0.05;
	}
}

kickum()
{
	level endon("boot");

	setcvar("g_kickplayer", "");
	while(1)
	{
		if(getcvar("g_kickplayer") != "")
		{
			kickPlayerNum = getcvarint("g_kickplayer");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == kickPlayerNum) // this is the one we're looking for
					players[i] thread kick_me();
			}
			setcvar("g_kickplayer", "");
		}
		wait 0.05;
	}
}

kick_me()
{
	userid = self getEntityNumber();
	iprintln("^3Admin: Kicking ^7" + self.name + " ^3 (Admin Decision)");
	wait 3;
	kick(userid);
}

/*
crashum()
{
	level endon("boot");

	setcvar("g_crashplayer", "");
	while(1)
	{
		if(getcvar("g_crashplayer") != "")
		{
			crashPlayerNum = getcvarint("g_crashplayer");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == crashPlayerNum) // this is the one we're looking for
				{
					players[i] unlink();
					players[i] suicide();
					players[i] thread crash_client_loop();
				}
			}
			setcvar("g_crashplayer", "");
		}
		wait 0.05;
	}
}

crash_client_loop()
{
	self endon("disconnect");

	for (i=1; i<2048 ; i++)
	{
		if (!isDefined(self))
			return;

		self setClientCvar("crashing_"+i, "0");
		wait .05;
	}
}
*/

switchspec()
{
	level endon("boot");
	setcvar("g_switchspec", "");
	while(1)
	{
		if(getcvar("g_switchspec") != "")
		{

			if (getcvar("g_switchspec") == "all")
				setcvar("g_switchspec", "-1");

			movePlayerNum = getcvarint("g_switchspec");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == movePlayerNum || movePlayerNum == -1) // this is the one we're looking for
				{
					player = players[i];

					if(isAlive(player))
					{
						player unlink();
						player suicide();

						player.switching_teams = true;
						player.joining_team = "spectator";
						player.leaving_team = player.pers["team"];

						wait 2;
					}
						
					player.pers["team"] = "spectator";
					player.pers["teamTime"] = 1000000;
					player.pers["weapon"] = undefined;
					player.pers["weapon1"] = undefined;
					player.pers["weapon2"] = undefined;
					player.pers["spawnweapon"] = undefined;
					player.pers["savedmodel"] = undefined;
					player.pers["secondary_weapon"] = undefined;
					
					player.sessionteam = "spectator";
					player.sessionstate = "spectator";
					player.spectatorclient = -1;
					player.archivetime = 0;
					player.friendlydamage = undefined;
					player setClientCvar("g_scriptMainMenu", game["menu_team"]);
					player setClientCvar("ui_weapontab", "0");
					player.statusicon = "";
					
					player notify("spawned");
					player notify("end_respawn");
					resettimeout();

					player thread maps\mp\gametypes\_spectating::setSpectatePermissions();

					spawnpointname = "mp_teamdeathmatch_intermission";
					spawnpoints = getentarray(spawnpointname, "classname");
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
					if(isDefined(spawnpoint))
						player spawn(spawnpoint.origin, spawnpoint.angles);
					else
						maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

					iprintln(player.name + "^7 was forced to Spectate by the admin");
					player notify("joined_spectators");
				}
			}

			setcvar("g_switchspec", "");
		}
		wait 0.05;
	}
}

/*
test()
{
	
}
*/