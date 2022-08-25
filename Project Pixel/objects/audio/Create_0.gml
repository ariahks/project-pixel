SIGNATURE = "47eeed78d46ceff4d28e5f86d99cf51a";
VERSION = "3cb33df3651600715e7961b29ad0e4ff";

#region Constants

BGM_PRIORITY = __AriahAudioLibrary__BGM_PRIORITY();
SFX_PRIORITY = __AriahAudioLibrary__SFX_PRIORITY();
BGS_PRIORITY = __AriahAudioLibrary__BGS_PRIORITY();

FALLOFF_MODEL = __AriahAudioLibrary__FALLOFF_MODEL();
FALLOFF_REF_DIST = __AriahAudioLibrary__FALLOFF_REF_DIST();
FALLOFF_MAX_DIST = __AriahAudioLibrary__FALLOFF_MAX_DIST();
FALLOFF_FACTOR = __AriahAudioLibrary__FALLOFF_FACTOR();

#endregion

#region Define Variables

//Global volume variables
gb_vol_bgm = 1; //global music volume
gb_vol_sfx = 1; //global sound effects volume
gb_vol_bgs = 1; //global background sounds volume

//BGM
music = undefined; //currently playing music track
music_inst = undefined; //current instance of the above track
music_volume = 1; //track volume, multiplier
music_pitch = 1; //track pitch
music_paused_time = undefined; //time at which the current track is paused
music_loop_end = undefined; //time at which the track should loop
music_loop_length = undefined; //length of looped section
music_loop_full_track = false; //loop entire track instead of a specific section

//SFX
sounds = []; //list of currently playing sound effects
sound_insts = []; //list of instances of above sound effects
sound_volumes = []; //list of volumes for each above sound, multiplier
sound_pitches = []; //list of pitches for each above sound
sound_emitters = []; //list of emitters for each above sound

//BGS
backgrounds = []; //list of currently playing background sounds
background_insts = []; //list of instnaces of above background sounds
background_volumes = []; //list of volumes for each above sound, multiplier
background_pitches = []; //list of pitches for each above sound
background_emitters = []; //list of emitters for each above sound

stop_queue = []; //list of sounds waiting to be stopped

#endregion

#region BGM Loop Info

li_tracks = [];
li_info = [];

///@desc Function for setting the time at which a track loops and the length of the loop.
///@param track - The GameMaker asset representing the track you want to loop.
///@param [start] - The time (in seconds) where the loop begins.
///@param [end] - The time (in seconds) where the loop ends.
function bgm_set_loop_info(_track, _start = undefined, _end = undefined) {
	for(var i=0;i<array_length(li_tracks);i++) {
		if(li_tracks[i] == _track) {
			array_delete(li_tracks, i, 1);
			array_delete(li_info, i, 1);
			break;
		}
	}
	
	if(is_undefined(_start) || is_undefined(_end)) return;
	
	var _info = [_start, _end];
	array_push(li_tracks, _track);
	array_push(li_info, _info);
}

///@desc Function for getting loop information of a track. There really isn't any reason for you to use this function.
///@param track - The GameMaker asset representing the track you want the loop info for.
///@returns Loop info for 'track' or 'undefined' if not set.
function bgm_get_loop_info(_track) {
	for(var i=0;i<array_length(li_tracks);i++) {
		if(li_tracks[i] == _track) {
			return li_info[i];
		}
	}
	return undefined;
}

#endregion

#region BGM

