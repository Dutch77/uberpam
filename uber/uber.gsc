/*
yes, yes the code is a mess, I'm no programmer :D
website: www.uberpam.tk or www.dutch.tym.cz
(c) Dutch
*/

precacheUberModels() {
    precachemodel("xmodel/vehicle_panzer_ii");
    precachemodel("xmodel/vehicle_panzer_ii_destroyed");
    precachemodel("xmodel/light_lantern_off");
    precachemodel("xmodel/furniture_plainchair");
    precachemodel("xmodel/furniture_duhoc_bunker_table");
    precachemodel("xmodel/prop_tractor");
    precachemodel("xmodel/vehicle_stuka_flying");
    precachemodel("xmodel/prop_mortar_ammunition");
    precacheModel("xmodel/mp_tntbomb");
    precacheModel("xmodel/prop_bear");
    precacheModel("xmodel/cow_dead_3");
    precacheModel("xmodel/american_radio");
    precacheModel("xmodel/caen_grasstuft_5");
    precacheModel("xmodel/tree_grey_oak_xl_a");
    precacheModel("xmodel/caen_spikeybush_01");
    precacheModel("xmodel/weapon_potato");
    precacheModel("xmodel/crate01");
//    precacheModel("xmodel/brush_egypt_desert_1");
//    precacheModel("xmodel/brush_egypt_desert_2");
//    precacheModel("xmodel/brush_snowbushweed01");
//    precacheModel("xmodel/brush_snowbushweed02");
//    precacheModel("xmodel/brush_toujanebigbushy");
//    precacheModel("xmodel/caen_bush_full_01");
//    precacheModel("xmodel/caen_spikeybush_01");
//    precacheModel("xmodel/tree_desertbushy");
//    precacheModel("xmodel/tree_desertpalm01");
//    precacheModel("xmodel/tree_desertpalm02");
//    precacheModel("xmodel/tree_destoyed_trunk_a");
//    precacheModel("xmodel/tree_destoyed_trunk_b");
//    precacheModel("xmodel/tree_destoyed_snow_trunk_a");
//    precacheModel("xmodel/tree_destoyed_snow_trunk_b");
//    precacheModel("xmodel/tree_grey_oak_sm_a");
    precacheModel("xmodel/prop_bear");
    precacheModel("xmodel/weapon_panzerschreck");
    precacheModel("xmodel/weapon_g43_scoped");
    precacheModel("xmodel/weapon_m1garand");
    precacheModel("xmodel/weapon_ppsh");
    precacheModel("xmodel/civiliancar_intact_blue");
    precacheModel("xmodel/gully_bridge01");
    precacheModel("xmodel/head_british_price");
}

antalova() {
    self setModel("xmodel/character_russian_diana_medic");
}


//these functions are called from _menus and from _quickmessages (I didn't have time to rewrite it all to _menus...maybe in next version)
brush_desertshrubgroup01() //maps\mp\gametypes\_uber::brush_desertshrubgroup01();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  brush_desertshrubgroup01 = spawn("script_model", self.origin + (0, 0, 15));
  brush_desertshrubgroup01 setmodel("xmodel/brush_desertshrubgroup01");
  brush_desertshrubgroup01.angles = (self.angles);
  brush_desertshrubgroup01 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_desertshrubgroup01 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_desertshrubgroup01 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
brush_egypt_desert_1() //maps\mp\gametypes\_uber::brush_egypt_desert_1();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  brush_egypt_desert_1 = spawn("script_model", self.origin + (0, 0, 15));
  brush_egypt_desert_1 setmodel("xmodel/brush_egypt_desert_1");
  brush_egypt_desert_1.angles = (self.angles);
  brush_egypt_desert_1 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_egypt_desert_1 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_egypt_desert_1 delete();
      self show();
      hidden();
      return (0);
    }
  }
}

brush_egypt_desert_2() //maps\mp\gametypes\_uber::brush_egypt_desert_2();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  brush_egypt_desert_2 = spawn("script_model", self.origin + (0, 0, 15));
  brush_egypt_desert_2 setmodel("xmodel/brush_egypt_desert_2");
  brush_egypt_desert_2.angles = (self.angles);
  brush_egypt_desert_2 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_egypt_desert_2 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_egypt_desert_2 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
