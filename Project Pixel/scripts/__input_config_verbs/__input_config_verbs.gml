//Input defines the default profiles as a macro called 
//This macro is parsed when Input boots up and provides the baseline bindings for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The root struct called __input_config_verbs() contains the names of each default profile
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

return {
    
    keyboard_and_mouse:
    {
        up:		input_binding_key(vk_up),
        down:	input_binding_key(vk_down),
        left:	input_binding_key(vk_left),
        right:	input_binding_key(vk_right),
        
        z:		input_binding_key(ord("Z")),
        x:		input_binding_key(ord("X")),
        c:		input_binding_key(ord("C")),
        v:		input_binding_key(ord("V")),
        
        pause:	input_binding_key(vk_escape),
    },
    
    gamepad:
    {
        up:		input_binding_gamepad_axis(gp_axislv, true),
        down:	input_binding_gamepad_axis(gp_axislv, false),
        left:	input_binding_gamepad_axis(gp_axislh, true),
        right:	input_binding_gamepad_axis(gp_axislh, false),
        
        z:		input_binding_gamepad_button(gp_face1),
        x:		input_binding_gamepad_button(gp_face2),
        c:		input_binding_gamepad_button(gp_face3),
        v:		input_binding_gamepad_button(gp_face4),
		
        pause: input_binding_gamepad_button(gp_start),
    },
    
};