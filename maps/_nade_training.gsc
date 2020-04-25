// * Training Nade Script by Matthias lorenz * (_slightly_ modified by zar & z0d)

go() 
{
	fly_mode = getcvarint("cg_training_nade_fly_mode");
	nadee = self.nadee;
	//nadee = 1;
	
	if(fly_mode != 1 || nadee != 1) 
		return;
	
	self notify("nadescript_ende");
	self endon("nadescript_ende");
	
	//level.nade_go = 1;

	grenade_counter = 0;

	granaten_anzahl_alt	 = self maps\mp\gametypes\_weapons::getFragGrenadeCount();
	smokegranaten_anzahl_alt = self maps\mp\gametypes\_weapons::getSmokeGrenadeCount();

	//while(1) {
	for(;;) {

		fly_mode = getcvarint("cg_training_nade_fly_mode");
		nadee = self.nadee;
	
		if(fly_mode != 1 || nadee != 1) 
		{
			self.mygodmode = 0;
			
			return;
		}
		else if (fly_mode == 1 && nadee == 1)
		{
			self.mygodmode = 1;
 		}

		granaten_anzahl 	= self maps\mp\gametypes\_weapons::getFragGrenadeCount();
		smokegranaten_anzahl 	= self maps\mp\gametypes\_weapons::getSmokeGrenadeCount();
	
		if(granaten_anzahl != granaten_anzahl_alt || smokegranaten_anzahl != smokegranaten_anzahl_alt) {

			//self setWeaponClipAmmo(getFragGrenadeType(), 3);
			//self setWeaponClipAmmo(getSmokeGrenadeType(), 3);
			
			
		
			grenades = getentarray("grenade","classname");

			for(i=0;i<grenades.size;i++) {

				if(isDefined(grenades[i].origin) && !isDefined(grenades[i].running)) {

					
					// * Nur wenn es die eigene Nade ist (Nahe am Player) *
					if(distance(grenades[i].origin, self.origin) < 140) {
					
						grenades[i].running = true;	
						grenades[i] thread Fly(self);									
					}
					
				}
			}
		}
					
		
		
		granaten_anzahl_alt	 = granaten_anzahl;
		smokegranaten_anzahl_alt = smokegranaten_anzahl;
		
		wait 0.1;
	}
}





Fly(player)
{
	player notify("flying_ende");
	player endon("flying_ende");

	old_player_origin = player.origin;	
	
	// * Hilfsobjekt *
	player.hilfsObjekt = spawn("script_model", player.origin );
	player.hilfsObjekt.angles = player.angles;
	player.hilfsObjekt linkto(self);
	
		
	player linkto(player.hilfsObjekt);

	
	time = 2.8;

	
	old_origin = (0,0,0);


	attack_button_pressed = false;
	use_button_pressed = false;

	
	while(isDefined(self)) {
	
		wait 0.1;
		time -= 0.1;
	
			
		if(isDefined(self)) {
		
				
			
			// * solange warten bis Granate sich nicht mehr bewegt *
			if(self.origin == old_origin) {
					
				break;
			}
		
			old_origin = self.origin;
		}
		
		
		if(player attackButtonPressed()) {
			
			attack_button_pressed = true;
			break;
		}
	
		if(player useButtonPressed()) {
				
			use_button_pressed = true;
			break;
		}
		
		
	}
	
	
	
	wait 0.1;

	player.hilfsObjekt unlink();

	
	if(!use_button_pressed) {
	
		if(attack_button_pressed) {

			for(i=0;i<3.5;i+=0.1) {

				wait 0.1;
				if(player useButtonPressed()) break;		
			}
		}
		else {

			player.hilfsObjekt moveto(player.origin+(0,0,20),0.1);
			wait 0.2;

			for(i=0;i<1;i+=0.1) {

				wait 0.1;
				if(player useButtonPressed()) break;	
			}
		}
	}

			
	player.hilfsObjekt moveto(old_player_origin,0.1);
	wait 0.2;
	
	player unlink();	
	if(isDefined(player.hilfsObjekt)) player.hilfsObjekt delete();	
	
	
}		




getFragGrenadeType() {
	
	

	self endon("disconnect");
	self endon("killed_player");


	if(self.pers["team"] == "allies") {
	
		switch(game["allies"]) {
		
		case "american":
			fraggrenadetype = "frag_grenade_american_mp";
						
			break;

		case "british":
			fraggrenadetype = "frag_grenade_british_mp";
						
			break;

		default:
			fraggrenadetype = "frag_grenade_russian_mp";
						
			break;
		}
	}
	else {		
	
		fraggrenadetype = "frag_grenade_german_mp";	
						
	}

	return fraggrenadetype;
}


