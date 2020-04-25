// * SavePosition mod by Leveller * (_slightly_ modified by z0d)

_MeleeKey()
{
	self endon("end_saveposition_threads");

	for(;;)
	{
		if(self meleeButtonPressed())
		{
			catch_next = false;

			for(i=0; i<=0.10; i+=0.01)
			{
				if(catch_next && self meleeButtonPressed())
				{
					self thread savePos();
					wait 1;
					break;
				}
				else if(!(self meleeButtonPressed()))
					catch_next = true;
					
				wait 0.01;
			}
		}
		wait 0.05;
	}
}

_UseKey()
{
	self endon("end_saveposition_threads");

	for(;;)
	{
		if(self useButtonPressed())
		{
			catch_next = false;

			for(i=0; i<=0.10; i+=0.01)
			{
				if(catch_next && self useButtonPressed())
				{
					self thread loadPos();
					wait 1;
					break;
				}
				else if(!(self useButtonPressed()))
					catch_next = true;

				wait 0.01;
			}
		}

		wait 0.05;
	}
}

loadPos()
{
	if(!isDefined(self.saved_origin))
		{
			self iprintln("^1There is no previous ^3position ^1to load");
			return;
		}
	else
		{
			self setPlayerAngles(self.saved_angles); 
			self setOrigin(self.saved_origin);
			self iprintln("^3Position ^1loaded"); 
		}

}


savePos()
{
	self.saved_origin = self.origin;
	self.saved_angles = self.angles;
	self iprintln("^3Position ^1saved");
}

showlogo()
{
	if(isdefined(level.pamlogo))
		level.pamlogo destroy();
	if(isdefined(level.positionlogo))
		level.positionlogo destroy();
	if(isdefined(level.savelogo))
		level.savelogo destroy();
	if(isdefined(level.loadlogo))
		level.loadlogo destroy();
	if(isdefined(level.savelogo2))
		level.savelogo2 destroy();
	if(isdefined(level.loadlogo2))
		level.loadlogo2 destroy();
	if(isdefined(level.granade1))
		level.granade1 destroy();

	level.pamlogo = newHudElem();
	level.pamlogo.x = 575;
	level.pamlogo.y = 20;
	level.pamlogo.alignX = "center";
	level.pamlogo.alignY = "top";
	level.pamlogo.fontScale = 1.2;
	level.pamlogo.color = (.8, 1, 1);
	level.pamlogo setText(&"zPAM v2.07");
	
	pammodes = newHudElem();
	if (getCvarInt("scr_clock_position") == 1)
	{
		pammodes.x = 10;
		pammodes.y = 2;
	}
	else
	{
		pammodes.x = 50;
		pammodes.y = 11;
	}
	pammodes.alignX = "left";
	pammodes.alignY = "top";
	pammodes.fontScale = 1.2;
	pammodes.color = (1, 1, 0);
	pammodes setText(&"Strategy Planning Mode");
	
	level.positionlogo = newHudElem();
	level.positionlogo.x = 575; 
	level.positionlogo.y = 45; //145
	level.positionlogo.alignX = "center";
	level.positionlogo.alignY = "top";
	level.positionlogo.fontScale = 1.2;
	level.positionlogo.color = (.8, 1, 1);
	level.positionlogo setText(&"Position");

	level.savelogo = newHudElem();
	level.savelogo.x = 575;
	level.savelogo.y = 65; //165
	level.savelogo.alignX = "center";
	level.savelogo.alignY = "top";
	level.savelogo.fontScale = 1.2;
	level.savelogo.color = (.8, 1, 1);
	level.savelogo setText(&"Save: Press ^3[{+melee_breath}] ^7twice");

	level.loadlogo = newHudElem();
	level.loadlogo.x = 575;
	level.loadlogo.y = 85; //185
	level.loadlogo.alignX = "center";
	level.loadlogo.alignY = "top";
	level.loadlogo.fontScale = 1.2;
	level.loadlogo.color = (.8, 1, 1);
	level.loadlogo setText(&"Load: Press ^3[{+activate}] ^7twice");	

	level.granade1 = newHudElem();
	level.granade1.x = 575; 
	level.granade1.y = 125; //45
	level.granade1.alignX = "center";
	level.granade1.alignY = "top";
	level.granade1.fontScale = 1.2;
	level.granade1.color = (.8, 1, 1);
	level.granade1 setText(&"Grenade training");
}