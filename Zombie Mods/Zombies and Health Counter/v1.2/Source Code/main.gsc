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
		player thread statsHUD();
		player thread lowHealthWarning();
    }
}

//////HEALTH//////

healthCounter ()
{
	self endon ("disconnect");
	level endon( "end_game" );
	common_scripts\utility::flag_wait( "initial_blackscreen_passed" );
	
	// Create label for "Health: " text (no glow)
	self.healthLabel = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.8);
	self.healthLabel maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", -10, 170);
	self.healthLabel.color = (1, 1, 1);  // White
	self.healthLabel setText("Health: ");
	
	// Create value for the number (colored with glow)
	self.healthText = maps\mp\gametypes_zm\_hud_util::createFontString ("hudsmall", 1.8);
	self.healthText maps\mp\gametypes_zm\_hud_util::setPoint ("CENTER", "CENTER", 30, 170);
	self.healthText.glowAlpha = 1;  // Always glow
	
	red_pulse_up = true;
	red_pulse_alpha = 0.5;
	yellow_pulse_up = true;
	yellow_pulse_alpha = 1.0;
	
	while ( 1 )
	{
		self.healthText setValue(self.health);
		
		// Change color based on health - check from lowest to highest
		if(self.health <= 30)
		{
			self.healthText.color = (1, 0, 0);  // Red
			self.healthText.glowColor = (0.8, 0, 0);  // Dark red glow
			self.healthText.fontScale = 2.25;  // Bigger when red
			
			// Fast pulsing effect when critical health
			if(red_pulse_up)
			{
				red_pulse_alpha += 0.1;
				if(red_pulse_alpha >= 1)
				{
					red_pulse_up = false;
				}
			}
			else
			{
				red_pulse_alpha -= 0.1;
				if(red_pulse_alpha <= 0.3)
				{
					red_pulse_up = true;
				}
			}
			self.healthText.alpha = red_pulse_alpha;
		}
		else if(self.health >= 31 && self.health <= 119)
		{
			self.healthText.color = (1, 1, 0);  // Yellow
			self.healthText.glowColor = (0.8, 0.8, 0);  // Dark yellow glow
			self.healthText.fontScale = 2.0;  // Medium size for caution
			
			// Slow pulsing effect for yellow health
			if(yellow_pulse_up)
			{
				yellow_pulse_alpha += 0.03;  // Slower pulse
				if(yellow_pulse_alpha >= 1)
				{
					yellow_pulse_up = false;
				}
			}
			else
			{
				yellow_pulse_alpha -= 0.03;  // Slower pulse
				if(yellow_pulse_alpha <= 0.6)
				{
					yellow_pulse_up = true;
				}
			}
			self.healthText.alpha = yellow_pulse_alpha;
		}
		else if(self.health >= 120)
		{
			self.healthText.color = (0, 1, 0);  // Green
			self.healthText.glowColor = (0, 0.6, 0);  // Dark green glow
			self.healthText.fontScale = 1.8;  // Normal size
			self.healthText.alpha = 1;
		}
		
		wait 0.05;  // Faster update for smooth pulsing
	}
}

//////LOW HEALTH WARNING//////

lowHealthWarning()
{
	self endon("disconnect");
	level endon("end_game");
	common_scripts\utility::flag_wait("initial_blackscreen_passed");
	
	// Create LOW HEALTH warning text
	self.lowHealthText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 2.0);
	self.lowHealthText maps\mp\gametypes_zm\_hud_util::setPoint("CENTER", "TOP", 0, 60);
	self.lowHealthText.color = (1, 0, 0);  // Red
	self.lowHealthText.glowColor = (0.8, 0, 0);
	self.lowHealthText.glowAlpha = 1;
	self.lowHealthText.alpha = 0;  // Hidden by default
	
	pulse_up = true;
	pulse_alpha = 0.5;
	
	while(1)
	{
		// Show warning when health <= 30
		if(self.health <= 30)
		{
			self.lowHealthText setText("LOW HEALTH");
			
			// Pulsing effect
			if(pulse_up)
			{
				pulse_alpha += 0.15;
				if(pulse_alpha >= 1)
				{
					pulse_up = false;
				}
			}
			else
			{
				pulse_alpha -= 0.15;
				if(pulse_alpha <= 0.3)
				{
					pulse_up = true;
				}
			}
			self.lowHealthText.alpha = pulse_alpha;
		}
		else
		{
			self.lowHealthText.alpha = 0;  // Hide when health is above 30
		}
		
		wait 0.05;  // Faster for smooth pulse
	}
}

//////STATS//////

