onPlayer_Connect()
{
	// Let DVAR enforcer do its thing!
	self thread Enable_Dvar_Enforcer();
	self.bombinteraction = 0;

	//TK Monitor
	thread maps\pam\tkmonitor::SetupPlayerTKMonitor();

	// Ready Up Setup
	thread maps\pam\readyup::onPlayer_Connect();

	// Welcome Center 
	if (game["mode"] != "match")
		self thread maps\pam\messagecenter::Welcome_Me();

	// sv_fps handling
	fps = getcvarint("sv_fps");
	self setClientCvar("snaps", fps);
}

Enable_Dvar_Enforcer()
{
	self endon("disconnect");

	wait level.fps_multiplier * 7;

	self.pers["dvarenforcement"] = 1;
}