///@desc Function for playing music. One piece of music can play at a time, and playing a new one will replace the old one.
///@param music - The GameMaker asset representing the piece of music you want to play.
///@param [loop] - Whether or not this particular piece of music should loop.
///@param [fade] - The time (in milliseconds) over which the track fades in. If another piece of music is playing already, that one will fade out over this amount of time as well.
///@param [volume] - The fractional volume to play music at (1 = 100%)
///@param [pitch] - The fractional pitch to play music at (1 = Normal)
function bgm_play(_music, _loop = true, _fade = 0, _volume = 1, _pitch = 1) {
	music_loop_end = undefined;
	music_loop_length = undefined;
	music_loop_full_track = false;
	
	if(_loop) {
		var _info = bgm_get_loop_info(_music);
		if(is_undefined(_info)) {
			music_loop_full_track = true;	
		} else {
			var _loop_start = _info[0];
			music_loop_end = _info[1];
			music_loop_length = music_loop_end - _loop_start;
		}
	}
	
	music_volume = _volume;
	music_pitch = _pitch;
	
	if(music == _music) {
		if(bgm_is_paused()) {
			bgm_resume(_fade);
		} else {
			bgm_set_volume(_volume, _fade);
			bgm_set_pitch(_pitch);
		}
	} else {
		bgm_stop(_fade);
		music = _music;
		music_inst = audio_play_sound(music, BGM_PRIORITY, music_loop_full_track);
		if(_fade > 0) audio_sound_gain(music_inst, 0, 0);
		audio_sound_pitch(music_inst, music_pitch);
		audio_sound_gain(music_inst, music_volume*gb_vol_bgm, _fade);
		music_paused_time = undefined;
	}
}

///@desc Function for stopping the currently playing music.
///@param [fade] - The time (in milliseconds) over which the track fades out.
function bgm_stop(_fade = 0) {
	if(bgm_is_playing()) {
		if(_fade == 0) {
			audio_stop_sound(music_inst);	
		} else {
			audio_sound_gain(music_inst, 0, _fade);
			array_push(stop_queue, music_inst);
		}
	}
	music = undefined;
	music_inst = undefined;
	music_paused_time = undefined;
}

///@desc Function for pausing the currently playing music.
///@param [fade] - The time (in milliseconds) over which the track fades out.
function bgm_pause(_fade = 0) {
	if(bgm_is_playing()) {
		music_paused_time = audio_sound_get_track_position(music_inst);
		if(_fade == 0) {
			audio_stop_sound(music_inst);
		} else {
			audio_sound_gain(music_inst, 0, _fade);
			array_push(stop_queue, music_inst);
		}
	}
}

///@desc Function for resuming the currently paused music.
///@param [fade] - The time (in milliseconds) over which the track fades in.
function bgm_resume(_fade = 0) {
	if(bgm_is_paused() && !is_undefined(music)) {
		music_inst = audio_play_sound(music, BGM_PRIORITY, music_loop_full_track);
		audio_sound_set_track_position(music_inst, music_paused_time);
		if(_fade > 0) audio_sound_gain(music_inst, 0, 0);
		audio_sound_pitch(music_inst, music_pitch);
		audio_sound_gain(music_inst, music_volume*gb_vol_bgm, _fade);
		music_paused_time = undefined;
	}
}

///@desc Function for setting the global volume of all pieces of music you could play. Unlike bgm_set_volume, this volume is not overridden when new music plays. This is recommended for game volume set by the player in a menu.
///@param volume - The volume to set as the global music volume.
///@param [fade] - The time (in milliseconds) over which the currently playing track changes volume.
function bgm_set_global_volume(_volume, _fade = 0) {
	gb_vol_bgm = _volume;
	bgm_update_gain(_fade);
}

///@desc Function for getting the current global music volume.
///@returns The global music volume.
function bgm_get_global_volume() {
	return gb_vol_bgm;
}

///@desc Function for setting the volume of the currently playing music.
///@param volume - The volume to set.
///@param [fade] - The time (in milliseconds) over which the track changes volume.
function bgm_set_volume(_volume, _fade = 0) {
	music_volume = _volume;
	bgm_update_gain(_fade);
}

///@desc Function for getting the volume of the currently playing music.
///@returns The volume of the currently playing music.
function bgm_get_volume() {
	return music_volume;
}

///@desc Function for setting the pitch of the currently playing music.
///@param [pitch] - The pitch to set.
function bgm_set_pitch(_pitch) {
	music_pitch = _pitch;
	if(bgm_is_playing()) {
		audio_sound_pitch(music_inst, music_pitch);	
	}
}

///@desc Function for getting the pitch of the currently playing music.
///@returns The pitch of the currently playing music.
function bgm_get_pitch() {
	return music_pitch;
}

///@desc Function for setting the current position of the currently playing music.
///@param time - The time to set.
function bgm_set_time(_time) {
	if(bgm_is_playing()) {
		audio_sound_set_track_position(music_inst, _time);	
	} else if(bgm_is_paused()) {
		music_paused_time = _time;
	}
}

