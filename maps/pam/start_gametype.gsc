Init()
{
	level.xenon = false;
	level.pam_hud = maps\pam\hud_elements::Hud_Elem;
	level.pam_changed = maps\pam\pam_server_settings::Dvar_Changed;

	level.pam_mode_change = false;
	level.mapname = getcvar("mapname");
	level.gametype = getcvar("g_gametype");
	level.exiting_map = false;

	// HTTP Redirect
	/*setcvar("sv_allowdownload", 0);
	setcvar("sv_wwwdownload", 1);
	stranica = "http://godfather-clan.com/zPAM/mod";
	setcvar("sv_wwwbaseurl", stranica);
	setcvar("sv_wwwdldisconnected", 0);*/	
	
	[[level.setdvar]]("g_ot", 0, 0);
	[[level.setdvar]]("g_ot_active", 0, 0);
	[[level.setdvar]]("pam_mode", "pub");

	level.intimeout = 0;

	if (!isdefined(game["clockfirstrup"]))
		game["clockfirstrup"] = 0;

	if(!isdefined(game["gamestarted"]))
	{
		if(!isDefined(game["mode"]))
			game["mode"] = "match";

		[[level.setdvar]]("sv_pure", 1, 0, 1);

		game["ruleset"] = getCvar("pam_mode");

		switch (level.gametype)
		{
		case "sd":
			maps\pam\rules\sd_rulesets::Get_SD_Rules(); break;
		case "hq":
			maps\pam\rules\hq_rulesets::Get_HQ_Rules(); break;
		case "ctf":
			maps\pam\rules\ctf_rulesets::Get_CTF_Rules(); break;
		case "tdm":
			maps\pam\rules\tdm_rulesets::Get_TDM_Rules(); break;
		case "dm":
			maps\pam\rules\dm_rulesets::Get_DM_Rules(); break;
		}

		// Set up all the PAM Precache Goodies!
		maps\pam\precache::Precache();
		//maps\pam\messagecenter::Precache_MessageCenter_HUD();

		setcvar("utimeu", 0);
		setcvar("bombplented2", 0);
		setcvar("halfooo", 0);
		setcvar("isstrattime2", 0);
		setcvar("matchstartingy", 0);
		setcvar("endround3d", 0);

		game["dolive"] = 0;
		game["halftimeflag"] = 0;
		game["alliedscore"] = 0;
		game["axisscore"] = 0;
		game["half_1_allies_score"] = 0;
		game["half_1_axis_score"] = 0; 
		game["half_2_allies_score"] = 0;
		game["half_2_axis_score"] = 0;
		game["Team_1_Score"] = 0;
		game["Team_2_Score"] = 0;

		game["allies_tos"] = 0;
		game["axis_tos"] = 0;
		game["allies_tos_half"] = 0;
		game["axis_tos_half"] = 0;

		game["roundsplayed"] = 0;
		game["Do_Ready_up"] = 0;

		game["serverbot_enabled"] = 0;

		// zPAM
		pers["downloadedmod"] = 0;
		pers["beenspec"] = 0;
		pers["beenspecforonce"] = 0;
		pers["was_spectator_once"] = 0;
		pers["became_spectator_once"] = 0;
		pers["specmenuopened"] = 0;
		pers["hqstoper"] = 0;
		pers["stoppedat"] = 0;
		pers["playerdefuses"] = 0;
		pers["dlchecked"] = 0; //add

		self.pers["downloadedmod"] = 0;		
		self.pers["became_spectator_once"] = 0;
		self.pers["was_spectator_once"] = 0;
		self.pers["beenspec"] = 0;
		self.pers["beenspecforonce"] = 0;
		self.pers["specmenuopened"] = 0;
		self.pers["hqstoper"] = 0;
		self.pers["stoppedat"] = 0;
		self.pers["playerdefuses"] = 0;
		self.pers["dlchecked"] = 0; //add

		game["waiterspawn"] = 0;
		game["teamcalledto"] = "default";	
		game["timesto"] = 0;
		game["timestoc"] = 0;
		game["plantton"] = 0;
		game["defannono"] = 0;
		game["killonja"] = 0;
		game["timowo"] = 0;

		usedgt = 0;
		usedgt2 = 0;
		fdl = 0;
		
		self.usedgt = 0;
		self.usedgt2 = 0;
		self.fdl = 0;

		level.limitingentered = 0;
		level.al_sniplimited = 0;
		level.ax_sniplimited = 0;
 		level.roundended_dc = 0;

		serverbot_start_cfg = "serverbotstart.cfg";
		setcvar("exec", serverbot_start_cfg);
	}

		
	// Menu precache
	game["menu_rec_win"] = "record_response";
	precacheMenu(game["menu_rec_win"]);
	
	game["rec_menu"] = "record";
	precacheMenu(game["rec_menu"]);

	// sv_fps
	maps\pam\sv_fps::Setup_sv_fps();
	
	if (getcvar("scr_allow_ambient_sounds") != "" && getcvarint("scr_allow_ambient_sounds") == 0)
		game["ambient_sounds"] = false;
	else
		game["ambient_sounds"] = true;

	if (getcvar("scr_allow_ambient_fire") != "" && getcvarint("scr_allow_ambient_fire") == 0)
		game["ambient_fire"] = false;
	else
		game["ambient_fire"] = true;

	if (getcvar("scr_allow_ambient_weather") != "" && getcvarint("scr_allow_ambient_weather") == 0)
		game["ambient_weather"] = false;
	else
		game["ambient_weather"] = true;

	if (getcvar("scr_allow_ambient_fog") != "" && getcvarint("scr_allow_ambient_fog") == 0)
		game["ambient_fog"] = false;
	else
		game["ambient_fog"] = true;

	// Match Start Setup
	if (!isDefined(game["matchstarted"]))
		game["matchstarted"] = false;

	// Gametype Specific Settings
	switch (level.gametype)
	{
	case "sd":
		SD_Variables(); break;
	case "hq":
		HQ_Variables(); break;
	case "ctf":
		CTF_Variables(); break;
	case "tdm":
		TDM_Variables(); break;
	case "dm":
		DM_Variables(); break;
	}

	//Stock Stuff
	level.allowvote = getCvar("g_allowvote");
	level.friendlyfire = getCvar("scr_friendlyfire");
	level.drawfriend = getCvarInt("scr_drawfriend");
	level.teambalance = getCvarInt("scr_teambalance");
	level.killcam = getCvarInt("scr_killcam");
	level.spectatefree = getCvarInt("scr_spectatefree");
	level.spectateenemy = getCvarInt("scr_spectateenemy");

	// Between Round/Half Timing
	level.half_start_timer = [[level.setdvar]]("g_matchwarmuptime", 10, 0);
	level.round_start_timer = [[level.setdvar]]("g_roundwarmuptime", 5, 0);

	// Match Styles
	level.allow_tie = getcvarint("g_allowtie");
	level.playersleft = getcvarint("sv_playersleft");

	// Ready-Up
	level.rdyup = 0;
	setcvar("urupuu", 0);

	level.R_U_Name = [];
	level.R_U_State = [];
	level.playersready = false;

	level.warmup = 0;
	setcvar("uwup", 0);
	level.hithalftime = 0;

	//////////////////////////
	// Weapons & Limits
	//////////////////////////
	level.weaponnames = [];
	level.weaponnames[0] = "greasegun_mp";
	level.weaponnames[1] = "m1carbine_mp";
	level.weaponnames[2] = "m1garand_mp";
	level.weaponnames[3] = "springfield_mp";
	level.weaponnames[4] = "thompson_mp";
	level.weaponnames[5] = "bar_mp";
	level.weaponnames[6] = "sten_mp";
	level.weaponnames[7] = "enfield_mp";
	level.weaponnames[8] = "enfield_scope_mp";
	level.weaponnames[9] = "bren_mp";
	level.weaponnames[10] = "PPS42_mp";
	level.weaponnames[11] = "mosin_nagant_mp";
	level.weaponnames[12] = "SVT40_mp";
	level.weaponnames[13] = "mosin_nagant_sniper_mp";
	level.weaponnames[14] = "ppsh_mp";
	level.weaponnames[15] = "mp40_mp";
	level.weaponnames[16] = "kar98k_mp";
	level.weaponnames[17] = "g43_mp";
	level.weaponnames[18] = "kar98k_sniper_mp";
	level.weaponnames[19] = "mp44_mp";
	level.weaponnames[20] = "shotgun_mp";
	level.weaponnames[21] = "fraggrenade";
	level.weaponnames[22] = "smokegrenade";
	level.weaponnames[23] = "mosin_nagant_sniper_allies_mp";
	level.weaponnames[24] = "mosin_nagant_sniper_axis_mp";
	level.weaponnames[25] = "springfield_allies_mp";
	level.weaponnames[26] = "springfield_axis_mp";
	level.weaponnames[27] = "kar98k_sniper_axis_mp";
	level.weaponnames[28] = "kar98k_sniper_allies_mp";
	level.weaponnames[29] = "enfield_scope_axis_mp";
	level.weaponnames[30] = "enfield_scope_allies_mp";

	level.weapons = [];
	level.weapons["greasegun_mp"] = spawnstruct();
	level.weapons["greasegun_mp"].server_allowcvar = "scr_allow_greasegun";
	level.weapons["greasegun_mp"].client_allowcvar = "ui_allow_greasegun";
	level.weapons["greasegun_mp"].allow_default = 1;
	level.weapons["greasegun_mp"].classname = "smg";
	level.weapons["greasegun_mp"].team = "allies";

	level.weapons["m1carbine_mp"] = spawnstruct();
	level.weapons["m1carbine_mp"].server_allowcvar = "scr_allow_m1carbine";
	level.weapons["m1carbine_mp"].client_allowcvar = "ui_allow_m1carbine";
	level.weapons["m1carbine_mp"].allow_default = 1;
	level.weapons["m1carbine_mp"].classname = "semiautomatic";
	level.weapons["m1carbine_mp"].team = "allies";

	level.weapons["m1garand_mp"] = spawnstruct();
	level.weapons["m1garand_mp"].server_allowcvar = "scr_allow_m1garand";
	level.weapons["m1garand_mp"].client_allowcvar = "ui_allow_m1garand";
	level.weapons["m1garand_mp"].allow_default = 1;
	level.weapons["m1garand_mp"].classname = "semiautomatic";
	level.weapons["m1garand_mp"].team = "allies";


	level.weapons["springfield_mp"] = spawnstruct();
	level.weapons["springfield_mp"].server_allowcvar = "scr_allow_springfield";
	level.weapons["springfield_mp"].client_allowcvar = "ui_allow_springfield";
	level.weapons["springfield_mp"].allow_default = 1;
	level.weapons["springfield_mp"].classname = "sniper";
	level.weapons["springfield_mp"].team = "allies";

	level.weapons["thompson_mp"] = spawnstruct();
	level.weapons["thompson_mp"].server_allowcvar = "scr_allow_thompson";
	level.weapons["thompson_mp"].client_allowcvar = "ui_allow_thompson";
	level.weapons["thompson_mp"].allow_default = 1;
	level.weapons["thompson_mp"].classname = "smg";
	level.weapons["thompson_mp"].team = "allies";

	level.weapons["bar_mp"] = spawnstruct();
	level.weapons["bar_mp"].server_allowcvar = "scr_allow_bar";
	level.weapons["bar_mp"].client_allowcvar = "ui_allow_bar";
	level.weapons["bar_mp"].allow_default = 1;
	level.weapons["bar_mp"].classname = "mg";
	level.weapons["bar_mp"].team = "allies";

	level.weapons["sten_mp"] = spawnstruct();
	level.weapons["sten_mp"].server_allowcvar = "scr_allow_sten";
	level.weapons["sten_mp"].client_allowcvar = "ui_allow_sten";
	level.weapons["sten_mp"].allow_default = 1;
	level.weapons["sten_mp"].classname = "smg";
	level.weapons["sten_mp"].team = "axis";

	level.weapons["enfield_mp"] = spawnstruct();
	level.weapons["enfield_mp"].server_allowcvar = "scr_allow_enfield";
	level.weapons["enfield_mp"].client_allowcvar = "ui_allow_enfield";
	level.weapons["enfield_mp"].allow_default = 1;
	level.weapons["enfield_mp"].classname = "boltaction";
	level.weapons["enfield_mp"].team = "allies";

	level.weapons["enfield_scope_mp"] = spawnstruct();
	level.weapons["enfield_scope_mp"].server_allowcvar = "scr_allow_enfieldsniper";
	level.weapons["enfield_scope_mp"].client_allowcvar = "ui_allow_enfieldsniper";
	level.weapons["enfield_scope_mp"].allow_default = 1;
	level.weapons["enfield_scope_mp"].classname = "sniper";
	level.weapons["enfield_scope_mp"].team = "allies";

	level.weapons["bren_mp"] = spawnstruct();
	level.weapons["bren_mp"].server_allowcvar = "scr_allow_bren";
	level.weapons["bren_mp"].client_allowcvar = "ui_allow_bren";
	level.weapons["bren_mp"].allow_default = 1;
	level.weapons["bren_mp"].classname = "mg";
	level.weapons["bren_mp"].team = "allies";

	level.weapons["PPS42_mp"] = spawnstruct();
	level.weapons["PPS42_mp"].server_allowcvar = "scr_allow_pps42";
	level.weapons["PPS42_mp"].client_allowcvar = "ui_allow_pps42";
	level.weapons["PPS42_mp"].allow_default = 1;
	level.weapons["PPS42_mp"].classname = "smg";
	level.weapons["PPS42_mp"].team = "allies";

	level.weapons["mosin_nagant_mp"] = spawnstruct();
	level.weapons["mosin_nagant_mp"].server_allowcvar = "scr_allow_nagant";
	level.weapons["mosin_nagant_mp"].client_allowcvar = "ui_allow_nagant";
	level.weapons["mosin_nagant_mp"].allow_default = 1;
	level.weapons["mosin_nagant_mp"].classname = "boltaction";
	level.weapons["mosin_nagant_mp"].team = "allies";

	level.weapons["SVT40_mp"] = spawnstruct();
	level.weapons["SVT40_mp"].server_allowcvar = "scr_allow_svt40";
	level.weapons["SVT40_mp"].client_allowcvar = "ui_allow_svt40";
	level.weapons["SVT40_mp"].allow_default = 1;
	level.weapons["SVT40_mp"].classname = "semiautomatic";
	level.weapons["SVT40_mp"].team = "allies";

	level.weapons["mosin_nagant_sniper_mp"] = spawnstruct();
	level.weapons["mosin_nagant_sniper_mp"].server_allowcvar = "scr_allow_nagantsniper";
	level.weapons["mosin_nagant_sniper_mp"].client_allowcvar = "ui_allow_nagantsniper";
	level.weapons["mosin_nagant_sniper_mp"].allow_default = 1;
	level.weapons["mosin_nagant_sniper_mp"].classname = "sniper";
	level.weapons["mosin_nagant_sniper_mp"].team = "allies";

	level.weapons["ppsh_mp"] = spawnstruct();
	level.weapons["ppsh_mp"].server_allowcvar = "scr_allow_ppsh";
	level.weapons["ppsh_mp"].client_allowcvar = "ui_allow_ppsh";
	level.weapons["ppsh_mp"].allow_default = 1;
	level.weapons["ppsh_mp"].classname = "smg";
	level.weapons["ppsh_mp"].team = "allies";

	level.weapons["mp40_mp"] = spawnstruct();
	level.weapons["mp40_mp"].server_allowcvar = "scr_allow_mp40";
	level.weapons["mp40_mp"].client_allowcvar = "ui_allow_mp40";
	level.weapons["mp40_mp"].allow_default = 1;
	level.weapons["mp40_mp"].classname = "smg";
	level.weapons["mp40_mp"].team = "axis";

	level.weapons["kar98k_mp"] = spawnstruct();
	level.weapons["kar98k_mp"].server_allowcvar = "scr_allow_kar98k";
	level.weapons["kar98k_mp"].client_allowcvar = "ui_allow_kar98k";
	level.weapons["kar98k_mp"].allow_default = 1;
	level.weapons["kar98k_mp"].classname = "boltaction";
	level.weapons["kar98k_mp"].team = "axis";

	level.weapons["g43_mp"] = spawnstruct();
	level.weapons["g43_mp"].server_allowcvar = "scr_allow_g43";
	level.weapons["g43_mp"].client_allowcvar = "ui_allow_g43";
	level.weapons["g43_mp"].allow_default = 1;
	level.weapons["g43_mp"].classname = "semiautomatic";
	level.weapons["g43_mp"].team = "axis";

	level.weapons["kar98k_sniper_mp"] = spawnstruct();
	level.weapons["kar98k_sniper_mp"].server_allowcvar = "scr_allow_kar98ksniper";
	level.weapons["kar98k_sniper_mp"].client_allowcvar = "ui_allow_kar98ksniper";
	level.weapons["kar98k_sniper_mp"].allow_default = 1;
	level.weapons["kar98k_sniper_mp"].classname = "sniper";
	level.weapons["kar98k_sniper_mp"].team = "axis";

	level.weapons["mp44_mp"] = spawnstruct();
	level.weapons["mp44_mp"].server_allowcvar = "scr_allow_mp44";
	level.weapons["mp44_mp"].client_allowcvar = "ui_allow_mp44";
	level.weapons["mp44_mp"].allow_default = 1;
	level.weapons["mp44_mp"].classname = "mg";
	level.weapons["mp44_mp"].team = "axis";

	level.weapons["shotgun_mp"] = spawnstruct();
	level.weapons["shotgun_mp"].server_allowcvar = "scr_allow_shotgun";
	level.weapons["shotgun_mp"].client_allowcvar = "ui_allow_shotgun";
	level.weapons["shotgun_mp"].allow_default = 1;
	level.weapons["shotgun_mp"].classname = "shotgun";
	level.weapons["shotgun_mp"].team = "both";

	level.weapons["fraggrenade"] = spawnstruct();
	level.weapons["fraggrenade"].server_allowcvar = "scr_allow_fraggrenades";
	level.weapons["fraggrenade"].client_allowcvar = "ui_allow_fraggrenades";
	level.weapons["fraggrenade"].allow_default = 1;
	level.weapons["fraggrenade"].classname = "nade";
	level.weapons["fraggrenade"].team = "both";

	level.weapons["smokegrenade"] = spawnstruct();
	level.weapons["smokegrenade"].server_allowcvar = "scr_allow_smokegrenades";
	level.weapons["smokegrenade"].client_allowcvar = "ui_allow_smokegrenades";
	level.weapons["smokegrenade"].allow_default = 1;
	level.weapons["smokegrenade"].classname = "smoke";
	level.weapons["smokegrenade"].team = "both";

	level.weapons["mosin_nagant_sniper_allies_mp"] = spawnstruct();
	level.weapons["mosin_nagant_sniper_allies_mp"].server_allowcvar = "scr_allow_nagantsniper_allies";
	level.weapons["mosin_nagant_sniper_allies_mp"].client_allowcvar = "ui_allow_nagantsniper_allies";
	level.weapons["mosin_nagant_sniper_allies_mp"].allow_default = 1;
	level.weapons["mosin_nagant_sniper_allies_mp"].classname = "sniper";
	level.weapons["mosin_nagant_sniper_allies_mp"].team = "allies";

	level.weapons["mosin_nagant_sniper_axis_mp"] = spawnstruct();
	level.weapons["mosin_nagant_sniper_axis_mp"].server_allowcvar = "scr_allow_nagantsniper_axis";
	level.weapons["mosin_nagant_sniper_axis_mp"].client_allowcvar = "ui_allow_nagantsniper_axis";
	level.weapons["mosin_nagant_sniper_axis_mp"].allow_default = 1;
	level.weapons["mosin_nagant_sniper_axis_mp"].classname = "sniper";
	level.weapons["mosin_nagant_sniper_axis_mp"].team = "axis";

	level.weapons["springfield_allies_mp"] = spawnstruct();
	level.weapons["springfield_allies_mp"].server_allowcvar = "scr_allow_springfield_allies";
	level.weapons["springfield_allies_mp"].client_allowcvar = "ui_allow_springfield_allies";
	level.weapons["springfield_allies_mp"].allow_default = 1;
	level.weapons["springfield_allies_mp"].classname = "sniper";
	level.weapons["springfield_allies_mp"].team = "allies";

	level.weapons["springfield_axis_mp"] = spawnstruct();
	level.weapons["springfield_axis_mp"].server_allowcvar = "scr_allow_springfield_axis";
	level.weapons["springfield_axis_mp"].client_allowcvar = "ui_allow_springfield_axis";
	level.weapons["springfield_axis_mp"].allow_default = 1;
	level.weapons["springfield_axis_mp"].classname = "sniper";
	level.weapons["springfield_axis_mp"].team = "axis";

	level.weapons["kar98k_sniper_axis_mp"] = spawnstruct();
	level.weapons["kar98k_sniper_axis_mp"].server_allowcvar = "scr_allow_kar98ksniper_axis";
	level.weapons["kar98k_sniper_axis_mp"].client_allowcvar = "ui_allow_kar98ksniper_axis";
	level.weapons["kar98k_sniper_axis_mp"].allow_default = 1;
	level.weapons["kar98k_sniper_axis_mp"].classname = "sniper";
	level.weapons["kar98k_sniper_axis_mp"].team = "axis";

	level.weapons["kar98k_sniper_allies_mp"] = spawnstruct();
	level.weapons["kar98k_sniper_allies_mp"].server_allowcvar = "scr_allow_kar98ksniper_allies";
	level.weapons["kar98k_sniper_allies_mp"].client_allowcvar = "ui_allow_kar98ksniper_allies";
	level.weapons["kar98k_sniper_allies_mp"].allow_default = 1;
	level.weapons["kar98k_sniper_allies_mp"].classname = "sniper";
	level.weapons["kar98k_sniper_allies_mp"].team = "allies";

	
	level.weapons["enfield_scope_axis_mp"] = spawnstruct();
	level.weapons["enfield_scope_axis_mp"].server_allowcvar = "scr_allow_enfieldsniper_axis";
	level.weapons["enfield_scope_axis_mp"].client_allowcvar = "ui_allow_enfieldsniper_axis";
	level.weapons["enfield_scope_axis_mp"].allow_default = 1;
	level.weapons["enfield_scope_axis_mp"].classname = "sniper";
	level.weapons["enfield_scope_axis_mp"].team = "axis";


	level.weapons["enfield_scope_allies_mp"] = spawnstruct();
	level.weapons["enfield_scope_allies_mp"].server_allowcvar = "scr_allow_enfieldsniper_allies";
	level.weapons["enfield_scope_allies_mp"].client_allowcvar = "ui_allow_enfieldsniper_allies";
	level.weapons["enfield_scope_allies_mp"].allow_default = 1;
	level.weapons["enfield_scope_allies_mp"].classname = "sniper";
	level.weapons["enfield_scope_allies_mp"].team = "allies";

	level.weapons["colt_mp"] = spawnstruct();
	level.weapons["colt_mp"].classname = "pistol";
	level.weapons["colt_mp"].team = "allies";

	level.weapons["webley_mp"] = spawnstruct();
	level.weapons["webley_mp"].classname = "pistol";
	level.weapons["webley_mp"].team = "allies";

	level.weapons["TT30_mp"] = spawnstruct();
	level.weapons["TT30_mp"].classname = "pistol";
	level.weapons["TT30_mp"].team = "allies";

	level.weapons["luger_mp"] = spawnstruct();
	level.weapons["luger_mp"].classname = "pistol";
	level.weapons["luger_mp"].team = "axis";

	for(i = 0; i < level.weaponnames.size; i++)
	{
		weaponname = level.weaponnames[i];

		if(getCvar(level.weapons[weaponname].server_allowcvar) == "")
		{
			level.weapons[weaponname].allow = level.weapons[weaponname].allow_default;
			setCvar(level.weapons[weaponname].server_allowcvar, level.weapons[weaponname].allow);
		}
		else
			level.weapons[weaponname].allow = getCvarInt(level.weapons[weaponname].server_allowcvar);
	}

	// Array of Available Weapon Classes
	level.weaponclasses = [];
	level.weaponclasses[0] = "boltaction";
	level.weaponclasses[1] = "sniper";
	level.weaponclasses[2] = "semiautomatic";
	level.weaponclasses[3] = "smg";
	level.weaponclasses[4] = "mg";
	level.weaponclasses[5] = "shotgun";

	// Weapon-Class Array Definitions Setup
	level.weaponclass = [];
	level.weaponclass["boltaction"] = spawnstruct();
	level.weaponclass["boltaction"].limit = 0;
	level.weaponclass["boltaction"].axis_limited = 0;
	level.weaponclass["boltaction"].allies_limited = 0;

	level.weaponclass["sniper"] = spawnstruct();
	level.weaponclass["sniper"].limit = 0;
	level.weaponclass["sniper"].axis_limited = 0;
	level.weaponclass["sniper"].allies_limited = 0;

	level.weaponclass["semiautomatic"] = spawnstruct();
	level.weaponclass["semiautomatic"].limit = 0;
	level.weaponclass["semiautomatic"].axis_limited = 0;
	level.weaponclass["semiautomatic"].allies_limited = 0;

	level.weaponclass["smg"] = spawnstruct();
	level.weaponclass["smg"].limit = 0;
	level.weaponclass["smg"].axis_limited = 0;
	level.weaponclass["smg"].allies_limited = 0;

	level.weaponclass["mg"] = spawnstruct();
	level.weaponclass["mg"].limit = 0;
	level.weaponclass["mg"].axis_limited = 0;
	level.weaponclass["mg"].allies_limited = 0;

	level.weaponclass["shotgun"] = spawnstruct();
	level.weaponclass["shotgun"].limit = 0;
	level.weaponclass["shotgun"].axis_limited = 0;
	level.weaponclass["shotgun"].allies_limited = 0;

	// Single Shot Kills
	level.prevent_single_shot_pistol = [[level.setdvar]]("scr_no_oneshot_pistol_kills", 0, 0, 1);
	level.prevent_single_shot_ppsh = [[level.setdvar]]("scr_no_oneshot_ppsh_kills", 0, 0, 1);

	//ppsh -> tommy balance
	level.balance_ppsh = [[level.setdvar]]("scr_balance_ppsh_distance", 0, 0, 1);

	///////////////////
	// Set-Up Mod Dvars
	///////////////////

	// Force Bolt-Action
	level.force_boltaction = [[level.setdvar]]("scr_force_boltaction", 0, 0, 2);

	// Nade/Smoke Spawn Counts
	level.boltactionnades = [[level.setdvar]]("scr_boltaction_nades", 3, 0);
	level.boltactionsmokes = [[level.setdvar]]("scr_boltaction_smokes", 0, 0);

	level.semiautonades = [[level.setdvar]]("scr_semiautomatic_nades", 2, 0);
	level.semiautosmokes = [[level.setdvar]]("scr_semiautomatic_smokes", 0, 0);

	level.smgnades = [[level.setdvar]]("scr_smg_nades", 1, 0);
	level.smgsmokes = [[level.setdvar]]("scr_smg_smokes", 1, 0);

	level.snipernades = [[level.setdvar]]("scr_sniper_nades", 3, 0);
	level.snipersmokes = [[level.setdvar]]("scr_sniper_smokes", 0, 0);

	level.mgnades = [[level.setdvar]]("scr_mg_nades", 2, 0);
	level.mgsmokes = [[level.setdvar]]("scr_mg_smokes", 0, 0);

	level.shotgunnades = [[level.setdvar]]("scr_shotgun_nades", 1, 0);
	level.shotgunsmokes = [[level.setdvar]]("scr_shotgun_smokes", 1, 0);


	// Weapon Drops Dvars
	level.allow_nadedrops = [[level.setdvar]]("scr_allow_weapondrop_nade", 1, 0, 1);
	level.allow_sniperdrops = [[level.setdvar]]("scr_allow_weapondrop_sniper", 1, 0, 1);
	level.allow_shotgundrops = [[level.setdvar]]("scr_allow_weapondrop_shotgun", 1, 0, 1);

	//Secondary Weapon Drop
	level.allow_secondary_drop = [[level.setdvar]]("scr_allow_secondary_drop", 0, 0, 1);

	// Weapon Class Weapon Limit Dvars
	level.weaponclass["boltaction"].limit = [[level.setdvar]]("scr_boltaction_limit", 99, 0, 99);
	level.weaponclass["sniper"].limit = [[level.setdvar]]("scr_sniper_limit", 99, 0, 99);
	level.weaponclass["semiautomatic"].limit = [[level.setdvar]]("scr_semiautomatic_limit", 99, 0, 99);
	level.weaponclass["smg"].limit = [[level.setdvar]]("scr_smg_limit", 99, 0, 99);
	level.weaponclass["mg"].limit = [[level.setdvar]]("scr_mg_limit", 99, 0, 99);
	level.weaponclass["shotgun"].limit = [[level.setdvar]]("scr_shotgun_limit", 99, 0, 99);

	//Pistols
	level.allow_pistols = [[level.setdvar]]("scr_allow_pistols", 1, 0, 1);

	//Turrets
	level.allow_turrets = [[level.setdvar]]("scr_allow_turrets", 1, 0, 1);


	maps\pam\weapon_limiter::Update_All_Weapon_Limits();

	// Weapon Switch Monitor
	if (!level.allow_sniperdrops || !level.allow_shotgundrops)
		level thread maps\pam\weapon_drop::Weapon_Switch_Monitor_Setup();


	// Health Bar, Regen, & Healthpacks
	thread maps\pam\health_bar::Init();
	level.regen_model = [[level.setdvar]]("scr_allow_health_regen", 1, 0, 4);
	level.playerHealth_RegularRegenDelay = [[level.setdvar]]("scr_regen_delay", 5000, 0, 30000);
	level.healthpacks = [[level.setdvar]]("scr_allow_healthpacks", 0, 0, 1);
	game["healthpacks"] = [];
	game["currenthealthpack"] = 0;

	// HUD Stuff
	level.objective_icon = [[level.setdvar]]("scr_show_objective_icons", 1, 0, 1);
	level.deathicon = [[level.setdvar]]("scr_show_death_icons", 1, 0, 1);
	level.grenadeicon = [[level.setdvar]]("scr_show_grenade_icon", 1, 0, 1);
	level.allow_hitblip = [[level.setdvar]]("scr_allow_hitblip", 1, 0, 1);
	level.allow_hud_scoreboard = [[level.setdvar]]("scr_allow_hud_scoreboard", 1, 0, 1);

	// ShellShock
	level.allow_shellshock = [[level.setdvar]]("scr_allow_shellshock", 1, 0, 1);

	// Fall Damage Heigths
	min = [[level.setdvar]]("scr_fallDamageMinHeight", 21, 0, 40);
	max = [[level.setdvar]]("scr_fallDamageMaxHeight", 40, min, 60);
	min = int(min * 12);
	max = int(max * 12);
	setcvar("bg_fallDamageMaxHeight", max);
	setcvar("bg_fallDamageMinHeight", min);


	// Clientside DVAR Enforcer Start-Up
	thread maps\pam\dvar_enforcer::DVAR_Enforcer_Init();
	
	//Monitor Server DVARs for Changes
	thread maps\pam\pam_server_settings::Dvar_Monitors();

	// Non-Match Mode Goodies
	if (game["mode"] != "match")
	{
		// Admin Tools
		thread maps\pam\utils\admin_tools::Init();

		// TK Monitor Init
		thread maps\pam\tkmonitor::TK_Monitor_Init();

		//Message Center
		thread maps\pam\messagecenter::Start_Messagecenter();

		//AFK and Spectate Monitors
		thread maps\pam\afk_monitor::Init();
		thread maps\pam\spec_monitor::Init();

		//No OT for PUB mode
		setcvar("g_ot", 0);
		setcvar("g_ot_active", 0);
	}
	// ePAM
	thread maps\pam\anticheat::init();
	if (!isDefined(getcvar("g_to"))) // Is time out defined in the rules?
		setcvar("g_to", "0");
	if (!isDefined(getcvar("g_to_length")))
		setcvar("g_to_length", "0");
	else if(getcvarFloat("g_to_length") > 1440)
		setcvar("g_to_length", "5");
	if (!isDefined(getcvar("g_to_side")))
		setcvar("g_to_side", getcvarInt("g_to"));
	//if (!isDefined(game["timeout"]))
		game["timeout"] = false;
	game["to"] = getcvarInt("g_to");
	game["to_length"] = getcvarFloat("g_to_length");
	game["to_side"] = getcvarInt("g_to_side");
	thread maps\pam\serverset::sset();

	//
}


