Init()
{
	if (getcvar("scr_spec_limit") == "" || getcvarint("scr_spec_limit") < 0)
		setcvar("scr_spec_limit", 0);
	level.spec_timer = getcvarint("scr_spec_limit");

	level thread onPlayerConnect();
 }

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		if (!isDefined(player.pers["Spec_Time"]) )
			player.pers["Spec_Time"] = level.spec_timer;

		player thread onPlayerSpawned();
		player thread onJoinedSpectators();
		player thread onJoinedTeam();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self notify("stop_spec_monitor");
		self.pers["Spec_Time"] = level.spec_timer;
	}
}

onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self notify("stop_spec_monitor");
		self.pers["Spec_Time"] = level.spec_timer;
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");

		wait level.fps_multiplier * .1;

		if (level.spec_timer)
			self thread SPEC_Monitor();
	}
}

SPEC_Monitor()
{
	self endon("disconnect");
	self endon("stop_spec_monitor");

	level.spec_timer = getcvarint("scr_spec_limit");
	if (level.spec_timer < 0)
		level.spec_timer = 0;

	if (level.spec_timer > 0 && level.spec_timer < 60)
		level.spec_timer = 60;

	if (level.spec_timer == 0)
		return;

	while (self.pers["team"] == "spectator")
	{
		wait level.fps_multiplier * 1;

		if (self.pers["team"] == "spectator")
			self.pers["Spec_Time"]--;

		if (self.pers["Spec_Time"] < 1)
		{
			self thread deal_with_me();
			return;
		}

		if (self.pers["Spec_Time"] == 30)
		{
			self iprintlnbold("^3Warning, this server does not allow Spectator camping.");
			self iprintlnbold("^3Soon your game will be removed from the server.");
		}
	}

	self.pers["Spec_Time"] = level.spec_timer;
}

deal_with_me()
{
	self endon("disconnect");

	userid = self getEntityNumber();
	iprintln("^3Admin: Kicking ^7" + self.name + " ^3for ^1sitting in Spec too long");
	wait level.fps_multiplier * 2;
	kick(userid);
}