brush_snowbushweed01() //maps\mp\gametypes\_uber::brush_snowbushweed01();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  brush_snowbushweed01 = spawn("script_model", (self.origin));
  brush_snowbushweed01 setmodel("xmodel/brush_snowbushweed01");
  brush_snowbushweed01.angles = (self.angles);
  brush_snowbushweed01 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_snowbushweed01 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_snowbushweed01 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
brush_snowbushweed02() //maps\mp\gametypes\_uber::brush_snowbushweed02();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  brush_snowbushweed02 = spawn("script_model", (self.origin));
  brush_snowbushweed02 setmodel("xmodel/brush_snowbushweed02");
  brush_snowbushweed02.angles = (self.angles);
  brush_snowbushweed02 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_snowbushweed02 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_snowbushweed02 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
brush_toujanebigbushy() //maps\mp\gametypes\_uber::brush_toujanebigbushy();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  brush_toujanebigbushy = spawn("script_model", (self.origin));
  brush_toujanebigbushy setmodel("xmodel/brush_toujanebigbushy");
  brush_toujanebigbushy.angles = (self.angles);
  brush_toujanebigbushy linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_toujanebigbushy delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      brush_toujanebigbushy delete();
      self show();
      hidden();
      return (0);
    }
  }
}
caen_bush_full_01() //maps\mp\gametypes\_uber::caen_bush_full_01();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  caen_bush_full_01 = spawn("script_model", (self.origin));
  caen_bush_full_01 setmodel("xmodel/caen_bush_full_01");
  caen_bush_full_01.angles = (self.angles);
  caen_bush_full_01 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      caen_bush_full_01 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      caen_bush_full_01 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
caen_spikeybush_01() //maps\mp\gametypes\_uber::caen_spikeybush_01();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  caen_spikeybush_01 = spawn("script_model", (self.origin));
  caen_spikeybush_01 setmodel("xmodel/caen_spikeybush_01");
  caen_spikeybush_01.angles = (self.angles);
  caen_spikeybush_01 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      caen_spikeybush_01 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      caen_spikeybush_01 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_desertbushy() //maps\mp\gametypes\_uber::tree_desertbushy();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_desertbushy = spawn("script_model", (self.origin));
  tree_desertbushy setmodel("xmodel/tree_desertbushy");
  tree_desertbushy.angles = (self.angles);
  tree_desertbushy linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_desertbushy delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_desertbushy delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_desertpalm01() //maps\mp\gametypes\_uber::tree_desertpalm01();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_desertpalm01 = spawn("script_model", (self.origin));
  tree_desertpalm01 setmodel("xmodel/tree_desertpalm01");
  tree_desertpalm01.angles = (self.angles);
  tree_desertpalm01 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_desertpalm01 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_desertpalm01 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_desertpalm02() //maps\mp\gametypes\_uber::tree_desertpalm02();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_desertpalm02 = spawn("script_model", (self.origin));
  tree_desertpalm02 setmodel("xmodel/tree_desertpalm02");
  tree_desertpalm02.angles = (self.angles);
  tree_desertpalm02 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_desertpalm02 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_desertpalm02 delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_destoyed_trunk_a() //maps\mp\gametypes\_uber::tree_destoyed_trunk_a();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_destoyed_trunk_a = spawn("script_model", (self.origin));
  tree_destoyed_trunk_a setmodel("xmodel/tree_destoyed_trunk_a");
  tree_destoyed_trunk_a.angles = (self.angles);
  tree_destoyed_trunk_a linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_trunk_a delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_trunk_a delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_destoyed_trunk_b() //maps\mp\gametypes\_uber::tree_destoyed_trunk_b();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_destoyed_trunk_b = spawn("script_model", (self.origin));
  tree_destoyed_trunk_b setmodel("xmodel/tree_destoyed_trunk_b");
  tree_destoyed_trunk_b.angles = (self.angles);
  tree_destoyed_trunk_b linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_trunk_b delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_trunk_b delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_destoyed_snow_trunk_a() //maps\mp\gametypes\_uber::tree_destoyed_snow_trunk_a();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_destoyed_snow_trunk_a = spawn("script_model", (self.origin));
  tree_destoyed_snow_trunk_a setmodel("xmodel/tree_destoyed_snow_trunk_a");
  tree_destoyed_snow_trunk_a.angles = (self.angles);
  tree_destoyed_snow_trunk_a linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_snow_trunk_a delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_snow_trunk_a delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_destoyed_snow_trunk_b() //maps\mp\gametypes\_uber::tree_destoyed_snow_trunk_b();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_destoyed_snow_trunk_b = spawn("script_model", (self.origin));
  tree_destoyed_snow_trunk_b setmodel("xmodel/tree_destoyed_snow_trunk_b");
  tree_destoyed_snow_trunk_b.angles = (self.angles);
  tree_destoyed_snow_trunk_b linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_snow_trunk_b delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_destoyed_snow_trunk_b delete();
      self show();
      hidden();
      return (0);
    }
  }
}
tree_grey_oak_sm_a() //maps\mp\gametypes\_uber::tree_grey_oak_sm_a();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree_grey_oak_sm_a = spawn("script_model", (self.origin));
  tree_grey_oak_sm_a setmodel("xmodel/tree_grey_oak_sm_a");
  tree_grey_oak_sm_a.angles = (self.angles);
  tree_grey_oak_sm_a linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_grey_oak_sm_a delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();

      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree_grey_oak_sm_a delete();
      self show();
      hidden();
      return (0);
    }
  }
}
bear() //maps\mp\gametypes\_uber::bear();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  bear = spawn("script_model", self.origin + (0, 0, 15));
  bear setmodel("xmodel/prop_bear");
  bear.angles = (self.angles);
  bear linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      bear delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      bear delete();
      self show();
      hidden();
      return (0);
    }
  }
}

