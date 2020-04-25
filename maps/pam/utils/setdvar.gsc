Setup_Dvar(dvar, default_setting, min, max)
{
	// NOTE: MAKE SURE YOU CALL FOR A MINIMUM IF THIS IS AN INTEGER!

	if (!isDefined(default_setting))
		return;

	if (!isDefined(min))
		min = undefined;

	if (!isDefined(max))
		max = undefined;

	if (getcvar(dvar) == "" )
		setcvar(dvar, default_setting);
	
	if (isDefined(min) && getcvarint(dvar) < min)
		setcvar(dvar, min);

	if (isDefined(max) && getcvarint(dvar) > max)
		setcvar(dvar, max);

	if (isDefined(min))
		return getcvarint(dvar);
	else
		return getcvar(dvar);
}