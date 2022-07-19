if(IS_DEV_BUILD) {
	window_set_caption(GAME_TITLE + " (dev build) V" + string(MAJOR_VERSION) + "." + string(MINOR_VERSION));
}

display_set_gui_size(GAME_WIDTH, GAME_HEIGHT);