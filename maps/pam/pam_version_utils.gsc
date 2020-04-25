Get_PAM_Version()
{
	game["pamstring"] = &"zPAM v2.07";
}

isValid_PAM_Mode()
{
	next_gametype = getCvar("g_gametype");
	mode = getCvar("pam_mode");
	valid_mode = [];

	if (next_gametype == "sd")
	{
		valid_mode[0] = "bash";
		valid_mode[1] = "cg";
		valid_mode[2] = "cg_1v1";
		valid_mode[3] = "cg_2v2";
		valid_mode[4] = "cg_mr3";
		valid_mode[5] = "cg_mr10";
		valid_mode[6] = "cg_mr12";
		valid_mode[7] = "cg_rifle";
		valid_mode[8] = "cg_rush";
		valid_mode[9] = "mr3";
		valid_mode[10] = "mr10";
		valid_mode[11] = "mr12";
		valid_mode[12] = "mr15";
		valid_mode[13] = "pub";
		valid_mode[14] = "pub_rifle";
	}
	else if (next_gametype == "dm")
	{
		valid_mode[0] = "cg";
		valid_mode[1] = "cg_rifle";
		valid_mode[2] = "pub";
		valid_mode[3] = "pub_rifle";
	}
	else if (next_gametype == "ctf")
	{
		valid_mode[0] = "cg";
		valid_mode[1] = "cg_2v2";
		valid_mode[2] = "pub";
	}
	else if (next_gametype == "tdm")
	{
		valid_mode[0] = "cg";
		valid_mode[1] = "cg_1v1";
		valid_mode[2] = "cg_2v2";
		valid_mode[3] = "cg_rifle";
		valid_mode[4] = "pub";
		valid_mode[5] = "pub_rifle";
	}
	else if (next_gametype == "hq")
	{
		valid_mode[0] = "cg";
		valid_mode[1] = "cg_1v1";
		valid_mode[2] = "cg_2v2";
		valid_mode[3] = "pub";
	}

	for (i=0; i < valid_mode.size ; i++ )
	{
		if (mode == valid_mode[i])
			return true;
	}

	// zPAM
	iprintln("^1zPAM: ^3Warning! ^2" + mode + " ^3not valid");
	wait(2);
	
	heygametype = getcvar("g_gametype");
	if (heygametype == "sd")
	{
		iprintln("^1zPAM: ^3Following S&D modes are valid [15]:");
		wait(3);
		iprintln("^1zPAM: ^2cg, cg_1v1, cg_2v2, cg_mr3,");
		iprintln("^1zPAM: ^2cg_mr10, cg_mr12, cg_rifle, cg_rush,");
		iprintln("^1zPAM: ^2mr3, mr10, mr12, mr15, bash, pub ^3and ^2pub_rifle");
	}
	else if (heygametype == "tdm")
	{
		iprintln("^1zPAM: ^3Following TDM modes are valid [6]:");
		wait(3);
		iprintln("^1zPAM: ^2cg, cg_1v1, cg_2v2, cg_rifle,");
		iprintln("^1zPAM: ^2pub ^3and ^2pub_rifle");
	}
	else if (heygametype == "dm")
	{
		iprintln("^1zPAM: ^3Following DM modes are valid [4]:");
		wait(3);
		iprintln("^1zPAM: ^2cg, cg_rifle, pub ^3and ^2pub_rifle");
	}
	else if (heygametype == "hq")
	{
		iprintln("^1zPAM: ^3Following HQ modes are valid [4]:");
		wait(3);
		iprintln("^1zPAM: ^2cg, cg_1v1, cg_2v2, ^3and ^2pub");
	}
	else if (heygametype == "ctf")
	{
		iprintln("^1zPAM: ^3Following CTF modes are valid [3]:");
		wait(3);
		iprintln("^1zPAM: ^2cg, cg_2v2 ^3and ^2pub");
	}
	return false;
}
