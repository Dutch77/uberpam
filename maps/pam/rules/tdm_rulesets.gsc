Get_TDM_Rules()
{
	switch (game["ruleset"])
	{	// Rule Files in Alpha Order
		case "cg":
			maps\pam\rules\tdm\cg::Rules();
			break;
		case "cg_1v1":
			maps\pam\rules\tdm\cg_1v1::Rules();
			break;
		case "cg_2v2":
			maps\pam\rules\tdm\cg_2v2::Rules();
			break;
		case "cg_rifle":
			maps\pam\rules\tdm\cg_rifle::Rules();
			break;
		case "pub_rifle":
			maps\pam\rules\tdm\pub_rifle::Rules();
			break;

		case "pub":
		default:
			setCvar("pam_mode", "pub");
			game["ruleset"] = "pub";
			game["mode"] = "pub";
			maps\pam\rules\tdm\pub::Rules();
	}
}