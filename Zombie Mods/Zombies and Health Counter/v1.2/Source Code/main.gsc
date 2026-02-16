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
        player thread zombieCounter();
    }
}

healthCounter ()
{
	self endon ("disconnect");
	level endon( "end_game" );
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
	self.healthText = maps/mp/gametypes_zm/_hud_util::createFontString ("hudsmall", 2.0);  // Increased from 1.5 to 2.0
	self.healthText maps/mp/gametypes_zm/_hud_util::setPoint ("CENTER", "CENTER", 100, 130);  // Moved up from 180 to 130
	self.healthText.label = &"Health: ";
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

zombieCounter()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
    self.zombieText = maps/mp/gametypes_zm/_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText maps/mp/gametypes_zm/_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    while( 1 )
    {
        self.zombieText setValue( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        if( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
        {
        	self.zombieText.label = &"Zombies: ^1";
        }
        else
        {
        	self.zombieText.label = &"Zombies: ^6";
        }
        wait 0.25;
    }
}

