init()
{
	if (isDefined(game["Do_Ready_up"]) && game["Do_Ready_up"])
		return;

	thread Players_Alive_Monitor();
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onPlayerDisconnected();
		player thread onPlayerKilled();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		level notify("update_playersleft");

		self Kill_Existing_Display();
		wait level.frame;

		self thread Setup_Player_Display();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		level notify("update_playersleft");
		
		self Kill_Existing_Display();
		wait level.frame;

		self thread Setup_Player_Display();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		level notify("update_playersleft");

		self Kill_Existing_Display();
		wait level.frame;

		self thread Setup_Spec_Display();
	}
}

onPlayerKilled()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("killed_player");

		level notify("update_playersleft");
	}
}

onPlayerDisconnected()
{
	self endon("pleft_disconnect");

	for(;;)
	{
		self waittill("disconnect");
		
		level notify("update_playersleft");
		wait 0.1;
		self notify("pleft_disconnect");
	}
}
	

Kill_Existing_Display()
{
	self notify("stop_alive_scanning");

	if (isDefined(self.teamleftnum) )
		self.teamleftnum destroy();
	if (isDefined(self.teamleft) )
		self.teamleft destroy();
	if (isDefined(self.enemyleftnum) )
		self.enemyleftnum destroy();
	if (isDefined(self.enemyleft) )
		self.enemyleft destroy();

	if (isDefined(self.axisleftnum) )
		self.axisleftnum destroy();
	if (isDefined(self.axisleft) )
		self.axisleft destroy();
	if (isDefined(self.alliesleftnum) )
		self.alliesleftnum destroy();
	if (isDefined(self.alliesleft) )
		self.alliesleft destroy();
}

Setup_Player_Display()
{
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
		return;
	}

	if (!level.hud_playersleft)
		return;

	if (level.gametype == "ctf" && level.hud_flagstatus)
	{
		self thread Setup_CTF_Player_Display();
		return;
	}

	self endon("disconnect");
	self endon("stop_alive_scanning");

	self.teamleftnum = newClientHudElem(self);
	self.teamleftnum.x = 375;
	self.teamleftnum.y = 479;
	self.teamleftnum.alignX = "right";
	self.teamleftnum.alignY = "bottom";
	self.teamleftnum.fontScale = 1.2;
	self.teamleftnum.color = (0.580,0.961,0.573);
	self.teamleftnum.alpha = 1;

	self.teamleft =  newClientHudElem(self);
	self.teamleft.x = 380;
	self.teamleft.y = 479;
	self.teamleft.alignX = "left";
	self.teamleft.alignY = "bottom";
	self.teamleft.fontScale = 1.2;
	self.teamleft.color = (0.580,0.961,0.573);
	self.teamleft.alpha = 1;
	if (self.pers["team"] == "axis")
		self.teamleft setText(game["axis_hud_text"]);
	else
		self.teamleft setText(game["allies_hud_text"]);

	self.enemyleftnum =  newClientHudElem(self);
	self.enemyleftnum.x = 465;
	self.enemyleftnum.y = 479;
	self.enemyleftnum.alignX = "right";
	self.enemyleftnum.alignY = "bottom";
	self.enemyleftnum.fontScale = 1.2;
	self.enemyleftnum.color = (0.055,0.855,0.996);
	self.enemyleftnum.alpha = 1;

	self.enemyleft =  newClientHudElem(self);
	self.enemyleft.x = 470;
	self.enemyleft.y = 479;
	self.enemyleft.alignX = "left";
	self.enemyleft.alignY = "bottom";
	self.enemyleft.fontScale = 1.2;
	self.enemyleft.color = (0.055,0.855,0.996);
	self.enemyleft.alpha = 1;
	if (self.pers["team"] == "allies")
		self.enemyleft setText(game["axis_hud_text"]);
	else
		self.enemyleft setText(game["allies_hud_text"]);

	while(self.pers["team"] != "spectator")
	{
		if (self.pers["team"] == "axis")
		{
			teammates = level.axis_alive;
			enemy = level.allies_alive;
		}
		else
		{
			teammates = level.allies_alive;
			enemy = level.axis_alive;
		}

		self.teamleftnum setValue(teammates);
		self.enemyleftnum setValue(enemy);

		level waittill("update_playersleft");
		wait level.fps_multiplier * .1;
	}
}