getSmokeGrenadeType() {
	
	

	self endon("disconnect");
	self endon("killed_player");


	if(self.pers["team"] == "allies") {
	
		switch(game["allies"]) {
		
		case "american":
			smokegrenadetype = "smoke_grenade_american_mp";
			break;

		case "british":
			smokegrenadetype = "smoke_grenade_british_mp";
			break;

		default:
			smokegrenadetype = "smoke_grenade_russian_mp";
			break;
		}
	}
	else {		
	
		smokegrenadetype = "smoke_grenade_german_mp";		
	}



	return smokegrenadetype;
}


// zPAM
_training()
{
	self.nadee = 1;
	for(;;)
	{	
		waittime = 0;
		while (self meleebuttonpressed() && waittime <= 1.5)
		{
			waittime+=0.05;
			wait 0.05;
		}
		//nademode = getcvarint("cg_training_nade_fly_mode");	
		nademode = self.nadee;
		if (waittime >= 1.5 && nademode == 0) {
			//self setClientCvar("cg_training_nade_fly_mode", 1);
			self iprintln("^3Training nade fly mode turned ^1on");
			self.nadee = 1;
			self thread go();
		} else if (waittime >= 1.5 && nademode == 1) {
			//self setClientCvar("cg_training_nade_fly_mode", 0);
			self iprintln("^3Training nade fly mode turned ^1off");
			self.nadee = 0;
			self go();
		}
		wait 0.05;
	}
}

nadelogo1()
{				
	// PRESS A/D
	
	self.pressad = newClientHudElem(self);
	self.pressad.x = 575;
	self.pressad.y = 165; //85
	self.pressad.alignX = "center";
	self.pressad.alignY = "top";
	self.pressad.fontScale = 1.2;
	self.pressad.font = "default";
	self.pressad.color = (.8, 1, 1);

	for(;;)
	{		
		nade1 = self.nadee;	
	
		if (isdefined(nade1) && nade1 == 1)
		{
			self.pressad setText(game["todisable"]); 
		}
		else if (!isdefined(nade1) || nade1 == 0)
		{
			self.pressad setText(game["toenable"]);
		}
	wait 0.05;
	}
	if(isdefined(self.pressad))
		self.pressad destroy();
}
nadelogo2()
{
	// ENABLE / DISABLE
	
	self.nadelogo = newClientHudElem(self);
	self.nadelogo.x = 575;
	self.nadelogo.y = 145; //65
	self.nadelogo.alignX = "center";
	self.nadelogo.alignY = "top";
	self.nadelogo.fontScale = 1.2;
	self.nadelogo.font = "default";

	for(;;)
	{		
		nade1 = self.nadee;	
	
		if (isdefined(nade1) && nade1 == 1)
		{
			self.nadelogo.color = (.73, .99, .73);
			self.nadelogo setText(game["flyenabled"]);
		}
		else if (!isdefined(nade1) || nade1 == 0)
		{
			self.nadelogo.color = (1, .66, .66);
			self.nadelogo setText(game["flydisabled"]);
		}
	wait 0.05;
	}
	if(isdefined(self.nadelogo))
		self.nadelogo destroy();
}

nc()
{ 
	self thread nadelogo1();
	self thread nadelogo2();
}

nadecounter()
{
	self endon("disconnect");
	self.nadec = 0;
	
	for(;;)
	{
		if(self.pers["team"] == "allies") 
		{
			switch(game["allies"]) 
			{
				case "american":
				{	
					if (self.nadechangeAME > self getammocount("frag_grenade_american_mp") && isalive(self)) 
					{
						self.maybenade = 1;
						self.nades++;
						self.hurt = false;
						self.pos = self.origin;
						self thread donadecounter();
					}
					if (isalive(self)) 
						self.nadechangeAME = self getammocount("frag_grenade_american_mp"); 
					else 
						self.nadechangeAME = 1;
		
					wait 0.05;

					break;
				}
				
				case "british":
				{	
					if (self.nadechangeBRI > self getammocount("frag_grenade_british_mp") && isalive(self)) 
					{
						self.maybenade = 1;
						self.nades++;
						self.hurt = false;
						self.pos = self.origin;
						self thread donadecounter();
					}
					if (isalive(self)) 
						self.nadechangeBRI = self getammocount("frag_grenade_british_mp"); 
					else 
						self.nadechangeBRI = 1;
		
					wait 0.05;
			
					break;
				}
				
				default:
				{	
					if (self.nadechangeRUS > self getammocount("frag_grenade_russian_mp") && isalive(self)) 
					{
						self.maybenade = 1;
						self.nades++;
						self.hurt = false;
						self.pos = self.origin;
						self thread donadecounter();
					}
					if (isalive(self)) 
						self.nadechangeRUS = self getammocount("frag_grenade_russian_mp"); 
					else 
						self.nadechangeRUS = 1;
		
					wait 0.05;
				
					break;
				}

			}
		}
		else if (self.pers["team"] == "axis")
		{
			if (self.nadechangeGER > self getammocount("frag_grenade_german_mp") && isalive(self)) 
			{
				self.maybenade = 1;
				self.nades++;
				self.hurt = false;
				self.pos = self.origin;
				self thread donadecounter();
			}
			if (isalive(self)) 
				self.nadechangeGER = self getammocount("frag_grenade_german_mp"); 
			else 
				self.nadechangeGER = 1;
			
			wait 0.05;
	
				//break;
		}
	wait 0.05;
	}
}

