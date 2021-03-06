toujane()
{	
	precacheModel("xmodel/furniture_bookshelveswide");

	jump = spawn("script_model",(1999, 2027, 344));
	jump.angles = (0, 119.8, 90); 
	jump setmodel("xmodel/furniture_bookshelveswide");

	jump2 = spawn("script_model",(1938, 1991, 344));
	jump2.angles = (0, 119.8, 90); 
	jump2 setmodel("xmodel/furniture_bookshelveswide");

	jump3 = spawn("script_model",(2024, 1983.75, 344));
	jump3.angles = (0, 119.8, 90); 
	jump3 setmodel("xmodel/furniture_bookshelveswide");
	
	jump4 = spawn("script_model",(1960, 1950, 344));
	jump4.angles = (0, 119.8, 90); 
	jump4 setmodel("xmodel/furniture_bookshelveswide");

	jump5 = spawn("script_model",(2054, 1931, 344));
	jump5.angles = (0, 119.8, 90); 
	jump5 setmodel("xmodel/furniture_bookshelveswide");

	jump6 = spawn("script_model",(1994, 1897, 344));
	jump6.angles = (0, 119.8, 90); 
	jump6 setmodel("xmodel/furniture_bookshelveswide");
}

burgundy()
{
	
	precacheModel("xmodel/military_flak88_boxlid");
	precacheModel("xmodel/caen_fence_post_1");	
	
	window0 = spawn("script_model",(202.5, 2350, 210));
	window0.angles = (90,90,0); 
	window0 setmodel("xmodel/military_flak88_boxlid");
	
	window1 = spawn("script_model",(202.5, 2350, 215));
	window1.angles = (90,90,0); 
	window1 setmodel("xmodel/military_flak88_boxlid");
	
	window2 = spawn("script_model",(202.5, 2350, 220));
	window2.angles = (90,90,0); 
	window2 setmodel("xmodel/military_flak88_boxlid");
	
	window3 = spawn("script_model",(202.5, 2350, 225));
	window3.angles = (90,90,0); 
	window3 setmodel("xmodel/military_flak88_boxlid");
	
	window4 = spawn("script_model",(202.5, 2350, 230));
	window4.angles = (90,90,0); 
	window4 setmodel("xmodel/military_flak88_boxlid");
	
	window5 = spawn("script_model",(202.5, 2350, 235));
	window5.angles = (90,90,0); 
	window5 setmodel("xmodel/military_flak88_boxlid");
	
	window6 = spawn("script_model",(202.5, 2350, 240));
	window6.angles = (90,90,0); 
	window6 setmodel("xmodel/military_flak88_boxlid");
	
	window7 = spawn("script_model",(202.5, 2350, 245));
	window7.angles = (90,90,0); 
	window7 setmodel("xmodel/military_flak88_boxlid");
	
	window8 = spawn("script_model",(202.5, 2350, 250));
	window8.angles = (90,90,0); 
	window8 setmodel("xmodel/military_flak88_boxlid");
	
	window9 = spawn("script_model",(202.5, 2350, 255));
	window9.angles = (90,90,0); 
	window9 setmodel("xmodel/military_flak88_boxlid");
	
	window10 = spawn("script_model",(202.5, 2350, 260));
	window10.angles = (90,90,0); 
	window10 setmodel("xmodel/military_flak88_boxlid");
	
	window11 = spawn("script_model",(202.5, 2350, 265));
	window11.angles = (90,90,0); 
	window11 setmodel("xmodel/military_flak88_boxlid");
	
	window12 = spawn("script_model",(202.5, 2350, 270));
	window12.angles = (90,90,0); 
	window12 setmodel("xmodel/military_flak88_boxlid");
	
	window13 = spawn("script_model",(202.5, 2350, 275));
	window13.angles = (90,90,0); 
	window13 setmodel("xmodel/military_flak88_boxlid");
	
	window14 = spawn("script_model",(202.5, 2350, 280));
	window14.angles = (90,90,0); 
	window14 setmodel("xmodel/military_flak88_boxlid");
	
	window15 = spawn("script_model",(202.5, 2350, 285));
	window15.angles = (90,90,0); 
	window15 setmodel("xmodel/military_flak88_boxlid");
	
	window16 = spawn("script_model",(202.5, 2350, 290));
	window16.angles = (90,90,0); 
	window16 setmodel("xmodel/military_flak88_boxlid");
	
	wagon1 = spawn("script_model",(1800, 2310, 33));
	wagon1.angles = (90,260,0); 
	wagon1 setmodel("xmodel/caen_fence_post_1");

	wagon2 = spawn("script_model",(1790, 2245, 33));
	wagon2.angles = (90,78,0); 
	wagon2 setmodel("xmodel/caen_fence_post_1");
	
	wall1 = spawn("script_model",(2015, 2115, -10));
	wall1.angles = (90,350,0); 
	wall1 setmodel("xmodel/caen_fence_post_1");
	
	// spawn( "trigger_radius", position, spawn flags, radius, height )
	window1_collision = spawn("trigger_radius", window1.origin, 0, 10 , 30);
	window1_collision setcontents(1);
	
	wagon1_collision = spawn("trigger_radius", wagon1.origin, 0, 60 , 30); 
	wagon1_collision setcontents(1);
	
	wall1_collision = spawn("trigger_radius", wall1.origin, 0, 30 , 30); 
	wall1_collision setcontents(1);
}