bomb() //maps\mp\gametypes\_uber::bomb();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  bomb = spawn("script_model", (self.origin));
  bomb setmodel("xmodel/mp_tntbomb");
  bomb.angles = (self.angles);
  bomb linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      bomb delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      bomb delete();
      self show();
      hidden();
      return (0);
    }
  }
}

deadcow() //maps\mp\gametypes\_uber::deadcow();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  deadcow = spawn("script_model", (self.origin));
  deadcow setmodel("xmodel/cow_dead_3");
  deadcow.angles = (self.angles);
  deadcow linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      deadcow delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      deadcow delete();
      self show();
      hidden();
      return (0);
    }
  }
}

radio() //maps\mp\gametypes\_uber::radio();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  radio = spawn("script_model", self.origin + (0, 0, 25));
  radio setmodel("xmodel/american_radio");
  radio.angles = self.angles + (0, 90, 0);
  radio linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      radio delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      radio delete();
      self show();
      hidden();
      return (0);
    }
  }
}

grass() //maps\mp\gametypes\_uber::grass();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  grass = spawn("script_model", (self.origin));
  grass setmodel("xmodel/caen_grasstuft_5");
  grass.angles = (self.angles);
  grass linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      grass delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      grass delete();
      self show();
      hidden();
      return (0);
    }
  }
}

tree() //maps\mp\gametypes\_uber::tree();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  tree = spawn("script_model", (self.origin));
  tree setmodel("xmodel/tree_grey_oak_xl_a");
  tree.angles = (self.angles);
  tree linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tree delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tree delete();
      self show();
      hidden();
      return (0);
    }
  }
}

bush() //maps\mp\gametypes\_uber::bush();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  bush = spawn("script_model", (self.origin));
  bush setmodel("xmodel/caen_spikeybush_01");
  bush.angles = (self.angles);
  bush linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      bush delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      bush delete();
      self show();
      hidden();
      return (0);
    }
  }
}

weaponmp44() //maps\mp\gametypes\_uber::weaponmp44();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  weaponmp44 = spawn("script_model", self.origin + (0, 0, 2));
  weaponmp44 setmodel("xmodel/weapon_mp44");
  weaponmp44.angles = self.angles + (0, 0, 90);
  weaponmp44 linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      weaponmp44 delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      weaponmp44 delete();
      self show();
      hidden();
      return (0);
    }
  }
}

grenade() //maps\mp\gametypes\_uber::grenade();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  grenade = spawn("script_model", self.origin + (0, 0, 2));
  grenade setmodel("xmodel/weapon_nebelhandgrenate");
  grenade.angles = self.angles + (0, 0, 90);
  grenade linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      grenade delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      grenade delete();
      self show();
      hidden();
      return (0);
    }
  }
}

potato() //maps\mp\gametypes\_uber::potato();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  potato = spawn("script_model", (self.origin));
  potato setmodel("xmodel/weapon_potato");
  potato.angles = (self.angles);
  potato linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      potato delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      potato delete();
      self show();
      hidden();
      return (0);
    }
  }
}

