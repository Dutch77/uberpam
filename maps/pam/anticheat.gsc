init()
{
	thread Check_Devmap();
	thread Check_Pb();
}
Check_Devmap()
{
	self endon("disconnect");
	wait level.fps_multiplier * 1;
	if (getCvarInt("sv_cheats") == 0)
		return;
	cheats_on = newHudElem();
	cheats_on.x = 70;
	cheats_on.y = 470;
	cheats_on.alignX = "left";
	cheats_on.alignY = "top";
	cheats_on.fontScale = 0.8;
	cheats_on.color = (1, 0, 0);
	cheats_on setText(game["cheatson"]);
}
Check_Pb()
{
	self endon("disconnect");
	wait level.fps_multiplier * 1;
	if (getCvarInt("sv_punkbuster") == 1)
		return;
	mode = getcvar("pam_mode");

	if(mode == "pub" || mode == "pub_rifle")
		return;

/*
	pb_off = newHudElem();
	pb_off.x = 70;
	pb_off.y = 460;
	pb_off.alignX = "left";
	pb_off.alignY = "top";
	pb_off.fontScale = 0.8;
	pb_off.color = (1, 0, 0);
	pb_off setText(game["pboff"]);
	*/
}