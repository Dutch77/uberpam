Get_Next_Map()
{
	maprot = "";

	// Get current maprotation
	maprot = strip(getcvar("sv_maprotationcurrent"));	

	// Get maprotation if current empty or not the one we want
	if(maprot == "")
		maprot = strip(getcvar("sv_maprotation"));	

	// No map rotation setup!
	if(maprot == "")
		return undefined;
	
	// Explode entries into an array
	j=0;
	temparr2[j] = "";	
	for(i=0;i<maprot.size;i++)
	{
		if(maprot[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += maprot[i];
	}

	map = undefined;
	gt = undefined;

	for(i=0;i<temparr2.size;i++)
	{
		if (isDefined(map))
			break;

		if (temparr2[i] == "gametype")
		{
			n = temparr2.size - i;
			for (x=1;x<n ;x++ )
			{
				if (temparr2[i+x] != " ")
					gt = temparr2[i+x];
					break;
			}
		}
		else if (temparr2[i] == "map")
		{
			n = temparr2.size - i;
			for (x=1;x<n ;x++ )
			{
				if (temparr2[i+x] != " ")
				{
					map = temparr2[i+x];
					break;
				}
			}
		}
	}
	
	if (!isdefined(map))
		return undefined;

	if (!isdefined(gt))
		gt = getcvar("g_gametype");

	//Construct string
	nextmap = "^3Next Map: ^2" + map + " (" + gt + ")";

	return nextmap;
}


////////////////////////////////////////////////////////////////////
/* BELOW CODE ORIGINALLY FROM CODAM AND/OR AWE FOR COD AND COD:UO */
////////////////////////////////////////////////////////////////////

// Strip blanks at start and end of string
strip(s)
{
	if(s=="")
		return "";

	s2="";
	s3="";

	i=0;
	while(i<s.size && s[i]==" ")
		i++;

	// String is just blanks?
	if(i==s.size)
		return "";
	
	for(;i<s.size;i++)
	{
		s2 += s[i];
	}

	i=s2.size-1;
	while(s2[i]==" " && i>0)
		i--;

	for(j=0;j<=i;j++)
	{
		s3 += s2[j];
	}
		
	return s3;
}

// breaks an array into an array of arrays based on some separator
splitArray( str, sep, quote, skipEmpty )
{
	if ( !isdefined( str ) || ( str == "" ) )
		return ( [] );

	if ( !isdefined( sep ) || ( sep == "" ) )
		sep = ";";	// Default separator

	if ( !isdefined( quote ) )
		quote = "";

	skipEmpty = isdefined( skipEmpty );

	a = _splitRecur( 0, str, sep, quote, skipEmpty );

	return ( a );
}

_splitRecur( iter, str, sep, quote, skipEmpty )
{
	s = sep[ iter ];

	_a = [];
	_s = "";
	doQuote = false;
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];
		if ( ch == quote )
		{
			doQuote = !doQuote;

			if ( iter + 1 < sep.size )
				_s += ch;
		}
		else
		if ( ( ch == s ) && !doQuote )
		{
			if ( ( _s != "" ) || !skipEmpty )
			{
				_l = _a.size;

				if ( iter + 1 < sep.size )
				{
					_x = _splitRecur( iter + 1, _s,	sep, quote, skipEmpty );

					if ( ( _x.size > 0 ) || !skipEmpty )
					{
						_a[ _l ][ "str" ] = _s;
						_a[ _l ][ "fields" ] = _x;
					}
				}
				else
					_a[ _l ] = _s;
			}

			_s = "";
		}
		else
			_s += ch;
	}

	if ( _s != "" )
	{
		_l = _a.size;

		if ( iter + 1 < sep.size )
		{
			_x = _splitRecur( iter + 1, _s, sep, quote, skipEmpty );
			if ( _x.size > 0 )
			{
				_a[ _l ][ "str" ] = _s;
				_a[ _l ][ "fields" ] = _x;
			}
		}
		else
			_a[ _l ] = _s;
	}

	return ( _a );
}


// Finds a string within a string
findStr( find, str, pos )
{
	if ( !isdefined( find ) || ( find == "" ) || 
		 !isdefined( str ) || 
		 !isdefined( pos ) || 
		 ( find.size > str.size ) )
		return ( -1 );

	fsize = find.size;
	ssize = str.size;

	switch ( pos )
	{
	  case "start": place = 0 ; break;
	  case "end":	place = ssize - fsize; break;
	  default:	place = 0 ; break;
	}

	for ( i = place; i < ssize; i++ )
	{
		if ( i + fsize > ssize )
			break;			// Too late to compare

		// Compare now ...
		for ( j = 0; j < fsize; j++ )
			if ( str[ i + j ] != find[ j ] )
				break;		// No match

		if ( j >= fsize )
			return ( i );		// Found it!

		if ( pos == "start" )
			break;			// Didn't find at start
	}

	return ( -1 );
}

