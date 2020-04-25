onPlayer_Disconnect()
{
	// Ready Up Issues
	if (game["mode"] == "match")
		self thread maps\pam\readyup::onPlayer_Disconnect();
}