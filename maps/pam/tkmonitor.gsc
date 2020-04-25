TK_Monitor_Init()
{
	if (getcvar("tk_monitor") == "" || getcvarint("tk_monitor") < 1)
	{
		level.tk_monitor = 0;
		return;
	}
	else
		level.tk_monitor = 1;

	if (getcvar("tk_punish_type") == "" || (getcvar("tk_punish_type") != "kick" && getcvar("tk_punish_type") != "pb_kick") )
		setcvar("tk_punish_type", "reflect");
	level.tk_punish_type = getcvar("tk_punish_type");

	if (getcvar("tk_punishtime") == "")
		setcvar("tk_punishtime", "240");
	else if (getcvarint("tk_punishtime") < 0)
		setcvar("tk_punishtime", "0");
	else if (getcvarint("tk_punishtime") > 9999)
		setcvar("tk_punishtime", "9999");
	level.tk_punishtime = getcvarint("tk_punishtime");

	if (getcvar("tk_limit") == "")
		setcvar("tk_limit", "3");
	else if (getcvarint("tk_limit") < 2)
		setcvar("tk_limit", "2");
	else if (getcvarint("tk_limit") > 10)
		setcvar("tk_limit", "10");
	level.tk_limit = getcvarint("tk_limit");
}

SetupPlayerTKMonitor()
{

	if (!isDefined(self.pers["tkcount"]))
	{
		self.pers["tkcount"] = 0;
		self.pers["tktimer"] = 0;
		self.pers["tker_reflect"] = 0;
	}
}

TK_Monitor(attacker)
{
	if (!isdefined(self) || !isDefined(attacker) || !isPlayer(attacker))
		return;

	if (!level.tk_monitor)
		return;

	//See if this kill is a TK
	if ( (self.pers["team"] != attacker.pers["team"] && attacker.pers["team"] != "spectator") || self == attacker)
		return;

	if (!isdefined(attacker.pers["tkcount"]))
		attacker.pers["tkcount"] = 0;

	attacker.pers["tkcount"]++;

	if (attacker.pers["tkcount"] >= level.tk_limit)
	{
		if (level.tk_punish_type == "reflect")
		{
			attacker.pers["tker_reflect"] = 1;
			wait level.fps_multiplier * 1;
			if (level.gametype != "sd")
			{
				attacker iprintlnbold("^3TK Reflection Now Active for ^1" + level.tk_punishtime + "^3 seconds");
				attacker thread Reflect_Timer();
			}
			else
				attacker iprintlnbold("^3TK Reflection Now Active for the rest of this map");
		}
		else
			attacker thread deal_with_me();
	}
	else
		attacker thread TK_Warn();
}

TK_Warn()
{
	self endon("disconnect");

	remainder = level.tk_limit - self.pers["tkcount"];

	self iprintlnbold("^1Team Killing will NOT be tolerated!");
	if (remainder == 1)
		self iprintlnbold("^5" + remainder + " ^3teamkill remaining");
	else
		self iprintlnbold("^5" + remainder + " ^3teamkills remaining");
}

Reflect_Timer()
{
	self endon("disconnect");

	if (!level.tk_punishtime)
		return;

	wait level.fps_multiplier * level.tk_punishtime;

	self.pers["tker_reflect"] = 0;
	self iprintlnbold("^3TK Reflection Released");
}

deal_with_me()
{
	self endon("disconnect");

	if (level.tk_punish_type == "pb_kick")
		self.score = -10;
	else
	{
		userid = self getEntityNumber();
		iprintln("^3Admin: Kicking ^7" + self.name + " ^3for ^1Team Killing!");
		wait level.fps_multiplier * 2;
		kick(userid);
	}
}