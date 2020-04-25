_respawn() {
    self endon("disconnect");
    self notify("spawned");
    resettimeout();
    self.spectatorclient = -1;
    self.archivetime = 0;
    self.psoffsettime = 0;
    self.maxhealth = 100;
    self.health = self.maxhealth;
    self.sessionstate = "playing";
    self spawn(self.origin, self.angles);
    self giveWeapon(self.pers["weapon"]);
    self giveMaxAmmo(self.pers["weapon"]);
    self setSpawnWeapon(self.pers["weapon"]);
    maps\mp\gametypes\_weapons::givePistol();
    maps\mp\gametypes\_weapons::giveGrenades();
    maps\mp\gametypes\_weapons::giveBinoculars();
    self.pers["team"] = self.sessionteam;
    self.spawned = true;
    level maps\mp\gametypes\sd::updateTeamStatus();
    self notify("spawned_player");

    self detachAll();
    if (self.pers["team"] == "allies")
        [[game["allies_model"]]]();
    else if (self.pers["team"] == "axis")
        [[game["axis_model"]]]();

    if (self.sessionteam == "allies") {
        self.headicon = game["headicon_allies"];
        self.headiconteam = "allies";
    }
    if (self.sessionteam == "axis") {
        self.headicon = game["headicon_axis"];
        self.headiconteam = "axis";
    }
    self.statusicon = "";
    self.pers["savedmodel"] = maps\mp\_utility::saveModel();
    level maps\mp\gametypes\sd::updateTeamStatus();
}

_switchModel() {
    if (self.sessionteam == "allies")
        self.sessionteam = "axis";
      else if (self.sessionteam == "axis")
        self.sessionteam = "allies";

      self detachAll();
      if (self.pers["team"] == "allies")
        [[game["axis_model"]]]();
      else if (self.pers["team"] == "axis")
        [[game["allies_model"]]]();

      if (self.sessionteam == "allies") {
        self.headicon = game["headicon_allies"];
        self.headiconteam = "allies";
      }
      if (self.sessionteam == "axis") {
        self.headicon = game["headicon_axis"];
        self.headiconteam = "axis";
      }
      if (self.pers["team"] == "allies")
        self.pers["team"] = "axis";
      else
        self.pers["team"] = "allies";

      self.pers["savedmodel"] = maps\mp\_utility::saveModel();
      level maps\mp\gametypes\sd::updateTeamStatus();
}

_hidden() {
    uber\uber::hidden();
    wait 5;
    uber\uber::hidden();
}

respawn() {
    _respawn();
}

respawnHidden() {
    _respawn();
    _hidden();
}

respawnSwitch() {
    _respawn();
    _switchModel();
}

respawnSwitchHidden() {
    _respawn();
    _switchModel();
    _hidden();
}