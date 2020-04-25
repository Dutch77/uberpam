Precache()
{
	precacheShader("black");
	precacheShader("white");

	/* PAM precacheStrings */
	// HUD Header Elements
	maps\pam\pam_version_utils::Get_PAM_Version();
	precacheString(game["pamstring"]);

	// Logo
	if (level.gametype == "bash")
		game["leaguestring"] = &"Bash Mode";
	//if (level.gametype == "dm")
	//	game["leaguestring"] = &"zPAM Deathmatch";
	if (!isdefined(game["leaguestring"]))
		game["leaguestring"] = &"Unknown Pam_Mode Error";
	precacheString(game["leaguestring"]);
	game["overtimemode"] = &"Overtime";
	precacheString(game["overtimemode"]);

	//PAM Enable
	game["pam_on_off"] = &"zPAM Disabled";
	precacheString(game["pam_on_off"]);
	game["please_wait"] = &"Please Wait";
	precacheString(game["please_wait"]);

	// Team Win Hud Elements
	game["team1win"] = &"Allies Win!";
	precacheString(game["team1win"]);
	game["team2win"] = &"Axis Win!";
	precacheString(game["team2win"]);
	game["dsptie"] = &"Its a TIE!";
	precacheString(game["dsptie"]);
	game["matchover"] = &"Match Over";
	precacheString(game["matchover"]);
	game["overtime"] = &"Going to OverTime";
	precacheString(game["overtime"]);

	game["halftime"] = &"Halftime";
	precacheString(game["halftime"]);

	game["empty"] = &" ";
	precacheString(game["empty"]);

	//Round Starting Display
	game["round"] = &"Round";
	precacheString(game["round"]);
	game["starting"] = &"Starting";
	precacheString(game["starting"]);

	// Strat Time Announcement
	game["strattime"] = &"Strat Time";
	precacheString(game["strattime"]);

	// bomb exploedes in
	game["rushexplode"] = &"Bomb explodes in";
	precacheString(game["rushexplode"]);

	//Teams Swithcing Announcement
	game["switching"] = &"Team Auto-Switch";
	precacheString(game["switching"]);	
	game["switching2"] = &"Please wait";
	precacheString(game["switching2"]);

	game["startingin"] = &"Starting In";
	precacheString(game["startingin"]);		
	
	game["livemsg"] = &"LIVE!";
	precacheString(game["livemsg"]);

	//Half Starting Display
	game["first"] = &"First";
	precacheString(game["first"]);
	game["second"] = &"Second";
	precacheString(game["second"]);
	game["half"] = &"Half";
	precacheString(game["half"]);
	game["starting"] = &"Starting";
	precacheString(game["starting"]);


	// Ready-Up Plugin Requires:
	game["warning_dl2"] = &"You must download MOD to play on this server";
	precacheString(game["warning_dl2"]);

	game["warning_dl1"] = &"Type /cl_allowdownload 1 and after that /reconnect";
	precacheString(game["warning_dl1"]);

	game["ctt"] = &"Clock";
	precacheString(game["ctt"]);
	game["cttcb"] = &"Match starts in";
	precacheString(game["cttcb"]);
	game["killstextrup"] = &"Kills";
	precachestring(game["killstextrup"]);
	game["waiting"] = &"Ready-Up Mode";
	precacheString(game["waiting"]);
	game["waitingon"] = &"Waiting on";
	precacheString(game["waitingon"]);
	game["playerstext"] = &"Players";
	precacheString(game["playerstext"]);
	game["goingtoo"] = &"Going to time-out in";
	precacheString(game["goingtoo"]);
	game["start_time"] = &"Start time";
	precacheString(game["start_time"]);
	game["status"] = &"Your Status";
	precacheString(game["status"]);
	game["ready"] = &"Ready";
	precacheString(game["ready"]);
	game["notready"] = &"Not Ready";
	precacheString(game["notready"]);
	precacheStatusIcon("party_ready");
	precacheStatusIcon("party_notready");
	// Ready-Up Complete
	game["allready"] = &"All Players are Ready";
	precacheString(game["allready"]);
	game["start2ndhalf"] = &"Starting Second Half!";
	precacheString(game["start2ndhalf"]);
	game["start1sthalf"] = &"Starting the First Half!";
	precacheString(game["start1sthalf"]);
	// No Password
	game["no_password"] = &"Warning: No Server Password Set";
	precacheString(game["no_password"]);
	//Timeout
	game["timeouthead"] = &"Time-out Mode";
	precacheString(game["timeouthead"]);
	game["resuming"] = &"Resuming In";

	precacheString(game["resuming"]);
	game["timeoutcount"] = &"Time-outs";
	precacheString(game["timeoutcount"]);
	game["axis_text"] = &"Axis";
	precacheString(game["axis_text"]);
	game["allies_text"] = &"Allies";
	precacheString(game["allies_text"]);
	game["kdisabled"] = &"Disabled";
	precachestring(game["kdisabled"]);
	game["killingt"] = &"Killing";
	precachestring(game["killingt"]);
	
	// Bash Round
	game["bashrnd"] = &"Starting Bash Round";
	precacheString(game["bashrnd"]);
	game["bashbegin"] = &"BEGIN!";
	precacheString(game["bashbegin"]);

	// Players Left Display		
	game["axis_hud_text"] = &"Axis Left";
	precacheString(game["axis_hud_text"]);
	game["allies_hud_text"] = &"Allies Left";
	precacheString(game["allies_hud_text"]);

	/*game["specmode_message_on"] = &"- Press [[{+activate}]] to enable map overview";
	precacheString(game["specmode_message_on"]);

	game["specmode_message_off"] = &"- Press [[{+activate}]] to disable map overview";
	precacheString(game["specmode_message_off"]);

	game["specmode_message_mouse"] = &"- Press [[{+attack}]] to change view";
	precacheString(game["specmode_message_mouse"]);*/

	// Round Timer
	game["round"] = &"Round";
	precacheString(game["round"]);		
	game["startingin"] = &"Starting In";
	precacheString(game["startingin"]);		
	game["matchstarting"] = &"Match Starting In";
	precacheString(game["matchstarting"]);

	game["matchresuming"] = &"Match Resuming In";
	precacheString(game["matchresuming"]);

	// Scoreboard Text
	game["dspteam1"] = &"AXIS";
	precacheString(game["dspteam1"]);
	game["dspteam2"] = &"ALLIES";
	precacheString(game["dspteam2"]);
	game["scorebd"] = &"Scoreboard";
	precacheString(game["scorebd"]);
	game["dspaxisscore"] = &"AXIS SCORE";
	precacheString(game["dspaxisscore"]);		
	game["dspalliesscore"] = &"ALLIES SCORE";
	precacheString(game["dspalliesscore"]);
	game["1sthalf"] = &"1st Half";
	precacheString(game["1sthalf"]);	
	game["2ndhalf"] = &"2nd Half";
	precacheString(game["2ndhalf"]);
	game["matchscore2"] = &"Match";
	precacheString(game["matchscore2"]);

	// Strat Time Announcement
	game["strattime"] = &"Strat Time";
	precacheString(game["strattime"]);

	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");

	//Health Bar
	game["health_back"] = "gfx/hud/hud@health_back.tga";
	precacheShader(game["health_back"]);
	game["health_bar"] = "gfx/hud/hud@health_bar.tga";
	precacheShader(game["health_bar"]);
	game["health_cross"] = "gfx/hud/hud@health_cross.tga";
	precacheShader(game["health_cross"]);

	//Health Packs
	game["Item_Healthpack"] = "xmodel/health_medium";
	precacheModel(game["Item_Healthpack"]);

	// /Record Reminder
	if (game["mode"] == "match")
	{
		game["rec_remind"] = &"Don't forget to record!";
		precacheString(game["rec_remind"]);
	}

	// CTF Status Icons
	if (level.gametype == "ctf")
	{
		precacheStatusIcon("compass_flag_" + game["allies"]);
		precacheStatusIcon("compass_flag_" + game["axis"]);

		game["alive_hud_text"] = &"Alive";
		precacheString(game["alive_hud_text"]);
	}
	
	// Strat mode
	game["flyenabled"] = &"Enabled";
	precacheString(game["flyenabled"]);
	game["flydisabled"] = &"Disabled";
	precacheString(game["flydisabled"]);
	game["toenable"] = &"Enable: Hold ^3[{+melee_breath}]";
	precacheString(game["toenable"]);
	game["todisable"] = &"Disable: Hold ^3[{+melee_breath}]";
	precacheString(game["todisable"]);	
	
	// Anticheat
	game["cheatson"] = &"Warning: Cheats are Enabled";
	precacheString(game["cheatson"]);
	game["pboff"] = &"Warning: PunkBuster is Disabled";
	precacheString(game["pboff"]);
	/*
	// Stream checking facility isn't working, thus the following are not needed
	game["streamaddroff"] = &"Stream Address: Missing";
	precacheString(game["streamaddroff"]);
	game["streamaddr"] = &"Stream Address: Set";
	precacheString(game["streamaddr"]);
	game["streamauthoff"] = &"Stream Auth: Missing";
	precacheString(game["streamauthoff"]);
	game["streamauth"] = &"Stream Auth: Set";
	precacheString(game["streamauth"]);
	*/

	uber\uber::precacheUberModels();
}