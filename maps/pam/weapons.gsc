#include maps\mp\_utility;

init()
{
	/*ORIGINAL*/
	switch(game["allies"])
	{
	case "american":
		precacheItem("frag_grenade_american_mp");
		precacheItem("smoke_grenade_american_mp");
		precacheItem("colt_mp");
		precacheItem("m1carbine_mp");
		precacheItem("m1garand_mp");
		precacheItem("thompson_mp");
		precacheItem("bar_mp");
		precacheItem("springfield_mp");
		precacheItem("greasegun_mp");
		precacheItem("shotgun_mp");
		//PAM
		precacheItem("enfield_mp");
		precacheItem("mosin_nagant_mp");
		//precacheItem("30cal_mp");
		//precacheItem("M9_Bazooka");
		break;

	case "british":
		precacheItem("frag_grenade_british_mp");
		precacheItem("smoke_grenade_british_mp");
		precacheItem("webley_mp");
		precacheItem("enfield_mp");
		precacheItem("sten_mp");
		precacheItem("bren_mp");
		precacheItem("enfield_scope_mp");
		precacheItem("m1garand_mp");
		precacheItem("thompson_mp");
		precacheItem("shotgun_mp");
		//precacheItem("30cal_mp");
		//precacheItem("M9_Bazooka");
		break;

	case "russian":
		precacheItem("frag_grenade_russian_mp");
		precacheItem("smoke_grenade_russian_mp");
		precacheItem("TT30_mp");
		precacheItem("mosin_nagant_mp");
		precacheItem("SVT40_mp");
		precacheItem("PPS42_mp");
		precacheItem("ppsh_mp");
		precacheItem("mosin_nagant_sniper_mp");
		precacheItem("shotgun_mp");
		//precacheItem("dp28_mp");
		//precacheItem("M9_Bazooka");
		break;
	}

	precacheItem("frag_grenade_german_mp");
	precacheItem("smoke_grenade_german_mp");
	precacheItem("luger_mp");
	precacheItem("kar98k_mp");
	precacheItem("g43_mp");
	precacheItem("mp40_mp");
	precacheItem("mp44_mp");
	precacheItem("kar98k_sniper_mp");
	precacheItem("shotgun_mp");
	//precacheItem("dp28_mp");
	//precacheItem("panzerfaust_mp");
	//precacheItem("panzerschreck_mp");

	//precacheShader("force_downl");

	precacheItem("binoculars_mp");

	level thread deleteRestrictedWeapons();
	level thread onPlayerConnect();

	for(;;)
	{
		updateAllowed();
		wait level.fps_multiplier * 5;
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedweapons = false;

		player thread updateAllAllowedConnectingClient();
		player thread onPlayerSpawned();
		player thread onPlayerDisconnect();
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");

	maps\pam\weapon_limiter::Update_All_Weapon_Limits();
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		self thread watchWeaponUsage();
	}
}

deleteRestrictedWeapons()
{
	if (!level.allow_turrets)
	{
		deletePlacedEntity("misc_turret");
		deletePlacedEntity("misc_mg42");
	}

	/*
	for(i = 0; i < level.weaponnames.size; i++)
	{
		weaponname = level.weaponnames[i];

		//if(level.weapons[weaponname].allow != 1)
			//deletePlacedEntity(level.weapons[weaponname].radiant_name);
	}

	// Need to not automatically give these to players if I allow restricting them
	// colt_mp
	// webley_mp
	// TT30_mp
	// luger_mp
	// fraggrenade_mp
	// mk1britishfrag_mp
	// rgd-33russianfrag_mp
	// stielhandgranate_mp
	*/
}

