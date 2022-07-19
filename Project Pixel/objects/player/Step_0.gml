facing = input_check_press_most_recent(["up", "left", "down", "right"]) ?? facing;

var _dir_x = input_check("right") - input_check("left");
var _dir_y = input_check("down") - input_check("up");

var _move_x = _dir_x * move_speed / (_dir_y != 0 ? sqrt(2) : 1);
var _move_y = _dir_y * move_speed / (_dir_x != 0 ? sqrt(2) : 1);

if(place_meeting(x + _move_x, y, obj_mk_solid) || bbox_right + _move_x > room_width || bbox_left + _move_x < 0) {
	_move_x = round(x) - x;
	while(!(place_meeting(x + _move_x, y, obj_mk_solid) || bbox_right + _move_x > room_width || bbox_left + _move_x < 0)) {
		_move_x += _dir_x;
	}
	_move_x -= _dir_x;
}

x += _move_x;

if(place_meeting(x, y + _move_y, obj_mk_solid) || bbox_bottom + _move_y > room_height || bbox_top + _move_y < 0) {
	_move_y = round(y) - y;
	while(!(place_meeting(x, y + _move_y, obj_mk_solid) || bbox_bottom + _move_y > room_height || bbox_top + _move_y < 0)) {
		_move_y += _dir_y;
	}
	_move_y -= _dir_y;
}

y += _move_y;



//DEBUG STUFF
var _recent = input_check_press_most_recent();
if(!is_undefined(_recent) && IS_DEV_BUILD) show_debug_message(_recent);

if(input_check_pressed("v") && IS_DEV_BUILD) {
	game.data.room = room;
	game.data.x = x;
	game.data.y = y;
	game.save();
}