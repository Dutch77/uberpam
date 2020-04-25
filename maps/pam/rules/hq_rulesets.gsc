Get_HQ_Rules()
{
	switch (game["ruleset"])
	{	// Rule Files in Alpha Order
		case "cg":
			maps\pam\rules\hq\cg::Rules();
			break;
		case "cg_1v1":
			maps\pam\rules\hq\cg_1v1::Rules();
			break;
		case "cg_2v2":
			maps\pam\rules\hq\cg_2v2::Rules();
			break;

		case "pub":
		default:
			setCvar("pam_mode", "pub");
			game["ruleset"] = "pub";
			game["mode"] = "pub";
			maps\pam\rules\hq\pub::Rules();
	}
}