SD_Variables()
{
	level.pam_spawn_player = maps\pam\sd::spawnPlayer;
	level.pam_spawn_spectator = maps\pam\sd::spawnSpectator;

	level.timelimit = getCvarFloat("scr_sd_timelimit");
	level.scorelimit = getCvarInt("scr_sd_scorelimit");
	level.roundlimit = getCvarInt("scr_sd_roundlimit");
	level.graceperiod = getCvarFloat("scr_sd_graceperiod");
	level.roundlength = getCvarFloat("scr_sd_roundlength");

	level.halfround = getcvarint("scr_sd_half_round");
	level.halfscore = getcvarint("scr_sd_half_score");
	level.matchround = getcvarint("scr_sd_end_round");
	level.matchscore1 = getcvarint("scr_sd_end_score");
	level.matchscore2 = getcvarint("scr_sd_end_half2score");
	level.countdraws = getcvarint("scr_sd_count_draws");

	level.strat_time = getcvarint("scr_sd_strat_time");

	level.bombtimer = getCvarInt("scr_sd_bombtimer");
	level.plant_time = getcvarint("scr_sd_PlantTime");
	level.defuse_time = getcvarint("scr_sd_DefuseTime");

	level.show_bombtimer = [[level.setdvar]]("scr_show_bombtimer", 1, 0, 1);

	// Bomb plant and defuse points
	level.bomb_defuse_points = [[level.setdvar]]("scr_sd_plant_points", 0, 0, 10);
	level.bomb_plant_points = [[level.setdvar]]("scr_sd_defuse_points", 0, 0, 10);

	//Players Left Start-Up
	level.hud_playersleft = [[level.setdvar]]("scr_playersleft", 1, 0, 1);
	thread maps\pam\players_left::Init();
}

