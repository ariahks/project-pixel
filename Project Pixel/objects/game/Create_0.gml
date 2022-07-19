if(IS_DEV_BUILD) {
	window_set_caption(GAME_TITLE + " (dev build) V" + string(MAJOR_VERSION) + "." + string(MINOR_VERSION));
}

display_set_gui_size(GAME_WIDTH, GAME_HEIGHT);

settings = { };

data = { };

flag = {
	flags : { },
	set : function(_flag, _bool) {
		flags[$ _flag] = _bool;
	},
	get : function(_flag) {
		if(variable_struct_exists(flags, _flag)) return flags[$ _flag];
		return false;
	},
	toggle : function(_flag) {
		set(_flag, !get(_flag));	
	},
};

num = {
	nums : { },
	set : function(_num, _value) {
		nums[$ _num] = _value;	
	},
	get : function(_num) {
		if(variable_struct_exists(nums, _num)) return nums[$ _num];
		return 0;
	},
	add : function(_num, _addend) {
		set(_num, get(_num) + _addend);	
	},
	multiply : function(_num, _factor) {
		set(_num, get(_num) * _factor);
	},
};

str = {
	strs : { },
	set : function(_str, _string) {
		strs[$ _str] = _string;	
	},
	get : function(_str) {
		if(variable_struct_exists(strs, _str)) return strs[$ _str];
		return "";
	},
	concatenate : function(_str, _string) {
		set(_str, get(_str) + string(_string));

	},
};

function reset_settings() {
	delete settings;
	settings = {
		language : "en_us",
		vol_bgm : 100,
		vol_sfx : 100,
		vol_bgs : 100,
		scale : 3,
		fullscreen : false,
	};
}

function reset_save_data() {
	delete data;
	delete flag.flags;
	delete num.nums;
	delete str.strs;
	data = {
		room : START_ROOM,
		x : START_X,
		y : START_Y,
	};
	flag.flags = {
		game_has_started : false,	
	};
	num.nums = {
		r : irandom(99) + 1,
	};
	str.strs = {
		game_title : "Project Pixel",
	};
}

function settings_save() {
	var _string = string(SETTINGS_FORMAT) + "%" + json_stringify(settings);
	string_save_to_file(SETTINGS_FILE, _string);
}

function settings_load() {
	var _string = string_load_from_file(SETTINGS_FILE);
	if(!is_undefined(_string)) {
		var _format_str = "";
		var _settings_str = "";
		for(var i=1;i<=string_length(_string);i++) {
			var _c = string_char_at(_string, i);
			if(_c != "%") _format_str += _c;
			else {
				_settings_str = string_copy(_string, i+1, string_length(_string)-i);
				break;
			}
		}
		var _format = real(_format_str);
		if(_format == SETTINGS_FORMAT) {
			delete settings;
			settings = json_parse(_settings_str);
			
			window_set_size(GAME_WIDTH*game.settings.scale, GAME_HEIGHT*game.settings.scale);
			window_set_position((display_get_width() - GAME_WIDTH*game.settings.scale)/2, (display_get_height() - GAME_HEIGHT*game.settings.scale)/2);
			window_set_fullscreen(game.settings.fullscreen);
		} else if(_format < SETTINGS_FORMAT) {
			show_debug_message("[WARNING] Old settings file detected. Attempting to convert...");
			var _converted_str = convert_old_settings(_format, _settings_str); 
			if(!is_undefined(_converted_str)) {
				show_debug_message("[INFO] Conversion successful!");
				delete settings;
				settings = json_parse(_converted_str);
			
				window_set_size(GAME_WIDTH*game.settings.scale, GAME_HEIGHT*game.settings.scale);
				window_set_position((display_get_width() - GAME_WIDTH*game.settings.scale)/2, (display_get_height() - GAME_HEIGHT*game.settings.scale)/2);
				window_set_fullscreen(game.settings.fullscreen);
			} else {
				show_debug_message("[ERROR] Conversion failed. Is the file corrupt?");
				show_debug_message("[INFO] Renaming old settings file to \""+SETTINGS_FILE+"_backup_ST"+string(_format)+"\"...");
				file_rename(SETTINGS_FILE, SETTINGS_FILE+"_backup_ST"+string(_format));
				show_debug_message("[INFO] Done!");
			}
		} else if(_format > SETTINGS_FORMAT) {
			show_debug_message("[ERROR] Settings file is from the future! It cannot be parsed by this version.");
			show_debug_message("[INFO] Renaming old settings file to \""+SETTINGS_FILE+"_backup_ST"+string(_format)+"\"...");
			file_rename(SETTINGS_FILE, SETTINGS_FILE+"_backup_ST"+string(_format));
			show_debug_message("[INFO] Done!");
		}
	}
}

function save() {
	var _string = string(SAVE_FORMAT) + "%" + 
				  json_stringify(data) + "%" +
				  json_stringify(flag.flags) + "%" +
				  json_stringify(num.nums) + "%" +
				  json_stringify(str.strs);
	string_save_to_file(SAVE_FILE, _string, true);
}

function load() {
	var _string = string_load_from_file(SAVE_FILE, true);
	if(!is_undefined(_string)) {
		var _format_str = "";
		var _data_str = "";
		var _flags_str = "";
		var _nums_str = "";
		var _strs_str = "";
		
		var _str_index = 0;
		
		for(var i=1;i<=string_length(_string);i++) {
			var _c = string_char_at(_string, i);
			if(_c != "%") {
				switch(_str_index) {
					case 0:
						_format_str += _c;
						break;
					case 1:
						_data_str += _c;
						break;
					case 2:
						_flags_str += _c;
						break;
					case 3:
						_nums_str += _c;
						break;
					case 4:
						_strs_str += _c;
						break;
				}
			} else {
				_str_index++;	
			}
		}
		var _format = real(_format_str);
		if(_format == SAVE_FORMAT) {
			delete data;
			delete flag.flags;
			delete num.nums;
			delete str.strs;
			data = json_parse(_data_str);
			flag.flags = json_parse(_flags_str);
			num.nums = json_parse(_nums_str);
			str.strs = json_parse(_strs_str);
		} else if(_format < SAVE_FORMAT) {
			show_debug_message("[WARNING] Old save file detected. Attempting to convert...");
			var _converted_str = convert_old_save(_format, _data_str, _flags_str, _nums_str, _strs_str); 
			if(!is_undefined(_converted_str)) {
				show_debug_message("[INFO] Conversion successful!");
				delete data;
				delete flag.flags;
				delete num.nums;
				delete str.strs;
				data = json_parse(_data_str);
				flag.flags = json_parse(_flags_str);
				num.nums = json_parse(_nums_str);
				str.strs = json_parse(_strs_str);
			} else {
				show_debug_message("[ERROR] Conversion failed. Is the file corrupt?");
				show_debug_message("[INFO] Renaming old save file to \""+SAVE_FILE+"_backup_SV"+string(_format)+"\"...");
				file_rename(SAVE_FILE, SAVE_FILE+"_backup_SV"+string(_format));
				show_debug_message("[INFO] Done!");
			}
		} else if(_format > SAVE_FORMAT) {
			show_debug_message("[ERROR] Save file is from the future! It cannot be parsed by this version.");
			show_debug_message("[INFO] Renaming old save file to \""+SAVE_FILE+"_backup_SV"+string(_format)+"\"...");
			file_rename(SAVE_FILE, SAVE_FILE+"_backup_SV"+string(_format));
			show_debug_message("[INFO] Done!");
		}
	}
}

reset_settings();
settings_load();
settings_save();

reset_save_data();
load();
save();