///@desc Function for getting the current position of the currently playing music.
///@returns The position of the currently playing music.
function bgm_get_time() {
	if(bgm_is_playing()) {
		return audio_sound_get_track_position(music_inst);	
	} else if(bgm_is_paused()) {
		return music_paused_time;	
	}
	return 0;
}

///@desc Function for determining if music is currently playing.
///@returns Whether or not music is playing (true = yes)
function bgm_is_playing() {
	return !is_undefined(music_inst);
}

///@desc Function for determining if music is currently paused.
///@returns Whether or not music is paused (true = yes)
function bgm_is_paused() {
	return !is_undefined(music) && !is_undefined(music_paused_time);
}

///@desc Function for updating the volume of the currently playing music. There really isn't any reason for you to use this function.
///@param [fade] - The time (in milliseconds) over which the track changes volume.
function bgm_update_gain(_fade = 0) {
	if(bgm_is_playing()) {
		audio_sound_gain(music_inst, music_volume*gb_vol_bgm, _fade);	
	}
}

#endregion

#region SFX

///@desc Function for playing sound effects. Sound effects are non-looping sounds that can trigger when something happens in your game.
///@param sound - The GameMaker asset representing the sound you want to play.
///@param [fade] - The time (in milliseconds) over which the sound fades in.
///@param [volume] - The fractional volume to play the sound at (1 = 100%)
///@param [pitch] - The fractional pitch to play the sound at (1 = Normal)
function sfx_play(_sound, _fade = 0, _volume = 1, _pitch = 1) {
	array_push(sounds, _sound);
	array_push(sound_volumes, _volume);
	array_push(sound_pitches, _pitch);
	array_push(sound_emitters, undefined);
	
	var _inst = audio_play_sound(_sound, SFX_PRIORITY, false);
	if(_fade > 0) audio_sound_gain(_inst, 0, 0);
	audio_sound_gain(_inst, _volume*gb_vol_sfx, _fade);
	audio_sound_pitch(_inst, _pitch);
	array_push(sound_insts, _inst);
}

///@desc Function for playing sound effects at a physical location in the world. In order for this function to work, you must set the audio_listener_orientation once and update the audio_listener_position every step. It is recommended you do this in your player object. Sound effects are non-looping sounds that can trigger when something happens in your game.
///@param sound - The GameMaker asset representing the sound you want to play.
///@param x - The x coordinate from which the sound should originate.
///@param y - The y coordinate from which the sound should originate.
///@param [fade] - The time (in milliseconds) over which the sound fades in.
///@param [volume] - The fractional volume to play the sound at (1 = 100%)
///@param [pitch] - The fractional pitch to play the sound at (1 = Normal)
function sfx_play_at(_sound, _x, _y, _fade = 0, _volume = 1, _pitch = 1) {
	array_push(sounds, _sound);
	array_push(sound_volumes, _volume);
	array_push(sound_pitches, _pitch);
	
	var _emitter = audio_emitter_create();
	audio_emitter_position(_emitter, _x, _y, 0);
	audio_falloff_set_model(FALLOFF_MODEL);
	array_push(sound_emitters, _emitter);
	
	var _inst = audio_play_sound_at(_sound, _x, _y, 0, FALLOFF_REF_DIST, FALLOFF_MAX_DIST, FALLOFF_FACTOR, false, SFX_PRIORITY);
	if(_fade > 0) audio_sound_gain(_inst, 0, 0);
	audio_sound_gain(_inst, _volume*gb_vol_sfx, _fade);
	audio_sound_pitch(_inst, _pitch);
	array_push(sound_insts, _inst);
}

///@desc Function for stopping a currently playing sound effect.
///@param sound - The GameMaker asset representing the sound you want to stop.
///@param [fade] - The time (in milliseconds) over which the sound fades out.
function sfx_stop(_sound, _fade = 0) {
	for(var i=0;i<array_length(sounds);i++) {
		if(sounds[i] == _sound) {
			if(_fade == 0) {
				audio_stop_sound(sound_insts[i]);
				if(!is_undefined(sound_emitters[i])) {
					audio_emitter_free(sound_emitters[i]);
				}
			} else {
				audio_sound_gain(sound_insts[i], 0, _fade);
				if(!is_undefined(sound_emitters[i])) {
					array_push(stop_queue, [sound_insts[i], sound_emitters[i]]);
				} else {
					array_push(stop_queue, sound_insts[i]);
				}
			}
			array_delete(sounds, i, 1);
			array_delete(sound_volumes, i, 1);
			array_delete(sound_pitches, i, 1);
			array_delete(sound_emitters, i, 1);
			array_delete(sound_insts, i, 1);
			
			i--;
		}
	}
}

