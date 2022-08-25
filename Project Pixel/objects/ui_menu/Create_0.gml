SIGNATURE = "758e6af20bcc929e4f9a24490425a26d";
VERSION = "394107e54b7afdd84ab8050a43f90fb1";

#region Constants

__USE_ARIAH_AUDIO_LIB = function() {
	if(asset_get_type("audio") == asset_object) {
		if(instance_number(audio) > 0) {
			var _id = instance_find(audio, 0);
			if(variable_instance_exists(_id, "SIGNATURE")) {
				if(_id.SIGNATURE == "47eeed78d46ceff4d28e5f86d99cf51a") {
					return true;
				}
			}
		}
	}
	return false;
};

__DIRECTION_RIGHT = 0;
__DIRECTION_UP = 1;
__DIRECTION_LEFT = 2;
__DIRECTION_DOWN = 3;

#endregion

#region Define Variables

font_default = __AriahMenuLibrary__DEFAULT_FONT();

sprite_default = __AriahMenuLibrary__DEFAULT_SPRITE();

blip_z_default = __AriahMenuLibrary__DEFAULT_CONFIRM_BLIP();
blip_x_default = __AriahMenuLibrary__DEFAULT_CANCEL_BLIP();
blip_move_default = __AriahMenuLibrary__DEFAULT_MOVE_BLIP();

anchor_h_default = __AriahMenuLibrary__DEFAULT_HORIZONTAL_ANCHOR();
anchor_v_default = __AriahMenuLibrary__DEFAULT_VERTICAL_ANCHOR();

x_offset_default = __AriahMenuLibrary__DEFAULT_X_OFFSET();
y_offset_default = __AriahMenuLibrary__DEFAULT_Y_OFFSET();

colors_default = __AriahMenuLibrary__DEFAULT_COLORS();

index = 0;

focus = true;
with(ui_menu) {
	if(focus && id != other.id) other.focus = false;
}

name = undefined;

op_v_border = 8;
op_h_border = 8;
op_v_space = 2;
op_h_space = 8;

width = 0;
height = 0;

grid_width = 0;
grid_height = 0;

col_width = 0;
row_height = 0;

alpha = 1;

fade = false;
darken_background = false;
pending_destruction = false;

menu_visible = true;

func_step = function() { }

page = [];

#endregion

function destroy() {
	pending_destruction = true;
	return id;
}

function set_name(_name) {
	name = _name;
	return id;
}

function get_name() {
	return name;	
}

function request_focus() {
	with(ui_menu) focus = false;
	focus = true;
	return id;
}

function has_focus() {
	return focus;	
}

function select_option(_option, _page = undefined) {
	var _index = index;
	if(!is_undefined(_page)) {
		for(var i=0;i<array_length(page);i++) {
			if(page[i].name == _page) _index = i;	
		}
	}
	if(page[_index].layout == "free") {
		for(var i=0;i<array_length(page[_index].options);i++) {
			var _o = page[_index].options[i];
			if(_o.name == _option) {
				page[_index].options[page[_index].pos].func_leave();
				page[_index].pos = i;
				page[_index].options[i].func_enter();
				return id;
			}
		}
	} else {
		for(var i=0;i<array_length(page[_index].options);i++) {
			for(var j=0;j<array_length(page[_index].options[i]);j++) {
				var _o = page[_index].options[i][j];
				if(_o.name == _option) {
					if(page[_index].layout == "rows") {
						page[_index].options[page[_index].y_pos][page[_index].x_pos].func_leave();	
						page[_index].x_pos = j;
						page[_index].y_pos = i;
					} else if(page[_index].layout == "columns") {
						page[_index].options[page[_index].x_pos][page[_index].y_pos].func_leave();
						page[_index].x_pos = i;
						page[_index].y_pos = j;
					}
					page[_index].options[i][j].func_enter();
					return id;
				}
			}
		}
	}
	return id;
}

