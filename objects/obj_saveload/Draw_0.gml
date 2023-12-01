var __b__;
__b__ = action_if_variable(hide, 0, 0);
if __b__ {

    var xx, yy;
    xx = __view_get(e__VW.XView, 0) + 0;
    yy = __view_get(e__VW.YView, 0) + 0;
    if (instance_exists(obj_main_menu)) {
        xx = 0;
        yy = 0;
    }


    if (save_part + load_part > 0) {
        draw_set_color(0);

        scr_image("loading0", splash, xx + 0, yy + 0, 1600, 900);

        draw_sprite(spr_loadbar_empty, 0, xx + 1047, yy + 875);
        draw_sprite(spr_loadbar, 0, xx + 1047, yy + 875);
        draw_sprite(spr_loadbar_cover, bar, xx + 1047, yy + 875);

        if (save_part > 0) then draw_sprite(spr_load_text, 1, xx + 1068, yy + 821);
        if (load_part > 0) and(global.restart = 0) then draw_sprite(spr_load_text, 0, xx + 1068, yy + 821);
        if (load_part > 0) and(global.restart > 0) then draw_sprite(spr_load_text, 2, xx + 1068, yy + 821);
    }

    if (menu = 1) or(menu = 2) { // This is the other one
        draw_set_color(0);
        draw_set_alpha(0.75);
        if (room_get_name(room) != "Main_Menu") then draw_rectangle(0, 0, room_width, room_height, 0);
        if (room_get_name(room) = "Main_Menu") then draw_rectangle(0, 0, room_width, 707, 0);
        draw_set_alpha(1);

        draw_set_color(c_red);
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_set_halign(fa_center);

        draw_set_color(0);

        draw_sprite(spr_save_header, 0, xx + 0, yy + 27);
        if (menu = 1) then draw_sprite(spr_save_headers, 1, xx + 800, yy + 60);
        if (menu = 2) then draw_sprite(spr_save_headers, 0, xx + 800, yy + 60);
        draw_sprite(spr_save_footer, 0, xx + 0, yy + 797);

        var o, x2, y2, s;
        o = top;
        x2 = __view_get(e__VW.XView, 0) + 32;
        y2 = __view_get(e__VW.YView, 0) + 166;
        s = 0;
        repeat(4) {
            if ((save[o] > 0) or((first_open = o) and(menu = 1)) or(global.load = o) or(save_number = o)) and(save_number = 0) {
                s = save[o];
                draw_set_font(fnt_40k_30b);
                draw_set_halign(fa_left);
                draw_set_color(0);

                draw_rectangle(x2 + 56, y2 + 5, x2 + 238, y2 + 123, 0);
                draw_rectangle(x2 + 258, y2 + 25, x2 + 1480, y2 + 80, 0);

                if (o = top) and(save[o] != 0) and(img1 != 0) and(sprite_exists(img1)) {
                    draw_sprite_stretched(img1, 0, x2 + 64, y2 + 28, 166, 94);
                }
                if (o = top + 1) and(save[o] != 0) and(img2 != 0) and(sprite_exists(img2)) {
                    draw_sprite_stretched(img2, 0, x2 + 64, y2 + 28, 166, 94);
                }
                if (o = top + 2) and(save[o] != 0) and(img3 != 0) and(sprite_exists(img3)) {
                    draw_sprite_stretched(img3, 0, x2 + 64, y2 + 28, 166, 94);
                }
                if (o = top + 3) and(save[o] != 0) and(img4 != 0) and(sprite_exists(img4)) {
                    draw_sprite_stretched(img4, 0, x2 + 64, y2 + 28, 166, 94);
                }


                var high;
                high = 0;
                if (scr_hit(x2, y2, x2 + 1526, y2 + 149) = true) {
                    // high=1;
                    debug = "Save:" + string(save[o]) + ", array position:" + string(o) + ", turn:" + string(save_turn[o]);
                }
                draw_sprite(spr_save_data, 0, x2, y2);

                draw_text_transformed(x2 + 23, y2 + 62, string_hash_to_newline(o), 1.1, 1.1, 0);
                draw_text_transformed(x2 + 270, y2 + 10, string_hash_to_newline("Chapter"), 0.9, 0.9, 0);
                draw_text_transformed(x2 + 774, y2 + 10, string_hash_to_newline("Marines"), 0.9, 0.9, 0);
                draw_text_transformed(x2 + 1024, y2 + 10, string_hash_to_newline("Turn"), 0.9, 0.9, 0);
                draw_text_transformed(x2 + 1274, y2 + 10, string_hash_to_newline("Game Time"), 0.9, 0.9, 0);

                draw_set_color(c_gray);
                if (first_open != o) {
                    draw_text_transformed(x2 + 270, y2 + 48, string_hash_to_newline(string(save_chapter[save[o]]) + " (" + string(save_date[save[o]]) + ")"), 0.7, 0.7, 0);
                    draw_text_transformed(x2 + 774, y2 + 48, string_hash_to_newline(string(save_marines[save[o]])), 0.7, 0.7, 0);
                    draw_text_transformed(x2 + 1024, y2 + 48, string_hash_to_newline(string(save_turn[save[o]])), 0.7, 0.7, 0);
                    var ohboy, result, tsec, tmin, thour, tday;
                    ohboy = save_time[save[o]];
                    result = "";
                    tsec = 0;
                    tmin = 0;
                    thour = 0;
                    tday = 0;
                    if (ohboy > 0) {
                        tday = floor(ohboy / 86400);
                        if (tday >= 1) then ohboy -= (tday * 86400);
                        thour = floor(ohboy / 3600);
                        if (thour >= 1) then ohboy -= (thour * 3600);
                        tmin = floor(ohboy / 60);
                        if (tmin >= 1) then ohboy -= (tmin * 60);
                        tsec = ohboy;

                        if (tday > 0) then result += string(tday) + "d ";
                        if (thour = 0) then result += "00:";
                        if (thour > 0) and(thour < 10) then result += "0" + string(thour) + ":";
                        if (thour >= 10) then result += string(thour) + ":";
                        if (tmin = 0) then result += "00:";
                        if (tmin > 0) and(tmin < 10) then result += "0" + string(tmin) + ":";
                        if (tmin >= 10) then result += string(tmin) + ":";
                        if (tsec = 0) then result += "00";
                        if (tsec > 0) and(tsec < 10) then result += "0" + string(tsec);
                        if (tsec >= 10) then result += string(tsec);
                    }
                    draw_text_transformed(x2 + 1274, y2 + 48, string_hash_to_newline(string(result)), 0.7, 0.7, 0);
                }
                if (first_open = o) and(menu = 1) then draw_text_transformed(x2 + 270, y2 + 48, string_hash_to_newline("(EMPTY SAVE SLOT)"), 0.7, 0.7, 0);
            }

            draw_set_font(fnt_40k_30b);
            draw_set_halign(fa_center);

            if (save[o] > 0) {
                // Delete Data
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_rectangle(x2 + 807, y2 + 113, x2 + 951, y2 + 146, 0);
                draw_set_color(c_black);
                draw_rectangle(x2 + 807, y2 + 113, x2 + 951, y2 + 146, 1);
                draw_text_transformed(x2 + 879, y2 + 117, string_hash_to_newline("Delete Game"), 0.7, 0.7, 0);
                if (scr_hit(x2 + 807, y2 + 113, x2 + 951, y2 + 146) = true) {
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(x2 + 807, y2 + 113, x2 + 951, y2 + 146, 0);
                    draw_set_alpha(1);
                    if (mouse_left >= 1) and(!instance_exists(obj_popup)) and(cooldown <= 0) { // Clear
                        var com;
                        com = instance_create(0, 0, obj_popup);
                        com.image = "fuklaw";
                        com.title = "Delete Save Game?";
                        com.text = "Are you sure you wish to delete Save " + string(save[o]) + "- " + string(save_chapter[save[o]]) + "?";
                        com.option1 = "Yes";
                        com.option2 = "No";
                        com.save = o;
                        com.woopwoopwoop = menu;
                        com.owner = top;
                    }
                }
            }


            if (menu = 2) and(save[o] > 0) { // Restart
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_rectangle(x2 + 977, y2 + 113, x2 + 1121, y2 + 146, 0);
                draw_set_color(c_black);
                draw_rectangle(x2 + 977, y2 + 113, x2 + 1121, y2 + 146, 1);
                draw_text_transformed(x2 + 1050, y2 + 117, string_hash_to_newline("Restart Game"), 0.7, 0.7, 0);
                if (scr_hit(x2 + 977, y2 + 113, x2 + 1121, y2 + 146) = true) {
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(x2 + 977, y2 + 113, x2 + 1121, y2 + 146, 0);
                    draw_set_alpha(1);
                    if (mouse_left >= 1) and(!instance_exists(obj_popup)) and(cooldown <= 0) {
                        if (file_exists("save" + string(save[o]) + ".ini")) { // Resets the data
                            global.restart = 1;
                            global.load = save[o];
                            menu = 0;
                            load_part = 1;
                            obj_cursor.image_alpha = 0;
                            splash = choose(0, 1, 2, 3, 4);

                            if (instance_exists(obj_main_menu)) {
                                with(obj_main_menu) {
                                    part_particles_clear(p_system);
                                    instance_destroy();
                                }
                            }

                            with(obj_controller) {
                                instance_destroy();
                            }
                            with(obj_creation) {
                                instance_destroy();
                            }
                            with(obj_ini) {
                                instance_destroy();
                            }
                            with(obj_star) {
                                instance_destroy();
                            }
                            with(obj_all_fleet) {
                                instance_destroy();
                            }
                            with(obj_popup) {
                                instance_destroy();
                            }
                            audio_stop_all();

                            room_goto(Game);
                        }
                    }
                }

                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_rectangle(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146, 0);
                draw_set_color(c_black);
                draw_rectangle(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146, 1);
                draw_text_transformed(x2 + 1385, y2 + 117, string_hash_to_newline("Load Game"), 0.7, 0.7, 0);
                if (scr_hit(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146) = true) {
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146, 0);
                    draw_set_alpha(1);

                    if (mouse_left >= 1) and(!instance_exists(obj_popup)) and(cooldown <= 0) { // Load
                        global.load = save[o];
                        menu = 0;
                        load_part = 1;
                        obj_cursor.image_alpha = 0;
                        splash = choose(0, 1, 2, 3, 4);

                        // show_message("loading 'save"+string(save[o])+".ini'");

                        if (instance_exists(obj_main_menu)) {
                            with(obj_main_menu) {
                                part_particles_clear(p_system);
                                instance_destroy();
                            }
                        }

                        with(obj_controller) {
                            instance_destroy();
                        }
                        with(obj_creation) {
                            instance_destroy();
                        }
                        with(obj_ini) {
                            instance_destroy();
                        }
                        with(obj_star) {
                            instance_destroy();
                        }
                        with(obj_all_fleet) {
                            instance_destroy();
                        }
                        with(obj_popup) {
                            instance_destroy();
                        }
                        audio_stop_all();

                        room_goto(Game);
                    }
                }
            }

            if (menu = 1) and((save[o] > 0) or(first_open = o)) { // Save
                draw_set_alpha(1);
                draw_set_color(c_gray);
                draw_rectangle(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146, 0);
                draw_set_color(c_black);
                draw_rectangle(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146, 1);
                draw_text_transformed(x2 + 1386, y2 + 117, string_hash_to_newline("Save Game"), 0.7, 0.7, 0);
                if (scr_hit(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146) = true) {
                    draw_set_alpha(0.1);
                    draw_set_color(c_white);
                    draw_rectangle(x2 + 1317, y2 + 113, x2 + 1461, y2 + 146, 0);
                    draw_set_alpha(1);
                    if (mouse_left >= 1) and(cooldown <= 0) {
                        var _clicked_exactly_once = 0;
                        if (instance_exists(obj_main_menu)) {
                            with(obj_main_menu) {
                                part_particles_clear(p_system);
                            }
                        }

                        // Check save folder
                        var _saves_folder = program_directory + "\saves";
                        if (!directory_exists(_saves_folder)) then directory_create(_saves_folder);

                        // Check open slot 
                        var _open_slot_id = save[o];
                        var _potential_open_slot_save_file = _saves_folder + $"\\save{_open_slot_id}.json";

                        // If open slot then set the save.ini to the maximum
                        if (!file_exists(_potential_open_slot_save_file)) or(_open_slot_id = 0) and(_clicked_exactly_once = 0) {
                            save_number = max_ini;
                        }
                        // If file exists then overright
                        if (file_exists(_potential_open_slot_save_file)) {
                            file_delete(_potential_open_slot_save_file);
                            save_number = o;
                        }

                        // Set rest of state
						save_file = _saves_folder + $"\\save{save_number}.json";
                        save_part = 1;
                        menu = 0;
                        obj_cursor.image_alpha = 0;
                        splash = choose(0, 1, 2, 3, 4);
                        with(obj_new_button) {
                            instance_destroy();
                        }
                        with(obj_ingame_menu) {
                            instance_destroy();
                        }

                        // Other here
                        alarm[0] = 1;
                        _clicked_exactly_once = 1;
                    }
                }
            }

            o++;
            y2 += 158;
        }

        if (instance_exists(obj_main_menu_buttons)) {
            if (obj_main_menu_buttons.fade > 0) {
                draw_set_color(0);
                draw_set_alpha(obj_main_menu_buttons.fade / 40);
                draw_rectangle(0, 0, room_width, room_height, 0);
            }
            draw_set_alpha(1);
        }

    }
}