givePistol()
{
	weapon2 = self getweaponslotweapon("primaryb");
	if(weapon2 == "none")
	{
		if(self.pers["team"] == "allies")
		{
			switch(game["allies"])
			{
			case "american":
				pistoltype = "colt_mp";
				break;

			case "british":
				pistoltype = "webley_mp";
				break;

			default:
				assert(game["allies"] == "russian");
				pistoltype = "TT30_mp";
				break;
			}
		}
		else
		{
			assert(self.pers["team"] == "axis");
			switch(game["axis"])
			{
			default:
				assert(game["axis"] == "german");
				pistoltype = "luger_mp";
				break;
			}
		}

		self takeWeapon("colt_mp");
		self takeWeapon("webley_mp");
		self takeWeapon("TT30_mp");
		self takeWeapon("luger_mp");

		if (!level.allow_pistols)
			return;

		//self giveWeapon(pistoltype);
		self setWeaponSlotWeapon("primaryb", pistoltype);
		
		mode = getcvar("pam_mode");

		if (mode == "bash")
		{
			self setWeaponSlotAmmo("primaryb",0);
			self setWeaponSlotClipAmmo("primaryb", 0);
		
			wait 0.05;

			self switchToWeapon(pistoltype);
		}
		else
			self giveMaxAmmo(pistoltype);
	}
}

giveGrenades()
{
	self endon("weapon_change");	

	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])
		{
		case "american":
			grenadetype = "frag_grenade_american_mp";
			smokegrenadetype = "smoke_grenade_american_mp";
			break;

		case "british":
			grenadetype = "frag_grenade_british_mp";
			smokegrenadetype = "smoke_grenade_british_mp";
			break;

		default:
			assert(game["allies"] == "russian");
			grenadetype = "frag_grenade_russian_mp";
			smokegrenadetype = "smoke_grenade_russian_mp";
			break;
		}
	}
	else
	{
		assert(self.pers["team"] == "axis");
		switch(game["axis"])
		{
		default:
			assert(game["axis"] == "german");
			grenadetype = "frag_grenade_german_mp";
			smokegrenadetype = "smoke_grenade_german_mp";
			break;
		}
	}

	self takeWeapon("frag_grenade_american_mp");
	self takeWeapon("frag_grenade_british_mp");
	self takeWeapon("frag_grenade_russian_mp");
	self takeWeapon("frag_grenade_german_mp");
	self takeWeapon("smoke_grenade_american_mp");
	self takeWeapon("smoke_grenade_british_mp");
	self takeWeapon("smoke_grenade_russian_mp");
	self takeWeapon("smoke_grenade_german_mp");

	if (isDefined(level.instrattime))
	{
		while (level.instrattime)
		{
			wait level.frame;
		}
	}

	if(getcvarint("scr_allow_fraggrenades"))
	{
		fraggrenadecount = getWeaponBasedGrenadeCount(self.pers["weapon"]);
		if(fraggrenadecount)
		{
			self giveWeapon(grenadetype);
			self setWeaponClipAmmo(grenadetype, fraggrenadecount);
		}
	}

	if(getcvarint("scr_allow_smokegrenades"))
	{
		smokegrenadecount = getWeaponBasedSmokeGrenadeCount(self.pers["weapon"]);
		if(smokegrenadecount)
		{
			self giveWeapon(smokegrenadetype);
			self setWeaponClipAmmo(smokegrenadetype, smokegrenadecount);
		}
	}

	self switchtooffhand(grenadetype);
}

giveBinoculars()
{
	self giveWeapon("binoculars_mp");
}

dropWeapons()
{
	self thread dropWeapon();
	self thread dropOffhand();
}

dropWeapon()
{
	current = self getcurrentweapon();

	if (current == "sprint_weap_mp")
		return;

	if(current != "none")
	{
		weapon1 = self getweaponslotweapon("primary");
		weapon2 = self getweaponslotweapon("primaryb");

		if(current == weapon1)
			currentslot = "primary";
		else
		{
			assert(current == weapon2);
			currentslot = "primaryb";
		}

		clipsize = self getweaponslotclipammo(currentslot);
		reservesize = self getweaponslotammo(currentslot);

		if (level.weapons[current].classname == "sniper" && !level.allow_sniperdrops)
			return;
		if (level.weapons[current].classname == "shotgun" && !level.allow_shotgundrops)
			return;

		if(clipsize || reservesize)
			self dropItem(current);
	}
}

dropOffhand()
{
	current = self getcurrentoffhand();
	if(current != "none")
	{
		ammosize = self getammocount(current);

		if (!level.allow_nadedrops)
			return;

		if(ammosize)
			self dropItem(current);
	}
}

getWeaponBasedGrenadeCount(weapon)
{
	switch (level.weapons[weapon].classname)
	{
	case "sniper":
		return level.snipernades;
	case "boltaction":
		return level.boltactionnades;
	case "semiautomatic":
		return level.semiautonades;
	case "smg":
		return level.smgnades;
	case "mg":
		return level.mgnades;
	case "shotgun":
		return level.shotgunnades;
	default:
		return 2;
	}
}

