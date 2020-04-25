Monitor_Weapon_Drop()
{
	self endon("disconnect");
	self endon("killed_player");

	if (!level.allow_secondary_drop)
		return;

	while (1)
	{
		timer = 0;
		primary = self getWeaponSlotWeapon("primary");
		primaryb = self getWeaponSlotWeapon("primaryb");
		current = self getcurrentweapon();

		while (self UseButtonPressed() && isDefined(primary) && isDefined(primaryb) && primaryb == current && !self.bombinteraction)
		{
			timer = timer + .1;

			if (timer > 1.6)
			{
				self dropItem(self getcurrentweapon());

				primary = self getWeaponSlotWeapon("primary");
				if (isDefined(primary) && primary != "none")
					self switchToWeapon(primary);
			}

			wait level.frame * 2;
			current = self getcurrentweapon();
		}

		wait level.fps_multiplier * .5;
	}
}

Weapon_Switch_Monitor_Setup()
{
	level.weapondeletes = [];
	i=0;

	if (!level.allow_sniperdrops && level.weaponclass["sniper"].limit > 0)
	{
		if( game["allies"] == "american" && getcvarint("scr_allow_springfield") )
		{
			level.weapondeletes[i] = "springfield_mp";
			i++;
		}
		else if( game["allies"] == "british" && getcvarint("scr_allow_enfieldsniper") )
		{
			level.weapondeletes[i] = "enfield_scope_mp";
			i++;
		}
		else if( game["allies"] == "russian" && getcvarint("scr_allow_nagantsniper") )
		{
			level.weapondeletes[i] = "mosin_nagant_sniper_mp";
			i++;
		}
		
		// ZPAM
		else if( (game["allies"] == "russian" || game["allies"] == "american" || game["allies"] == "british") && getcvarint("scr_allow_nagantsniper_allies"))
		{
			level.weapondeletes[i] = "mosin_nagant_sniper_allies_mp";
			i++;
		}
		else if( (game["allies"] == "russian" || game["allies"] == "american" || game["allies"] == "british") && getcvarint("scr_allow_springfield_allies"))
		{
			level.weapondeletes[i] = "springfield_allies_mp";
			i++;
		}
		else if( (game["allies"] == "russian" || game["allies"] == "american" || game["allies"] == "british") && getcvarint("scr_allow_kar98ksniper_allies"))
		{
			level.weapondeletes[i] = "kar98k_sniper_allies_mp";
			i++;
		}
		else if( (game["allies"] == "russian" || game["allies"] == "american" || game["allies"] == "british") && getcvarint("scr_allow_enfieldsniper_allies"))
		{
			level.weapondeletes[i] = "enfield_scope_allies_mp";
			i++;
		}
		
		if( getcvarint("scr_allow_kar98ksniper") )
		{
			level.weapondeletes[i] = "kar98k_sniper_mp";
			i++;
		}
		
		// ZPAM
		else if (getcvarint("scr_allow_nagantsniper_axis") )
		{
			level.weapondeletes[i] = "mosin_nagant_sniper_axis_mp";
			i++;
		}
		else if (getcvarint("scr_allow_springfield_axis") )
		{
			level.weapondeletes[i] = "springfield_axis_mp";
			i++;
		}
		else if (getcvarint("scr_allow_kar98ksniper_axis") )
		{
			level.weapondeletes[i] = "kar98k_sniper_axis_mp";
			i++;
		}
		else if (getcvarint("scr_allow_enfieldsniper_axis") )
		{
			level.weapondeletes[i] = "enfield_scope_axis_mp";
			i++;
		}
	}

	if ( !level.allow_shotgundrops && level.weaponclass["shotgun"].limit > 0 && getcvarint("scr_allow_shotgun") )
	{
		level.weapondeletes[i] = "shotgun_mp";
		i++;
	}

	if (i)
		level thread Delete_Swapped_Weapons();
}

Delete_Swapped_Weapons()
{
	while (1)
	{
		wait level.fps_multiplier * .25;

		for (i=0 ; i<level.weapondeletes.size ; i++)
		{
			deletePlacedEntity(level.weapondeletes[i]);
		}

	}
}

deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
		entities[i] delete();
}