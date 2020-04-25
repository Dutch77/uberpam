forcedownload()
{
	self endon("disconnect");
	
	mode = getcvar("pam_mode");
	
	gametype = getcvar("g_gametype");

	if ((mode == "cg_rifle" || mode == "pub_rifle") && gametype != "strat")
	{
		if(!isdefined(self.pers["dlchecked"]) || (isdefined(self.pers["dlchecked"]) && self.pers["dlchecked"] != 1))
			self do_forcedownload();
	}
}

do_forcedownload()
{
	self endon("disconnect");	

	for(;;)
	{		
		if (self.pers["downloadedmod"] == 0) 
		{
			if (!isdefined(self.forcedownload) || !isdefined(self.forcedownloadm1) || !isdefined(self.forcedownloadm2))
			{
				self.forcedownload = newClientHudElem(self);
				self.forcedownload.horzAlign = "fullscreen";
				self.forcedownload.vertAlign = "fullscreen";
				self.forcedownload.alignx = "left";
				self.forcedownload.aligny = "top";
				self.forcedownload.alpha = 1;
				self.forcedownload.sort = -3;
				self.forcedownload.foreground = true;
				self.forcedownload setShader("black", 640, 480);
			
				self.forcedownloadm1 = newClientHudElem(self);
				self.forcedownloadm1.alignx = "center";
				self.forcedownloadm1.aligny = "top";
				self.forcedownloadm1.x = 320;
				self.forcedownloadm1.y = 223;
				self.forcedownloadm1.fontscale = 1.3;
				self.forcedownloadm1.alpha = 1;
				self.forcedownloadm1.sort = -2;
				self.forcedownloadm1.foreground = true;
				self.forcedownloadm1 SetText(game["warning_dl2"]);
	
				self.forcedownloadm2 = newClientHudElem(self);
				self.forcedownloadm2.alignx = "center";
				self.forcedownloadm2.aligny = "top";
				self.forcedownloadm2.x = 320;
				self.forcedownloadm2.y = 239;
				self.forcedownloadm2.fontscale = 1.3;
				self.forcedownloadm2.alpha = 1;
				self.forcedownloadm2.sort = -1;
				self.forcedownloadm2.foreground = true;
				self.forcedownloadm2 SetText(game["warning_dl1"]);
			
				self thread spectating();

				wait level.fps_multiplier * 1;
		
				if (self.pers["downloadedmod"] == 0)
					self closemenu();
				else if (self.pers["downloadedmod"] == 1)
				{	
					self.forcedownload destroy();
					self.forcedownloadm1 destroy();
					self.forcedownloadm2 destroy();
					
					self.pers["dlchecked"] = 1;

					self maps\mp\gametypes\_spectating::setSpectatePermissions();
	
					return;
				}

				wait level.fps_multiplier * 1.5;
			}
		}
		else if (self.pers["downloadedmod"] == 1)
		{
			if (isdefined(self.forcedownload) || isdefined(self.forcedownloadm1) || isdefined(self.forcedownloadm2))
			{
				self.forcedownload destroy();
				self.forcedownloadm1 destroy();
				self.forcedownloadm2 destroy();
			}
			
			self.pers["dlchecked"] = 1;

			self maps\mp\gametypes\_spectating::setSpectatePermissions();
	
			return;
		}
	wait 0.1;
	}
}

spectating()
{
	self endon("disconnect");

	while(self.pers["dlchecked"] != 1)
	{
		self allowSpectateTeam("allies", false);
		self allowSpectateTeam("axis", false);
		self allowSpectateTeam("freelook", false);
		self allowSpectateTeam("none", false);
	
		wait 0.1;
	}

	self maps\mp\gametypes\_spectating::setSpectatePermissions();
}