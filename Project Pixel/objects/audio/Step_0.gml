//Stop Queue
for(var i=0;i<array_length(stop_queue);i++) {
	if(is_array(stop_queue[i])) {
		if(audio_sound_get_gain(stop_queue[i][0]) <= 0) {
			audio_stop_sound(stop_queue[i][0]);
			audio_emitter_free(stop_queue[i][1]);
			array_delete(stop_queue, i, 1);
			i--;
		}
	} else {
		if(audio_sound_get_gain(stop_queue[i]) <= 0) {
			audio_stop_sound(stop_queue[0]);
			array_delete(stop_queue, i, 1);
			i--;
		}
	}
}

//Dealing with Music looping

if(!is_undefined(music_loop_end) && bgm_is_playing()) {
	var _pos = audio_sound_get_track_position(music_inst);
	if(!__AriahAudioLibrary__LEGACY_USE_SECONDS_IN_BGM()) _pos *= 1000;
	if(_pos >= music_loop_end) {
		if(__AriahAudioLibrary__LEGACY_USE_SECONDS_IN_BGM()) audio_sound_set_track_position(music_inst, _pos - music_loop_length);	
		else audio_sound_set_track_position(music_inst, (_pos - music_loop_length)/1000);
	}
}

//Dealing with Music ending

if(bgm_is_playing() && !audio_is_playing(music_inst)) {
	bgm_stop();	
}

//Dealing with Sound Effects ending

for(var i=0;i<array_length(sounds);i++) {
	if(!audio_is_playing(sound_insts[i])) {
		array_delete(sounds, i, 1);
		array_delete(sound_volumes, i, 1);
		array_delete(sound_pitches, i, 1);
		if(!is_undefined(sound_emitters[i])) audio_emitter_free(sound_emitters[i]);
		array_delete(sound_emitters, i, 1);
		array_delete(sound_insts, i, 1);
		
		i--;
	}
}

//Audio Listener Shtuff

if(!is_undefined(listener) && instance_exists(listener)) {
	x = listener.x;
	y = listener.y;
}