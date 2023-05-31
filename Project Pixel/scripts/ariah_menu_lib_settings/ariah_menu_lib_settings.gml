/* -- Ariah's Menu Library ~ Version 1.1.0 --
 *
 * LICENSE:
 * > CC0
 * > To the extent possible under law, Ariah has waived all copyright and related or neighboring rights to Ariah's Menu Library. This work is published from: United States.
 *
 * INSTRUCTIONS:
 * 0. Modify any of the settings in this file below until you are happy with them.
 * 1. Create an instance of ui_menu with instance_create_depth( ... );
 * 2. Utilize the built in function to setup your menu the way you'd like it.
 *
 * COMPATIBILITY:
 * > Automatic support for Ariah's Audio Library (V1.2.0 and later)
 *
 * DOCUMENTATION:
 * > Documentation may be available on my website: 'https://ariahsiwik.github.io/gmlibs/menu'
 */

#region Input Settings

function __AriahMenuLibrary__UP() {
	// If you are using JujuAdams' Input Library, use this line:
	return input_check_pressed("up");
}

function __AriahMenuLibrary__DOWN() {
	// If you are using JujuAdams' Input Library, use this line:
	return input_check_pressed("down");
}

function __AriahMenuLibrary__LEFT() {
	// If you are using JujuAdams' Input Library, use this line:
	return input_check_pressed("left");
}

function __AriahMenuLibrary__RIGHT() {
	// If you are using JujuAdams' Input Library, use this line:
	return input_check_pressed("right");
}

function __AriahMenuLibrary__CONFIRM() {
	// If you are using JujuAdams' Input Library, use this line:
	return input_check_pressed("z");
}

function __AriahMenuLibrary__CANCEL() {
	// If you are using JujuAdams' Input Library, use this line:
	return input_check_pressed("x");
}

#endregion

#region Game Size Settings

function __AriahMenuLibrary_WIDTH() {
	//If you have a macro for your game's width, or otherwise have a variable that may change throughout the game, put that macro/variable here:
	return GAME_WIDTH;
}

function __AriahMenuLibrary_HEIGHT() {
	//If you have a macro for your game's height, or otherwise have a varaible that may change throughout the game, put that macro/variable here:
	return GAME_HEIGHT;	
}

#endregion 

#region Menu Defaults

function __AriahMenuLibrary__DEFAULT_FONT() {
	//If you want to set a global default font, put it here:
	return fnt_m5x7; //(font asset or undefined)
}

function __AriahMenuLibrary__DEFAULT_SPRITE() {
	//If you want to set a global default sprite, put it here:
	return spr_ui_box_black; //(sprite asset or undefined)
}

function __AriahMenuLibrary__DEFAULT_CONFIRM_BLIP() {
	//If you want to set a global default confirm blip, put it here:
	return sfx_menu_blip_z; //(sound asset or undefined)
}

function __AriahMenuLibrary__DEFAULT_CANCEL_BLIP() {
	//If you want to set a global default cancel blip, put it here:
	return sfx_menu_blip_x; //(sound asset or undefined)
}

function __AriahMenuLibrary__DEFAULT_MOVE_BLIP() {
	//If you want to set a global default move blip, put it here:
	return sfx_menu_blip_move; //(sound asset or undefined)
}

function __AriahMenuLibrary__DEFAULT_HORIZONTAL_ANCHOR() {
	//If you want to set a global default horizontal anchor, put it here:
	return "center"; //("left", "right", or "center")
}

function __AriahMenuLibrary__DEFAULT_VERTICAL_ANCHOR() {
	//If you want to set a global default vertical anchor, put it here:
	return "middle"; //("top", "bottom", or "middle")
}

function __AriahMenuLibrary__DEFAULT_X_OFFSET() {
	//If you want to set a global default x offset, put it here:
	return 0; //(number)
}

function __AriahMenuLibrary__DEFAULT_Y_OFFSET() {
	//If you want to set a global default y offset, put it here:
	return 0; //(number)
}

function __AriahMenuLibrary__DEFAULT_COLORS() {
	//If you want to set a global default color theme, put it here:
	return {
		//Default colors for an *unselected* menu option (top to bottom gradient)
		c1: #ffffff, //(hex code)
		c2: #aaaaaa, //(hex code or undefined)
		
		//Default colors for a *selected* menu option (top to bottom gradient)
		s1: #ffff00, //(hex code or undefined)
		s2: #aaaa00, //(hex code or undefined)
	};
}

#endregion