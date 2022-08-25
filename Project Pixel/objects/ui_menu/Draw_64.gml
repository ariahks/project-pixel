if(darken_background) {
	draw_set_color(#000000);
	draw_set_alpha(alpha/2);
	
	draw_rectangle(0, 0, __AriahMenuLibrary_WIDTH(), __AriahMenuLibrary_HEIGHT(), false);
}

draw_set_alpha(alpha);

var _spr = page[index].sprite;
draw_sprite_ext(_spr, 0, x, y, width/sprite_get_width(_spr), height/sprite_get_height(_spr), 0, #ffffff, alpha);

draw_set_valign(fa_top);
draw_set_halign(fa_center);

switch(page[index].layout) {
	case "free":
		for(var i=0;i<array_length(page[index].options);i++) {
			switch(page[index].halign[i]) {
				case "center":
					draw_set_halign(fa_center);
					break;
				case "left":
					draw_set_halign(fa_left);
					break;
				case "right":
					draw_set_halign(fa_right);
					break;
			}
			switch(page[index].valign[i]) {
				case "middle":
					draw_set_valign(fa_middle);
					break;
				case "top":
					draw_set_valign(fa_top);
					break;
				case "bottom":
					draw_set_valign(fa_bottom);
					break;
			}
			draw_set_font(page[index].options[i].font);
			var _c1 = page[index].options[i].colors.c1;
			var _c2 = page[index].options[i].colors.c2;
			if(page[index].pos == i && focus) {
				_c1 = page[index].options[i].colors.s1;
				_c2 = page[index].options[i].colors.s2;
			}
			
			var _x = page[index].coords[i][0];
			var _y = page[index].coords[i][1];
			
			switch(page[index].anchor_h) {
				case "center":
					_x += (__AriahMenuLibrary_WIDTH()/2 - width/2) + op_h_border;
					break;
				case "right":
					_x += __AriahMenuLibrary_WIDTH() - width + op_h_border;
					break;
			}
			switch(page[index].anchor_v) {
				case "middle":
					_y += (__AriahMenuLibrary_HEIGHT()/2 - height/2) + op_v_border;
					break;
				case "bottom":
					_y += __AriahMenuLibrary_HEIGHT() - height + op_v_border;
					break;
			}
			
			draw_text_color(_x + page[index].x_offset, _y + page[index].y_offset, page[index].options[i].text, _c1, _c1, _c2, _c2, alpha);
		}
		break;
	case "rows":
		for(var i=0;i<array_length(page[index].options);i++) {
			for(var j=0;j<array_length(page[index].options[i]);j++) {
				draw_set_font(page[index].options[i][j].font);
				var _c1 = page[index].options[i][j].colors.c1;
				var _c2 = page[index].options[i][j].colors.c2;
				if(page[index].y_pos == i && page[index].x_pos == j && focus) {
					_c1 = page[index].options[i][j].colors.s1;
					_c2 = page[index].options[i][j].colors.s2;
				}
				
				var _d = grid_width - array_length(page[index].options[i]);
				draw_text_color(x+(col_width+op_h_space)*(_d/2)+op_h_border+(col_width+op_h_space)*j+col_width/2, y+op_v_border+(row_height+op_v_space)*i, page[index].options[i][j].text, _c1, _c1, _c2, _c2, alpha);
			}
		}
		break;
	case "columns":
		for(var i=0;i<array_length(page[index].options);i++) {
			for(var j=0;j<array_length(page[index].options[i]);j++) {
				draw_set_font(page[index].options[i][j].font);
				var _c1 = page[index].options[i][j].colors.c1;
				var _c2 = page[index].options[i][j].colors.c2;
				if(page[index].x_pos == i && page[index].y_pos == j && focus) {
					_c1 = page[index].options[i][j].colors.s1;
					_c2 = page[index].options[i][j].colors.s2;
				}
				
				var _d = grid_height - array_length(page[index].options[i]);
				draw_text_color(x+op_h_border+(col_width+op_h_space)*i+col_width/2, y+(row_height+op_v_space)*(_d/2)+op_v_border+(row_height+op_v_space)*j, page[index].options[i][j].text, _c1, _c1, _c2, _c2, alpha);
			}
		}
		break;
}

draw_set_alpha(1);