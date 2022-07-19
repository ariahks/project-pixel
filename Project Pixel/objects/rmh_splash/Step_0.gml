if(skipping) {
	alpha += 0.05;
} else if(!is_undefined(input_check_press_most_recent())) {
	skipping = true;
}

if(alpha >= 1.2) seq_splash_end();