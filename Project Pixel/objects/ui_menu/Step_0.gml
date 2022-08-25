if(pending_destruction) {
	if(fade && alpha > 0) alpha -= 0.1;
	else instance_destroy();
} else if(fade && alpha < 1) {
	alpha += 0.1;
}

if(!init) {
	for(var p=0;p<array_length(page);p++) {
		if(page[p].layout == "free") {
			for(var i=0;i<array_length(page[p].options);i++) {
				page[p].options[i].func_init();	
			}
		} else {
			for(var i=0;i<array_length(page[p].options);i++) {
				for(var j=0;j<array_length(page[p].options[i]);j++) {
					var _option = page[p].options[i][j];
					if(page[p].layout == "rows") {
						if(array_length(page[p].options) == 1) {
							_option.move_up_enabled = false;
							_option.move_down_enabled = false;
						}
						if(array_length(page[p].options[i]) == 1) {
							_option.move_left_enabled = false;
							_option.move_right_enabled = false;
						}
					} else if(page[p].layout == "columns") {
						if(array_length(page[p].options) == 1) {
							_option.move_left_enabled = false;
							_option.move_right_enabled = false;
						}
						if(array_length(page[p].options[i]) == 1) {
							_option.move_up_enabled = false;
							_option.move_down_enabled = false;
						}
					}
					_option.func_init();
				}
			}
		}
	}
	init = true;
}

func_step();

var _option;

switch(page[index].layout) {
	case "free":
		_option = page[index].options[page[index].pos];
		break;
	case "rows":
		_option = page[index].options[page[index].y_pos][page[index].x_pos];
		break;
	case "columns":
		_option = page[index].options[page[index].x_pos][page[index].y_pos];
		break;
}

if(focus) _option.func_selected();

if(__AriahMenuLibrary__UP() && focus) {
	if(!is_undefined(_option.blip_move) && _option.move_up_enabled) {
		if(__USE_ARIAH_AUDIO_LIB()) {
			audio.sfx_play(_option.blip_move);	
		} else {
			audio_play_sound(_option.blip_move, 3, false);	
		}
	}
	_option.func_up();
}

if(__AriahMenuLibrary__DOWN() && focus) {
	if(!is_undefined(_option.blip_move) && _option.move_down_enabled) {
		if(__USE_ARIAH_AUDIO_LIB()) {
			audio.sfx_play(_option.blip_move);	
		} else {
			audio_play_sound(_option.blip_move, 3, false);	
		}
	}
	_option.func_down();
}

if(__AriahMenuLibrary__LEFT() && focus) {
	if(!is_undefined(_option.blip_move) && _option.move_left_enabled) {
		if(__USE_ARIAH_AUDIO_LIB()) {
			audio.sfx_play(_option.blip_move);	
		} else {
			audio_play_sound(_option.blip_move, 3, false);	
		}
	}
	_option.func_left();
}

if(__AriahMenuLibrary__RIGHT() && focus) {
	if(!is_undefined(_option.blip_move) && _option.move_right_enabled) {
		if(__USE_ARIAH_AUDIO_LIB()) {
			audio.sfx_play(_option.blip_move);	
		} else {
			audio_play_sound(_option.blip_move, 3, false);	
		}
	}
	_option.func_right();
}

if(__AriahMenuLibrary__CONFIRM() && focus) {
	if(!is_undefined(_option.blip_z)) {
		if(__USE_ARIAH_AUDIO_LIB()) {
			audio.sfx_play(_option.blip_z);	
		} else {
			audio_play_sound(_option.blip_z, 3, false);	
		}
	}
	_option.func_z();
}

if(__AriahMenuLibrary__CANCEL() && focus) {
	if(!is_undefined(_option.blip_x)) {
		if(__USE_ARIAH_AUDIO_LIB()) {
			audio.sfx_play(_option.blip_x);	
		} else {
			audio_play_sound(_option.blip_x, 3, false);	
		}
	}
	_option.func_x();
}