function set_visible(_visible) {
	menu_visible = _visible;
}

function is_visible() {
	return menu_visible;
}

#region set_default_functions

function set_default_font(_font) {
	font_default = _font;
	return id;
}

function set_default_sprite(_sprite) {
	sprite_default = _sprite;
	return id;
}

function set_default_blips(_blip_z, _blip_x, _blip_move) {
	blip_z_default = _blip_z;
	blip_x_default = _blip_x;
	blip_move_default = _blip_move;
	return id;
}

function set_default_anchor(_anchor_h, _anchor_v) {
	anchor_h_default = _anchor_h;
	anchor_v_default = _anchor_v;
	return id;
}

function set_default_position(_x_offset, _y_offset) {
	x_offset_default = _x_offset;
	y_offset_default = _y_offset;
	return id;
}

///@param color1
///@param [color2]
///@param [color3]
///@param [color4]
function set_default_colors() {
	if(argument_count == 0) return;
	colors_default.c1 = argument[0];
	colors_default.c2 = undefined;
	colors_default.s1 = undefined;
	colors_default.s2 = undefined;
	
	if(argument_count == 2) {
		colors_default.s1 = argument[1];
	} else if(argument_count == 3) {
		colors_default.c2 = argument[1];
		colors_default.s1 = argument[2];
	} else if(argument_count >= 4) {
		colors_default.c2 = argument[1];
		colors_default.s1 = argument[2];
		colors_default.s2 = argument[3];
	}
}

#endregion

#region Page Manipulation

function add_page(_page) {
	array_push(page, _page);
	return id;
}

function set_page(_page) {
	for(var i=0;i<array_length(page);i++) {
		if(page[i].name == _page) {
			index = i;
		}
	}
	return id;
}

function get_page(_page) {
	for(var i=0;i<array_length(page);i++) {
		if(page[i].name == _page) {
			return page[i];	
		}
	}
	return undefined;
}

function get_current_page() {
	return page[index];
}

function get_current_option() {
	switch(page[index].layout) {
		case "free":
			return page[index].options[page[index].pos];
		case "rows":
			return page[index].options[page[index].y_pos][page[index].x_pos];
		case "columns":
			return page[index].options[page[index].x_pos][page[index].y_pos];
	}
	return undefined;
}

#endregion

function set_fade(_fade) {
	fade = _fade;
	alpha = _fade ? 0 : 1;	
	return id;
}

function set_darken_background(_dark_bg) {
	darken_background = _dark_bg;
	return id;
}

function set_function_step(_func) {
	func_step = _func;
	return id;
}

#region MenuPage

function MenuPage(_name) constructor {
	name = _name;
	sprite = other.sprite_default;
	anchor_h = other.anchor_h_default;
	anchor_v = other.anchor_v_default;
	x_offset = other.x_offset_default;
	y_offset = other.y_offset_default;
	options = [];
	layout = "";
	
	set_sprite = function(_sprite) {
		sprite = _sprite;
		return self;
	};
	
	set_anchor = function(_anchor_h, _anchor_v) {
		anchor_h = _anchor_h;
		anchor_v = _anchor_v;
		return self;
	};
	
	set_position = function(_x_offset, _y_offset) {
		x_offset = _x_offset;
		y_offset = _y_offset;
		return self;
	};
	
	func_up_default = function() { };
	func_down_default = function() { };
	func_left_default = function() { };
	func_right_default = function() { };
	
	get_option = function(_option) { };
}

