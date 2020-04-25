Get_SD_Rules()
{
	switch (game["ruleset"])
	{	// Rule Files in Alpha Order
		case "bash":
			maps\pam\rules\sd\bash::Rules();
			break;
		case "cg":
			maps\pam\rules\sd\cg::Rules();
			break;
		case "cg_1v1":
			maps\pam\rules\sd\cg_1v1::Rules();
			break;
		case "cg_2v2":
			maps\pam\rules\sd\cg_2v2::Rules();
			break;
		case "cg_mr3":
			maps\pam\rules\sd\cg_mr3::Rules();
			break;
		case "cg_mr10":
			maps\pam\rules\sd\cg_mr10::Rules();
			break;
		case "cg_mr12":
			maps\pam\rules\sd\cg_mr12::Rules();
			break;
		case "cg_rifle":
			maps\pam\rules\sd\cg_rifle::Rules();
			break;
		case "cg_rush":
			maps\pam\rules\sd\cg_rush::Rules();
			break;
		case "mr3":
			maps\pam\rules\sd\mr3::Rules();
			break;
		case "mr10":
			maps\pam\rules\sd\mr10::Rules();
			break;
		case "mr12":
			maps\pam\rules\sd\mr12::Rules();
			break;
		case "mr15":
			maps\pam\rules\sd\mr15::Rules();
			break;
		case "pub_rifle":
			maps\pam\rules\sd\pub_rifle::Rules();
			break;
			
		case "pub":
		default:
			setCvar("pam_mode", "pub");
			game["ruleset"] = "pub";
			game["mode"] = "pub";
			maps\pam\rules\sd\pub::Rules();
	}

	// S&D Specific DVARs that must be set
	[[level.setdvar]]("sv_playersleft", 1, 0, 1);
	[[level.setdvar]]("scr_sd_PlantTime", 5, 0);
	[[level.setdvar]]("scr_sd_DefuseTime", 10, 0);

	[[level.setdvar]]("scr_sd_half_round", 0, 0);
	[[level.setdvar]]("scr_sd_half_score", 0, 0);
	[[level.setdvar]]("scr_sd_end_round", 0, 0);
	[[level.setdvar]]("scr_sd_end_score", 0, 0);
	[[level.setdvar]]("scr_sd_end_half2score", 0, 0);
}