DVAR_Enforcer_Init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onJoinedSpectators();
		player thread onPlayerKilled();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self notify("stop_enforcement");
	}
}

onPlayerKilled()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("killed_player");
		self notify("stop_enforcement");
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self thread Start_Enforcer();
	}
}

Start_Enforcer()
{
	self endon("disconnect");
	self endon("killed_player");
	self endon("stop_enforcement");

	wait level.fps_multiplier * 4; // Wait a while after they spawned to help minimize the number of commands being flooded into the client
	if ( getcvar("g_gametype") == "sd")
		wait level.fps_multiplier * 3; //wait LONGER for the S&D spawn

	// Every Half-Second Loop
	timer_slow = 7;
	timer_fast = 2;
	while (1)
	{
		if (timer_slow == 7)
		{
			timer_slow = 0;
			self thread Slow_Enforce();
		}

		if (timer_fast == 2)
		{
			timer_fast = 0;
			self thread Fast_Enforce();
		}

		wait level.fps_multiplier * 0.5;
		timer_slow = timer_slow + .5;
		timer_fast = timer_fast + .5;
	}
}


Slow_Enforce()
{
	self endon("disconnect");
	self endon("killed_player");

	if (getcvar("de_allow_mantlehint") != "" && getcvarint("de_allow_mantlehint") == 0)
	{
		self setClientCvar("cg_drawmantlehint", 0);
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_allow_turret_crosshair") != "" && getcvarint("de_allow_turret_crosshair") == 0)
	{
		self setClientCvar("cg_drawturretcrosshair", 0);
		wait level.fps_multiplier * 0.1;
	}
	else
	{
		self setClientCvar("cg_drawturretcrosshair", 1);
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_allow_hudstance") != "" && getcvarint("de_allow_hudstance") == 0)
	{
		self setClientCvar("hud_fade_stance", .05);
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_Sound_Ping_QuickFade") != "" && getcvarint("de_Sound_Ping_QuickFade") > 0)
	{
		self setClientCvar("cg_hudCompassSoundPingFadeTime", 0);
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_allow_crosshairnames") != "" && getcvarint("de_allow_crosshairnames") == 0)
	{
		self setClientCvar("cg_drawcrosshairnames", 0);
		wait level.fps_multiplier * 0.1;
	}
	else
	{
		self setClientCvar("cg_drawcrosshairnames", 1);
		wait level.fps_multiplier * 0.1;
	}
}

Fast_Enforce()
{
	self endon("disconnect");
	self endon("killed_player");

	if (getcvar("de_force_rate") != "" && getcvarint("de_force_rate") > 999 && getcvarint("de_force_rate") < 25001)
	{
		self setClientCvar("rate", getcvarint("de_force_rate"));
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_force_packets") != "" && getcvarint("de_force_packets") > 59 && getcvarint("de_force_packets") < 101)
	{
		self setClientCvar("cl_maxpackets", getcvarint("de_force_packets"));
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_force_snaps") != "" && getcvarint("de_force_snaps") > 0 && getcvarint("de_force_snaps") < 31)
	{
		self setClientCvar("snaps", getcvarint("de_force_snaps"));
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_allow_crosshair") != "" && getcvarint("de_allow_crosshair") == 0)
	{
		self setClientCvar("cg_drawcrosshair", 0);
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_remove_exploits") != "" && getcvarint("de_remove_exploits") != 0)
	{
		self setClientCvar("r_lighttweakambient", 0);
		wait level.fps_multiplier * 0.1;

		self setClientCvar("r_lodscale", 1);
		wait level.fps_multiplier * 0.1;

		self setClientCvar("mss_Q3fs", 1);
		wait level.fps_multiplier * 0.1;

		self setClientCvar("fx_sort", 1);
		wait level.fps_multiplier * 0.1;
	}

	if (getcvar("de_stock_polygonOffset") != "" && getcvarint("de_stock_polygonOffset") != 0)
	{
		self setClientCvar("r_polygonOffsetBias", "-1");
		wait level.fps_multiplier * 0.1;

		self setClientCvar("r_polygonOffsetScale", "-1");
		wait level.fps_multiplier * 0.1;
	}
}