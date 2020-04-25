main()
{
	//maps\pam\pam_setup::main();

	maps\mp\mp_harbor_fx::main();
	maps\mp\_load::main();

	

	thread Ambient_Sound();
	
	mode = getcvar("pam_mode");
	
	if(mode == "bash" || mode == "cg" || mode == "cg_1v1" || mode == "cg_2v2" || mode == "cg_mr3" || mode == "cg_mr10" || mode == "cg_mr12" || mode == "cg_rifle" || mode == "cg_rush" || mode == "mr3" || mode == "mr10" || mode == "mr12" || mode == "mr15")
	{
		game["allies"] = "british";
		game["axis"] = "german";
		game["attackers"] = "allies";
		game["defenders"] = "axis";
		game["british_soldiertype"] = "normandy";
		game["german_soldiertype"] = "winterlight";
	}
	else
	{
		game["allies"] = "russian";
		game["axis"] = "german";
		game["attackers"] = "allies";
		game["defenders"] = "axis";
		game["russian_soldiertype"] = "padded";
		game["german_soldiertype"] = "winterlight";
	}

	setcvar("r_glowbloomintensity0","1");
	setcvar("r_glowbloomintensity1","1");
	setcvar("r_glowskybleedintensity0",".5");

	if((getcvar("g_gametype") == "hq"))
	{
		level.radio = [];
		level.radio[0] = spawn("script_model", (-6960.68, -7405.43, -3.61082));
		level.radio[0].angles = (4.40472, 76.0809, -0.520537);		
		
		level.radio[1] = spawn("script_model", (-8388.52, -7920.24, 9.02138));
		level.radio[1].angles = (0, 330, 0);
		
		level.radio[2] = spawn("script_model", (-9787.16, -8687.53, 8.00002));
		level.radio[2].angles = (0, 345.2, 0);
		
		level.radio[3] = spawn("script_model", (-11576.8, -7591.59, 15.243));
		level.radio[3].angles = (358.462, 30.004, -0.146589);

		level.radio[4] = spawn("script_model", (-9204.64, -6806.99, 0.224747));
		level.radio[4].angles = (1.75818, 15.035, 0.94779);

		level.radio[5] = spawn("script_model", (-8521.13, -8747.75, 0));
		level.radio[5].angles = (0, 345.035, 0);
			
	}

	
	maps\pam\maps::harbor();
}

Ambient_Sound()
{
	while (!isdefined(game["ambient_weather"]))
	{
		wait 0.1;
	}

	if ( game["ambient_sounds"] )
		ambientPlay("ambient_russia");
	
	if ( game["ambient_fog"] )
		setExpFog(0.00028, .58, .57, .57, 0);
}