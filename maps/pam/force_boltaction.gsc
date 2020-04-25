Force_Check(response)
{
	do_not_force = "no";

	if (isDefined(level.force_boltaction) && level.force_boltaction)
	{
		if (self.pers["team"] == "axis")
		{
			if (response == "kar98k_sniper_mp" && getcvarint("scr_allow_kar98ksniper"))
				return response;
			else
			{
				response = "kar98k_mp";
				return response;
			}
		}
		else
		{
			switch (game["allies"])
			{
			case "russian":
				if (response == "mosin_nagant_sniper_mp" && getcvarint("scr_allow_nagantsniper"))
					return response;
				else
				{
					response = "mosin_nagant_mp";
					return response;
				}

			case "american":
				if(response == "springfield_mp" && getcvarint("scr_allow_springfield"))
					return response;
				else
				{
					if (level.force_boltaction == 1) response = "enfield_mp";
					else response = "mosin_nagant_mp";
					return response;
				}

			case "british":
				if (response == "enfield_scope_mp"&& getcvarint("scr_allow_enfieldsniper"))
					return response;
				else
				{
					response = "enfield_mp";
					return response;
				}

			default:
				response = "enfield_mp";
				return response;
			}
		}
	}

	else return do_not_force;
}