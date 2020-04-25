spectator_mode()
{
	self endon("disconnect");

	wait 1;

	mode = getcvar("pam_mode");
	gametypeyoy = getcvar("g_gametype");

	if (mode == "pub" || mode == "pub_rifle")
		return;
	if (gametypeyoy != "sd")
		return;

	//self thread overview_enter();

	// DEFINING ARRAY FOR AXIS
	self.health_background_axis = [];
	self.healthbar_axis = [];
	self.playername_axis = [];

	// DEFINING ARRAY FOR ALLIES
	self.health_background_allies = [];
	self.healthbar_allies = [];
	self.playername_allies = [];	

	// MAKING AXIS BOXES
	for(i = 0; i < 5; i++)
	{
		y_pos = 120 + (30 * i);
		self making_AXIS_boxes(i, y_pos);
	}

	// MAKING ALLIES BOXES
	for(i = 0; i < 5; i++)
	{
		y_pos = 120 + (30 * i);
		self making_ALLIES_boxes(i, y_pos);
	}

	self filling_boxes();
} 

making_AXIS_boxes(i, y)
{		
	self endon("disconnect");

	self.healthbar_axis[i] = newClientHudElem(self);
	self.healthbar_axis[i].x = 4;
	self.healthbar_axis[i].y = y + 1;
	self.healthbar_axis[i].horzAlign = "left";
	self.healthbar_axis[i].vertAlign = "top";
	self.healthbar_axis[i].color = (0, 0, .7);
	self.healthbar_axis[i].alpha = 0;
	self.healthbar_axis[i].sort = 1;
	self.healthbar_axis[i].filled = false;
	self.healthbar_axis[i].archived = false;
		
	self.playername_axis[i] = newClientHudElem(self);
	self.playername_axis[i].x = 8;
	self.playername_axis[i].y = y + 3.5;
	self.playername_axis[i].horzalign = "left";
	self.playername_axis[i].vertalign = "top";
	self.playername_axis[i].sort = 2;
	self.playername_axis[i].fontScale = 1;
	self.playername_axis[i].color = (.8, 1, 1);
	self.playername_axis[i].archived = false;
	
	self.healthbar_axis[i] setShader(game["health_bar"], 128, 18);
}

making_ALLIES_boxes(i, y)
{		     
	self endon("disconnect");

	self.healthbar_allies[i] = newClientHudElem(self);
	self.healthbar_allies[i].x = -4;
	self.healthbar_allies[i].y = y + 1;
	self.healthbar_allies[i].horzAlign = "right";
	self.healthbar_allies[i].vertAlign = "top";
	self.healthbar_allies[i].color = (1, 0, 0);
	self.healthbar_allies[i].alignX = "right";
	self.healthbar_allies[i].alpha = 0;
	self.healthbar_allies[i].sort = 1;
	self.healthbar_allies[i].filled = false;
	self.healthbar_allies[i].archived = false;	     	
	
	self.playername_allies[i] = newClientHudElem(self);
	self.playername_allies[i].x = -8;
	self.playername_allies[i].y = y + 3.5;
	self.playername_allies[i].horzalign = "right";
	self.playername_allies[i].vertalign = "top";
	self.playername_allies[i].alignX = "right";
	self.playername_allies[i].sort = 2;
	self.playername_allies[i].fontScale = 1;
	self.playername_allies[i].color = (.8, 1, 1);
	self.playername_allies[i].archived = false;
	    
	//bar = Int(self.health * 1.28);

	self.healthbar_allies[i] setShader(game["health_bar"], 128, 18);
}

filling_boxes()
{
	self endon("disconnect");

	for(;;)
	{
		if (self.pers["team"] == "spectator")
		{		
			players = getentarray("player", "classname");
	
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
	
				if (player.pers["team"] == "allies")
				{
					for(j = 0; j < 5; j++)
					{
						if(self.healthbar_allies[j].filled == false)
						{
							self.playername_allies[j] setplayernamestring(player);
							self.healthbar_allies[j].filled = true;
	
							health2 = player.health;
		     
							if(isDefined(self.healthbar_allies[j]))
							{
								if (health2 == 0)
								{
									self.healthbar_allies[j].alpha = 0;
									self.playername_allies[j].alpha = 0.5;
								}
								else
								{
									bar = Int(health2 * 1.28);
			
									self.healthbar_allies[j].alpha = 1;
									self.healthbar_allies[j] setShader(game["health_bar"], bar, 18);
									self.playername_allies[j].alpha = 1;
								}        
							}
							break;
						}
						
					}
				}
				else if (player.pers["team"] == "axis")
				{
					for(j = 0; j < 5; j++)
					{
						if(self.healthbar_axis[j].filled == false)
						{
							self.playername_axis[j] setplayernamestring(player);
							self.healthbar_axis[j].filled = true;
	
							health2 = player.health;
		     
							if(isDefined(self.healthbar_axis[j]))
							{
								if (health2 == 0)
								{
									self.healthbar_axis[j].alpha = 0;
									self.playername_axis[j].alpha = 0.5;
								}
								else
								{							
									bar = Int(health2 * 1.28);
		
									self.healthbar_axis[j].alpha = 1;
									self.healthbar_axis[j] setShader(game["health_bar"], bar, 18);
									self.playername_axis[j].alpha = 1;
								}         
							}
							break;
						}
					}
				}
			}
		self unfill_boxes();
		wait 0.1;
		}
		else
		{
			for(c = 0; c < 5; c++)
			{
				if(isdefined(self.playername_allies[c]))
					self.playername_allies[c] destroy();
				if(isdefined(self.healthbar_allies[c]))
					self.healthbar_allies[c] destroy();
				if(isdefined(self.playername_axis[c]))
					self.playername_axis[c] destroy();
				if(isdefined(self.healthbar_axis[c]))
					self.healthbar_axis[c] destroy();
			}
			return;
		}
	}
}