///@desc Function for stopping all currently playing sound effects.
///@param [fade] - The time (in milliseconds) over which the sounds fade out.
function sfx_stop_all(_fade = 0) {
	while(array_length(sounds) > 0) {
		if(_fade == 0) {
			audio_stop_sound(sound_insts[0]);
			if(!is_undefined(sound_emitters[0])) {
				audio_emitter_free(sound_emitters[0]);	
			}
		} else {
			audio_sound_gain(sound_insts[0], 0, _fade);
			if(!is_undefined(sound_emitters[0])) {
				array_push(stop_queue, [sound_insts[0], sound_emitters[0]]);
			} else {
				array_push(stop_queue, sound_insts[0]);	
			}
		}
		array_delete(sounds, 0, 1);
		array_delete(sound_volumes, 0, 1);
		array_delete(sound_pitches, 0, 1);
		array_delete(sound_emitters, 0, 1);
		array_delete(sound_insts, 0, 1);
	}
}

///@desc Function for setting the global volume of all sound effects you could play. Unlike sfx_set_volume, this volume is used for all playing sounds, and is not overridden when a new sound effect plays. This is recommended for game volume set by the player in a menu.
///@param volume - The volume to set as the global sound effects volume.
///@param [fade] - The time (in milliseconds) over which the currently playing sound effects change volume.
function sfx_set_global_volume(_volume, _fade = 0) {
	gb_vol_sfx = _volume;
	sfx_update_gain(_fade);
}

///@desc Function for getting the current global sound effects volume.
///@returns The global sound effects volume.
function sfx_get_global_volume() {
	return gb_vol_sfx;
}

///@desc Function for setting the volume of a currently playing sound effect.
///@param sound - The GameMaker asset representing the sound you want to adjust the volume of.
///@param volume - The volume to set.
///@param [fade] - The time (in milliseconds) over which the track changes volume.
function sfx_set_volume(_sound, _volume, _fade = 0) {
	for(var i=0;i<array_length(sounds);i++) {
		if(sounds[i] == _sound) {
			sound_volumes[i] = _volume;
			audio_sound_gain(sound_insts[i], sound_volumes[i]*gb_vol_sfx, _fade);
		}
	}
}

///@desc Function for getting the volume of the currently playing sound effect.
///@param sound - The GameMaker asset representing the sound you want to get the volume of.
///@returns The volume of the sound effect.
function sfx_get_volume(_sound) {
	for(var i=0;i<array_length(sounds);i++) {
		if(sounds[i] == _sound) {
			return sound_volumes[i];
		}
	}
	return undefined;
}

///@desc Function for setting the pitch of the currently playing sound effect.
///@param sound - The GameMaker asset representing the sound you want to adjust the pitch of.
///@param [pitch] - The pitch to set.
function sfx_set_pitch(_sound, _pitch) {
	for(var i=0;i<array_length(sounds);i++) {
		if(sounds[i] == _sound) {
			sound_pitches[i] = _pitch;
			audio_sound_pitch(sound_insts[i], sound_pitches[i]);
		}
	}
}

///@desc Function for getting the pitch of the currently playing sound effect.
///@param sound - The GameMaker asset representing the sound you want to get the pitch of.
///@returns The pitch of the sound effect.
function sfx_get_pitch(_sound) {
	for(var i=0;i<array_length(sounds);i++) {
		if(sounds[i] == _sound) {
			return sound_pitches[i];	
		}
	}
	return undefined;
}

///@desc Function for determining if a specific sound effect is currently playing.
///@param sound - The GameMaker asset representing the sound you want to see if it's playing.
///@returns Whether or not the sound is playing (true = yes)
function sfx_is_playing(_sound) {
	for(var i=0;i<array_length(sounds);i++) {
		if(sounds[i] == _sound) {	
			return true;
		}
	}
	return false;
}

