onWeaponSelect_Check_Limit(response)
{
	restricted = "restricted";
	weaponclass = level.weapons[response].classname;
	team = self.pers["team"];

	weapon_class_count = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (!isDefined(player.pers["team"]) || !isDefined(player.pers["weapon"]) )
			continue;

		if (player.pers["team"] != self.pers["team"] || player == self)
			continue;

		playerweapon = player.pers["weapon"];

		if (level.weapons[playerweapon].classname == weaponclass)
			weapon_class_count++;
	}

	if (weapon_class_count >= level.weaponclass[weaponclass].limit)
	{
		if (team == "allies") level.weaponclass[weaponclass].allies_limited = 1;
		else level.weaponclass[weaponclass].axis_limited = 1;
		thread Update_WeaponClass_HUDs(team, weaponclass, 0);
		return restricted;
	}
	if (weapon_class_count+1 == level.weaponclass[weaponclass].limit)
	{
		if (team == "allies") level.weaponclass[weaponclass].allies_limited = 1;
		else level.weaponclass[weaponclass].axis_limited = 1;
		thread Update_WeaponClass_HUDs(team, weaponclass, 0);
		return response;
	}
	else
	{
		if (team == "allies") level.weaponclass[weaponclass].allies_limited = 0;
		else level.weaponclass[weaponclass].axis_limited = 0;
		thread Update_WeaponClass_HUDs(team, weaponclass, 1);
		return response;
	}
}