function MenuPageRows(_name) : MenuPage(_name) constructor {
	x_pos = 0;
	y_pos = 0;
	layout = "rows";
	
	add_option = function() {
		var _row = [];
		for(var i=0;i<argument_count;i++) {
			var _option = argument[i];
			if(is_undefined(_option.func_up)) _option.set_function_up(func_up_default);
			if(is_undefined(_option.func_down)) _option.set_function_down(func_down_default);
			if(is_undefined(_option.func_left)) _option.set_function_left(func_left_default);
			if(is_undefined(_option.func_right)) _option.set_function_right(func_right_default);
			array_push(_row, argument[i]);
		}
		array_push(options, _row);
		return self;
	};
	
	func_up_default = function() {
		with(other) {
			if(!page[index].options[page[index].y_pos][page[index].x_pos].move_up_enabled) return;
			
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].y_pos--;
			if(page[index].y_pos < 0) page[index].y_pos = array_length(page[index].options)-1;
			if(page[index].x_pos >= array_length(page[index].options[page[index].y_pos])) page[index].x_pos = array_length(page[index].options[page[index].y_pos])-1;
			while(!page[index].options[page[index].y_pos][page[index].x_pos].selectable) {
				page[index].y_pos--;
				if(page[index].y_pos < 0) page[index].y_pos = array_length(page[index].options)-1;
				if(page[index].x_pos >= array_length(page[index].options[page[index].y_pos])) page[index].x_pos = array_length(page[index].options[page[index].y_pos])-1;
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_y0][_x0].func_leave();
				page[index].options[page[index].y_pos][page[index].x_pos].func_enter();
			}
		}
	};
	
	func_down_default = function() { 
		with(other) {
			if(!page[index].options[page[index].y_pos][page[index].x_pos].move_down_enabled) return;
			
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].y_pos++;
			if(page[index].y_pos >= array_length(page[index].options)) page[index].y_pos = 0;
			if(page[index].x_pos >= array_length(page[index].options[page[index].y_pos])) page[index].x_pos = array_length(page[index].options[page[index].y_pos])-1;
			while(!page[index].options[page[index].y_pos][page[index].x_pos].selectable) {
				page[index].y_pos++;
				if(page[index].y_pos >= array_length(page[index].options)) page[index].y_pos = 0;
				if(page[index].x_pos >= array_length(page[index].options[page[index].y_pos])) page[index].x_pos = array_length(page[index].options[page[index].y_pos])-1;
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_y0][_x0].func_leave();
				page[index].options[page[index].y_pos][page[index].x_pos].func_enter();
			}
		}
	};
	
	func_left_default = function() { 
		with(other) {
			if(!page[index].options[page[index].y_pos][page[index].x_pos].move_left_enabled) return;
		
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].x_pos--;
			if(page[index].x_pos < 0) page[index].x_pos = array_length(page[index].options[page[index].y_pos])-1;
			while(!page[index].options[page[index].y_pos][page[index].x_pos].selectable) {
				page[index].x_pos--;
				if(page[index].x_pos < 0) page[index].x_pos = array_length(page[index].options[page[index].y_pos])-1;
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_y0][_x0].func_leave();
				page[index].options[page[index].y_pos][page[index].x_pos].func_enter();
			}
		}
	};
	
	func_right_default = function() { 
		with(other) {
			if(!page[index].options[page[index].y_pos][page[index].x_pos].move_right_enabled) return;
			
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].x_pos++;
			if(page[index].x_pos >= array_length(page[index].options[page[index].y_pos])) page[index].x_pos = 0;	
			while(!page[index].options[page[index].y_pos][page[index].x_pos].selectable) {
				page[index].x_pos++;
				if(page[index].x_pos >= array_length(page[index].options[page[index].y_pos])) page[index].x_pos = 0;	
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_y0][_x0].func_leave();
				page[index].options[page[index].y_pos][page[index].x_pos].func_enter();
			}
		}
	};
	
	get_option = function(_option) {
		for(var	i=0;i<array_length(options);i++) {
			for(var j=0;j<array_length(options[i]);j++) {
				if(options[i][j].name == _option) return options[i][j];	
			}
		}
	};
}

