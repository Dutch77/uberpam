onPlayer_Spawn()
{
	// Monitor Weapon Drop
	self thread maps\pam\weapon_drop::Monitor_Weapon_Drop();
}