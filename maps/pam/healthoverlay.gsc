//||||||||||||||||||||||||||||||||||||||||||||||||||||||
//  Developed by Wanna Ganoush -- www.anarchic-x.com
//  HEAVILY modified by worm for PAM2
//||||||||||||||||||||||||||||||||||||||||||||||||||||||
//  healModel is set with cvar "scr_allow_health_regen"
//    = "0" : turns OFF the health regen system
//    = "1" : implements IW's "flawed" model (default)
//	  = "2" : implements my "smooth" regen model
//    = "3" : implements my "healing regen limits" model
//	  = "4" : implements "healing regen limits" and "pain"
//||||||||||||||||||||||||||||||||||||||||||||||||||||||

init()
{
	precacheShader("overlay_low_health");

	level.regen_sounds = 1;
	if (getcvar("scr_allow_regen_sounds") != "" && getcvarint("scr_allow_regen_sounds") < 1)
		level.regen_sounds = 0;

	if(level.regen_model)
	{
		level.healthOverlayCutoff = 0.45;
		level thread onPlayerConnect();
	}
 }

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerDisconnect();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self notify("end_healthregen");
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self notify("end_healthregen");
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread playerHealthRegen();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
		self notify("end_healthregen");
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	self notify("end_healthregen");
}

playerHealthRegen()
{
	level.regen_per_sec = 2;
	health_tick = 0;
	self endon("end_healthregen");

	maxhealth = self.health;
	oldhealth = maxhealth;
	player = self;

	gapHealth = 0;
	gapRecoverRatio = 0;
	sustainHealth = 0;
	sustainRegenRate = 0;
	woundGroan = 0;

	
	regenRate = 0.1; // 0.017;
	veryHurt = false;
	
	if (level.regen_sounds)
		thread playerBreathingSound(maxhealth * .45);

	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;
    //--------------V
    lastTime = 0;
	for (;;)
	{
		wait level.frame;
		if (player.health == maxhealth)
		{
			veryHurt = false;
			continue;
		}
					
		if (player.health <= 0)
			return;

		if (player.health < oldhealth)
		{
				gapHealth = (maxHealth - player.health);
				gapRecoverRatio = ((100 - gapHealth)/100);
				sustainHealth = int(player.health + (gapHealth * gapRecoverRatio));
				sustainRegenRate = regenRate * (gapRecoverRatio + .5);
				hurtTime = gettime();
		}
		wasVeryHurt = veryHurt;
		ratio = player.health / maxHealth;
		if (ratio <= level.healthOverlayCutoff)
			veryHurt = true;
			
		if (player.health >= oldhealth)
		{
			if (gettime() - hurttime < level.playerHealth_RegularRegenDelay)
				continue;

			if (gettime() - lastSoundTime_Recover > level.playerHealth_RegularRegenDelay)
			{
				if ( veryHurt && level.regen_model != 4)
				{
					lastSoundTime_Recover = gettime();
					if (level.regen_sounds)
						self playLocalSound("breathing_better");
				}
			}

			if (level.regen_model > 2 && player.health >= sustainHealth)
				continue;
	
			if (veryHurt)
			{
				newHealth = ratio;
				//if(level.regen_model < 3)
				lastTime = hurtTime;

				if (gettime() > lastTime + 3000)
				{
					if(level.regen_model == 1)
					{
						newHealth += regenRate;
					}
					else
					{
						health_tick++;
						if (health_tick == 20)
						{
							player.health = player.health + level.regen_per_sec;
							if (player.health > maxhealth)
								player.health = maxhealth;

							if (level.regen_model > 2 && player.health > sustainHealth)
								player.health = sustainHealth;

							health_tick = 0;
						}
					}
					
					//lastTime = getTime();
				}
			}
			else
			{
				newHealth = ratio;
				//if(level.regen_model < 3)
				lastTime = hurtTime;

				if (gettime() > lastTime + 3000)
				{
					if(level.regen_model < 2)
					{
						newHealth =1;
					}
					else
					{
						health_tick++;
						if (health_tick == 20)
						{
							player.health = player.health + level.regen_per_sec;
							if (player.health > maxhealth)
								player.health = maxhealth;

							if (level.regen_model > 2 && player.health > sustainHealth)
								player.health = sustainHealth;

							health_tick = 0;
						}
					}

					//lastTime = getTime();
				}
			
			}
							
			if (newHealth > 1.0)
				newHealth = 1.0;
				
			if (newHealth <= 0)
			{
				// Player is dead
				player.health = 0;
				return;
			}
			
			if (level.regen_model == 1)
				player setnormalhealth (newHealth);

			oldhealth = player.health;
			continue;
		}

		oldhealth = player.health;
			
		hurtTime = gettime();
	}	
}

playerBreathingSound(healthcap)
{
	self endon("end_healthregen");
	
	wait level.fps_multiplier * 2;
	player = self;
	for (;;)
	{
		wait level.fps_multiplier * 0.2;
		if (player.health <= 0)
			return;
			
		// Player still has a lot of health so no breathing sound
		if (player.health >= healthcap)
			continue;
			
		player playLocalSound("breathing_hurt");
		wait level.fps_multiplier * .784;
		wait level.fps_multiplier * (0.1 + randomfloat (0.8));
	}
}