switch(page[index].layout) {
	case "free":
		var _left_bound = __AriahMenuLibrary_WIDTH();
		var _right_bound = 0;
		var _top_bound = __AriahMenuLibrary_HEIGHT();
		var _bottom_bound = 0;
		for(var i=0;i<array_length(page[index].options);i++) {
			draw_set_font(page[index].options[i].font);
			var _text = page[index].options[i].text;
			var _op_x = page[index].coords[i][0];
			var _op_y = page[index].coords[i][0];
			var _op_w = string_width(_text);
			var _op_h = string_height(_text);
			
			var _op_left;
			var _op_right;
			var _op_top;
			var _op_bottom;
			
			switch(page[index].halign[i]) {
				default:
				case "center":
					_op_left = _op_x - _op_w/2;
					_op_right = _op_x + _op_w/2;
					break;
				case "left":
					_op_left = _op_x;
					_op_right = _op_x + _op_w;
					break;
				case "right":
					_op_left = _op_x - _op_w;
					_op_right = _op_x;
					break;
			}
			switch(page[index].valign[i]) {
				default:
				case "middle":
					_op_top = _op_y - _op_h/2;
					_op_bottom = _op_y + _op_h/2;
					break;
				case "top":
					_op_top = _op_y;
					_op_bottom = _op_y + _op_h;
					break;
				case "bottom":
					_op_top = _op_y - _op_h;
					_op_bottom = _op_y;
					break;
			}
			
			_left_bound = min(_left_bound, _op_left - op_h_border);
			_right_bound = max(_right_bound, _op_right + op_h_border);
			_top_bound = min(_top_bound, _op_top - op_v_border);
			_bottom_bound = max(_bottom_bound, _op_bottom + op_v_border);
		}
		
		switch(page[index].anchor_h) {
			case "center":
				x = __AriahMenuLibrary_WIDTH()/2 - (_right_bound - _left_bound)/2 + page[index].x_offset;
				break;
			case "left":
				x = _left_bound + page[index].x_offset;
				break;
			case "right":
				x = __AriahMenuLibrary_WIDTH() - (_right_bound - _left_bound) + page[index].x_offset;
				break;
		}
		switch(page[index].anchor_v) {
			case "middle":
				y = __AriahMenuLibrary_HEIGHT()/2 - (_bottom_bound - _top_bound)/2 + page[index].y_offset;
				break;
			case "top":
				y = _top_bound + page[index].y_offset;
				break;
			case "bottom":
				y = __AriahMenuLibrary_HEIGHT() - (_bottom_bound - _top_bound) + page[index].y_offset;
				break;
		}
		
		width = _right_bound - _left_bound;
		height = _bottom_bound - _top_bound;
		break;
	case "rows":
		grid_height = array_length(page[index].options);
		grid_width = 0;
		
		col_width = 0;
		row_height = 0;
		
		for(var i=0;i<grid_height;i++) {
			grid_width = max(grid_width, array_length(page[index].options[i]));
			for(var j=0;j<array_length(page[index].options[i]);j++) {
				draw_set_font(page[index].options[i][j].font);
				var _text = page[index].options[i][j].text;
				var _op_w = string_width(_text);
				var _op_h = string_height(_text);
				col_width = max(col_width, _op_w);
				row_height = max(row_height, _op_h);
			}
		}
		
		width = col_width * grid_width + op_h_border * 2 + op_h_space * (grid_width - 1);
		height = row_height * grid_height + op_v_border * 2 + op_v_space * (grid_height - 1);
		break;
	case "columns":
		grid_width = array_length(page[index].options);
		grid_height = 0;
		
		col_width = 0;
		row_height = 0;
		
		for(var i=0;i<grid_width;i++) {
			grid_height = max(grid_height, array_length(page[index].options[i]));
			for(var j=0;j<array_length(page[index].options[i]);j++) {
				draw_set_font(page[index].options[i][j].font);
				var _text = page[index].options[i][j].text;
				var _op_w = string_width(_text);
				var _op_h = string_height(_text);
				col_width = max(col_width, _op_w);
				row_height = max(row_height, _op_h);
			}
		}
		
		width = col_width * grid_width + op_h_border * 2 + op_h_space * (grid_width - 1);
		height = row_height * grid_height + op_v_border * 2 + op_v_space * (grid_height - 1);
		break;
}

if(page[index].layout != "free") {
	switch(page[index].anchor_h) {
		case "center":
			x = __AriahMenuLibrary_WIDTH()/2 - width/2 + page[index].x_offset;
			break;
		case "left":
			x = page[index].x_offset;
			break;
		case "right":
			x = __AriahMenuLibrary_WIDTH() - width + page[index].x_offset;
			break;
	}
	switch(page[index].anchor_v) {
		case "middle":
			y = __AriahMenuLibrary_HEIGHT()/2 - height/2 + page[index].y_offset;
			break;
		case "top":
			y = page[index].y_offset;
			break;
		case "bottom":
			y = __AriahMenuLibrary_HEIGHT() - height + page[index].y_offset;
			break;
	}
}