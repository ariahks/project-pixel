bgm_stop();
sfx_stop_all();
bgs_stop_all();

while(array_length(stop_queue) > 0) {
	if(is_array(stop_queue[0])) {
		audio_stop_sound(stop_queue[0][0]);
		audio_emitter_free(stop_queue[0][1]);
	} else {
		audio_stop_sound(stop_queue[0]);
	}
	array_delete(stop_queue, 0, 1);
}