crate() //maps\mp\gametypes\_uber::crate();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  crate = spawn("script_model", (self.origin));
  crate setmodel("xmodel/crate01");
  crate.angles = (self.angles);
  crate linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      crate delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      crate delete();
      self show();
      hidden();
      return (0);
    }
  }
}

thirdperson() //maps\mp\gametypes\_uber::thirdperson();
{
  if (!isDefined(self.isthirdperson) || !self.isthirdperson) {
    self.isthirdperson = true;
    self SetClientCvar("cg_thirdperson", "1");
    self SetClientCvar("cg_thirdpersonrange", "120");
    self iprintln("^23rd person Activated");
  } else
  if (self.isthirdperson) {
    self.isthirdperson = false;
    self SetClientCvar("cg_thirdperson", "0");
    self SetClientCvar("cg_thirdpersonrange", "120");
    self iprintln("^13rd person Deactivated");
  }
}

hidden() //maps\mp\gametypes\_uber::hidden();
{
  if (self.model == "") {
    self.health = 100;
    self show();

    self detachAll();
    if (self.pers["team"] == "allies")
      [[game["allies_model"]]]();
    else if (self.pers["team"] == "axis")
      [[game["axis_model"]]]();

    self iprintln("^1Hidden mod DISABLED");
  } else {
    self hide();
    self setModel("");
    self iprintln("^2Hidden mod ENABLED");
  }

}

autospawn() //maps\mp\gametypes\_uber::autospawn();
{

  while (1) {
    if (self.health <= 0) {
      self openMenu(game["menu_quickspawn"]);
      return (0);
    }
    wait(0.05);
  }

}

