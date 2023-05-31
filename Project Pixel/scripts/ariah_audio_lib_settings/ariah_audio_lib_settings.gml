/* -- Ariah's Audio Library ~ Version 1.3.0 --
 *
 * LICENSE:
 * > CC0
 * > To the extent possible under law, Ariah has waived all copyright and related or neighboring rights to Ariah's Audio Library. This work is published from: United States.
 *
 * INSTRUCTIONS:
 * 0. Modify any of the settings in this file below until you are happy with them.
 * 1. Place this object in the first room in your game.
 * 2. Use any of the included functions anywhere, and it just works!
 *
 * DOCUMENTATION:
 * > Documentation may be available on my website: 'https://ariahsiwik.github.io/gmlibs/audio'
 */

#region Audio Priority Settings

function __AriahAudioLibrary__BGM_PRIORITY() {
	return 2;	
}

function __AriahAudioLibrary__SFX_PRIORITY() {
	return 3;	
}

function __AriahAudioLibrary__BGS_PRIORITY() {
	return 1;	
}

#endregion

#region Audio Falloff Settings

function __AriahAudioLibrary__FALLOFF_MODEL() {
	return audio_falloff_linear_distance;	
}

function __AriahAudioLibrary__FALLOFF_REF_DIST() {
	return 100;	
}

function __AriahAudioLibrary__FALLOFF_MAX_DIST() {
	return 300;	
}

function __AriahAudioLibrary__FALLOFF_FACTOR() {
	return 1;	
}

#endregion

#region Legacy Settings

function __AriahAudioLibrary__LEGACY_USE_SECONDS_IN_BGM() {
	return false;	
}

#endregion