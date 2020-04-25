init()
{
	precacheShader("headicon_dead");

	if(level.deathicon)
	{
		level.deathicons["allies"] = spawnstruct();
		level.deathicons["allies"].array = [];
		level.deathicons["axis"] = spawnstruct();
		level.deathicons["axis"].array = [];
		level.deathicons["spectator"] = spawnstruct();
		level.deathicons["spectator"].array = [];

		level thread onPlayerConnect();
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onPlayerDisconnect();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		removeDeathIcon(self.clientid);
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	
	removeDeathIcon(self.clientid);
}

addDeathIcon(entity, id, team, timeout)
{
	if(getCvar("scr_ctf_deathicon") == "")
		setCvar("scr_ctf_deathicon", "0");
	level.deathicon = getCvarInt("scr_ctf_deathicon");
        if(level.deathicon == 1)
       {
	assert(team == "allies" || team == "axis");

	newdeathicon = newTeamHudElem(team);
	newdeathicon.id = id;
	newdeathicon.x = entity.origin[0];
	newdeathicon.y = entity.origin[1];
	newdeathicon.z = entity.origin[2] + 54;
	newdeathicon.alpha = .61;
	newdeathicon.archived = true;
	newdeathicon setShader("headicon_dead", 7, 7); // 56.8% of on screen headicons size
	newdeathicon setwaypoint(true);
	level.deathicons[team].array[level.deathicons[team].array.size] = newdeathicon;

	newdeathicon = newTeamHudElem("spectator");
	newdeathicon.id = id;
	newdeathicon.x = entity.origin[0];
	newdeathicon.y = entity.origin[1];
	newdeathicon.z = entity.origin[2] + 54;
	newdeathicon.alpha = .61;
	newdeathicon.archived = true;
	newdeathicon setShader("headicon_dead", 7, 7); // 56.8% of on screen headicons size
	newdeathicon setwaypoint(true);
	level.deathicons["spectator"].array[level.deathicons["spectator"].array.size] = newdeathicon;
	
//	println("ADDED ID: ", id, " to ", team, " array");
//	println("ADDED ID: ", id, " to spectator array");
	
	if(isdefined(timeout))
	{
		wait level.fps_multiplier * timeout;
		removeDeathIcon(id);
	}
     }
     else return;
}

removeDeathIcon(id)
{
	for(i = 0; i < 3; i++)
	{
		if(i == 0)
			team = "allies";
		else if(i == 1)
			team = "axis";
		else
			team = "spectator";

		removeElement = undefined;
		
		for(j = 0; j < level.deathicons[team].array.size; j++)
		{
			if(level.deathicons[team].array[j].id != id)
				continue;
				
			removeElement = level.deathicons[team].array[j];
			break;
		}
		
		if(isdefined(removeElement))
		{
			lastElement = level.deathicons[team].array.size - 1;
			
			for(j = 0; j < level.deathicons[team].array.size; j++)
			{
			    if(level.deathicons[team].array[j] != removeElement)
			        continue;
			        
			    level.deathicons[team].array[j] = level.deathicons[team].array[lastElement];
			    level.deathicons[team].array[lastElement] = undefined;
			    break;
			}
			
			removeElement destroy();
			
//			println("REMOVED ID: ", id, " from ", team, " array");
		}
	}
}

