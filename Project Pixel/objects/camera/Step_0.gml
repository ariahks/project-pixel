if(following != noone) {
	x_to = following.x - camera_get_view_width(view_camera[0])/2;
	y_to = following.y - camera_get_view_height(view_camera[0])/2;
	x_to = clamp(x_to, 0, room_width - camera_get_view_width(view_camera[0]));
	y_to = clamp(y_to, 0, room_height - camera_get_view_height(view_camera[0]));
}

x += (x_to - x) * move_speed;
y += (y_to - y) * move_speed;

camera_set_view_pos(view_camera[0], x, y);