if(following != noone) {
	x = following.x - camera_get_view_width(view_camera[0])/2;
	y = following.y - camera_get_view_height(view_camera[0])/2;
	x = clamp(x, 0, room_width - camera_get_view_width(view_camera[0]));
	y = clamp(y, 0, room_height - camera_get_view_height(view_camera[0]));
}

x_to = x;
y_to = y;