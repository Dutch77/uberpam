Init()
{
	if (getcvar("scr_afk_limit") == "" || getcvarint("scr_afk_limit") < 0)
		setcvar("scr_afk_limit", 0);
	level.afk_timer = getcvarint("scr_afk_limit");

	level thread onPlayerConnect();
 }

 onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onJoinedSpectators();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self notify("stop_afk_monitor");

		level.afk_timer = getcvarint("scr_afk_limit");
		if (level.afk_timer < 0)
			level.afk_timer = 0;

		wait level.fps_multiplier * .1;

		if (level.afk_timer)
			self thread AFK_Monitor();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self notify("stop_afk_monitor");
	}
}

AFK_Monitor()
{
	self endon("disconnect");
	self endon("killed_player");
	self endon("stop_afk_monitor");

	level.afk_timer = getcvarint("scr_afk_limit");
	if (level.afk_timer < 0)
		level.afk_timer = 0;

	if (level.afk_timer == 0)
		return;

	old_origin = self.origin;
	afk_limit = level.afk_timer * 2;
	afk_time = 0;

	while (1)
	{
		wait level.fps_multiplier * 0.5;

		if (self.sessionstate != "playing" || 
			(isDefined(self.healing) && self.healing) || 
			(isDefined(self.beinghealed) && self.beinghealed ) ||
			(isDefined(self.bomb_interraction) && self.bomb_interraction ) )

		{
			afk_time = 0;
			wait level.fps_multiplier * 5;
			continue;
		}

		new_origin = self.origin;

		if (old_origin == new_origin)
			afk_time++;
		else
		{
			old_origin = new_origin;
			afk_time = 0;
			continue;
		}

		if (afk_time >= afk_limit)
		{
			thisPlayerNum = self getEntityNumber();
			setcvar("g_switchspec", thisPlayerNum);
			self iprintlnbold("^3You were moved to Spec for being AFK");
			return;
		}
		if (afk_time == afk_limit - 20)
		{
			self iprintlnbold("^3Warning, you seem to be AFK due to lack of movement");
			self iprintlnbold("^3Soon you will be moved into Spec if you don't start moving");
		}
	}
}