function MenuPageColumns(_name) : MenuPage(_name) constructor {
	x_pos = 0;
	y_pos = 0;
	layout = "columns";
	
	add_option = function() {
		var _column = [];
		for(var i=0;i<argument_count;i++) {
			var _option = argument[i];
			if(is_undefined(_option.func_up)) _option.set_function_up(func_up_default);
			if(is_undefined(_option.func_down)) _option.set_function_down(func_down_default);
			if(is_undefined(_option.func_left)) _option.set_function_left(func_left_default);
			if(is_undefined(_option.func_right)) _option.set_function_right(func_right_default);
			array_push(_column, argument[i]);
		}
		array_push(options, _column);
		return self;
	};
	
	func_up_default = function() { 
		with(other) {
			if(!page[index].options[page[index].x_pos][page[index].y_pos].move_up_enabled) return;
			
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].y_pos--;
			if(page[index].y_pos < 0) page[index].y_pos = array_length(page[index].options[page[index].x_pos])-1;
			while(!page[index].options[page[index].x_pos][page[index].y_pos].selectable) {
				page[index].y_pos--;
				if(page[index].y_pos < 0) page[index].y_pos = array_length(page[index].options[page[index].x_pos])-1;
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_x0][_y0].func_leave();
				page[index].options[page[index].x_pos][page[index].y_pos].func_enter();
			}
		}
	};
	
	func_down_default = function() { 
		with(other) {
			if(!page[index].options[page[index].x_pos][page[index].y_pos].move_down_enabled) return;
		
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].y_pos++;
			if(page[index].y_pos >= array_length(page[index].options[page[index].x_pos])) page[index].y_pos = 0;
			while(!page[index].options[page[index].x_pos][page[index].y_pos].selectable) {
				page[index].y_pos++;
				if(page[index].y_pos >= array_length(page[index].options[page[index].x_pos])) page[index].y_pos = 0;
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_x0][_y0].func_leave();
				page[index].options[page[index].x_pos][page[index].y_pos].func_enter();
			}
		}
	};
	
	func_left_default = function() { 
		with(other) {
			if(!page[index].options[page[index].x_pos][page[index].y_pos].move_left_enabled) return;
			
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].x_pos--;
			if(page[index].x_pos < 0) page[index].x_pos = array_length(page[index].options)-1;
			if(page[index].y_pos >= array_length(page[index].options[page[index].x_pos])) page[index].y_pos = array_length(page[index].options[page[index].x_pos])-1;
			while(!page[index].options[page[index].x_pos][page[index].y_pos].selectable) {
				page[index].x_pos--;
				if(page[index].x_pos < 0) page[index].x_pos = array_length(page[index].options)-1;
				if(page[index].y_pos >= array_length(page[index].options[page[index].x_pos])) page[index].y_pos = array_length(page[index].options[page[index].x_pos])-1;
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_x0][_y0].func_leave();
				page[index].options[page[index].x_pos][page[index].y_pos].func_enter();
			}
		}
	};
	
	func_right_default = function() { 
		with(other) {
			if(!page[index].options[page[index].x_pos][page[index].y_pos].move_right_enabled) return;
			
			var _x0 = page[index].x_pos;
			var _y0 = page[index].y_pos;
			
			page[index].x_pos++;
			if(page[index].x_pos >= array_length(page[index].options)) page[index].x_pos = 0;	
			if(page[index].y_pos >= array_length(page[index].options[page[index].x_pos])) page[index].y_pos = array_length(page[index].options[page[index].x_pos])-1;
			while(!page[index].options[page[index].x_pos][page[index].y_pos].selectable) {
				page[index].x_pos++;
				if(page[index].x_pos >= array_length(page[index].options)) page[index].x_pos = 0;	
				if(page[index].y_pos >= array_length(page[index].options[page[index].x_pos])) page[index].y_pos = array_length(page[index].options[page[index].x_pos])-1;
			}
			
			if(page[index].x_pos != _x0 || page[index].y_pos != _y0) {
				page[index].options[_x0][_y0].func_leave();
				page[index].options[page[index].x_pos][page[index].y_pos].func_enter();
			}
		}
	};
	
	get_option = function(_option) { 
		for(var i=0;i<array_length(options);i++) {
			for(var j=0;j<array_length(options[i]);j++) {
				if(options[i][j].name == _option) return options[i][j];	
			}
		}
		return undefined;
	};
}

