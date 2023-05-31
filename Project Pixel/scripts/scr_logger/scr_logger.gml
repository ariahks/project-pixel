function log_raw(_string) {
	show_debug_message(_string);	
}

function log_debug(_string) {
	if(IS_DEV_BUILD) log_raw("[DEBUG] " + string(_string));
}

function log_info(_string) {
	if(LOG_LEVEL >= 4) log_raw("[INFO] " + string(_string));
}

function log_warning(_string) {
	if(LOG_LEVEL >= 3) log_raw("[WARNING] " + string(_string));
}

function log_error(_string) {
	if(LOG_LEVEL >= 2) log_raw("[ERROR] " + string(_string));
}

function log_fatal(_string) {
	if(LOG_LEVEL >= 1) log_raw("[FATAL] " + string(_string));
}