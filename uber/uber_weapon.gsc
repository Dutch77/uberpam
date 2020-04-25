springfield() {
    weapon = spawn ("weapon_springfield_mp", (self.origin));
    weapon setmodel("xmodel/weapon_springfield");
}

kar98() {
    weapon = spawn ("weapon_kar98k_mp", (self.origin));
    weapon setmodel("xmodel/weapon_kar98");
}

mp44() {
    weapon = spawn ("weapon_mp44_mp", (self.origin));
    weapon setmodel("xmodel/weapon_mp44");
}

thompson() {
    weapon = spawn ("weapon_thompson_mp", (self.origin));
    weapon setmodel("xmodel/weapon_thompson");
}

m1Garand() {
    weapon = spawn ("weapon_m1garand_mp", (self.origin));
    weapon setmodel("xmodel/weapon_m1garand");
}

ppsh() {
    weapon = spawn ("weapon_ppsh_mp", (self.origin));
    weapon setmodel("xmodel/weapon_ppsh");
}

shotgun() {
    weapon = spawn ("weapon_shotgun_mp", (self.origin));
    weapon setmodel("xmodel/weapon_trenchgun");
}

grenade() {
    weapon = spawn ("weapon_frag_grenade_american_mp", (self.origin));
    weapon setmodel("xmodel/weapon_mk2fraggrenade");
}

smoke() {
    weapon = spawn ("weapon_smoke_grenade_german_mp", (self.origin));
    weapon setmodel("xmodel/weapon_us_smoke_grenade");
}