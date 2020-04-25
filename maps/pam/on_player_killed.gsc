onPlayer_Killed(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	prevent_death = true;

	roundended = false;
	roundendedkill = false;
	if (isDefined(level.roundended) && level.roundended )
	{
		roundended = true;
		roundendedkill = true;
	}

	if (!isDefined(attacker))
		attacker = undefined;

	if(level.rdyup && !self.pers["killer"] && self != attacker )
		return prevent_death;

	if(level.warmup)
		return prevent_death;

	gametype = getcvar("g_gametype");
	mode = getcvar("pam_mode");

	if (gametype == "sd" && (mode == "pub" || mode == "pub_rifle"))
	{	
		if( level.roundendedkill && !level.warmup && !level.rdyup) // umjesto roundended staviti level.roundendedkill i nakon 5 sec se jos moze ubijat
			return prevent_death;
	} else 
	{
		if( roundended && !level.warmup && !level.rdyup) // umjesto roundended staviti level.roundendedkill i nakon 5 sec se jos moze ubijat
			return prevent_death;
	}

	if ( level.rdyup && !isdefined(self.switching_teams) )
	{
		self.deaths--;
		self.pers["deaths"] = self.deaths;
	}
	else if ( !level.rdyup )
		self.statusicon = "hud_status_dead";

	//Healthpacks
	if (level.healthpacks)
		thread maps\pam\healthpacks::dropHealth();

	if (level.rdyup && isPlayer(attacker) && self != attacker)
	{
		if (!isdefined(attacker.ru_kills))
			attacker.ru_kills = 1;
		else
			attacker.ru_kills++;
	}

	// TK Monitor
	if (game["mode"] != "match" && isDefined(attacker) && level.gametype != "dm")
		self thread maps\pam\tkmonitor::TK_Monitor(attacker);

	// Weapon/Nade Drops
	if (!level.rdyup)
		self thread maps\pam\weapons::dropWeapons();

	// Passed all checks, allow death
	return false;
}