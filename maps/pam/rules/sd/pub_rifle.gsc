Rules()
{
	// Match Style
	//setcvar("scr_sd_timelimit", 0);
	//setcvar("scr_sd_half_round", 10);
	//setcvar("scr_sd_half_score", 0);
	//setcvar("scr_sd_end_round", 20);
	//setcvar("scr_sd_end_score", 0);
	//setcvar("scr_sd_end_half2score", 0);
	// Halftime auto-ready
	//setcvar("g_halftime_ready", 0); // 0 = disabled

	//setcvar("scr_sd_roundlength", 2);
	//setcvar("scr_sd_graceperiod", 3);
	//setcvar("scr_sd_strat_time", 1);
	//setcvar("scr_sd_count_draws", 1);

	/*// Are there OT Rules?
	//setcvar("g_ot", 0);
	
	// Time-out
	//setcvar("g_to", 2);
	//setcvar("g_to_length", 5);
	//setcvar("g_to_side", 1);*/


	// Bomb Timers
	//setcvar("scr_sd_bombtimer", 60);
	//setcvar("scr_sd_PlantTime", 5);
	//setcvar("scr_sd_DefuseTime", 10);

	// Smokefuse

	setcvar("smoke_fuse", 1);


	/*// Between Round/Half Timers
	setcvar("g_matchwarmuptime", 8);
	setcvar("g_roundwarmuptime", 3);*/


	// Hud Options
	setcvar("sv_playersleft", 1);
	setcvar("scr_show_healthbar", 0);
	setcvar("scr_fade_healthbar", 0); //Only works when using the healthbar obviously
	setcvar("scr_show_death_icons", 0);
	setcvar("scr_show_objective_icons", 0);
	setcvar("scr_allow_hitblip", 1);
	setcvar("scr_show_grenade_icon", 1);
	setcvar("scr_allow_hud_scoreboard", 1); //The stock one up in the upper left corner...
	setcvar("scr_showscorelimit", 1);
	setcvar("scr_show_bombtimer", 1);
	//Clock Position
	setcvar("scr_clock_position", 1); // 0 = stock position, 1 = CoD1 position


	// Health Regen & Delay
	setcvar("scr_allow_health_regen", 1); // 0= no regen, 1 is stock, and there are other options too
	setcvar("scr_regen_delay", 5000); //Time before regen starts
	setcvar("scr_allow_healthpacks", 0);

	// Scoring options
	//setcvar("scr_sd_plant_points", 0);
	//setcvar("scr_sd_defuse_points", 0);


	// Force Bolt-Action Rifles
	setcvar("scr_force_boltaction", 0);

	// Nade Spawn Counts
	//setcvar("scr_boltaction_nades", 1);
	setcvar("scr_semiautomatic_nades", 0);
	setcvar("scr_smg_nades", 0);
	//setcvar("scr_sniper_nades", 0);
	setcvar("scr_mg_nades", 0);
	setcvar("scr_shotgun_nades", 0);

	// Smoke Spawn Counts
	setcvar("scr_boltaction_smokes", 0);
	setcvar("scr_semiautomatic_smokes", 0);
	setcvar("scr_smg_smokes", 0);
	setcvar("scr_sniper_smokes", 0);
	setcvar("scr_mg_smokes", 0);
	setcvar("scr_shotgun_smokes", 0);

	// Allow Weapon Drops
	setcvar("scr_allow_weapondrop_nade", 1);
	setcvar("scr_allow_weapondrop_sniper", 0);
	setcvar("scr_allow_weapondrop_shotgun", 0);

	// Secondary Weapon Drop
	setcvar("scr_allow_secondary_drop", 1);

	// Weapon Limits by class per team
	setcvar("scr_boltaction_limit", 99);
	//setcvar("scr_sniper_limit", 2);
	setcvar("scr_semiautomatic_limit", 0);
	setcvar("scr_smg_limit", 0);
	setcvar("scr_mg_limit", 0);
	setcvar("scr_shotgun_limit", 0);

	// Allow/Disallow Weapons
	setcvar("scr_allow_greasegun", 0);
	setcvar("scr_allow_m1carbine", 0);
	setcvar("scr_allow_m1garand", 0);
	setcvar("scr_allow_springfield", 0);
	setcvar("scr_allow_thompson", 0);
	setcvar("scr_allow_bar", 0);
	setcvar("scr_allow_sten", 0);
	//setcvar("scr_allow_enfield", 1);
	setcvar("scr_allow_enfieldsniper", 0);
	setcvar("scr_allow_bren", 0);
	setcvar("scr_allow_pps42", 0);
	//setcvar("scr_allow_nagant", 1);
	setcvar("scr_allow_svt40", 0);
	setcvar("scr_allow_nagantsniper", 0);
	setcvar("scr_allow_ppsh", 0);
	setcvar("scr_allow_mp40", 0);
	//setcvar("scr_allow_kar98k", 1);
	setcvar("scr_allow_g43", 0);
	setcvar("scr_allow_kar98ksniper", 0);
	setcvar("scr_allow_mp44", 0);
	setcvar("scr_allow_shotgun", 0);
	setcvar("scr_allow_fraggrenades", 1);
	setcvar("scr_allow_smokegrenades", 0);
	//setcvar("scr_allow_pistols", 1);
	setcvar("scr_allow_turrets", 0);

	//setcvar("scr_allow_enfieldsniper_allies", 0);
	//setcvar("scr_allow_enfieldsniper_axis", 0);
	//setcvar("scr_allow_nagantsniper_allies", 0);
	//setcvar("scr_allow_nagantsniper_axis", 0);
	//setcvar("scr_allow_springfield_axis", 0);
	//setcvar("scr_allow_springfield_allies", 0);
	//setcvar("scr_allow_kar98ksniper_axis", 1);
	//setcvar("scr_allow_kar98ksniper_allies", 1);

	// Single Shot Kills
	setcvar("scr_no_oneshot_pistol_kills", 0); 
	setcvar("scr_no_oneshot_ppsh_kills", 0);

	// PPSH Balance - Limits range of PPSH to same as Tommy
	setcvar("scr_balance_ppsh_distance", 0);

	//ShellShock
	setcvar("scr_allow_shellshock", 0);


	// Fall Damage
	setcvar("scr_fallDamageMinHeight", 21);
	setcvar("scr_fallDamageMaxHeight", 40);


	// DVAR Enforcer
	//setcvar("de_force_rate", 0);
	setcvar("de_remove_exploits", 1);
	setcvar("de_stock_polygonOffset", 0);
	setcvar("de_allow_enemycrosshaircolor", 0);
	setcvar("de_Sound_Ping_QuickFade", 1);
	setcvar("de_allow_mantlehint", 1);
	setcvar("de_allow_crosshair", 1);
	setcvar("de_allow_turret_crosshair", 1);
	setcvar("de_allow_crosshairnames", 1);
	setcvar("de_allow_hudstance", 1);

	// Ambients
	setcvar("scr_allow_ambient_fog", 0);
	setcvar("scr_allow_ambient_sounds", 0);
	setcvar("scr_allow_ambient_fire", 0);
	setcvar("scr_allow_ambient_weather", 0);

	// Kill Triggers
	setcvar("scr_remove_killtriggers", 1);


	// Not Likely to Change
	/*setcvar("sv_pure", 1);
	setcvar("g_speed", 190);
	setcvar("g_antilag", 0);
	setcvar("g_allowvote", 0);
	setcvar("scr_friendlyfire", 0);
	setcvar("scr_drawfriend", 1);
	setcvar("scr_teambalance", 1);
	setcvar("scr_killcam", 0);
	setcvar("scr_spectatefree", 0);
	setcvar("scr_spectateenemy", 0);
	setcvar("sv_minping", 0);
	setcvar("sv_maxping", 0);
	setcvar("sv_floodProtect", 1);
	setcvar("sv_voice", 0);
	setcvar("sv_cheats", 0);
	setcvar("g_weaponAmmoPools", 0);*/
	setcvar("logfile", 1);
	//setcvar("sv_fps", 30);

	// DO NOT MODIFY BELOW THIS LINE!
	game["leaguestring"] = &"S&D Rifle Public Mode";
	game["mode"] = "pub";
}