dawnville()
{
	precacheModel("xmodel/furniture_bookshelveswide");
	precacheModel("xmodel/military_flak88_boxlid");
	
	wall = spawn("script_model",(1410, -15200, -113));
	wall.angles = (0,0,0); 
	wall setmodel("xmodel/furniture_bookshelveswide");

	wall1 = spawn("script_model",(322, -16117, 34));
	wall1.angles = (0,0,90); 
	wall1 setmodel("xmodel/military_flak88_boxlid");
}

harbor()
{
	precacheModel("xmodel/furniture_bookshelveswide");

	wall1 = spawn("script_model",(-9706, -6473, 64));
	//wall1.angles = (0,0,0); 
	wall1 setmodel("xmodel/furniture_bookshelveswide");
	
	wall2 = spawn("script_model",(-9706, -6473, 123));
	//wall2.angles = (0,0,0); 
	wall2 setmodel("xmodel/furniture_bookshelveswide");

	wall3 = spawn("script_model",(-9706, -5945, 64));
	//wall3.angles = (0,0,0); 
	wall3 setmodel("xmodel/furniture_bookshelveswide");

	wall4 = spawn("script_model",(-9706, -5945, 123));
	//wall4.angles = (0,0,0); 
	wall4 setmodel("xmodel/furniture_bookshelveswide");
	
	wall5 = spawn("script_model",(-9706, -5801, 64));
	//wall5.angles = (0,0,0); 
	wall5 setmodel("xmodel/furniture_bookshelveswide");

	wall6 = spawn("script_model",(-9706, -5801, 123));
	//wall6.angles = (0,0,0); 
	wall6 setmodel("xmodel/furniture_bookshelveswide");
}

carentan()
{
	precacheModel("xmodel/military_flak88_boxlid");
	precacheModel("xmodel/caen_fence_post_1");
	
	window1 = spawn("script_model",(720.144, 1091, 28));
	window1.angles = (90,90,0); 
	window1 setmodel("xmodel/military_flak88_boxlid");
	
	wall2 = spawn("script_model",(1667, 2240, 17.9));
	wall2.angles = (270,90,90); 
	wall2 setmodel("xmodel/caen_fence_post_1");

	wall3 = spawn("script_model",(1685, 1870, -20));
	wall3.angles = (90,15,0); 
	wall3 setmodel("xmodel/military_flak88_boxlid");

	wall4 = spawn("script_model",(1685, 1870, -15));
	wall4.angles = (90,15,0); 
	wall4 setmodel("xmodel/military_flak88_boxlid");

	wall5 = spawn("script_model",(1685, 1870, -10));
	wall5.angles = (90,15,0); 
	wall5 setmodel("xmodel/military_flak88_boxlid");

	wall6 = spawn("script_model",(1685, 1870, -7));
	wall6.angles = (90,15,0); 
	wall6 setmodel("xmodel/military_flak88_boxlid");
	
	window1_collision = spawn("trigger_radius", window1.origin, 0, 8 , 50);
	window1_collision setcontents(1);	
}