DM_Variables()
{
	level.pam_spawn_player = maps\pam\dm::spawnPlayer;
	level.pam_spawn_spectator = maps\pam\dm::spawnSpectator;

	level.halfscore = getcvarint("scr_dm_half_score");
	level.matchscore1 = getcvarint("scr_dm_end_score");
	level.matchscore2 = getcvarint("scr_dm_end_half2score");

	level.do_halftime = [[level.setdvar]]("scr_dm_timelimit_halftime", 0, 0, 1);

	if (game["mode"] != "match")
		game["matchstarted"] = true;
}

HQ_Variables()
{
	level.pam_spawn_player = maps\pam\hq::spawnPlayer;
	level.pam_spawn_spectator = maps\pam\hq::spawnSpectator;

	level.halfscore = getcvarint("scr_hq_half_score");
	level.matchscore1 = getcvarint("scr_hq_end_score");
	level.matchscore2 = getcvarint("scr_hq_end_half2score");

	level.do_halftime = [[level.setdvar]]("scr_hq_timelimit_halftime", 0, 0, 1);

	if (game["mode"] != "match")
		game["matchstarted"] = true;

	level.orig_hq_style = 0;
	if (getcvar("scr_hq_gamestyle") == "original")
		level.orig_hq_style = 1;

	//Players Left Start-Up
	level.hud_playersleft = [[level.setdvar]]("scr_playersleft", 1, 0, 1);
	thread maps\pam\players_left::Init();
}