Setup_Spec_Display()
{
	if (!level.hud_playersleft)
		return;

	if (level.gametype == "ctf" && level.hud_flagstatus)
	{
		self thread Setup_CTF_Player_Display();
		return;
	}

	self endon("disconnect");
	self endon("stop_alive_scanning");

	self.axisleftnum =  newClientHudElem(self);
	self.axisleftnum.x = 385;
	self.axisleftnum.y = 479;
	self.axisleftnum.alignX = "right";
	self.axisleftnum.alignY = "bottom";
	self.axisleftnum.fontScale = 1.2;
	self.axisleftnum.color = (1, 1, 1);
	self.axisleftnum.alpha = 1;

	self.axisleft =  newClientHudElem(self);
	self.axisleft.x = 390;
	self.axisleft.y = 479;
	self.axisleft.alignX = "left";
	self.axisleft.alignY = "bottom";
	self.axisleft.fontScale = 1.2;
	self.axisleft.color = (1, 1, 1);
	self.axisleft.alpha = 1;
	self.axisleft setText(game["axis_hud_text"]);

	self.alliesleftnum =  newClientHudElem(self);
	self.alliesleftnum.x = 455;
	self.alliesleftnum.y = 479;
	self.alliesleftnum.alignX = "right";
	self.alliesleftnum.alignY = "bottom";
	self.alliesleftnum.fontScale = 1.2;
	self.alliesleftnum.color = (1, 1, 1);
	self.alliesleftnum.alpha = 1;

	self.alliesleft =  newClientHudElem(self);
	self.alliesleft.x = 460;
	self.alliesleft.y = 479;
	self.alliesleft.alignX = "left";
	self.alliesleft.alignY = "bottom";
	self.alliesleft.fontScale = 1.2;
	self.alliesleft.color = (1, 1, 1);
	self.alliesleft.alpha = 1;
	self.alliesleft setText(game["allies_hud_text"]);

	while(self.pers["team"] == "spectator")
	{
		self.axisleftnum setValue(level.axis_alive);
		self.alliesleftnum setValue(level.allies_alive);

		level waittill("update_playersleft");
		wait level.fps_multiplier * .1;
	}
}


Players_Alive_Monitor()
{
	
	while (1)
	{

		level waittill("update_playersleft");
		allied_alive = 0;
		axis_alive = 0;
		
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			{

				if(player.pers["team"] == "allies")
					allied_alive++;
				else if(player.pers["team"] == "axis")
					axis_alive++;
			}
		}

		level.axis_alive = axis_alive;
		level.allies_alive = allied_alive;
	}

}


Setup_CTF_Player_Display()
{
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
		return;
	}

	self endon("disconnect");
	self endon("stop_alive_scanning");

	self.teamleftnum = newClientHudElem(self);
	self.teamleftnum.x = 284;
	self.teamleftnum.y = 477;
	self.teamleftnum.alignX = "left";
	self.teamleftnum.alignY = "bottom";
	self.teamleftnum.fontScale = 1.4;
	self.teamleftnum.color = (1,1,0);
	self.teamleftnum.alpha = 1;

	self.teamleft =  newClientHudElem(self);
	self.teamleft.x = 320;
	self.teamleft.y = 477;
	self.teamleft.alignX = "center";
	self.teamleft.alignY = "bottom";
	self.teamleft.fontScale = 1.2;
	self.teamleft.color = (1,1,0);
	self.teamleft.alpha = 1;
	self.teamleft setText(game["alive_hud_text"]);

	self.enemyleftnum =  newClientHudElem(self);
	self.enemyleftnum.x = 355;
	self.enemyleftnum.y = 477;
	self.enemyleftnum.alignX = "right";
	self.enemyleftnum.alignY = "bottom";
	self.enemyleftnum.fontScale = 1.4;
	self.enemyleftnum.color = (1,1,0);
	self.enemyleftnum.alpha = 1;

	while (1)
	{
		if (self.pers["team"] == "spectator" || self.pers["team"] == "axis")
		{
			teammates = level.axis_alive;
			enemy = level.allies_alive;
		}
		else
		{
			teammates = level.allies_alive;
			enemy = level.axis_alive;
		}

		self.teamleftnum setValue(teammates);
		self.enemyleftnum setValue(enemy);

		level waittill("update_playersleft");
		wait level.fps_multiplier * .1;
	}
}