///@desc Function for determining if any sound effects are currently playing.
///@returns Whether or not any sound effects are playing (true = yes)
function sfx_is_any_playing() {
	return array_length(sounds) > 0;
}

///@desc Function for updating the volume of the currently playing sound effects. There really isn't any reason for you to use this function.
///@param [fade] - The time (in milliseconds) over which the sounds change volume.
function sfx_update_gain(_fade = 0) {
	for(var i=0;i<array_length(sounds);i++) {
		audio_sound_gain(sound_insts[i], sound_volumes[i]*gb_vol_sfx, _fade);	
	}
}

#endregion

#region BGS


///@desc Function for playing background sounds. Background sounds are loopable ambient sounds to spruce up an environment, such as rain.
///@param background - The GameMaker asset representing the sound you want to play.
///@param [fade] - The time (in milliseconds) over which the sound fades in.
///@param [volume] - The fractional volume to play the sound at (1 = 100%)
///@param [pitch] - The fractional pitch to play the sound at (1 = Normal)
function bgs_play(_background, _fade = 0, _volume = 1, _pitch = 1) {
	array_push(backgrounds, _background);
	array_push(background_volumes, _volume);
	array_push(background_pitches, _pitch);
	array_push(background_emitters, undefined);
	
	var _inst = audio_play_sound(_background, BGS_PRIORITY, true);
	if(_fade > 0) audio_sound_gain(_inst, 0, 0);
	audio_sound_gain(_inst, _volume*gb_vol_bgs, _fade);
	audio_sound_pitch(_inst, _pitch);
	array_push(background_insts, _inst);
}

///@desc Function for playing background sounds at a physical location in the world. In order for this function to work, you must set the audio_listener_orientation once and update the audio_listener_position every step. It is recommended you do this in your player object. Background sounds are loopable ambient sounds to spruce up an environment, such as rain.
///@param background - The GameMaker asset representing the sound you want to play.
///@param x - The x coordinate from which the sound should originate.
///@param y - The y coordinate from which the sound should originate.
///@param [fade] - The time (in milliseconds) over which the sound fades in.
///@param [volume] - The fractional volume to play the sound at (1 = 100%)
///@param [pitch] - The fractional pitch to play the sound at (1 = Normal)
function bgs_play_at(_background, _x, _y, _fade = 0, _volume = 1, _pitch = 1) {
	array_push(backgrounds, _background);
	array_push(background_volumes, _volume);
	array_push(background_pitches, _pitch);
	
	var _emitter = audio_emitter_create();
	audio_emitter_position(_emitter, _x, _y, 0);
	audio_falloff_set_model(FALLOFF_MODEL);
	array_push(background_emitters, _emitter);
	
	var _inst = audio_play_sound_at(_background, _x, _y, 0, FALLOFF_REF_DIST, FALLOFF_MAX_DIST, FALLOFF_FACTOR, true, BGS_PRIORITY);
	if(_fade > 0) audio_sound_gain(_inst, 0, 0);
	audio_sound_gain(_inst, _volume*gb_vol_bgs, _fade);
	audio_sound_pitch(_inst, _pitch);
	array_push(background_insts, _inst);
}

///@desc Function for stopping a currently playing background sound.
///@param background - The GameMaker asset representing the sound you want to stop.
///@param [fade] - The time (in milliseconds) over which the sound fades out.
function bgs_stop(_background, _fade = 0) {
	for(var i=0;i<array_length(backgrounds);i++) {
		if(backgrounds[i] == _background) {
			if(_fade == 0) {
				audio_stop_sound(background_insts[i]);
				if(!is_undefined(background_emitters[i])) {
					audio_emitter_free(background_emitters[i]);
				}
			} else {
				audio_sound_gain(background_insts[i], 0, _fade);
				if(!is_undefined(background_emitters[i])) {
					array_push(stop_queue, [background_insts[i], background_emitters[i]]);
				} else {
					array_push(stop_queue, background_insts[i]);
				}
			}
			array_delete(backgrounds, i, 1);
			array_delete(background_volumes, i, 1);
			array_delete(background_pitches, i, 1);
			array_delete(background_emitters, i, 1);
			array_delete(background_insts, i, 1);
			
			i--;
		}
	}
}