getWeaponBasedSmokeGrenadeCount(weapon)
{
	switch (level.weapons[weapon].classname)
	{
	case "sniper":
		return level.snipersmokes;
	case "boltaction":
		return level.boltactionsmokes;
	case "semiautomatic":
		return level.semiautosmokes;
	case "smg":
		return level.smgsmokes;
	case "mg":
		return level.mgsmokes;
	case "shotgun":
		return level.shotgunsmokes;
	default:
		return 1;
	}
}

getFragGrenadeCount()
{
	if(self.pers["team"] == "allies")
		grenadetype = "frag_grenade_" + game["allies"] + "_mp";
	else
	{
		assert(self.pers["team"] == "axis");
		grenadetype = "frag_grenade_" + game["axis"] + "_mp";
	}

	count = self getammocount(grenadetype);
	return count;
}

getSmokeGrenadeCount()
{
	if(self.pers["team"] == "allies")
		grenadetype = "smoke_grenade_" + game["allies"] + "_mp";
	else
	{
		assert(self.pers["team"] == "axis");
		grenadetype = "smoke_grenade_" + game["axis"] + "_mp";
	}

	count = self getammocount(grenadetype);
	return count;
}

isPistol(weapon)
{
	switch(weapon)
	{
	case "colt_mp":
	case "webley_mp":
	case "luger_mp":
	case "TT30_mp":
		return true;
	default:
		return false;
	}
}

isMainWeapon(weapon)
{
	// Include any main weapons that can be picked up

	switch(weapon)
	{
	case "greasegun_mp":
	case "m1carbine_mp":
	case "m1garand_mp":
	case "thompson_mp":
	case "bar_mp":
	case "springfield_mp":
	case "sten_mp":
	case "enfield_mp":
	case "bren_mp":
	case "enfield_scope_mp":
	case "mosin_nagant_mp":
	case "SVT40_mp":
	case "PPS42_mp":
	case "ppsh_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_mp":
	case "g43_mp":
	case "mp40_mp":
	case "mp44_mp":
	case "kar98k_sniper_mp":
	case "shotgun_mp":
		return true;
	default:
		return false;
	}
}

