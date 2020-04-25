Get_DM_Rules()
{
	switch (game["ruleset"])
	{	// Rule Files in Alpha Order
		case "cg":
			maps\pam\rules\dm\cg::Rules();
			break;
		case "cg_rifle":
			maps\pam\rules\dm\cg_rifle::Rules();
			break;
		case "pub_rifle":
			maps\pam\rules\dm\pub_rifle::Rules();
			break;

		case "pub":
		default:
			setCvar("pam_mode", "pub");
			game["ruleset"] = "pub";
			game["mode"] = "pub";
			maps\pam\rules\dm\pub::Rules();
	}
}