spawned() //maps\mp\gametypes\_uber::spawned();
{
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

model() {
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

shield() //maps\mp\gametypes\_uber::shield();
{
  self iprintln("^5Shield Enabled");
  self iprintln("^1Press USE button to delete the shield");
  panzer2 = spawn("script_model", (self.origin));
  panzer2 setmodel("xmodel/vehicle_panzer_ii");
  panzer2.angles = (self.angles);
  panzer2 linkto(self);
  panzer2 hide();

  while (1) {
    if (self useButtonPressed()) {
      self iprintln("^1Shield disappeared");
      panzer2 delete();
      return (0);
    }
    if (self.health <= 0) {
      panzer2 delete();
      return (0);
    }
    wait(0.05);
  }
}

turret() {
    turret = spawnTurret ("misc_mg42", (self.origin), "mg42_bipod_stand_mp");
    turret setmodel("xmodel/weapon_mg42");
    turret.angles = (self.angles);
}

panzerschreck() {
    panzerschreck = spawn ("weapon_panzerschreck_mp", (self.origin));
    panzerschreck setmodel("xmodel/weapon_panzerschreck");
}

bomb5() //maps\mp\gametypes\_uber::bomb5();
{
  startOrigin = self getEye() + (0, 0, 18);
  forward = anglesToForward(self getplayerangles());
  forward = maps\mp\_utility::vectorScale(forward, 100000);
  endOrigin = startOrigin + forward;

  trace = bulletTrace(startOrigin, endOrigin, false, self);
  angles = vectortoangles(vectornormalize(trace["normal"])) + (90, 0, 0);

  bomb1 = spawn("script_model", trace["position"]);
  bomb1.angles = angles;
  bomb1 setmodel("xmodel/mp_tntbomb");
  wait(1);
  bomb1 playLoopSound("bomb_tick");
  self iprintln("5");
  wait(2);
  self iprintln("3");
  wait(1);
  self iprintln("2");
  wait(1);
  self iprintln("1");
  wait(1);
  self iprintln("!!!BOOM!!!");
  level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
  playfx(level._effect["mortexplosion"], bomb1.origin);
  bomb1 playSound("flak88_explode");
  radiusDamage(bomb1.origin + (0, 0, 30), 400, 200, 80);
  bomb1 stopLoopSound();
  bomb1 delete();
}

bomb10() //maps\mp\gametypes\_uber::bomb10();
{
  startOrigin = self getEye() + (0, 0, 18);
  forward = anglesToForward(self getplayerangles());
  forward = maps\mp\_utility::vectorScale(forward, 100000);
  endOrigin = startOrigin + forward;

  trace = bulletTrace(startOrigin, endOrigin, false, self);
  angles = vectortoangles(vectornormalize(trace["normal"])) + (90, 0, 0);

  bomb2 = spawn("script_model", trace["position"]);
  bomb2.angles = angles;
  bomb2 setmodel("xmodel/mp_tntbomb");
  wait(1);
  bomb2 playLoopSound("bomb_tick");
  self iprintln("10");
  wait(5);
  self iprintln("5");
  wait(2);
  self iprintln("3");
  wait(1);
  self iprintln("2");
  wait(1);
  self iprintln("1");
  wait(1);
  self iprintln("!!!BOOM!!!");
  level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
  playfx(level._effect["mortexplosion"], bomb2.origin);
  bomb2 playSound("flak88_explode");
  radiusDamage(bomb2.origin + (0, 0, 30), 400, 200, 80);
  bomb2 stopLoopSound();
  bomb2 delete();
}

bomb30() //maps\mp\gametypes\_uber::bomb30();
{
  startOrigin = self getEye() + (0, 0, 18);
  forward = anglesToForward(self getplayerangles());
  forward = maps\mp\_utility::vectorScale(forward, 100000);
  endOrigin = startOrigin + forward;

  trace = bulletTrace(startOrigin, endOrigin, false, self);
  angles = vectortoangles(vectornormalize(trace["normal"])) + (90, 0, 0);

  bomb4 = spawn("script_model", trace["position"]);
  bomb4.angles = angles;
  bomb4 setmodel("xmodel/mp_tntbomb");
  wait(1);
  bomb4 playLoopSound("bomb_tick");
  self iprintln("30");
  wait(5);
  self iprintln("25");
  wait(5);
  self iprintln("20");
  wait(5);
  self iprintln("15");
  wait(5);
  self iprintln("10");
  wait(5);
  self iprintln("5");
  wait(2);
  self iprintln("3");
  wait(1);
  self iprintln("2");
  wait(1);
  self iprintln("1");
  wait(1);
  self iprintln("!!!BOOM!!!");
  level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
  playfx(level._effect["mortexplosion"], bomb4.origin);
  bomb4 playSound("flak88_explode");
  radiusDamage(bomb4.origin + (0, 0, 30), 400, 200, 80);
  bomb4 stopLoopSound();
  bomb4 delete();
}

bombremote() //maps\mp\gametypes\_uber::bombremote();
{
  startOrigin = self getEye() + (0, 0, 18);
  forward = anglesToForward(self getplayerangles());
  forward = maps\mp\_utility::vectorScale(forward, 100000);
  endOrigin = startOrigin + forward;

  trace = bulletTrace(startOrigin, endOrigin, false, self);
  angles = vectortoangles(vectornormalize(trace["normal"])) + (90, 0, 0);

  bombremote = spawn("script_model", trace["position"]);
  bombremote.angles = angles;
  bombremote setmodel("xmodel/mp_tntbomb");

  while (1) {
    if (self UseButtonPressed()) {
      self iprintln("!!!BOOM!!!");
      level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
      playfx(level._effect["mortexplosion"], bombremote.origin);
      bombremote playSound("flak88_explode");
      radiusDamage(bombremote.origin + (0, 0, 30), 400, 200, 80);
      bombremote delete();
      return (0);
    }
    wait(0.05);
  }

}

tank() //maps\mp\gametypes\_uber::tank();
{
  panzer2 = spawn("script_model", (self.origin));
  panzer2 setmodel("xmodel/vehicle_panzer_ii");
  panzer2.angles = (self.angles);
  panzer2 linkto(self);
  self hide();
  self disableWeapon();
  self iprintln("^2Press USE button to make tank disappear");
  self iprintln("^1Press MELEE button to destroy the Tank");

  while (1) {
    if (self attackButtonPressed()) {
      startOrigin = self getEye() + (0, 0, 18);
      forward = anglesToForward(self getplayerangles());
      forward = maps\mp\_utility::vectorScale(forward, 100000);
      endOrigin = startOrigin + forward;

      trace = bulletTrace(startOrigin, endOrigin, false, self);
      angles = vectortoangles(vectornormalize(trace["normal"])) + (90, 0, 0);

      projectile = spawn("script_model", trace["position"]);
      projectile.angles = angles;
      projectile setmodel("xmodel/mp_tntbomb");
      projectile hide();

      self iprintln("Fire!");
      wait(0.1);
      level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
      playfx(level._effect["mortexplosion"], projectile.origin);
      projectile playSound("flak88_explode");
      radiusDamage(projectile.origin + (0, 0, 30), 300, 500, 90);
      projectile delete();
      wait(2);
    }

    wait(0.05);

    if (self MeleeButtonPressed()) {
      panzer2d = spawn("script_model", (self.origin));
      panzer2d setmodel("xmodel/vehicle_panzer_ii_destroyed");
      panzer2d.angles = (self.angles);
      panzer2d linkto(self);
      panzer2d unlink();
      panzer2 delete();
      level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
      playfx(level._effect["mortexplosion"], panzer2d.origin);
      panzer2d playSound("flak88_explode");
      self iprintln("^1Tank has been destroyed");
      self show();
      self enableWeapon();
      return (0);
    }
    if (self UseButtonPressed()) {
      panzer2 delete();
      self iprintln("^2Tank has disappeared");
      self show();
      self enableWeapon();
      return (0);
    }
    if (self.health <= 0) {
      panzer2d = spawn("script_model", (self.origin));
      panzer2d setmodel("xmodel/vehicle_panzer_ii_destroyed");
      panzer2d.angles = (self.angles);
      panzer2d linkto(self);
      panzer2d unlink();
      panzer2 delete();
      self show();
      level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
      playfx(level._effect["mortexplosion"], panzer2d.origin);
      panzer2d playSound("flak88_explode");
      return (0);
    }
  }
}

lamp() //maps\mp\gametypes\_uber::lamp();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  lamp = spawn("script_model", (self.origin));
  lamp setmodel("xmodel/light_lantern_off");
  lamp.angles = (self.angles);
  lamp linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      lamp delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      lamp delete();
      self show();
      hidden();
      return (0);
    }
  }
}

