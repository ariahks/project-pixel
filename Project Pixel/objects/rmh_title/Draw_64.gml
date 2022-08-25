draw_set_font(font);
draw_set_color(#000000);
draw_set_valign(fa_bottom);

draw_set_halign(fa_right);
draw_text(GAME_WIDTH - 4, GAME_HEIGHT - 2, "Version " + string(MAJOR_VERSION) + "." + string(MINOR_VERSION));

if(IS_DEV_BUILD) {
	draw_set_halign(fa_left);
	draw_text(4, GAME_HEIGHT - 2, "(dev build)");
}

if(alpha < 1) {
	draw_set_alpha(1 - alpha);
	draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
	draw_set_alpha(1);
}