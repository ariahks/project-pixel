function menu_pause_create(_is_title, _fade = undefined) {
	_fade ??= !_is_title;
	
	var _menu = instance_create_depth(0, 0, DEPTH_UI_MENU, ui_menu);
	with(_menu) {
		set_fade(_fade);
		set_darken_background(!_is_title);
		
		__title = _is_title;
		
		add_page(new MenuPageRows("Main")
				.add_option(
						new MenuOption("Play")
							.set_function_init(function() {
								if(__title) {
									var _option = get_page("Main").get_option("Play");
									var _started = game.flag.get("game_has_started");
									if(_started) _option.set_text("Continue");
									else _option.set_text("New Game");
								} else {
									get_page("Main").get_option("Play").set_text("Resume");
								}
							})
							.set_function_z(function() {
								if(__title) {
									game.flag.set("game_has_started", true);
									game.menu_locked = false;
									instance_create_depth(game.data.x, game.data.y, 0, player);
									room_goto(game.data.room);
								} else {
									game.pause_for_menu = false;
									destroy();
								}
							})
							.set_blip_x(undefined)
				)
				.add_option(
						new MenuOption("Settings")
							.set_function_z(function() {
								set_page("Settings");
							})
							.set_blip_x(undefined)
				)
				.add_option(
						new MenuOption("Quit")
							.set_function_init(function() {
								if(!__title) {
									get_page("Main").get_option("Quit").set_text("Title Screen");
								}
							})
							.set_function_selected(function() {
								if(__title && !game.settings.fullscreen) {
									var _x = window_get_x() + irandom_range(-2, 2);
									var _y = window_get_y() + irandom_range(-2, 2);
									window_set_position(_x, _y);
								}
							})
							.set_function_z(function() {
								if(__title) {
									game_end();	
								} else {
									instance_destroy(player);
									instance_destroy(camera);
									game.menu_locked = true;
									game.pause_for_menu = false;
									audio.bgm_stop(500);
									audio.sfx_stop_all(500);
									audio.bgs_stop_all(500);
									game.reset_save_data();
									game.load();
									room_goto(rm_title);
								}
							})
							.set_blip_z(__title ? undefined : blip_z_default)
							.set_blip_x(undefined)
				)
		);
	
		add_page(new MenuPageRows("Settings")
				.add_option(
						new MenuOption("Game")
							.set_function_z(function() {
								set_page("Game");
							})
							.set_function_x(function() {
								set_page("Main");	
							})
						,
						new MenuOption("Video")
							.set_function_z(function() {
								set_page("Video");
							})
							.set_function_x(function() {
								set_page("Main");	
							})
				)
				.add_option(
						new MenuOption("Controls")
							.set_function_z(function() {
								set_page("Controls");
							})
							.set_function_x(function() {
								set_page("Main");	
							})
						,
						new MenuOption("Audio")
							.set_function_z(function() {
								set_page("Audio");
							})
							.set_function_x(function() {
								set_page("Main");	
							})
				)
				.add_option(
						new MenuOption("Back")
							.set_function_z(function() {
								set_page("Main");	
							})
							.set_function_x(function() {
								set_page("Main");	
							})
							.set_blip_z(sfx_menu_blip_x)
				)
		);
	
		add_page(new MenuPageRows("Game")
				.add_option(
						new MenuOption("Reset Save Data")
							.set_color(#bb0000, #880000)
							.set_color_selected(#ff0000)
							.set_function_init(function() {
								if(!__title) {
									get_page("Game").get_option("Reset Save Data")
											.set_color(#888888, #444444)
											.set_selectable(false);
									select_option("Back", "Game");
								}
							})
							.set_function_z(function() {
								game.reset_save_data();
								game.save();
								get_page("Main").get_option("Play").set_text("New Game");
								set_page("Reset");
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(sfx_menu_blip_success)
				)
				.add_option(
						new MenuOption("Back")
							.set_function_z(function() {
								set_page("Settings");	
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(sfx_menu_blip_x)
				)
		);
	
		add_page(new MenuPageRows("Reset")
				.add_option(
						new MenuOption("Save Data has been Reset!")
							.set_color_selected(#ffffff, #aaaaaa)
							.set_function_z(function() {
								set_page("Settings");	
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(undefined)
							.set_blip_x(undefined)
				)
		);
	
		add_page(new MenuPageRows("Video")
				.add_option(
						new MenuOption("Scale")
							.set_function_init(function() {
								var _text = "";
								if(game.settings.fullscreen) {
									var _max = min(display_get_width() / GAME_WIDTH, display_get_height() / GAME_HEIGHT);
									_text = string(_max * GAME_WIDTH) + " x " + string(_max * GAME_HEIGHT);
									get_page("Video").get_option("Scale")
											.set_color(#888888, #444444)
											.set_selectable(false);
									select_option("Fullscreen", "Video");
								} else {
									var _max = floor(min(display_get_width() / GAME_WIDTH, display_get_height() / GAME_HEIGHT));
									_text = game.settings.scale > 1 ? "< " : "  ";
									_text += string(game.settings.scale * GAME_WIDTH) + " x " + string(game.settings.scale * GAME_HEIGHT);
									_text += game.settings.scale < _max ? " >" : "  ";
								}
								get_page("Video").get_option("Scale").set_text(_text);
							})
							.set_function_left(function() {
								if(game.settings.scale == 1) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.scale--;
								if(game.settings.scale < 1) game.settings.scale = 1;
								window_set_size(GAME_WIDTH * game.settings.scale, GAME_HEIGHT * game.settings.scale);
								window_set_position((display_get_width() - GAME_WIDTH*game.settings.scale)/2, (display_get_height() - GAME_HEIGHT*game.settings.scale)/2);
								var _text = game.settings.scale > 1 ? "< " : "  ";
								_text += string(game.settings.scale * GAME_WIDTH) + " x " + string(game.settings.scale * GAME_HEIGHT);
								_text += " >";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_right(function() {
								var _max = floor(min(display_get_width() / GAME_WIDTH, display_get_height() / GAME_HEIGHT));
								if(game.settings.scale == _max) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.scale++;
								if(game.settings.scale > _max) game.settings.scale = _max;
								window_set_size(GAME_WIDTH * game.settings.scale, GAME_HEIGHT * game.settings.scale);
								window_set_position((display_get_width() - GAME_WIDTH*game.settings.scale)/2, (display_get_height() - GAME_HEIGHT*game.settings.scale)/2);
								var _text = "< ";
								_text += string(game.settings.scale * GAME_WIDTH) + " x " + string(game.settings.scale * GAME_HEIGHT);
								_text += game.settings.scale < _max ? " >" : "  ";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(undefined)
				)
				.add_option(
						new MenuOption("Fullscreen")
							.set_function_init(function() {
								var _text = game.settings.fullscreen ? "< Fullscreen  " : "  Windowed >";
								get_page("Video").get_option("Fullscreen").set_text(_text);
							})
							.set_function_left(function() {
								if(!game.settings.fullscreen) return;
							
								audio.sfx_play(get_current_option().blip_move);
								var _max = floor(min(display_get_width() / GAME_WIDTH, display_get_height() / GAME_HEIGHT));
								var _text = game.settings.scale > 1 ? "< " : "  ";
								_text += string(game.settings.scale * GAME_WIDTH) + " x " + string(game.settings.scale * GAME_HEIGHT);
								_text += game.settings.scale < _max ? " >" : "  ";
								get_current_page().get_option("Scale")
										.set_color(#ffffff, #aaaaaa)
										.set_selectable(true)
										.set_text(_text)
							
								game.settings.fullscreen = false;
								window_set_fullscreen(false);
								window_set_size(GAME_WIDTH * game.settings.scale, GAME_HEIGHT * game.settings.scale);
								window_set_position((display_get_width() - GAME_WIDTH*game.settings.scale)/2, (display_get_height() - GAME_HEIGHT*game.settings.scale)/2);
								get_current_option().set_text("  Windowed >");
								game.settings_save();
							})
							.set_function_right(function() {
								if(game.settings.fullscreen) return;
							
								audio.sfx_play(get_current_option().blip_move);
								var _max = min(display_get_width() / GAME_WIDTH, display_get_height() / GAME_HEIGHT);
								var _text = string(_max * GAME_WIDTH) + " x " + string(_max * GAME_HEIGHT);
								get_current_page().get_option("Scale")
										.set_color(#888888, #444444)
										.set_selectable(false)
										.set_text(_text)
								
								game.settings.fullscreen = true;
								window_set_fullscreen(true);
								get_current_option().set_text("< Fullscreen  ");
								game.settings_save();
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(undefined)
				)
				.add_option(
						new MenuOption("Back")
							.set_function_z(function() {
								set_page("Settings");	
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(sfx_menu_blip_x)
				)
		);
	
		add_page(new MenuPageRows("Controls")
				.add_option(
						new MenuOption("Keyboard")
							.set_function_x(function() {
								set_page("Settings");	
							})
				)
				.add_option(
						new MenuOption("Gamepad")
							.set_function_x(function() {
								set_page("Settings");	
							})
				)
				.add_option(
						new MenuOption("Back")
							.set_function_z(function() {
								set_page("Settings");	
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(sfx_menu_blip_x)
				)
		);
	
		add_page(new MenuPageRows("Audio")
				.add_option(
						new MenuOption("BGM_Label", "Music")
							.set_selectable(false)
							.set_color(#1CC9E1, #18A9BC)
							.set_function_init(function() {
								select_option("BGM", "Audio")	
							})
				)
				.add_option(
						new MenuOption("BGM")
							.set_function_init(function() {
								var _text = game.settings.vol_bgm > 0 ? "< " : "  ";
								_text += string(game.settings.vol_bgm);
								_text += game.settings.vol_bgm < 100 ? " >" : "  ";
								get_page("Audio").get_option("BGM").set_text(_text);
							})
							.set_function_left(function() {
								if(game.settings.vol_bgm == 0) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.vol_bgm -= 10;
								if(game.settings.vol_bgm < 0) game.settings.vol_bgm = 0;
								var _text = game.settings.vol_bgm > 0 ? "< " : "  ";
								_text += string(game.settings.vol_bgm);
								_text += " >";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_right(function() {
								if(game.settings.vol_bgm == 100) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.vol_bgm += 10;
								if(game.settings.vol_bgm > 100) game.settings.vol_bgm = 100;
								var _text = "< ";
								_text += string(game.settings.vol_bgm);
								_text += game.settings.vol_bgm < 100 ? " >" : "  ";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
				)
				.add_option(
						new MenuOption("SFX_Label", "Sound Effects")
							.set_selectable(false)
							.set_color(#1CC9E1, #18A9BC)
							.set_function_init(function() {
								select_option("SFX", "Audio")	
							})
				)
				.add_option(
						new MenuOption("SFX")
							.set_function_init(function() {
								var _text = game.settings.vol_sfx > 0 ? "< " : "  ";
								_text += string(game.settings.vol_sfx);
								_text += game.settings.vol_sfx < 100 ? " >" : "  ";
								get_page("Audio").get_option("SFX").set_text(_text);
							})
							.set_function_left(function() {
								if(game.settings.vol_sfx == 0) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.vol_sfx -= 10;
								if(game.settings.vol_sfx < 0) game.settings.vol_sfx = 0;
								var _text = game.settings.vol_sfx > 0 ? "< " : "  ";
								_text += string(game.settings.vol_sfx);
								_text += " >";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_right(function() {
								if(game.settings.vol_sfx == 100) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.vol_sfx += 10;
								if(game.settings.vol_sfx > 100) game.settings.vol_sfx = 100;
								var _text = "< ";
								_text += string(game.settings.vol_sfx);
								_text += game.settings.vol_sfx < 100 ? " >" : "  ";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
				)
				.add_option(
						new MenuOption("BGS_Label", "Background Sounds")
							.set_selectable(false)
							.set_color(#1CC9E1, #18A9BC)
							.set_function_init(function() {
								select_option("BGS", "Audio")	
							})
				)
				.add_option(
						new MenuOption("BGS")
							.set_function_init(function() {
								var _text = game.settings.vol_bgs > 0 ? "< " : "  ";
								_text += string(game.settings.vol_bgs);
								_text += game.settings.vol_bgs < 100 ? " >" : "  ";
								get_page("Audio").get_option("BGS").set_text(_text);
							})
							.set_function_left(function() {
								if(game.settings.vol_bgs == 0) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.vol_bgs -= 10;
								if(game.settings.vol_bgs < 0) game.settings.vol_bgs = 0;
								var _text = game.settings.vol_bgs > 0 ? "< " : "  ";
								_text += string(game.settings.vol_bgs);
								_text += " >";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_right(function() {
								if(game.settings.vol_bgs == 100) return;
							
								audio.sfx_play(get_current_option().blip_move);
								game.settings.vol_bgs += 10;
								if(game.settings.vol_bgs > 100) game.settings.vol_bgs = 100;
								var _text = "< ";
								_text += string(game.settings.vol_bgs);
								_text += game.settings.vol_bgs < 100 ? " >" : "  ";
								get_current_option().set_text(_text);
								game.settings_save();
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
				)
				.add_option(
						new MenuOption("Back")
							.set_function_z(function() {
								set_page("Settings");	
							})
							.set_function_x(function() {
								set_page("Settings");	
							})
							.set_blip_z(sfx_menu_blip_x)
				)
		);
	}	
}