chair() //maps\mp\gametypes\_uber::chair();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  chair = spawn("script_model", (self.origin));
  chair setmodel("xmodel/furniture_plainchair");
  chair.angles = (self.angles);
  chair linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      chair delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      chair delete();
      self show();
      hidden();
      return (0);
    }
  }
}

desk() //maps\mp\gametypes\_uber::desk();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "150");
  desk = spawn("script_model", (self.origin));
  desk setmodel("xmodel/furniture_duhoc_bunker_table");
  desk.angles = (self.angles);
  desk linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      desk delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      desk delete();
      self show();
      hidden();
      return (0);
    }
  }
}

tractor() //maps\mp\gametypes\_uber::tractor();
{
  self setclientcvar("cg_thirdPerson", "1");
  self setclientcvar("cg_thirdPersonRange", "200");
  tractor = spawn("script_model", (self.origin));
  tractor setmodel("xmodel/prop_tractor");
  tractor.angles = (self.angles) + (0, 270, 0);
  tractor linkto(self);
  self hide();
  self setModel("");
  self iprintln("^2Press USE button to unhide yourself");

  while (1) {

    wait(0.05);

    if (self.health <= 0) {
      self setclientcvar("cg_thirdPerson", "0");
      tractor delete();
      self show();
      hidden();
      return (0);
    }
    if (self UseButtonPressed()) {
      self setclientcvar("cg_thirdPerson", "0");
      tractor delete();
      self iprintln("^1Now you're unhidden");
      self show();
      hidden();
      return (0);
    }
  }
}

fire() //maps\mp\gametypes\_uber::fire();
{
  while (getCvarInt("scr_uber") == 1) {
    if (self UseButtonPressed()) {
      self iprintln("^1You stopped burn.");
      return (0);
    }
    if (self.health <= 0) {
      return (0);
    }
    playfx(level._effect["tank_fire_engine"], self.origin);
    wait(0.01);
    playfx(level._effect["tank_fire_engine"], self.origin + (0, 0, 10));
    wait(0.01);
  }
}

