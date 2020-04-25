dropHealth()
{
    if(isDefined(game["healthpacks"][game["currenthealthpack"]]))
		game["healthpacks"][game["currenthealthpack"]] delete();
     
	item_healthpack = spawn("script_model", (0,0,0));	
	item_healthpack setModel(game["Item_Healthpack"]);
	item_healthpack.targetname = "item_health";
	item_healthpack hide();    
	item_healthpack.origin = self.origin + (0, 0, 1);
	item_healthpack.angles = (0, randomint(360), 0);
	item_healthpack show(); 

	item_healthpack thread Healthpack_Think();

    game["healthpacks"][game["currenthealthpack"]] = item_healthpack;
    game["currenthealthpack"]++;

	if(game["currenthealthpack"] >= 12)
		game["currenthealthpack"] = 0;
}

Healthpack_Think()
{
	while(1)
	{
		wait level.fps_multiplier * 0.2;
		
		if(!isDefined(self))
			return;
		
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++) {             

			player = players[i];
  		
			if(player.sessionstate == "playing" && distance(self.origin,player.origin) < 50 && player.health < player.maxhealth)
			{
							
				player endon("disconnect");
				
				player.health = player.health+33;

				if(player.health > player.maxhealth) 
					player.health = player.maxhealth;
				
				player playLocalSound("health_pickup_small");  

				if(isDefined(self)) 
					self delete();
				
				return;
			}
		}				
	}
}