unfill_boxes()
{
	self endon("disconnect");	

	for(r = 0; r < 5; r++)
	{
		if(self.healthbar_allies[r].filled == false)
		{
			self.playername_allies[r] settext(game["empty"]);
			self.healthbar_allies[r] setShader(game["health_bar"], 128, 18);
			self.healthbar_allies[r].alpha = 0;
			self.playername_allies[r].alpha = 1;
		}
		
		if(self.healthbar_axis[r].filled == false)
		{
			self.playername_axis[r] settext(game["empty"]);
			self.healthbar_axis[r] setShader(game["health_bar"], 128, 18);
			self.healthbar_axis[r].alpha = 0;
			self.playername_axis[r].alpha = 1;
		}
	}
					
	for(r = 0; r < 5; r++)
	{
		self.healthbar_allies[r].filled = false;
		self.healthbar_axis[r].filled = false;
	}
}

/*
overview_enter()
{
	self endon("disconnect");
	self endon("spawned");

	whatmapisplaying = getcvar("mapname");

	if (whatmapisplaying == "mp_toujane" || whatmapisplaying == "mp_burgundy" || whatmapisplaying == "mp_carentan" || whatmapisplaying == "mp_matmata" || whatmapisplaying == "mp_dawnville")
		wait 0.05;
	else
		return;

	
	if (self.pers["team"] == "spectator" && self.sessionteam == "spectator")
	{	
		if (isdefined(self.specmode))
			self.specmode destroy();	
			
		self.specmode = newClientHudElem(self);
		self.specmode.x = 346.5;
		self.specmode.y = 397;
		self.specmode.horzAlign = "left";
		self.specmode.vertalign = "top";
		//self.specmode.alignY = "top";
		self.specmode.fontScale = 0.835;
		self.specmode.color = (1.0, 1.0, 1.0);
		self.specmode setText(game["specmode_message_on"]);
		self.specmode.sort = 1;
		self.specmode.archived = false;
	
		self thread usebutton_checker();
	}
	
}

do_specmode_text()
{
	if (isdefined(self.specmode1))
		self.specmode1 destroy();
	if (self.pers["team"] == "spectator")
	{
		self.specmode1 = newClientHudElem(self);
		self.specmode1.x = 346.5;
		self.specmode1.y = 406.5;
		self.specmode1.horzAlign = "left";
		self.specmode1.vertalign = "top";
		//self.specmode1.alignY = "top";
		self.specmode1.fontScale = 0.835;
		self.specmode1.color = (1.0, 1.0, 1.0);
		self.specmode1 setText(game["specmode_message_mouse"]);
		self.specmode1.sort = 1;
		self.specmode1.archived = false;
	}
}

usebutton_checker()
{
	self endon("disconnect");
	self endon("spawned");		

	self.overviewmode = 0;

	for(;;)
	{
		if (self.pers["team"] != "spectator" && isdefined(self.specmode))
			{
				self.specmode destroy();
				return;
			}				

		if (self useButtonPressed() == true )
		{
			if (self.overviewmode == 0)
			{
				self.overviewmode = 1;

				self.specmode setText(game["specmode_message_off"]);
				self.specmode.y = 416;
				self do_specmode_text();
				self allowSpectateTeam("allies", false);
				self allowSpectateTeam("axis", false);
				self allowSpectateTeam("freelook", false);
				self allowSpectateTeam("none", false);

				self thread shotbutton_checker();
			}
			else if (self.overviewmode == 1)
			{
				self.overviewmode = 0;

				self.specmode setText(game["specmode_message_on"]);
				self.specmode.y = 397;

				if (isdefined(self.specmode1))
					self.specmode1 destroy();
		
				self allowSpectateTeam("allies", true);
				self allowSpectateTeam("axis", true);
				self allowSpectateTeam("freelook", true);
				self allowSpectateTeam("none", true);
			}

			while (self useButtonPressed() == true)
				wait 0.5;
		}
		else
			wait 0.1;

		wait 0.1;
	}
}

shotbutton_checker()
{	
	self endon("disconnect");
	self endon("spawned");		

	wait 0.1;

	self.whatlook = 0;

	whatmap1 = getcvar("mapname");
	
	switch (whatmap1)
	{
		case "mp_toujane":
			self positioner("allies");
			break;
		case "mp_burgundy":
			self positioner("allies2");
			break;
		case "mp_dawnville":
			self positioner("allies");
			break;
		case "mp_carentan":
			self positioner("allies");
			break;
		case "mp_matmata":
			self positioner("allies2");
			break;
	}

	while (self.overviewmode == 1)
	{
		if (self.pers["team"] != "spectator" && self.sessionteam != "spectator")
			return;	
	
		if (self.overviewmode == 0)
			return;

		if (self attackbuttonpressed() == true)
		{
			whatmap2 = getcvar("mapname");
			switch (whatmap2)
			{
				case "mp_toujane":
					if(self.whatlook == 0)
					{
						self.whatlook = 1;
						self positioner("axis");
					}
					else if (self.whatlook == 1)
					{
						self.whatlook = 0;
						self positioner("allies");
					}

					break;

				case "mp_burgundy":
					if(self.whatlook == 0)
					{
						self.whatlook = 1;
						self positioner("axis");
					}
					else if (self.whatlook == 1)
					{
						self.whatlook = 2;
						self positioner("allies");
					}
					else if (self.whatlook == 2)
					{
						self.whatlook = 0;
						self positioner("allies2");
					}

					break;

				case "mp_dawnville":
					if(self.whatlook == 0)
					{
						self.whatlook = 1;
						self positioner("axis");
					}
					else if (self.whatlook == 1)
					{
						self.whatlook = 0;
						self positioner("allies");
					}

					break;

				case "mp_carentan":
					if(self.whatlook == 0)
					{
						self.whatlook = 1;
						self positioner("axis");
					}
					else if (self.whatlook == 1)
					{
						self.whatlook = 0;
						self positioner("allies");
					}

					break;

				case "mp_matmata":
					if(self.whatlook == 0)
					{
						self.whatlook = 1;
						self positioner("axis");
					}
					else if (self.whatlook == 1)
					{
						self.whatlook = 2;
						self positioner("allies");
					}
					else if (self.whatlook == 2)
					{
						self.whatlook = 0;
						self positioner("allies2");
					}

					break;
			}
				
			while (self attackbuttonpressed() == true)
				wait 0.5;
		}
		else
			wait 0.1;

		wait 0.1;			
	}
}	

positioner(position)
{
	whatmap = getcvar("mapname");
	switch (whatmap)
	{
		case "mp_toujane":
			if (position == "axis")
			{
				self setorigin((2407.7, 2739.88, 2000.87));
				self setplayerangles((61, 220, 0));
			}
			else if (position == "allies")
			{
				self setorigin((-277.392, 953.164, 2000.87));
				self setplayerangles((60, 10, 0));
			}

			break;

		case "mp_burgundy":
			if (position == "axis")
			{
				self setorigin((-1121.01, 2835.8, 1005)); 
				self setplayerangles((45, 320, 0)); 
			}
			else if (position == "allies")
			{
				self setorigin((-489, -513.148, 1005)); 
				self setplayerangles((30, 60, 0));
			}
			else if (position == "allies2")
			{
				self setorigin((1559.52, 2539.04, 1005));
				self setplayerangles((55, 230, 0));
			}
		
			break;
		
		case "mp_dawnville":
			if (position == "axis")
			{
				self setorigin((-763.631, -18238.8, 1516));
				self setplayerangles((50, 70, 0));
			}
			else if (position == "allies")
			{
				self setorigin((438.132, -14404.1, 1516.25));
				self setplayerangles((50, 285, 0));
			}

			break;

		case "mp_carentan":
			if (position == "axis")
			{
				self setorigin((-1033.63, 501.095, 2285));
				self setplayerangles((57, 23, 0));	
			}
			else if (position == "allies")
			{
				self setorigin((1993.14, 3016.27, 2285));
				self setplayerangles((55, 220, 0));
			}

			break;

		case "mp_matmata":
			if (position == "axis")
			{
				self setorigin((2293.83, 6968.72, 1195));
				self setplayerangles((45, 340, 0));
			}
			else if (position == "allies")
			{
				self setorigin((4538.57, 4252.3, 1195));
				self setplayerangles((45, 100, 0));
			}
			else if (position == "allies2")
			{
				self setorigin((5315.15, 8369.2, 1195));
				self setplayerangles((45, 250, 0));
			}
		
			break;
	}
}
*/