Weapon_Menu_Updater()
{
	level.limitingentered = 1;

	for(;;)
	{
		players = getentarray("player", "classname");
		
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if (player.pers["team"] == "allies")
			{
				player.weapon = player.pers["weapon"];	

				if (player.weapon == "enfield_scope_allies_mp" || player.weapon == "kar98k_sniper_allies_mp" || player.weapon == "springfield_allies_mp" || player.weapon == "mosin_nagant_sniper_allies_mp")
					player.sniperowner = "sniperowner";
				else 
					player.sniperowner = "notsniperowner";

				if (player.sniperowner == "sniperowner" && level.weaponclass["sniper"].allies_limited)
				{
					player setClientCvar(level.weapons["enfield_scope_allies_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["kar98k_sniper_allies_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["springfield_allies_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["mosin_nagant_sniper_allies_mp"].client_allowcvar, 1);
				}	
				else if (player.sniperowner == "notsniperowner" && level.weaponclass["sniper"].allies_limited)
				{
					player setClientCvar(level.weapons["enfield_scope_allies_mp"].client_allowcvar, 0);
					player setClientCvar(level.weapons["kar98k_sniper_allies_mp"].client_allowcvar, 0);
					player setClientCvar(level.weapons["springfield_allies_mp"].client_allowcvar, 0);
					player setClientCvar(level.weapons["mosin_nagant_sniper_allies_mp"].client_allowcvar, 0);
				}
				else if (!level.weaponclass["sniper"].allies_limited) 
				{
					player setClientCvar(level.weapons["enfield_scope_allies_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["kar98k_sniper_allies_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["springfield_allies_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["mosin_nagant_sniper_allies_mp"].client_allowcvar, 1);
				}
			}
			else if	(player.pers["team"] == "axis")
			{
				player.weapon = player.pers["weapon"];

				if (player.weapon == "enfield_scope_axis_mp" || player.weapon == "kar98k_sniper_axis_mp" || player.weapon == "springfield_axis_mp" || player.weapon == "mosin_nagant_sniper_axis_mp")
					player.sniperowner = "sniperowner";
				else 
					player.sniperowner = "notsniperowner";

				if (player.sniperowner == "sniperowner" && level.weaponclass["sniper"].axis_limited)
				{
					player setClientCvar(level.weapons["enfield_scope_axis_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["kar98k_sniper_axis_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["springfield_axis_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["mosin_nagant_sniper_axis_mp"].client_allowcvar, 1);
				}	
				else if (player.sniperowner == "notsniperowner" && level.weaponclass["sniper"].axis_limited)
				{
					player setClientCvar(level.weapons["enfield_scope_axis_mp"].client_allowcvar, 0);
					player setClientCvar(level.weapons["kar98k_sniper_axis_mp"].client_allowcvar, 0);
					player setClientCvar(level.weapons["springfield_axis_mp"].client_allowcvar, 0);
					player setClientCvar(level.weapons["mosin_nagant_sniper_axis_mp"].client_allowcvar, 0);
				}
				else if (!level.weaponclass["sniper"].axis_limited) 
				{
					player setClientCvar(level.weapons["enfield_scope_axis_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["kar98k_sniper_axis_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["springfield_axis_mp"].client_allowcvar, 1);
					player setClientCvar(level.weapons["mosin_nagant_sniper_axis_mp"].client_allowcvar, 1);
				}
			}
		wait 0.1;	
		}
	wait 0.1;
	}
}

/*
Update_All_Weapon_Limits()
{
	// Needs to be called when weapon statuses may have changed:
	// Player Disconnect, Player Changes Teams, Player goes to Spec
	al_sniper_count = 0;
	ax_sniper_count = 0;

	al_boltaction_count = 0;
	ax_boltaction_count = 0;

	al_semiauto_count = 0;
	ax_semiauto_count = 0;

	al_smg_count = 0;
	ax_smg_count = 0;

	al_mg_count = 0;
	ax_mg_count = 0;

	al_shottie_count = 0;
	ax_shottie_count = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (!isDefined(player.pers["team"]) || (player.pers["team"] != "axis" || player.pers["team"] != "allies") )
			continue;

		if (!isDefined(player.pers["weapon"]))
			continue;
		spawnweapon = player.pers["weapon"];

		switch (level.weapons[spawnweapon].classname)
		{
		case "sniper":
			if (player.pers["team"] == "axis")
				ax_sniper_count++;
			else
				al_sniper_count++;
			break;
		case "boltaction":
			if (player.pers["team"] == "axis") ax_boltaction_count++;
			else al_boltaction_count++;
			break;
		case "semiautomatic":
			if (player.pers["team"] == "axis") ax_semiauto_count++;
			else al_semiauto_count++;
			break;
		case "smg":
			if (player.pers["team"] == "axis") ax_smg_count++;
			else al_smg_count++;
			break;
		case "mg":
			if (player.pers["team"] == "axis") ax_mg_count++;
			else al_mg_count++;
			break;
		case "shotgun":
			if (player.pers["team"] == "axis") ax_shottie_count++;
			else al_shottie_count++;
			break;
		default:
			//println("^3Weapon Limiter: " + spawnweapon + " has no weapon class");
		}
	}

	if (al_sniper_count >= level.weaponclass["sniper"].limit) level.weaponclass["sniper"].allies_limited = 1;
	else level.weaponclass["sniper"].allies_limited = 0;
	if (ax_sniper_count >= level.weaponclass["sniper"].limit) level.weaponclass["sniper"].axis_limited = 1;
	else level.weaponclass["sniper"].axis_limited = 0;

	if (al_boltaction_count >= level.weaponclass["boltaction"].limit) level.weaponclass["boltaction"].allies_limited = 1;
	else level.weaponclass["boltaction"].allies_limited = 0;
	if (ax_boltaction_count >= level.weaponclass["boltaction"].limit) level.weaponclass["boltaction"].axis_limited = 1;
	else level.weaponclass["boltaction"].axis_limited = 0;

	if (al_semiauto_count >= level.weaponclass["semiautomatic"].limit) level.weaponclass["semiautomatic"].allies_limited = 1;
	else level.weaponclass["semiautomatic"].allies_limited = 0;
	if (ax_semiauto_count >= level.weaponclass["semiautomatic"].limit) level.weaponclass["semiautomatic"].axis_limited = 1;
	else level.weaponclass["semiautomatic"].axis_limited = 0;

	if (al_smg_count >= level.weaponclass["smg"].limit) level.weaponclass["smg"].allies_limited = 1;
	else level.weaponclass["smg"].allies_limited = 0;
	if (ax_smg_count >= level.weaponclass["smg"].limit) level.weaponclass["smg"].axis_limited = 1;
	else level.weaponclass["smg"].axis_limited = 0;

	if (al_mg_count >= level.weaponclass["mg"].limit) level.weaponclass["mg"].allies_limited = 1;
	else level.weaponclass["mg"].allies_limited = 0;
	if (ax_mg_count >= level.weaponclass["mg"].limit) level.weaponclass["mg"].axis_limited = 1;
	else level.weaponclass["mg"].axis_limited = 0;

	if (al_shottie_count >= level.weaponclass["shotgun"].limit) level.weaponclass["shotgun"].allies_limited = 1;
	else level.weaponclass["shotgun"].allies_limited = 0;
	if (ax_shottie_count >= level.weaponclass["shotgun"].limit) level.weaponclass["shotgun"].axis_limited = 1;
	else level.weaponclass["shotgun"].axis_limited = 0;

	Update_All_Weapon_Menus();
}*/

Update_All_Weapon_Limits()
{
	// Needs to be called when weapon statuses may have changed:
	// Player Disconnect, Player Changes Teams, Player goes to Spec
	al_sniper_count = 0;
	al_sniper_was_limited = level.weaponclass["sniper"].allies_limited;
	ax_sniper_count = 0;
	ax_sniper_was_limited = level.weaponclass["sniper"].axis_limited;

	al_boltaction_count = 0;
	al_boltaction_was_limited = level.weaponclass["boltaction"].allies_limited;
	ax_boltaction_count = 0;
	ax_boltaction_was_limited = level.weaponclass["boltaction"].axis_limited;

	al_semiauto_count = 0;
	al_semiauto_was_limited = level.weaponclass["semiautomatic"].allies_limited;
	ax_semiauto_count = 0;
	ax_semiauto_was_limited = level.weaponclass["semiautomatic"].axis_limited;

	al_smg_count = 0;
	al_smg_was_limited = level.weaponclass["smg"].allies_limited;
	ax_smg_count = 0;
	ax_smg_was_limited = level.weaponclass["smg"].axis_limited;

	al_mg_count = 0;
	al_mg_was_limited = level.weaponclass["mg"].allies_limited;
	ax_mg_count = 0;
	ax_mg_was_limited = level.weaponclass["mg"].axis_limited;

	al_shottie_count = 0;
	al_shottie_was_limited = level.weaponclass["shotgun"].allies_limited;
	ax_shottie_count = 0;
	ax_shottie_was_limited = level.weaponclass["shotgun"].axis_limited;

	Check_WeaponLimit_Server_Changes();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (!isDefined(player.pers["team"]) || (player.pers["team"] != "axis" || player.pers["team"] != "allies") )
			continue;

		if (!isDefined(player.pers["weapon"]))
			continue;
		spawnweapon = player.pers["weapon"];

		switch (level.weapons[spawnweapon].classname)
		{
		case "sniper":
			if (player.pers["team"] == "axis") 	
				ax_sniper_count++;
			else 	
				al_sniper_count++;
			break;
		case "boltaction":
			if (player.pers["team"] == "axis") ax_boltaction_count++;
			else al_boltaction_count++;
			break;
		case "semiautomatic":
			if (player.pers["team"] == "axis") ax_semiauto_count++;
			else al_semiauto_count++;
			break;
		case "smg":
			if (player.pers["team"] == "axis") ax_smg_count++;
			else al_smg_count++;
			break;
		case "mg":
			if (player.pers["team"] == "axis") ax_mg_count++;
			else al_mg_count++;
			break;
		case "shotgun":
			if (player.pers["team"] == "axis") ax_shottie_count++;
			else al_shottie_count++;
			break;
		default:
			//println("^3Weapon Limiter: " + spawnweapon + " has no weapon class");
		}

		if (level.allow_secondary && isDefined(player.pers["secondary_weapon"]))
		{
			secondary = player.pers["secondary_weapon"];

			switch (level.weapons[secondary].classname)
			{
			case "sniper":
				if (player.pers["team"] == "axis") 
					ax_sniper_count++;
				else 
					al_sniper_count++;
				break;
			case "boltaction":
				if (player.pers["team"] == "axis") ax_boltaction_count++;
				else al_boltaction_count++;
				break;
			case "semiautomatic":
				if (player.pers["team"] == "axis") ax_semiauto_count++;
				else al_semiauto_count++;
				break;
			case "smg":
				if (player.pers["team"] == "axis") ax_smg_count++;
				else al_smg_count++;
				break;
			case "mg":
				if (player.pers["team"] == "axis") ax_mg_count++;
				else al_mg_count++;
				break;
			case "shotgun":
				if (player.pers["team"] == "axis") ax_shottie_count++;
				else al_shottie_count++;
				break;
			default:
				//println("^3Weapon Limiter: " + spawnweapon + " has no weapon class");
			}
		}
	}

	if (al_sniper_count >= level.weaponclass["sniper"].limit)
	{
		setcvar("al_sniplimited", 1); 	
		level.weaponclass["sniper"].allies_limited = 1;
	}
	else 
	{	
		setcvar("al_sniplimited", 0); 
		level.weaponclass["sniper"].allies_limited = 0;
	}
	
	if (ax_sniper_count >= level.weaponclass["sniper"].limit)
	{
		setcvar("ax_sniplimited", 1);  
		level.weaponclass["sniper"].axis_limited = 1;
	}
	else
	{
		setcvar("ax_sniplimited", 0);
		level.weaponclass["sniper"].axis_limited = 0; 
	}


	if (al_boltaction_count >= level.weaponclass["boltaction"].limit) level.weaponclass["boltaction"].allies_limited = 1;
	else level.weaponclass["boltaction"].allies_limited = 0;
	if (ax_boltaction_count >= level.weaponclass["boltaction"].limit) level.weaponclass["boltaction"].axis_limited = 1;
	else level.weaponclass["boltaction"].axis_limited = 0;

	if (al_semiauto_count >= level.weaponclass["semiautomatic"].limit) level.weaponclass["semiautomatic"].allies_limited = 1;
	else level.weaponclass["semiautomatic"].allies_limited = 0;
	if (ax_semiauto_count >= level.weaponclass["semiautomatic"].limit) level.weaponclass["semiautomatic"].axis_limited = 1;
	else level.weaponclass["semiautomatic"].axis_limited = 0;

	if (al_smg_count >= level.weaponclass["smg"].limit) level.weaponclass["smg"].allies_limited = 1;
	else level.weaponclass["smg"].allies_limited = 0;
	if (ax_smg_count >= level.weaponclass["smg"].limit) level.weaponclass["smg"].axis_limited = 1;
	else level.weaponclass["smg"].axis_limited = 0;

	if (al_mg_count >= level.weaponclass["mg"].limit) level.weaponclass["mg"].allies_limited = 1;
	else level.weaponclass["mg"].allies_limited = 0;
	if (ax_mg_count >= level.weaponclass["mg"].limit) level.weaponclass["mg"].axis_limited = 1;
	else level.weaponclass["mg"].axis_limited = 0;

	if (al_shottie_count >= level.weaponclass["shotgun"].limit) level.weaponclass["shotgun"].allies_limited = 1;
	else level.weaponclass["shotgun"].allies_limited = 0;
	if (ax_shottie_count >= level.weaponclass["shotgun"].limit) level.weaponclass["shotgun"].axis_limited = 1;
	else level.weaponclass["shotgun"].axis_limited = 0;

	//thread Update_All_Weapon_HUDs();

	//Check for changes in 'limited' status
	if (al_sniper_was_limited != level.weaponclass["sniper"].allies_limited)
	{
		allowed = 1;
		setcvar("al_sniplimited", 1);
		if (level.weaponclass["sniper"].allies_limited)
		{
			allowed = 0;
			setcvar("al_sniplimited", 0);
		}
		thread Update_WeaponClass_HUDs("allies", "sniper", allowed);
	}

	if (ax_sniper_was_limited != level.weaponclass["sniper"].axis_limited)
	{
		allowed = 1;
		setcvar("ax_sniplimited", 1);
		if (level.weaponclass["sniper"].axis_limited)
		{
			allowed = 0;
			setcvar("ax_sniplimited", 0);
		}
		thread Update_WeaponClass_HUDs("axis", "sniper", allowed);
	}

	if (al_boltaction_was_limited != level.weaponclass["boltaction"].allies_limited)
	{
		allowed = 1;
		if (level.weaponclass["boltaction"].allies_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("allies", "boltaction", allowed);
	}

	if (ax_boltaction_was_limited != level.weaponclass["boltaction"].axis_limited)
	{
		allowed = 1;
		if (level.weaponclass["boltaction"].axis_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("axis", "boltaction", allowed);
	}

	if (al_semiauto_was_limited != level.weaponclass["semiautomatic"].allies_limited)
	{
		allowed = 1;
		if (level.weaponclass["semiautomatic"].allies_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("allies", "semiautomatic", allowed);
	}

	if (ax_semiauto_was_limited != level.weaponclass["semiautomatic"].axis_limited)
	{
		allowed = 1;
		if (level.weaponclass["semiautomatic"].axis_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("axis", "semiautomatic", allowed);
	}

	if (al_smg_was_limited != level.weaponclass["smg"].allies_limited)
	{
		allowed = 1;
		if (level.weaponclass["smg"].allies_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("allies", "smg", allowed);
	}

	if (ax_smg_was_limited != level.weaponclass["smg"].axis_limited)
	{
		allowed = 1;
		if (level.weaponclass["smg"].axis_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("axis", "smg", allowed);
	}

	if (al_mg_was_limited != level.weaponclass["mg"].allies_limited)
	{
		allowed = 1;
		if (level.weaponclass["mg"].allies_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("allies", "mg", allowed);
	}

	if (ax_mg_was_limited != level.weaponclass["mg"].axis_limited)
	{
		allowed = 1;
		if (level.weaponclass["mg"].axis_limited)
			allowed = 0;
		thread Update_WeaponClass_HUDs("axis", "mg", allowed);
	}

	if (al_shottie_was_limited != level.weaponclass["shotgun"].allies_limited)
	{
		allowed = 1;
		if (level.weaponclass["shotgun"].allies_limited)
			allowed = 0;
		thread Update_Shotgun_Weapon_HUDs("allies");
	}

	if (ax_shottie_was_limited != level.weaponclass["shotgun"].axis_limited)
	{
		allowed = 1;
		if (level.weaponclass["shotgun"].axis_limited)
			allowed = 0;
		thread Update_Shotgun_Weapon_HUDs("axis");
	}
	
	mode = getcvar("pam_mode");
	
	gametype = getcvar("g_gametype");

	if ((mode == "cg_rifle" || mode == "pub_rifle") && (gametype == "tdm" || gametype == "sd") && (!isdefined(level.limitingentered) || (isdefined(level.limitingentered) && level.limitingentered != 1)))
	{
		thread Weapon_Menu_Updater();
	}
}

Check_WeaponLimit_Server_Changes()
{
	level.weaponclass["boltaction"].limit = getcvarint("scr_boltaction_limit");
	level.weaponclass["sniper"].limit = getcvarint("scr_sniper_limit");
	level.weaponclass["semiautomatic"].limit = getcvarint("scr_semiautomatic_limit");
	level.weaponclass["smg"].limit = getcvarint("scr_smg_limit");
	level.weaponclass["mg"].limit = getcvarint("scr_mg_limit");
	level.weaponclass["shotgun"].limit = getcvarint("scr_shotgun_limit");
}

Update_WeaponClass_HUDs(team, weaponclass, allowed)
{
	if (!isDefined(allowed))
	{
		iprintln("Error: Allowed not sent to Update_WeaponClass_HUDs()");
		return;
	}

	for(weaponname = 0; weaponname < level.weaponnames.size; weaponname++)
	{
		name = level.weaponnames[weaponname];
		if (level.weapons[name].classname != weaponclass)
			continue;

		if (weaponclass == "shotgun")
		{
			thread Update_Shotgun_Weapon_HUDs(team);
			return;
		}

		if (level.weapons[name].team != team)
			continue;

		thread Update_One_Weapon_HUDs(level.weapons[name].client_allowcvar, allowed);
		wait level.fps_multiplier * 0.05;
	}
}

Update_Shotgun_Weapon_HUDs(team)
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (!isDefined(player.pers["team"]))
			continue;

		if (player.pers["team"] != team)
			continue;

		if (team == "allies")
		{
			if(level.weaponclass["shotgun"].allies_limited)
				player setClientCvar(level.weapons["shotgun_mp"].client_allowcvar, 0);
			else
				player setClientCvar(level.weapons["shotgun_mp"].client_allowcvar, 1);
		}
		else if (team == "axis")
		{
			if(level.weaponclass["shotgun"].axis_limited)
				player setClientCvar(level.weapons["shotgun_mp"].client_allowcvar, 0);
			else
				player setClientCvar(level.weapons["shotgun_mp"].client_allowcvar, 1);
		}
	}
}

Update_One_Weapon_HUDs(client_dvar, allowed)
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (allowed)
			player setClientCvar(client_dvar, 1);
		else
			player setClientCvar(client_dvar, 0);
	}
}