plane() //maps\mp\gametypes\_uber::plane();
{
  self setClientCvar("cg_thirdperson", "1");
  self setClientCvar("cg_thirdpersonrange", "500");

  self hide();
  self setModel("");
  self disableWeapon();

  destination1 = 0;
  destination2 = 0;
  destination3 = 0;
  destination4 = 0;
  destination5 = 0;
  destination6 = 0;
  destination7 = 0;
  destination8 = 0;
  destination9 = 0;
  destination10 = 0;

  bomb1 = 0;
  bomb2 = 0;
  bomb3 = 0;
  bomb4 = 0;
  bomb5 = 0;
  bomb6 = 0;
  bomb7 = 0;
  bomb8 = 0;
  bomb9 = 0;
  bomb10 = 0;

  bum1 = 0;
  bum2 = 0;
  bum3 = 0;
  bum4 = 0;
  bum5 = 0;
  bum6 = 0;
  bum7 = 0;
  bum8 = 0;
  bum9 = 0;
  bum10 = 0;

  cislo = 1;

  self iprintln("^1Press F to delete plane");
  self iprintln("^2Press Shift to bombard");

  while (1) {
    startOrigin = self.origin;
    forward = anglesToForward(self getplayerangles());
    forward = maps\mp\_utility::vectorScale(forward, 18);
    endOrigin = startOrigin + forward;

    model = spawn("script_model", endorigin);
    model2 = spawn("script_model", self.origin);

    self linkto(model2);

    plane = spawn("script_model", self.origin + (0, 0, -30));
    plane setmodel("xmodel/vehicle_stuka_flying");
    plane.angles = (self.angles);

    model2.origin = model.origin;

    wait(0.02);

    model delete();
    model2 delete();
    plane delete();

    if (self.health <= 0) {
      model delete();
      model2 delete();
      plane delete();
      self show();
      hidden();
      self setClientCvar("cg_thirdperson", "0");
      self enableWeapon();
      return (0);
    }
    if (self UseButtonPressed()) {
      model delete();
      model2 delete();
      plane delete();
      self show();
      hidden();
      self setClientCvar("cg_thirdperson", "0");
      self enableWeapon();
      self iprintln("^1You have just left the plane");
      return (0);
    }
    if (cislo != 1 && cislo != 21 && cislo != 41 && cislo != 61 && cislo != 81 && cislo != 101 && cislo != 121 && cislo != 141 && cislo != 161 && cislo != 181) {
      cislo++;
    }
    if (self MeleeButtonPressed()) {
      if (cislo == 181) {
        bum10 = 1;
        bomb10 = spawn("script_model", self.origin);
        bomb10.angles = self.angles;
        bomb10 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination10 = spawn("script_model", trace["position"]);

        z1 = destination10.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb10 moveto(destination10.origin, j);
        cislo++;
      }
      if (cislo == 161) {
        bum9 = 1;
        bomb9 = spawn("script_model", self.origin);
        bomb9.angles = self.angles;
        bomb9 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination9 = spawn("script_model", trace["position"]);

        z1 = destination9.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb9 moveto(destination9.origin, j);
        cislo++;
      }
      if (cislo == 141) {
        bum8 = 1;
        bomb8 = spawn("script_model", self.origin);
        bomb8.angles = self.angles;
        bomb8 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination8 = spawn("script_model", trace["position"]);

        z1 = destination8.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb8 moveto(destination8.origin, j);
        cislo++;
      }
      if (cislo == 121) {
        bum7 = 1;
        bomb7 = spawn("script_model", self.origin);
        bomb7.angles = self.angles;
        bomb7 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination7 = spawn("script_model", trace["position"]);

        z1 = destination7.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb7 moveto(destination7.origin, j);
        cislo++;
      }
      if (cislo == 101) {
        bum6 = 1;
        bomb6 = spawn("script_model", self.origin);
        bomb6.angles = self.angles;
        bomb6 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination6 = spawn("script_model", trace["position"]);

        z1 = destination6.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb6 moveto(destination6.origin, j);
        cislo++;
      }
      if (cislo == 81) {
        bum5 = 1;
        bomb5 = spawn("script_model", self.origin);
        bomb5.angles = self.angles;
        bomb5 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination5 = spawn("script_model", trace["position"]);

        z1 = destination5.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb5 moveto(destination5.origin, j);
        cislo++;
      }
      if (cislo == 61) {
        bum4 = 1;
        bomb4 = spawn("script_model", self.origin);
        bomb4.angles = self.angles;
        bomb4 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination4 = spawn("script_model", trace["position"]);

        z1 = destination4.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb4 moveto(destination4.origin, j);
        cislo++;
      }
      if (cislo == 41) {
        bum3 = 1;
        bomb3 = spawn("script_model", self.origin);
        bomb3.angles = self.angles;
        bomb3 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination3 = spawn("script_model", trace["position"]);

        z1 = destination3.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb3 moveto(destination3.origin, j);
        cislo++;
      }
      if (cislo == 21) {
        bum2 = 1;
        bomb2 = spawn("script_model", self.origin);
        bomb2.angles = self.angles;
        bomb2 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward(self.angles + (90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination2 = spawn("script_model", trace["position"]);

        z1 = destination2.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb2 moveto(destination2.origin, j);
        cislo++;
      }
      if (cislo == 1) {
        bum1 = 1;
        bomb1 = spawn("script_model", self.origin);
        bomb1.angles = self.angles;
        bomb1 setmodel("xmodel/prop_mortar_ammunition");

        //bombarding
        startOrigin = self.origin;
        down = anglesToForward((90, 0, 0));
        down = maps\mp\_utility::vectorScale(down, 10000);
        endOrigin = startOrigin + down;

        trace = bulletTrace(startOrigin, endOrigin, false, self);
        angles = vectortoangles(vectornormalize(trace["normal"]));

        destination1 = spawn("script_model", trace["position"]);

        z1 = destination1.origin[2];
        z2 = self.origin[2];

        i = z2 - z1;

        j = i / 500;

        bomb1 moveto(destination1.origin, j);
        cislo++;
      }
    }
    if (bum1 == 1) {
      if (destination1.origin == bomb1.origin) {
        bomb1 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination1.origin);
        destination1 playSound("flak88_explode");
        radiusDamage(destination1.origin + (0, 0, 30), 350, 150, 80);
        destination1 = 0;
        bomb1 = 0;
        bum1 = 0;
      }
    }

    if (bum2 == 1) {
      if (destination2.origin == bomb2.origin) {
        bomb2 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination2.origin);
        destination2 playSound("flak88_explode");
        radiusDamage(destination2.origin + (0, 0, 30), 350, 150, 80);
        destination2 = 0;
        bomb2 = 0;
        bum2 = 0;
      }
    }

    if (bum3 == 1) {
      if (destination3.origin == bomb3.origin) {
        bomb3 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination3.origin);
        destination3 playSound("flak88_explode");
        radiusDamage(destination3.origin + (0, 0, 30), 350, 150, 80);
        destination3 = 0;
        bomb3 = 0;
        bum3 = 0;
      }
    }

    if (bum4 == 1) {
      if (destination4.origin == bomb4.origin) {
        bomb4 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination4.origin);
        destination4 playSound("flak88_explode");
        radiusDamage(destination4.origin + (0, 0, 30), 350, 150, 80);
        destination4 = 0;
        bomb4 = 0;
        bum4 = 0;
      }
    }

    if (bum5 == 1) {
      if (destination5.origin == bomb5.origin) {
        bomb5 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination5.origin);
        destination5 playSound("flak88_explode");
        radiusDamage(destination5.origin + (0, 0, 30), 350, 150, 80);
        destination5 = 0;
        bomb5 = 0;
        bum5 = 0;
      }
    }

    if (bum6 == 1) {
      if (destination6.origin == bomb6.origin) {
        bomb6 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination6.origin);
        destination6 playSound("flak88_explode");
        radiusDamage(destination6.origin + (0, 0, 30), 350, 150, 80);
        destination6 = 0;
        bomb6 = 0;
        bum6 = 0;
      }
    }

    if (bum7 == 1) {
      if (destination7.origin == bomb7.origin) {
        bomb7 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination7.origin);
        destination7 playSound("flak88_explode");
        radiusDamage(destination7.origin + (0, 0, 30), 350, 150, 80);
        destination7 = 0;
        bomb7 = 0;
        bum7 = 0;
      }
    }

    if (bum8 == 1) {
      if (destination8.origin == bomb8.origin) {
        bomb8 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination8.origin);
        destination8 playSound("flak88_explode");
        radiusDamage(destination8.origin + (0, 0, 30), 350, 150, 80);
        destination8 = 0;
        bomb8 = 0;
        bum8 = 0;
      }
    }

    if (bum9 == 1) {
      if (destination9.origin == bomb9.origin) {
        bomb9 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination9.origin);
        destination9 playSound("flak88_explode");
        radiusDamage(destination9.origin + (0, 0, 30), 350, 150, 80);
        destination9 = 0;
        bomb9 = 0;
        bum9 = 0;
      }
    }

    if (bum10 == 1) {
      if (destination10.origin == bomb10.origin) {
        bomb10 delete();
        level._effect["mortexplosion"] = loadfx("fx/explosions/flak88_explosion.efx");
        playfx(level._effect["mortexplosion"], destination10.origin);
        destination10 playSound("flak88_explode");
        radiusDamage(destination10.origin + (0, 0, 30), 350, 150, 80);
        destination10 = 0;
        bomb10 = 0;
        bum10 = 0;
      }
    }

    if (cislo >= 181) {
      cislo = 1;
    }

  }

}