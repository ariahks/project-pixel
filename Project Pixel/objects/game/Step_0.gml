if(input_check_pressed("pause")) {
	if(!menu_locked) {
		if(pause_for_menu) {
			with(ui_menu) {
				destroy();	
			}
			pause_for_menu = false;
		} else {
			menu_pause_create(false);
			pause_for_menu = true;
		}
	}
}

audio.bgm_set_global_volume(settings.vol_bgm / 100);
audio.sfx_set_global_volume(settings.vol_sfx / 100);
audio.bgs_set_global_volume(settings.vol_bgs / 100);