function MenuPageFree(_name) : MenuPage(_name) constructor {
	coords = [];
	mapping = [];
	valign = [];
	halign = [];
	pos = 0;
	layout = "free";
	
	add_option = function(_option, _x, _y, _halign = "center", _valign = "middle") {
		if(is_undefined(_option.func_up)) _option.set_function_up(func_up_default);
		if(is_undefined(_option.func_down)) _option.set_function_down(func_down_default);
		if(is_undefined(_option.func_left)) _option.set_function_left(func_left_default);
		if(is_undefined(_option.func_right)) _option.set_function_right(func_right_default);
		array_push(options, _option);
		array_push(coords, [_x, _y]);
		array_push(mapping, [undefined, undefined, undefined, undefined]);
		array_push(halign, _halign);
		array_push(valign, _valign);
		return self;
	};
	
	set_mapping = function(_option_from, _direction, _option_to) {
		for(var i=0;i<array_length(options);i++) {
			if(options[i].name == _option_from) {
				for(var j=0;j<array_length(options);j++) {
					if(options[j].name == _option_to) {
						mapping[i][_direction] = j;
						break;
					}
				}
				break;
			}
		}
		return self;
	};
	
	func_up_default = function() {
		if(!other.page[other.index].options[other.page[other.index].pos].move_up_enabled) return; 
		
		var _pos = other.page[other.index].pos;
		if(is_undefined(mapping[_pos][__DIRECTION_UP])) {
			var _x0 = coords[_pos][0];
			var _y0 = coords[_pos][1];
			
			var _best_index = undefined;
			var _best_score = undefined;
			
			for(var a=0;a<5;a++) {
				for(var i=0;i<array_length(coords);i++) {
					if(!options[i].selectable) continue;
					
					var _x = coords[i][0];
					var _y = coords[i][1];
					
					switch(a) {
						case 1:
							_x += __AriahMenuLibrary_WIDTH();
							break;
						case 2:
							_y -= __AriahMenuLibrary_HEIGHT();
							break;
						case 3:
							_x -= __AriahMenuLibrary_WIDTH();
							break;
						case 4:
							_y += __AriahMenuLibrary_HEIGHT();
							break;
					}
					
					if(_y >= _y0) continue;
					
					var _dist = sqrt(sqr(_x - _x0) + sqr(_y - _y0));
					var _score = _dist + abs(_x - _x0);
					
					if(is_undefined(_best_score) || _score < _best_score) {
						_best_score = _score;
						_best_index = i;
					}
				}
			}
			if(!is_undefined(_best_index)) {
				options[_pos].func_leave();
				options[_best_index].func_enter();
				other.page[other.index].pos = _best_index;
			}
		} else {
			options[_pos].func_leave();
			var _new_pos = mapping[_pos][__DIRECTION_UP];
			options[_new_pos].func_enter();
			other.page[other.index].pos = _new_pos;
		}
	};
	
	func_down_default = function() {
		if(!other.page[other.index].options[other.page[other.index].pos].move_down_enabled) return;
		
		var _pos = other.page[other.index].pos;
		if(is_undefined(mapping[_pos][__DIRECTION_DOWN])) {
			var _x0 = coords[_pos][0];
			var _y0 = coords[_pos][1];
			
			var _best_index = undefined;
			var _best_score = undefined;
			
			for(var a=0;a<5;a++) {
				for(var i=0;i<array_length(coords);i++) {
					if(!options[i].selectable) continue;
					
					var _x = coords[i][0];
					var _y = coords[i][1];
					
					switch(a) {
						case 1:
							_x += __AriahMenuLibrary_WIDTH();
							break;
						case 2:
							_y -= __AriahMenuLibrary_HEIGHT();
							break;
						case 3:
							_x -= __AriahMenuLibrary_WIDTH();
							break;
						case 4:
							_y += __AriahMenuLibrary_HEIGHT();
							break;
					}
					
					if(_y <= _y0) continue;
					
					var _dist = sqrt(sqr(_x - _x0) + sqr(_y - _y0));
					var _score = _dist + abs(_x - _x0);
					
					if(is_undefined(_best_score) || _score < _best_score) {
						_best_score = _score;
						_best_index = i;
					}
				}
			}
			if(!is_undefined(_best_index)) {
				options[_pos].func_leave();
				options[_best_index].func_enter();
				other.page[other.index].pos = _best_index;
			}
		} else {
			options[_pos].func_leave();
			var _new_pos = mapping[_pos][__DIRECTION_DOWN];
			options[_new_pos].func_enter();
			other.page[other.index].pos = _new_pos;
		}
	};
	func_left_default = function() {
		if(!other.page[other.index].options[other.page[other.index].pos].move_left_enabled) return;
		
		var _pos = other.page[other.index].pos;
		if(is_undefined(mapping[_pos][__DIRECTION_LEFT])) {
			var _x0 = coords[_pos][0];
			var _y0 = coords[_pos][1];
			
			var _best_index = undefined;
			var _best_score = undefined;
			
			for(var a=0;a<5;a++) {
				for(var i=0;i<array_length(coords);i++) {
					if(!options[i].selectable) continue;
					
					var _x = coords[i][0];
					var _y = coords[i][1];
					
					switch(a) {
						case 1:
							_x += __AriahMenuLibrary_WIDTH();
							break;
						case 2:
							_y -= __AriahMenuLibrary_HEIGHT();
							break;
						case 3:
							_x -= __AriahMenuLibrary_WIDTH();
							break;
						case 4:
							_y += __AriahMenuLibrary_HEIGHT();
							break;
					}
					
					if(_x >= _x0) continue;
					
					var _dist = sqrt(sqr(_x - _x0) + sqr(_y - _y0));
					var _score = _dist + abs(_y - _y0);
					
					if(is_undefined(_best_score) || _score < _best_score) {
						_best_score = _score;
						_best_index = i;
					}
				}
			}
			if(!is_undefined(_best_index)) {
				options[_pos].func_leave();
				options[_best_index].func_enter();
				other.page[other.index].pos = _best_index;
			}
		} else {
			options[_pos].func_leave();
			var _new_pos = mapping[_pos][__DIRECTION_LEFT];
			options[_new_pos].func_enter();
			other.page[other.index].pos = _new_pos;
		}
	};
	
	func_right_default = function() {
		if(!other.page[other.index].options[other.page[other.index].pos].move_right_enabled) return;
		
		var _pos = other.page[other.index].pos;
		if(is_undefined(mapping[_pos][__DIRECTION_RIGHT])) {
			var _x0 = coords[_pos][0];
			var _y0 = coords[_pos][1];
			
			var _best_index = undefined;
			var _best_score = undefined;
			
			for(var a=0;a<5;a++) {
				for(var i=0;i<array_length(coords);i++) {
					if(!options[i].selectable) continue;
					
					var _x = coords[i][0];
					var _y = coords[i][1];
					
					switch(a) {
						case 1:
							_x += __AriahMenuLibrary_WIDTH();
							break;
						case 2:
							_y -= __AriahMenuLibrary_HEIGHT();
							break;
						case 3:
							_x -= __AriahMenuLibrary_WIDTH();
							break;
						case 4:
							_y += __AriahMenuLibrary_HEIGHT();
							break;
					}
					
					if(_x <= _x0) continue;
					
					var _dist = sqrt(sqr(_x - _x0) + sqr(_y - _y0));
					var _score = _dist + abs(_y - _y0);
					
					if(is_undefined(_best_score) || _score < _best_score) {
						_best_score = _score;
						_best_index = i;
					}
				}
			}
			if(!is_undefined(_best_index)) {
				options[_pos].func_leave();
				options[_best_index].func_enter();
				other.page[other.index].pos = _best_index;
			}
		} else {
			options[_pos].func_leave();
			var _new_pos = mapping[_pos][__DIRECTION_RIGHT];
			options[_new_pos].func_enter();
			other.page[other.index].pos = _new_pos;
		}
	};
	
	get_option = function(_option) { 
		for(var i=0;i<array_length(options);i++) {
			if(options[i].name == _option) return options[i];	
		}
		return undefined;
	};
}

