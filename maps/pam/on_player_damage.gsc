onPlayer_Damage(Inflictor, Attacker, Damage, iDFlags, MeansOfDeath, Weapon, Point, Dir, HitLoc, OffsetTime)
{
	prevent_damage = true;

	gametype = getcvar("g_gametype");
	
	roundended = false;
	roundendedkill = false;
	
	if (gametype == "sd")
	{
		if ( (isDefined(level.roundended) && level.roundended) || (isDefined(level.mapended) && level.mapended ) )
		{	
			//wait 5; // dodano i trebalo bi omogucit ubijanje nakon kaj je runda gotova
			roundendedkill = true;
			roundended = true;
		}
	}
	else if ( (gametype == "dm" && game["mode"] != "pub") || (gametype == "hq" && game["mode"] != "pub") || (gametype == "tdm" && game["mode"] != "pub") || (gametype == "ctf" && game["mode"] != "pub"))
	{
		if ( (isDefined(level.roundended) && level.roundended) || (isDefined(level.mapended) && level.mapended ) || !game["matchstarted"] || !isDefined(game["firstreadyupdone"]) )
		{	
			roundended = true;
			roundendedkill = true;
		}
	}


	if(level.rdyup)
	{
		if (isPlayer(Attacker) && self != Attacker)
			Attacker.pers["killer"] = 1;
		
		if (!self.pers["killer"])
			return prevent_damage;
	}

	if (isPlayer(Attacker) && self.pers["team"] == Attacker.pers["team"] && Attacker.pers["tker_reflect"])
	{
		Damage = int(Damage * .5);
		if(Damage < 1)
			Damage = 1;

		Attacker.friendlydamage = true;
		Attacker finishPlayerDamage(Inflictor, Attacker, Damage, iDFlags, MeansOfDeath, Weapon, Point, Dir, HitLoc, OffsetTime);
		Attacker.friendlydamage = undefined;

		return prevent_damage;
	}
	
	if(level.warmup)
		return prevent_damage;


	if (isdefined(level.instrattime) && level.instrattime)
		return prevent_damage;

	//gametype = getcvar("g_gametype");
	mode = getcvar("pam_mode");

	if (gametype == "sd" && (mode == "pub" || mode == "pub_rifle"))
	{
		if( level.roundendedkill && !level.warmup && !level.rdyup ) // umjesto roudnended staviti level.roundendedkill i onda nakon 5 sec se moze ubijat
			return prevent_damage;
	} else
	{
		if( roundended && !level.warmup && !level.rdyup ) // umjesto roudnended staviti level.roundendedkill i onda nakon 5 sec se moze ubijat
			return prevent_damage;
	}

	// Passed all checks, allow damage
	return false;
}