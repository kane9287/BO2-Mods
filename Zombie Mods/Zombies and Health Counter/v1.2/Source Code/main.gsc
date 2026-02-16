init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread healthCounter();
    }
}

healthCounter ()
{
	self endon ("disconnect");
	level endon( "end_game" );
	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
	
	// Create label for "Health: " text
	self.healthLabel = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 2.0);
	self.healthLabel maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", -30, 120);
	self.healthLabel.color = (1, 1, 1);  // White
	self.healthLabel setText("Health: ");
	
	// Create value for the number (colored)
	self.healthText = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 2.0);
	self.healthText maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", 30, 120);
	
	while ( 1 )
	{
		self.healthText setValue(self.health);
		
		// Change color based on health
		if(self.health >= 150)
		{
			self.healthText.color = (0, 1, 0);  // Green
		}
		else if(self.health <= 90)
		{
			self.healthText.color = (1, 1, 0);  // Yellow
		}
		else if(self.health <= 30)
		{
			self.healthText.color = (1, 0.5, 0);  // Orange
		}
		else
		{
			self.healthText.color = (1, 0, 0);  // Red
		}
		
		wait 0.25;
	}
}



