Init()
{
	if (level.hud_flagstatus)
		level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onJoinedTeam();
		player thread onPlayerSpawned();
		player thread onJoinedSpectators();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");

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
		
		self Kill_Existing_Display();
		wait level.frame;

		self thread Setup_Player_Display();
	}
}

Kill_Existing_Display()
{
	self notify("stop_flag_scanning");

	if (isDefined(self.myflag) )
		self.myflag destroy();
	if (isDefined(self.myflag_status) )
		self.myflag_status destroy();

	if (isDefined(self.enemyflag) )
		self.enemyflag destroy();
	if (isDefined(self.enemyflag_status) )
		self.enemyflag_status destroy();
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

	self endon("disconnect");
	self endon("stop_flag_scanning");

	if (self.pers["team"] == "axis" || self.pers["team"] == "spectator")
	{
		myflag = level.hudflag_axis;
		myflag_ent = getent("axis_flag", "targetname");
		otherflag = level.hudflag_allies;
		enemyflag_ent = getent("allied_flag", "targetname");
	}
	else
	{
		myflag = level.hudflag_allies;
		myflag_ent = getent("allied_flag", "targetname");
		otherflag = level.hudflag_axis;
		enemyflag_ent = getent("axis_flag", "targetname");
	}

	if (!isDefined(myflag_ent.status) || !isDefined(enemyflag_ent.status) )
	{
		myflag_ent.status = "home";
		enemyflag_ent.status = "home";
	}

	// My Flag Icon
	self.myflag = newClientHudElem(self);
	self.myflag.x = 280;
	self.myflag.y = 442;
	self.myflag.alignX = "right";
	self.myflag.alignY = "top";
	self.myflag.alpha = 1;
	self.myflag.sort = 2;
	self.myflag setShader(myflag, 40, 40);

	// My Status Indication
	self.myflag_status =  newClientHudElem(self);
	self.myflag_status.x = 279; //280
	self.myflag_status.y = 447; //446
	self.myflag_status.alignX = "right";
	self.myflag_status.alignY = "top";
	self.myflag_status.alpha = .85;
	self.myflag_status.sort = 1;
	self.myflag_status setShader("white", 38, 27); //40, 30

	// Enemy Flag Icon
	self.enemyflag =  newClientHudElem(self);
	self.enemyflag.x = 360;
	self.enemyflag.y = 442;
	self.enemyflag.alignX = "left";
	self.enemyflag.alignY = "top";
	self.enemyflag.alpha = 1;
	self.enemyflag.sort = 2;
	self.enemyflag setShader(otherflag, 40, 40);

	// Enemy Status Indication
	self.enemyflag_status =  newClientHudElem(self);
	self.enemyflag_status.x = 361; //360
	self.enemyflag_status.y = 447; //446
	self.enemyflag_status.alignX = "left";
	self.enemyflag_status.alignY = "top";
	self.enemyflag_status.alpha = .85;
	self.enemyflag_status.sort = 1;
	self.enemyflag_status setShader("white", 38, 27); //40, 30

	while(1)
	{
		mycolor = (0,1,0.251);

		if (myflag_ent.status == "stolen")
			mycolor = (1,0,0);
		else if (myflag_ent.status == "dropped")
			mycolor = (1,1,0.5);

		enemycolor = (0,1,0.251);

		if (enemyflag_ent.status == "stolen")
			enemycolor = (1,0,0);
		else if (enemyflag_ent.status == "dropped")
			enemycolor = (1,1,0.5);

		self.myflag_status.color = mycolor;
		self.enemyflag_status.color = enemycolor;

		wait level.fps_multiplier * .25;
	}
}