statsHUD()
{
    self endon("disconnect");
    level endon("end_game");
    common_scripts\utility::flag_wait("initial_blackscreen_passed");
    
    // Initialize tracking variables
    self.round_start_time = getTime();
    self.total_downs = 0;
    self.headshots = 0;
    self.total_shots = 0;
    self.revives_given = 0;
    self.starting_points = self.score;  // Track starting points
    
    // Main stats (1.0 font with glow) - Left side, above midway
    self.roundTimerText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.roundTimerText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, -70);
    self.roundTimerText.color = (0.8, 0.8, 1);
    self.roundTimerText.glowColor = (0.8, 0.8, 1);
    self.roundTimerText.glowAlpha = 1;
    
    self.perkTimeText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.perkTimeText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, -55);
    self.perkTimeText.color = (0.8, 0.8, 1);
    self.perkTimeText.glowColor = (0.8, 0.8, 1);
    self.perkTimeText.glowAlpha = 1;
    
    self.powerupTimerText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.powerupTimerText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, -40);
    self.powerupTimerText.color = (0.8, 0.8, 1);
    self.powerupTimerText.glowColor = (0.8, 0.8, 1);
    self.powerupTimerText.glowAlpha = 1;
    
    self.papLevelText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.papLevelText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, -25);
    self.papLevelText.color = (0.8, 0.8, 1);
    self.papLevelText.glowColor = (0.8, 0.8, 1);
    self.papLevelText.glowAlpha = 1;
    
    // Secondary stats (1.0 font, no glow) - Below main stats
    self.headshotText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.headshotText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, 0);
    self.headshotText.color = (0.8, 0.8, 0.8);
    
    self.revivesText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.revivesText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, 15);
    self.revivesText.color = (0.8, 0.8, 0.8);
    
    self.totalPointsText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.totalPointsText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, 30);
    self.totalPointsText.color = (0.8, 0.8, 0.8);
    
    self.downsText = maps\mp\gametypes_zm\_hud_util::createFontString("hudsmall", 1.0);
    self.downsText maps\mp\gametypes_zm\_hud_util::setPoint("LEFT", "LEFT", 5, 45);
    self.downsText.color = (0.8, 0.8, 0.8);
    
    // Thread to track events
    self thread trackDowns();
    self thread trackHeadshots();
    self thread trackRevives();
    
    while(1)
    {
        // Round Timer
        elapsed = (getTime() - self.round_start_time) / 1000;
        minutes = int(elapsed / 60);
        seconds = int(elapsed % 60);
        self.roundTimerText setText("Round Time: " + minutes + ":" + self formatSeconds(seconds));
        
        // Game Time
        game_time = int(getTime() / 1000);
        game_minutes = int(game_time / 60);
        game_seconds = int(game_time % 60);
        self.perkTimeText setText("Game Time: " + game_minutes + ":" + self formatSeconds(game_seconds));
        
        // Powerup Timer (check for active powerups)
        powerup_text = self getPowerupStatus();
        self.powerupTimerText setText(powerup_text);
        
        // Pack-a-Punch Level
        current_weapon = self getCurrentWeapon();
        pap_level = self getPaPLevel(current_weapon);
        self.papLevelText setText("Punch Level: " + pap_level);
        
        // Headshot Accuracy
        if(self.total_shots > 0)
        {
            hs_percent = int((self.headshots / self.total_shots) * 100);
            self.headshotText setText("Headshot Acc: " + hs_percent);
        }
        else
        {
            self.headshotText setText("Headshot Acc: 0");
        }
        
        // Revives Given
        self.revivesText setText("Revives Given: " + self.revives_given);
        
        // Total Points Earned
        points_earned = self.score - self.starting_points;
        self.totalPointsText setText("Points Earned: " + points_earned);
        
        // Downs Counter
        self.downsText setText("Downs: " + self.total_downs);
        
        wait 0.1;
    }
}

formatSeconds(seconds)
{
    if(seconds < 10)
        return "0" + seconds;
    return seconds;
}

trackDowns()
{
    self endon("disconnect");
    level endon("end_game");
    
    while(1)
    {
        self waittill("player_downed");
        self.total_downs++;
    }
}

trackHeadshots()
{
    self endon("disconnect");
    level endon("end_game");
    
    while(1)
    {
        self waittill("weapon_fired");
        self.total_shots++;
        wait 0.05;
    }
}

trackRevives()
{
    self endon("disconnect");
    level endon("end_game");
    
    while(1)
    {
        self waittill("player_revived_another_player");
        self.revives_given++;
    }
}

getPowerupStatus()
{
    // Check common powerup flags/variables
    if(isdefined(level._powerup_timeout) && level._powerup_timeout > 0)
    {
        time_left = int(level._powerup_timeout);
        return "Powerup Active: " + time_left + "s";
    }
    
    return "Powerup: None";
}

getPaPLevel(weapon)
{
    if(!isdefined(weapon))
        return "0";
    
    // Check if weapon is upgraded
    if(maps\mp\zombies\_zm_weapons::is_weapon_upgraded(weapon))
    {
        return "1";
    }
    
    return "0";
}