CTF_Variables()
{
	level.pam_spawn_player = maps\pam\ctf::spawnPlayer;
	level.pam_spawn_spectator = maps\pam\ctf::spawnSpectator;

	level.flag_auto_return = [[level.setdvar]]("scr_flag_autoreturn_time", 120, -1, 300);

	level.halfscore = getcvarint("scr_ctf_half_score");
	level.matchscore1 = getcvarint("scr_ctf_end_score");
	level.matchscore2 = getcvarint("scr_ctf_end_half2score");

	level.do_halftime = [[level.setdvar]]("scr_ctf_timelimit_halftime", 0, 0, 1);

	if (game["mode"] != "match")
		game["matchstarted"] = true;

	//Respawn Delay
	level.respawndelay = [[level.setdvar]]("scr_ctf_respawn_time", 10, 0, 60);

	//Players Left Start-Up
	level.hud_playersleft = [[level.setdvar]]("scr_playersleft", 1, 0, 1);
	thread maps\pam\players_left::Init();

	//Compass/Flag Relationship Dvars
	level.show_compass_flag = [[level.setdvar]]("scr_ctf_show_compassflag", 0, 0, 1);
	level.flag_grace = [[level.setdvar]]("scr_ctf_flag_graceperiod", 30, 0, 600);
	level.positiontime = [[level.setdvar]]("scr_ctf_positiontime", 10, 1, 60);

	// CTF Points
	level.ctf_capture_points = [[level.setdvar]]("scr_ctf_capture_points", 10, 0, 20);
	level.ctf_return_points = [[level.setdvar]]("scr_ctf_return_points", 2, 0, 20);

	// Respawn all on capture
	level.respawn_on_capture = [[level.setdvar]]("scr_ctf_respawn_on_capture", 0, 0, 1);

	// Flag Status HUD
	level.hud_flagstatus = [[level.setdvar]]("scr_ctf_show_flagstatus_hud", 0, 0, 1);
	thread maps\pam\flag_status::Init();
}

TDM_Variables()
{
	level.pam_spawn_player = maps\pam\tdm::spawnPlayer;
	level.pam_spawn_spectator = maps\pam\tdm::spawnSpectator;

	level.tdm_tk_scoring = [[level.setdvar]]("scr_tdm_tk_penalty", 0, 0, 1);

	level.halfscore = getcvarint("scr_tdm_half_score");
	level.matchscore1 = getcvarint("scr_tdm_end_score");
	level.matchscore2 = getcvarint("scr_tdm_end_half2score");

	level.do_halftime = [[level.setdvar]]("scr_tdm_timelimit_halftime", 0, 0, 1);

	if (game["mode"] != "match")
		game["matchstarted"] = true;
}