smokecounter()
{
	self endon("disconnect");
	self.smokec = 0;
	
	for(;;)
	{
		if(self.pers["team"] == "allies") 
		{
			switch(game["allies"]) 
			{
				case "american":
				{	
					if (self.smokechangeAME > self getammocount("smoke_grenade_american_mp") && isalive(self)) 
					{
						self.maybenade = 1;
						self.nades++;
						self.hurt = false;
						self.pos = self.origin;
						self thread dosmokecounter();
					}
					if (isalive(self)) 
						self.smokechangeAME = self getammocount("smoke_grenade_american_mp"); 
					else 
						self.smokechangeAME = 0;
		
					wait 0.05;

				
					break;
				}
				
				case "british":
				{	
					if (self.smokechangeBRI > self getammocount("smoke_grenade_british_mp") && isalive(self)) 
					{
						self.maybenade = 1;
						self.nades++;
						self.hurt = false;
						self.pos = self.origin;
						self thread dosmokecounter();
					}
					if (isalive(self)) 
						self.smokechangeBRI = self getammocount("smoke_grenade_british_mp"); 
					else 
						self.smokechangeBRI = 0;
		
					wait 0.05;
			
					break;
				}
				
				default:
				{	
					if (self.smokechangeRUS > self getammocount("smoke_grenade_russian_mp") && isalive(self)) 
					{
						self.maybenade = 1;
						self.nades++;
						self.hurt = false;
						self.pos = self.origin;
						self thread dosmokecounter();
					}
					if (isalive(self)) 
						self.smokechangeRUS = self getammocount("smoke_grenade_russian_mp"); 
					else 
						self.smokechangeRUS = 0;
		
					wait 0.05;
				
					break;
				}

			}
		}
		else
		{
			if (self.smokechangeGER > self getammocount("smoke_grenade_german_mp") && isalive(self)) 
			{
				self.maybenade = 1;
				self.nades++;
				self.hurt = false;
				self.pos = self.origin;
				self thread dosmokecounter();
			}
			if (isalive(self)) 
				self.smokechangeGER = self getammocount("smoke_grenade_german_mp"); 
			else 
				self.smokechangeGER = 0;
		
			wait 0.05;
			
			//break;
		}
	}
}


donadecounter()
{
	self.nadec++;
	self.res = getcvar("r_mode");

	if (isdefined(self.c)) 
		self.c destroy();

	if(isdefined(self.exin))
		self.exin destroy();

	self.exin = newClientHudElem(self);
	self.exin.x = 535; 
	self.exin.y = 185;
	self.exin.alignX = "center";
	self.exin.alignY = "top";
	self.exin.fontScale = 1.2;
	self.exin.color = (.8, 1, 1);
	self.exin setText(&"Grenade explodes in");
	
	self.c = newClientHudElem(self);		
	self.c.x = 615;
	self.c.y = 185;
	self.c.alignX = "center";
	self.c.alignY = "top";
	self.c settenthsTimer(3.5);
	self.c.color = (.8, 1, 1);
	self.c.fontScale = 1.2;
	wait level.fps_multiplier * 3.5;
	self.nadec--;
	
	if (self.nadec == 0) 
	{
		self.c destroy();
		self.exin destroy();
	}
}

dosmokecounter()
{
	self.smokec++;

	if (isdefined(self.c2)) 
		self.c2 destroy();

	if(isdefined(self.exin2))
		self.exin2 destroy();

	self.exin2 = newClientHudElem(self);
	self.exin2.x = 505; 
	self.exin2.y = 202;
	self.exin2.alignY = "top";
	self.exin2.fontScale = 1.2;
	self.exin2.color = (1, 1, 0);
	self.exin2 setText(&"Smoke releases in");
	
	self.c2 = newClientHudElem(self);				
	self.c2.x = 609;
	self.c2.y = 202;
	self.c2 settenthsTimer(3.4);
	self.c2.color = (1, 1, 0);
	self.c2.fontScale = 1.2;
	wait 3.5;
	self.smokec--;
	
	if (self.smokec == 0) 
	{
		self.c2 destroy();
		self.exin2 destroy();
	}
}	