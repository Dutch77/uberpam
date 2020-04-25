Get_CTF_Rules()
{
	switch (game["ruleset"])
	{	// Rule Files in Alpha Order
		case "cg":
			maps\pam\rules\ctf\cg::Rules();
			break;
		case "cg_2v2":
			maps\pam\rules\ctf\cg_2v2::Rules();
			break;
			
		case "pub":
		default:
			setCvar("pam_mode", "pub");
			game["ruleset"] = "pub";
			game["mode"] = "pub";
			maps\pam\rules\ctf\pub::Rules();
	}
}