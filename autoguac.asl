state("Guac")
{
	int coins : 0x7696C0; // Not used, but is useful for debugging
	int loader : 0x760420; // Not used, but might be able to remove load times
	int newGame : 0x7696CC; // 0 after starting a new game, 15 otherwise
	uint objective : 0x74ECB0, 0x734; // changes depending on the current map objective. I wish I could find an address with nicer numbers...
	int powerup : 0x743600; // 4096 on some powerup-get screens, 512 otherwise
	int fight : 0x73BFB8; // 0 on a powerup-get or fight intro screen, 1 otherwise
	int xtabaycheck : 0x76A6F4; // 16 during the X'tabay fight, 32 after - to help Dimension Swap split as powerup doesn't change :(
	int rooster : 0x7757A0, 0x58; // 64 if rooster uppercut acquired and not on a load screen, 0 otherwise
	int calaca1 : 0x75627C, 0x58; // 4 when fighting Calaca I, changes to 3 when he ded
	byte isDead : 0x766808; // 1 if dying, to help with Calaca I split. This only seems to work during the final boss fight
	
	// Three addresses below to do the final split, because the values change around a lot and split loads of times otherwise...
	int finish : 0x7470FC; // Changes from 4 to 10 when pressed Y on altar
	int blacksun : 0x7691C8; // Changes to 2 when the black sun splits after beating Calaca II, then to 0 in the final cutscenes
	int maskget : 0x775A88, 0x58; // Changes from 0 to 64 when the getting the mask piece after beating Calaca II
	
	int area : 0x756250; // This gets its own paragraph because there are lots of values:
	// 28 for Agave Field
	// 46 for Pueblucho
	// 15 for La Mansion del Presidente
	// 57 for Forest del Chivo
	// 67 for Santa Luchita
	// 63 for Temple of Rain
	// 65 for Desierto Caliente
	// 99 for El Infierno
	// 50 for Sierra Morena
	// 55 for Great Temple
	// 12 for Great Altar
	// 41 for Tule Tree
	// 62 for Temple of War
	// 5 for Main Menu
	
	uint room : 0x764184, 0x44C; // Various values depending on what room you are in within an area. Used for distinguishing Olmec Headbutt and Goat Jump.
	
}

startup
{
	settings.Add("powerup", true, "Special Moves");
	settings.SetToolTip("powerup", "Splits on acquiring a new special move for Juan");
	settings.Add("rooster", true, "Rooster Uppercut", "powerup");
	settings.Add("headbutt", true, "Olmec Headbutt", "powerup");
	settings.Add("goatjump", true, "Goat Jump", "powerup");
	settings.Add("frogslam", true, "Frog Slam", "powerup");
	settings.Add("pollo", true, "Pollo Power", "powerup");
	settings.Add("dimswap", false, "Dimension Swap", "powerup");
	settings.Add("doublejump", false, "Double Jump", "powerup");
	settings.Add("derpderp", false, "Dashing Derpderp", "powerup");
	settings.Add("goatclimb", false, "Goat Climb", "powerup");
	settings.Add("goatfly", false, "Goat Fly", "powerup");
	
	settings.Add("boss", true, "Boss Fights");
	settings.SetToolTip("boss", "Splits on defeating a boss; either on the last hit or on the objective changing afterwards");
	settings.Add("alebrije", true, "Alebrije", "boss");
	settings.SetToolTip("alebrije", "Splits after talking to X'tabay after the Alebrije chase");
	settings.Add("flameface", false, "Flame Face", "boss");
	settings.SetToolTip("flameface", "Splits on the objective change after defeating Flame Face");
	settings.Add("javier", true, "Jaguar Javier", "boss");
	settings.SetToolTip("javier", "Splits after Jaguar Javier's last speech bubble");
	settings.Add("calaca1", true, "Calaca I", "boss");
	settings.SetToolTip("calaca1", "Splits on the final hit of Calaca's first form");
	
	settings.Add("misc", false, "Other Splits");
	settings.Add("church", false, "Church Introduction", "misc");
	settings.SetToolTip("church", "Splits on completing the first fight in Pueblucho church");
	settings.Add("combo", false, "Combo Chicken", "misc");
	settings.SetToolTip("combo", "Splits when you have completed the first combo chicken tutorial");
	settings.Add("trapped", false, "Desert Trap", "misc");
	settings.SetToolTip("trapped", "Splits on loading the cutscene when trapped by X'tabay in the desert");
	settings.Add("infierno", false, "El Infierno", "misc");
	settings.SetToolTip("infierno", "Splits on exiting room 3 in El Infierno (but doesn't check if you got Goat Fly because I can't figure it out yet)");
	settings.Add("wartemple", false, "Temple of War", "misc");
	settings.SetToolTip("wartemple", "Splits on entering the Temple of War, after climbing the Tule Tree");	

	settings.Add("finish", true, "Run Complete!");
	settings.SetToolTip("finish", "Splits on pressing Y at the final altar");
}
	