restrictWeaponByServerCvars(response)
{
	//Weapon Limiter
	limit_response = self maps\pam\weapon_limiter::onWeaponSelect_Check_Limit(response);
	if (limit_response == "restricted") return limit_response;

	//Force Bolt-Action
	force_response = self maps\pam\force_boltaction::Force_Check(response);
	if (force_response != "no")	return force_response;

	switch(response)
	{
	// All
	case "shotgun_mp":
		if(!getcvarint("scr_allow_shotgun"))
			response = "restricted";
		break;

	// American & British Only
	case "m1garand_mp": 
		if(!getcvarint("scr_allow_m1garand") || self.pers["team"] != "allies" || game["allies"] == "russian")
			response = "restricted";
		break;

	case "thompson_mp": 
		if(!getcvarint("scr_allow_thompson") || self.pers["team"] != "allies" || game["allies"] == "russian")
			response = "restricted";
		break;

	// American Only
	case "m1carbine_mp": 
		if(!getcvarint("scr_allow_m1carbine") || self.pers["team"] != "allies" || game["allies"] != "american")
			response = "restricted";
		break;

	case "bar_mp": 
		if(!getcvarint("scr_allow_bar") || self.pers["team"] != "allies" || game["allies"] != "american")
			response = "restricted";
		break;

	case "springfield_mp": 
		if(!getcvarint("scr_allow_springfield") || self.pers["team"] != "allies" || game["allies"] != "american")
			response = "restricted";
		break;

	case "greasegun_mp": 
		if(!getcvarint("scr_allow_greasegun") || self.pers["team"] != "allies" || game["allies"] != "american")
			response = "restricted";
		break;

	// British
	case "enfield_mp": 
		if(!getcvarint("scr_allow_enfield") || self.pers["team"] != "allies" || game["allies"] != "british")
			response = "restricted";
		break;

	case "sten_mp": 
		if(!getcvarint("scr_allow_sten") || self.pers["team"] != "allies" || game["allies"] != "british")
			response = "restricted";
		break;

	case "bren_mp": 
		if(!getcvarint("scr_allow_bren") || self.pers["team"] != "allies" || game["allies"] != "british")
			response = "restricted";
		break;

	case "enfield_scope_mp": 
		if(!getcvarint("scr_allow_enfieldsniper") || self.pers["team"] != "allies" || game["allies"] != "british")
			response = "restricted";
		break;

	// Russian
	case "mosin_nagant_mp": 
		if(!getcvarint("scr_allow_nagant") || self.pers["team"] != "allies" || game["allies"] != "russian")
			response = "restricted";
		break;

	case "SVT40_mp": 
		if(!getcvarint("scr_allow_svt40") || self.pers["team"] != "allies" || game["allies"] != "russian")
			response = "restricted";
		break;

	case "PPS42_mp": 
		if(!getcvarint("scr_allow_pps42") || self.pers["team"] != "allies" || game["allies"] != "russian")
			response = "restricted";
		break;

	case "ppsh_mp":
		if(!getcvarint("scr_allow_ppsh") || self.pers["team"] != "allies" || game["allies"] != "russian")
			response = "restricted";
		break;

	case "mosin_nagant_sniper_mp": 
		if(!getcvarint("scr_allow_nagantsniper") || self.pers["team"] != "allies" || game["allies"] != "russian")
			response = "restricted";
		break;

	// German
	case "kar98k_mp": 
		if(!getcvarint("scr_allow_kar98k") || self.pers["team"] != "axis")
			response = "restricted";
		break;

	case "g43_mp": 
		if(!getcvarint("scr_allow_g43") || self.pers["team"] != "axis")
			response = "restricted";
		break;

	case "mp40_mp": 
		if(!getcvarint("scr_allow_mp40") || self.pers["team"] != "axis")
			response = "restricted";
		break;

	case "mp44_mp": 
		if(!getcvarint("scr_allow_mp44") || self.pers["team"] != "axis")
			response = "restricted";
		break;

	case "kar98k_sniper_mp": 
		if(!getcvarint("scr_allow_kar98ksniper") || self.pers["team"] != "axis")
			response = "restricted";
		break;

	case "fraggrenade":
		if(!getcvarint("scr_allow_fraggrenades"))
			response = "restricted";
		break;

	case "smokegrenade": 
		if(!getcvarint("scr_allow_smokegrenades"))
			response = "restricted";
		break;

	default:
		response = "restricted";
		break;
	}

	return response;
}

// TODO: This doesn't handle offhands :: DOES NOW! MUhahahaha!
watchWeaponUsage()
{
	level endon("round_started");
	self endon("disconnect");

	self.usedweapons = false;
	spawn_nades = self getFragGrenadeCount();
	spawn_smokes = self getSmokeGrenadeCount();

	while (!self.usedweapons)
	{
		wait level.frame;

		my_nades = self getFragGrenadeCount();
		my_smokes = self getSmokeGrenadeCount();

		if (self attackButtonPressed() || my_nades != spawn_nades || my_smokes != spawn_smokes)
			self.usedweapons = true;
	}
}

