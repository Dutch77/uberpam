/*
COD2 healthbar replica
by |D|^Grunt
http://www.clan-disconnected.com
modified by worm for PAM2
*/

init()
{
	level.healthbarHUD = [[level.setdvar]]("scr_show_healthbar", 0, 0, 1);
	level.healthbarFadeHUD = [[level.setdvar]]("scr_fade_healthbar", 0, 0, 1);

	if(level.healthbarHUD)
		level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerKilled();
	}
}

onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self thread removeHealthbarHUD();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeHealthbarHUD();
	}
}

onPlayerKilled()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("killed_player");
		wait level.fps_multiplier * 2;
	
		gametype = getcvar("g_gametype");
				
		if (gametype != "strat")
			self thread removeHealthbarHUD();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		removeHealthbarHUD();

		self.health_back = newClientHudElem(self);
		self.health_back.x = 501;
		self.health_back.y = 426;
		self.health_back.horzAlign = "left";
		self.health_back.vertAlign = "top";
		self.health_back.alpha = 1;
		self.health_back.sort = 1;
		self.health_back.archived = true;

		self.health_backglow = newClientHudElem(self);
		self.health_backglow.x = 501;
		self.health_backglow.y = 426;
		self.health_backglow.horzAlign = "left";
		self.health_backglow.vertAlign = "top";
		self.health_backglow.color = ( 1 , .25 , 0);
		self.health_backglow.alpha = 0;
		self.health_backglow.sort = 2;
		self.health_backglow.archived = true;

		self.health_cross = newClientHudElem(self);
		self.health_cross.x = 488;
		self.health_cross.y = 426;
		self.health_cross.horzAlign = "left";
		self.health_cross.vertAlign = "top";
		self.health_cross.alpha = 1;
		self.health_cross.sort = 1;
		self.health_cross.archived = true;

		self.health_crossglow = newClientHudElem(self);
		self.health_crossglow.x = 488;
		self.health_crossglow.y = 426;
		self.health_crossglow.horzAlign = "left";
		self.health_crossglow.vertAlign = "top";
		self.health_crossglow.alpha = 0;
		self.health_crossglow.color = ( 1 , .25 , 0);
		self.health_crossglow.sort = 2;
		self.health_crossglow.archived = true;

		self.health_bar = newClientHudElem(self);
		self.health_bar.x = 502;
		self.health_bar.y = 427;
		self.health_bar.horzAlign = "left";
		self.health_bar.vertAlign = "top";
		self.health_bar.color = ( 0 , .4, 0);
		self.health_bar.alpha = 1;
		self.health_bar.sort = 4;
		self.health_bar.archived = true;

		self.health_redbar = newClientHudElem(self);
		self.health_redbar.x = 502;
		self.health_redbar.y = 427;
		self.health_redbar.horzAlign = "left";
		self.health_redbar.vertAlign = "top";
		self.health_redbar.color = ( 1 , 0 , 0);
		self.health_redbar.sort = 3;
		self.health_redbar.archived = true;


		if (level.healthbarFadeHUD)
		{
			self.health_bar.alpha = 0;
			self.health_back.alpha = 0;
			self.health_cross.alpha = 0;
		}

		self.health_back setShader(game["health_back"], 130, 12);
		self.health_cross setShader(game["health_cross"], 12, 12);

		self.health_backglow setShader(game["health_back"], 130, 12);
		self.health_crossglow setShader(game["health_cross"], 12, 12);

		bar = Int(self.health * 1.28);
		self.health_bar setShader(game["health_bar"], bar, 10);

		self thread glowHealthbarHud();
		self thread fadeHealthbarHud();
		self thread updateHealthbarHUD();
	}
}

updateHealthbarHUD()
{
	self endon("disconnect");

	while(level.healthbarHUD)
	{
		health1 = self.health;
		wait level.frame;
		health2 = self.health;

		if ( health1 != health2 )
		{
			if(isDefined(self.health_bar))
			{
				bar = Int(health2 * 1.28);
				if (bar == 0)
				{
					// Player is dead 
					self.health_bar destroy();
					return;
				}

				self.health_bar.alpha = 1;
				self.health_bar.color = ( .75 - .0075 * health2 , .4 , 0);
				self.health_bar setShader(game["health_bar"], bar, 10);
				if (health2 < health1)
				{
					redbar = Int((health1 - health2) * 1.28);
					scaletime = (health1 - health2) * .006;
					self.health_redbar.x = 502 + bar;
					self.health_redbar.alpha = 1;
					self.health_redbar setShader(game["health_bar"], redbar , 10);
					self.health_redbar scaleOverTime (scaletime , 1 , 10);
					wait level.fps_multiplier * (scaletime + .05);
					self.health_redbar.alpha = 0;
					self.health_redbar setShader(game["health_bar"], 1, 10);
				}
			}
		}
	}
}

glowHealthbarHud()
{
	self endon("disconnect");
	self endon("killed_player");

	old_health = self.maxhealth;

	while(level.healthbarHUD)
	{
		wait level.frame;
		if ( self.health < old_health )
		{
			old_health = self.health;
			flash = 1;
			count = 0;

			while (flash)
			{
				if (self.health < old_health)
					count = 0;

				if (self.health >= old_health)
					count ++;

				if (count >= 12)
					flash = 0;

				self.health_backglow.alpha = 1;
				self.health_backglow fadeOverTime(0.45);
				self.health_backglow.alpha = 0;

				self.health_crossglow.alpha = 1;
				self.health_crossglow fadeOverTime(0.45);
				self.health_crossglow.alpha = 0;

				wait level.fps_multiplier * 0.45;

				old_health = self.health;
			}
		}
	}
}

fadeHealthbarHud()
{
	self endon("disconnected");
	self endon("killed_player");

	while(level.healthbarFadeHUD)
	{
		wait level.fps_multiplier * .05;
		if (self.health == self.maxhealth && self.health_cross.alpha )
		{
			wait level.fps_multiplier * 1;

			self.health_bar.alpha = 1;
			self.health_bar fadeOverTime(1);
			self.health_bar.alpha = 0;

			self.health_back.alpha = 1;
			self.health_back fadeOverTime(1);
			self.health_back.alpha = 0;

			self.health_cross.alpha = 1;
			self.health_cross fadeOverTime(1);
			self.health_cross.alpha = 0;

			wait level.fps_multiplier * 1;
		}

		if (self.health < self.maxhealth && !self.health_cross.alpha )
		{
			self.health_back.alpha = 1;
			self.health_cross.alpha = 1;
			self.health_back setShader(game["health_back"], 130, 12);
			self.health_cross setShader(game["health_cross"], 12, 12);
		}
	}
}

removeHealthbarHUD()
{
	if(isDefined(self.health_back))
		self.health_back destroy();

	if(isDefined(self.health_backglow))
		self.health_backglow destroy();

	if(isDefined(self.health_cross))
		self.health_cross destroy();

	if(isDefined(self.health_crossglow))
		self.health_crossglow destroy();

	if(isDefined(self.health_bar))
		self.health_bar destroy();

	if(isDefined(self.health_redbar))
		self.health_redbar destroy();
}