#endregion

#region MenuOption

function MenuOption(_name, _text = undefined) constructor {
	name = _name;
	text = _text ?? _name;
	
	func_z = function() { };
	func_x = function() { };
	func_up = undefined;
	func_down = undefined;
	func_left = undefined;
	func_right = undefined;
	func_selected = function() { };
	func_enter = function() { };
	func_leave = function() { };
	func_init = function() { };
	
	blip_z = other.blip_z_default;
	blip_x = other.blip_x_default;
	blip_move = other.blip_move_default;
	
	move_up_enabled = true;
	move_down_enabled = true;
	move_left_enabled = true;
	move_right_enabled = true;
	
	font = other.font_default;
	
	colors = {
		c1 : other.colors_default.c1,
		c2 : other.colors_default.c2 ?? other.colors_default.c1,
		s1 : other.colors_default.s1 ?? (#ffffff - other.colors_default.c1),
		s2 : other.colors_default.s2 ?? (other.colors_default.s1 ?? (#ffffff - other.colors_default.c1)),
	};
	
	selectable = true;
	
	set_text = function(_text) {
		text = _text;
		return self;
	};
	
	set_font = function(_font) {
		font = _font;
		return self;
	};
	
	set_function_z = function(_func) {
		func_z = _func;
		return self;
	};
	
	set_function_x = function(_func) {
		func_x = _func;
		return self;
	};
	
	set_function_up = function(_func) {
		func_up = _func;
		return self;
	};
	
	set_function_down = function(_func) {
		func_down = _func;
		return self;
	};
	
	set_function_left = function(_func) {
		func_left = _func;
		return self;
	};
	
	set_function_right = function(_func) {
		func_right = _func;
		return self;
	};
	
	set_function_selected = function(_func) {
		func_selected = _func;	
		return self;	
	};
	
	set_function_enter = function(_func) {
		func_enter = _func;
		return self;
	};
	
	set_function_leave = function(_func) {
		func_leave = _func;
		return self;
	};
	
	set_function_init = function(_func) {
		func_init = _func;
		return self;
	};
	
	set_blip_z = function(_blip) {
		blip_z = _blip;
		return self;
	};
	
	set_blip_x = function(_blip) {
		blip_x = _blip;
		return self;
	};
	
	set_blip_move = function(_blip) {
		blip_move = _blip;
		return self;
	};
	
	set_color = function(_c1, _c2 = undefined) {
		colors.c1 = _c1;
		colors.c2 = _c2 ?? _c1;
		return self;
	};
	
	set_color_selected = function(_s1, _s2 = undefined) {
		colors.s1 = _s1;
		colors.s2 = _s2 ?? _s1;
		return self;
	};
	
	set_selectable = function(_selectable) {
		selectable = _selectable;
		return self;
	};
	
	set_up_enabled = function(_enabled) {
		move_up_enabled = _enabled;
		return self;
	};
	
	set_down_enabled = function(_enabled) {
		move_down_enabled = _enabled;
		return self;
	};
	
	set_left_enabled = function(_enabled) {
		move_left_enabled = _enabled;
		return self;
	};
	
	set_right_enabled = function(_enabled) {
		move_right_enabled = _enabled;
		return self;
	};
}

#endregion

init = false;