split
{	 
	// Splits when the current objective changes:
	if (old.objective != current.objective)
	{
		if (settings["church"] && old.objective == 1103980447 && current.objective == 3256686872) {print(">>>>Split for Church<<<<"); return true;} // Finished the fight in the church
		if (settings["combo"] && current.objective == 1132576863) {print(">>>>Split for Combo<<<<"); return true;} // Finished first Combo Chicken tutorial
		if (settings["alebrije"] && old.objective == 1132576863 && current.objective == 3256686872) {print(">>>>Split for Alebrije<<<<"); return true;} // Finished Alebrije chase
		if (settings["trapped"] && current.objective == 3271938162) {print(">>>>Split for Trap<<<<"); return true;} // Desert trap cutscene
		if (settings["javier"] && current.objective == 1105763556) {print(">>>>Split for Javier<<<<"); return true;} // Defeated Jaguar Javier
	
		if (settings["wartemple"] && current.objective == 1129734211) {print(">>>>Split for Temple of War<<<<"); return true;} // Entered Temple of War
		if (settings["flameface"] && current.objective == 1104939872) {print(">>>>Split for Flame Face<<<<"); return true;} // Defeated Flame Face
	}

	// Splits when getting a new special move:
	if (current.powerup == 4096 && old.powerup == 512)
	{
		// if (settings["rooster"] && current.objective == 3256686872) {print(">>>>Split for Rooster Uppercut<<<<"); return true;}
		if (settings["headbutt"] && current.area == 63 && current.room == 1105185470) {print(">>>>Split for Olmec Headbutt<<<<"); return true;}
		if (settings["goatjump"] && current.area == 63 && current.room == 1138054999) {print(">>>>Split for Goat Jump<<<<"); return true;}
		if (settings["frogslam"] && current.objective == 1112983162) {print(">>>>Split for Frog Slam<<<<"); return true;}
		// if (settings["pollo"] && current.objective == 3271938162) {print(">>>>Split for Pollo Power<<<<"); return true;}
		// if (settings["dimswap"] && current.objective == 3245936880) {print(">>>>Split for Dimension Swap<<<<"); return true;}
		if (settings["doublejump"] && current.objective == 1139026493) {print(">>>>Split for Double Jump<<<<"); return true;}
		if (settings["derpderp"] && current.objective == 1135132672) {print(">>>>Split for Dashing Derpderp<<<<"); return true;}
		if (settings["goatclimb"] && current.objective == 1104939872) {print(">>>>Split for Goat Climb<<<<"); return true;}
		if (settings["goatfly"] && current.objective == 1144402608) {print(">>>>Split for Goat Fly<<<<"); return true;}
	}

	// The powerup value doesn't change for these (why tho?), so we need to do something different:
	if (settings["rooster"] && vars.rooster == false && old.rooster == 0 && current.rooster == 64) {print(">>>>Split for Rooster<<<<"); vars.rooster = true; return true;}  // Acquired Rooster Uppercut
	if (settings["pollo"] && current.objective == 3271938162 && current.fight == 0 && old.fight == 1) {print(">>>>Split for Pollo Power<<<<"); return true;}
	if (settings["dimswap"] && current.objective == 3245936880 && current.xtabaycheck == 32 && current.fight == 0 && old.fight == 1) {print(">>>>Split for Dimension Swap<<<<"); return true;}
	
	// Other splits:
	if (settings["infierno"] && current.room == 3283933175 && old.room == 3270049792 && current.area == 99) {print(">>>>Split for El Infierno<<<<"); return true;}
	if (settings["calaca1"] && current.area == 12 && current.objective == 1151811584 && old.calaca1 == 4 && current.calaca1 == 3 && vars.aliveTime >= 250) {print(">>>>Split for Calaca I<<<<"); return true;} // Splits on the final hit of Calaca I
	if (settings["finish"] && old.finish == 4 && current.finish == 10 && current.maskget == 64 && current.blacksun == 2) {print(">>>>Split for end<<<<"); return true;} // Ending split - when pressed Y on the altar
}

start
{
	if (old.newGame == 15 && current.newGame == 0 && current.area == 5) {return true;}
}

update
{
	// Stores the current phase the timer is in, so we can use the old one on the next frame.
	current.timerPhase = timer.CurrentPhase;

	// Reset some stuff when the timer is started, so we don't need to rely on the start action in this script.
	if (old.timerPhase != current.timerPhase && old.timerPhase != TimerPhase.Paused && current.timerPhase == TimerPhase.Running)
	{
		vars.rooster = false; // Used to keep track of acquiring Rooster Uppercut
		vars.aliveTime = 0; // Used to count time after respawning in the Calaca fights, to avoid some splits
		print("Timer started - initialised rooster and Calaca variables");
	}

	if (current.isDead == 0 && current.area == 12 && vars.aliveTime < 250) {vars.aliveTime++;}
	if (current.isDead == 1 && old.isDead == 0 && current.area == 12) {vars.aliveTime = 0; print(">>>>>>>>>>>>>>>>>You died, idiot");}
	if (current.isDead == 0 && old.isDead == 1 && current.area == 12) {print(">>>>>>>>>>>>>>>>>Back to life, back to reality");}
	
// Debug test below - tweak and uncomment
//	if (current.coins > old.coins) {print(">>>>Rooster value is " + current.rooster.ToString());}
} 