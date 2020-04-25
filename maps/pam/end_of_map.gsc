End_Match_Scoreboard()
{
	thread [[level.pam_hud]]("match_over");
	thread [[level.pam_hud]]("team_win");
	thread [[level.pam_hud]]("header");
	thread [[level.pam_hud]]("scoreboard");	

	wait level.fps_multiplier * 7;

	thread [[level.pam_hud]]("kill_all");
}

Prepare_map_Tie()
{
	otcount = getcvarint("g_ot_active");
	otcount = otcount + 1;
	setcvar("g_ot_active", otcount);
}