getWeaponName(weapon)
{
	switch(weapon)
	{
	// American
	case "m1carbine_mp":
		weaponname = &"WEAPON_M1A1CARBINE";
		break;

	case "m1garand_mp":
		weaponname = &"WEAPON_M1GARAND";
		break;

	case "thompson_mp":
		weaponname = &"WEAPON_THOMPSON";
		break;

	case "bar_mp":
		weaponname = &"WEAPON_BAR";
		break;

	case "springfield_mp":
		weaponname = &"WEAPON_SPRINGFIELD";
		break;

	case "greasegun_mp":
		weaponname = &"WEAPON_GREASEGUN";
		break;

	case "shotgun_mp":
		weaponname = &"WEAPON_SHOTGUN";
		break;

//	case "30cal_mp":
//		weaponname = &"PI_WEAPON_MP_30CAL";
//		break;

//	case "M9_Bazooka":
//		weaponname = &"PI_WEAPON_MP_BAZOOKA";
//		break;

	// British
	case "enfield_mp":
		weaponname = &"WEAPON_LEEENFIELD";
		break;

	case "sten_mp":
		weaponname = &"WEAPON_STEN";
		break;

	case "bren_mp":
		weaponname = &"WEAPON_BREN";
		break;

	case "enfield_scope_mp":
		weaponname = &"WEAPON_SCOPEDLEEENFIELD";
		break;

	// Russian
	case "mosin_nagant_mp":
		weaponname = &"WEAPON_MOSINNAGANT";
		break;

	case "SVT40_mp":
		weaponname = &"WEAPON_SVT40";
		break;

	case "PPS42_mp":
		weaponname = &"WEAPON_PPS42";
		break;

	case "ppsh_mp":
		weaponname = &"WEAPON_PPSH";
		break;

	case "mosin_nagant_sniper_mp":
		weaponname = &"WEAPON_SCOPEDMOSINNAGANT";
		break;

	//German
	case "kar98k_mp":
		weaponname = &"WEAPON_KAR98K";
		break;

	case "g43_mp":
		weaponname = &"WEAPON_G43";
		break;

	case "mp40_mp":
		weaponname = &"WEAPON_MP40";
		break;

	case "mp44_mp":
		weaponname = &"WEAPON_MP44";
		break;

	case "kar98k_sniper_mp":
		weaponname = &"WEAPON_SCOPEDKAR98K";
		break;

//	case "panzerfaust_mp":
//		weaponname = &"WEAPON_PANZERFAUST";
//		break;
//
//	case "panzerschreck_mp":
//		weaponname = &"PI_WEAPON_MP_PANZERSCHRECK";
//		break;
//
//	case "dp28_mp":
//		weaponname = &"PI_WEAPON_MP_DP28";
//		break;

	default:
		weaponname = &"WEAPON_UNKNOWNWEAPON";
		break;
	}

	return weaponname;
}

useAn(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "mp40_mp":
	case "mp44_mp":
	case "shotgun_mp":
		result = true;
		break;

	default:
		result = false;
		break;
	}

	return result;
}

updateAllowed()
{
	for(i = 0; i < level.weaponnames.size; i++)
	{
		weaponname = level.weaponnames[i];

		cvarvalue = getCvarInt(level.weapons[weaponname].server_allowcvar);
		team = level.weapons[weaponname].team;
		classname = level.weapons[weaponname].classname;
		if(level.weapons[weaponname].allow != cvarvalue)
		{
			level.weapons[weaponname].allow = [[level.pam_changed]](level.weapons[weaponname].server_allowcvar, cvarvalue);

			thread maps\pam\weapon_limiter::Update_One_Weapon_HUDs(level.weapons[weaponname].client_allowcvar, cvarvalue);
			wait level.fps_multiplier * .05;
		}
	}
}

updateAllowedAllClients(weaponname, bit)
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] updateAllowedSingleClient(weaponname, bit);
}

updateAllowedSingleClient(weaponname, bit)
{
	self setClientCvar(level.weapons[weaponname].client_allowcvar, bit);
}


updateAllAllowedConnectingClient()
{
	for(i = 0; i < level.weaponnames.size; i++)
	{
		weaponname = level.weaponnames[i];
		weaponclass = level.weapons[weaponname].classname;
		weaponteam = level.weapons[weaponname].team;

		if (weaponteam == "allies")
		{
			if (level.weaponclass[weaponclass].allies_limited || !level.weapons[weaponname].allow)
				self setClientCvar(level.weapons[weaponname].client_allowcvar, 0);
			else
				self setClientCvar(level.weapons[weaponname].client_allowcvar, 1);
		}

		if (weaponteam == "axis")
		{
			if (level.weaponclass[weaponclass].axis_limited || !level.weapons[weaponname].allow)
				self setClientCvar(level.weapons[weaponname].client_allowcvar, 0);
			else
				self setClientCvar(level.weapons[weaponname].client_allowcvar, 1);
		}

		if (level.weapons[weaponname].classname == "shotgun" && !level.weapons[weaponname].allow)
			self setClientCvar(level.weapons[weaponname].client_allowcvar, 0);
		else if (level.weapons[weaponname].classname == "shotgun" && level.weapons[weaponname].allow)
			self setClientCvar(level.weapons[weaponname].client_allowcvar, 1);
	}
}

/*
deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
		entities[i] delete();
}*/