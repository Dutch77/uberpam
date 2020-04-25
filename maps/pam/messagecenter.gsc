Start_Messagecenter()
{
	level.logging = getcvarint("logfile");
	//Website Ad
	//if (getcvarint("mc_showsite") && isDefined(game["mc_site"]))
	//	thread MessageCenterHUD();

	// Setup Welcome Center
	thread Setup_WelcomeCenter();

	// Continuous Message Center
	if (getcvar("mc_enable") == "" || getcvarint("mc_enable") < 1)
		return;

	if (!isDefined(game["mc_current_msg"]))
		game["mc_current_msg"] = 1;
		
	if (getcvar("mc_restarteveryround") != "" && getCvarint("mc_restarteveryround") > 0 )
		game["mc_current_msg"] = 1;
		
	Run_Messages();
}

Run_Messages()
{
	wait level.fps_multiplier * 3;
	first_message = true;

	// Set up Generic timer
	if(getcvar("mc_delay") == "")
		setcvar("mc_delay", "20");
	generic_delay = 20;
		
	//Check to see if max messages is set, if not default to 20
	if (getcvar("mc_maxmessages") == "")
		setcvar("mc_maxmessages" , 20);

	message_start = game["mc_current_msg"];

	while (1)
	{
		// Set up Maximum Messages
		max = getcvarint("mc_maxmessages") +1;
		
		// Run Through Possible Messages
		for (i=message_start;i<max;i++)
		{
			// Current message tracker
			game["mc_current_msg"] = i;

			// No message, continue looking
			if (getcvar("mc_message" + i) == "")
			{
				wait level.frame;
				continue;
			}
			else
			{
				// Found Message, set it up for display
				message = getcvar("mc_message" + i);
				
				//First check for message specific timer
				if (getcvar("mc_messagedelay" +i) == "")
				{
					// No message specific timer, use generic timer
					if (generic_delay != getcvarint("mc_delay"))
					{
						generic_delay = getcvarint("mc_delay");
						if (generic_delay < 5)
						{
							setcvar("mc_delay" , 5);
							generic_delay = 5;
						}
					}
					
					delay = generic_delay;
				}
				else
				{
					delay = getcvarint("mc_messagedelay" +i);
					if (delay < 0)
						delay = 0;
				}
				
				//Lets see if this is a SPECIAL message
				if (message == "<*nextmap*>")
					message = maps\pam\utils\utils::Get_Next_Map();
				else if (message == "<*gtrules*>")
					message = GameTypeRules();


				if (!isDefined(message))
				{
					wait level.frame;
					continue;
				}
				
				// Run Timer
				if (!first_message)
					wait level.fps_multiplier * delay;
				else
					first_message = false;
				
				// Display Message
				if (level.logging)
				{
					setcvar("logfile", 0);
					wait level.frame;

					iprintln(message);
					setcvar("logfile", 1);
				}
				else
					iprintln(message);
			}
		}
		
		message_start = 1;
		game["mc_current_msg"] = 1;

		loopdelay = getcvarint("mc_delay");
		if (loopdelay < 5)
		{
			setcvar("mc_delay" , 5);
			loopdelay = 5;
		}
		
		wait level.fps_multiplier * loopdelay;
	}
}

GameTypeRules()
{
	if (!isdefined(level.gametype) || level.gametype == "")
		return undefined;

	message = getcvar("mc_rules_" + level.gametype);

	if (message == "")
		return undefined;
	else
		return message;
}

Setup_WelcomeCenter()
{
	if (!getcvarint("wc_enable"))
	{
		game["wc_enabled"] = 0;
		return;
	}
			
	//Verify there are welcome center messages
	exists = Verify_Messages();
	if (!exists)
	{
		setcvar("wc_enable", 0);
		iprintln("^1Welcome Center Disabled: ^3No Welcome Messages");
		game["wc_enabled"] = 0;
		return;
	}
	
	game["wc_enabled"] = 1;
}

Verify_Messages()
{
	exists = false;
	if (getCvar("wc_line1") != "" || getCvar("wc_line2") != "" || getCvar("wc_line3") != "" || getCvar("wc_line4") != "" || getCvar("wc_line5") != "")
		exists = true;
	
	return exists;
}


Welcome_Me()
{
	self endon("disconnect");

	//if ( game["forcedownloads"] && !isDefined(self.pers["warned"]) )
	//	Downloads_Forced_Warning();
	//self.pers["warned"] = 1;

	if (!game["wc_enabled"])
		return;
		
	if (isDefined(self.pers["welcomed"]))
		return;

	self waittill("spawned");

	while (self.pers["team"] == "spectator" || !isDefined(self.pers["weapon"]))
		wait level.fps_multiplier * .5;
		
	// Do Welcome Messages
	if (level.logging)
	{
		setcvar("logfile", 0);
		wait level.frame;
	}

	for (i=1; i<6; i++)
	{
		message = getCvar("wc_line" +i);
		self iprintlnbold(message);
		wait level.frame;
	}

	if (level.logging)
		setcvar("logfile", 1);

	self.pers["welcomed"] = 1;
}

MessageCenterHUD()
{
	if (isDefined(level.mc_hud))
		level.mc_hud destroy();

	wait level.frame;

	level.mc_hud = newHudElem();
	level.mc_hud.x = 635;
	level.mc_hud.y = 475; 
	level.mc_hud.alignX = "right";
	level.mc_hud.alignY = "middle";
	level.mc_hud.alpha = 1;
	level.mc_hud.fontScale = .8;
	level.mc_hud.color = (.99, .99, .75);
	level.mc_hud setText(game["mc_site"]);
}

/*
Downloads_Forced_Warning()
{
	self iprintlnbold("^3Auto-Downloads MUST be on to play on this server!");
	self iprintlnbold("^3If you cannot see, please disconnect, turn your");
	self iprintlnbold("^3downloads on, and re-connect.  Thank you!");

	wait 6;
}

Precache_MessageCenter_HUD()
{
	// HUD www element
	if (getcvarint("mc_showsite"))
	{
		game["mc_site"] = &"www.ASMDGaming.com"; // CHANGE THIS LINE TO YOUR SITE
		precacheString(game["mc_site"]);
	}
}
*/