function seq_splash_end() {
	instance_create_depth(game.data.x, game.data.y, 0, player);
	room_goto(game.data.room);
}