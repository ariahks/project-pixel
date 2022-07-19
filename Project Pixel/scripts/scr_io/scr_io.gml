function string_save_to_file(_filename, _string, _base64 = false) {
	if(_base64) _string = base64_encode(_string);
	var _buffer = buffer_create(string_byte_length(_string)+1, buffer_fixed, 1);
	buffer_write(_buffer, buffer_string, _string);
	buffer_save(_buffer, _filename);
	buffer_delete(_buffer);
}

function string_load_from_file(_filename, _base64 = false) {
	if(!file_exists(_filename)) {
		show_debug_message("[WARNING] Tried to load from a non-existant file! (" + _filename + ")");
		return undefined;
	}
	var _buffer = buffer_load(_filename);
	var _string = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	if(_base64) _string = base64_decode(_string);
	return _string;
}