///@desc Function for stopping all currently playing background sounds.
///@param [fade] - The time (in milliseconds) over which the sounds fade out.
function bgs_stop_all(_fade = 0) {
	while(array_length(backgrounds) > 0) {
		if(_fade == 0) {
			audio_stop_sound(background_insts[0]);
			if(!is_undefined(background_emitters[0])) {
				audio_emitter_free(background_emitters[0]);	
			}
		} else {
			audio_sound_gain(background_insts[0], 0, _fade);
			if(!is_undefined(background_emitters[0])) {
				array_push(stop_queue, [background_insts[0], background_emitters[0]]);
			} else {
				array_push(stop_queue, background_insts[0]);	
			}
		}
		array_delete(backgrounds, 0, 1);
		array_delete(background_volumes, 0, 1);
		array_delete(background_pitches, 0, 1);
		array_delete(background_emitters, 0, 1);
		array_delete(background_insts, 0, 1);
	}
}

///@desc Function for setting the global volume of all background sounds you could play. Unlike bgs_set_volume, this volume is used for all playing sounds, and is not overridden when a new background sound plays. This is recommended for game volume set by the player in a menu.
///@param volume - The volume to set as the global background sounds volume.
///@param [fade] - The time (in milliseconds) over which the currently playing background sounds change volume.
function bgs_set_global_volume(_volume, _fade = 0) {
	gb_vol_bgs = _volume;
	sfx_update_gain(_fade);
}

///@desc Function for getting the current global background sounds volume.
///@returns The global background sounds volume.
function bgs_get_global_volume() {
	return gb_vol_bgs;
}

///@desc Function for setting the volume of a currently playing background sounds.
///@param sound - The GameMaker asset representing the sound you want to adjust the volume of.
///@param volume - The volume to set.
///@param [fade] - The time (in milliseconds) over which the track changes volume.
function bgs_set_volume(_background, _volume, _fade = 0) {
	for(var i=0;i<array_length(backgrounds);i++) {
		if(backgrounds[i] == _background) {
			background_volumes[i] = _volume;
			audio_sound_gain(background_insts[i], background_volumes[i]*gb_vol_bgs, _fade);
		}
	}
}

///@desc Function for getting the volume of the currently playing background sounds.
///@param sound - The GameMaker asset representing the sound you want to get the volume of.
///@returns The volume of the background sounds.
function bgs_get_volume(_background) {
	for(var i=0;i<array_length(backgrounds);i++) {
		if(backgrounds[i] == _background) {
			return background_volumes[i];
		}
	}
	return undefined;
}

///@desc Function for setting the pitch of the currently playing background sounds.
///@param sound - The GameMaker asset representing the sound you want to adjust the pitch of.
///@param [pitch] - The pitch to set.
function bgs_set_pitch(_background, _pitch) {
	for(var i=0;i<array_length(backgrounds);i++) {
		if(backgrounds[i] == _background) {
			background_pitches[i] = _pitch;
			audio_sound_pitch(background_insts[i], background_pitches[i]);
		}
	}
}

///@desc Function for getting the pitch of the currently playing background sounds.
///@param sound - The GameMaker asset representing the sound you want to get the pitch of.
///@returns The pitch of the background sounds.
function bgs_get_pitch(_background) {
	for(var i=0;i<array_length(backgrounds);i++) {
		if(backgrounds[i] == _background) {
			return background_pitches[i];	
		}
	}
	return undefined;
}

///@desc Function for determining if a specific background sound is currently playing.
///@param background - The GameMaker asset representing the sound you want to see if it's playing.
///@returns Whether or not the sound is playing (true = yes)
function bgs_is_playing(_background) {
	for(var i=0;i<array_length(backgrounds);i++) {
		if(backgrounds[i] == _background) {	
			return true;
		}
	}
	return false;
}

///@desc Function for determining if any background sounds are currently playing.
///@returns Whether or not any background sounds are playing (true = yes)
function bgs_is_any_playing() {
	return array_length(backgrounds) > 0;
}

///@desc Function for updating the volume of the currently playing background sounds. There really isn't any reason for you to use this function.
///@param [fade] - The time (in milliseconds) over which the sounds change volume.
function bgs_update_gain(_fade = 0) {
	for(var i=0;i<array_length(backgrounds);i++) {
		audio_sound_gain(background_insts[i], background_volumes[i]*gb_vol_bgs, _fade);	
	}
}

#endregion