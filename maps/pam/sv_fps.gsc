Setup_sv_fps()
{
	Get_Mult_Settings();
	level thread Test_frames();
	
	level thread Monitor_FPS();
}


Monitor_FPS()
{
	old_fps = getcvarint("sv_fps");

	while (1)
	{
		wait .25;

		fps = getcvarint("sv_fps");

		if (fps != old_fps)
		{
			if (fps == 20 || fps == 25 || fps == 30)
			{
				iprintln("^1zPAM: ^3DVAR change detected: ^2sv_fps ^3--> ^2" + fps);
				Get_Mult_Settings();
				old_fps = getcvarint("sv_fps");
				thread Update_Client_Snaps();
			}
			else
			{
				setcvar("sv_fps", old_fps);
			}
		}

		if (getcvarint("pam_enable_serverbot") == 1 && game["serverbot_enabled"] == 0)
		{
			game["serverbot_enabled"] = 1;
			thread maps\mp\gametypes\_serverbot::serverbot();
		}
	}
}

Update_Client_Snaps(snaps)
{
	new_snaps = getcvarint("sv_fps");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] setClientCvar("snaps", new_snaps);
}

Get_Mult_Settings()
{
	if (getcvarint("sv_fps") == 30)
	{
		level.fps_multiplier = 1.51382;
		level.frame = .033;
	}
	else if (getcvarint("sv_fps") == 25)
	{
		level.fps_multiplier = 1.26110;
		level.frame = .039;
	}
	else
	{
		level.fps_multiplier = 1.0;
		level.frame = .05;
		setcvar("sv_fps", "20");
	}
}


Test_frames()
{
	level.running = 0;
	count = 0;
	timer = 0;
	active = 1;

	while (!level.running)
		wait .01;

	while (active)
	{
		if (level.running)
		{
			count = count + 1;
			timer = timer + 1;
		}

		if (timer == 100)
		{
			iprintln("Current Count: " + count);
			timer = 0;
		}

		if (!level.running)
		{
			iprintln("Total Count: " + count);
			active = 0;
		}

		wait .01;
	}
}