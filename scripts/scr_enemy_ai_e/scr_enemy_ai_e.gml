function scr_enemy_ai_e() {

    // Guess I'll handle all of the ship combat in here
    // This needs to keep on running in each sector until only one faction's fleet remains
    var imperium_enemies = present_fleet[7] + present_fleet[8] + present_fleet[9] + present_fleet[10] + present_fleet[13];

    var standard_xenos_enemies = present_fleet[2] + present_fleet[7] + present_fleet[8] + present_fleet[10] + present_fleet[13];

    var imperium_fleets = present_fleet[2]+present_fleet[3];


    var have_fleets, battle, battle2, strength, attack;
    have_fleets = 0;
    battle = 0;
    battle2 = 0;
    strength = 0;
    damage = 0;
    attack = 0;
    var i;
    i = -1;
    repeat(20) {
        i += 1;
        attack[i] = 0;
        strength[i] = 0;
        damage[i] = 0;
    }

    i = 0;
    repeat(13) {
        i += 1;
        if (present_fleet[i] > 0) then have_fleets += 1;
    }

    if (present_fleet[1] > 0) { // Battle1 is reserved for player battles
        if (present_fleet[2] > 0) and(obj_controller.faction_status[2] = "War") then battle = 1;
        if (present_fleet[3] > 0) and(obj_controller.faction_status[3] = "War") then battle = 1;
        if (present_fleet[6] > 0) and(obj_controller.faction_status[6] = "War") then battle = 1;
        if (present_fleet[7] > 0) then battle = 1;
        if (present_fleet[8] > 0) and(obj_controller.faction_status[8] = "War") then battle = 1;
        if (present_fleet[9] > 0) then battle = 1;
        if (present_fleet[10] > 0) and(obj_controller.faction_status[10] = "War") {
            
            var special_stop, run, s;
            special_stop = false;
            run = 0;
            s = 0;
            repeat(planets) {
                run += 1;
                s = 0;
                var problems = p_problem[run];
                if (array_contains(problems, "meeting") || array_contains(problems, "meeting_trap")){
                    special_stop = true;
                    break;
                }
            }
            if (special_stop = false) then battle = 1;
        }
        if (present_fleet[13] > 0) then battle = 1;
    }

    if (battle2 == 0){
        if (present_fleet[2] > 0){
            if (imperium_enemies > 0) then battle2 = 2;
        }
        else if (present_fleet[3] > 0){
            if (imperium_enemies > 0) then battle2 = 3;
        }
        else if (present_fleet[6] > 0){
            if (standard_xenos_enemies > 0) then battle2 = 6;
        }
        else if (present_fleet[7] > 0){
            if (standard_xenos_enemies-present_fleet[7] > 0) then battle2 = 7;
        }
        else if (present_fleet[8] > 0){
            if (standard_xenos_enemies-present_fleet[8] > 0) then battle2 = 8;
        }
        else if (present_fleet[9] > 0){
            if (standard_xenos_enemies-present_fleet[9] > 0) then battle2 = 9;
        }
        else if (present_fleet[10] > 0){
            if (standard_xenos_enemies-present_fleet[10] > 0) then battle2 = 10;
        }
        else if (present_fleet[13]-present_fleet[13] > 0){
            if (standard_xenos_enemies > 0) then battle2 = 13;
        }
    }



    instance_activate_object(obj_en_fleet);
    if (battle2 > 0) and(battle = 0) { // AI only battle
        var i, f, shiyp;
        i = 0;
        f = 1;
        shiyp = 0;

        repeat(10) {
            f += 1;
            if (f == 11) then f = 13;
            if (present_fleet[f] > 0) {
                obj_controller.temp[1049] = self.id;
                obj_controller.temp[1050] = f;

                with(obj_en_fleet) {
                    if (orbiting = obj_controller.temp[1049]) and(owner = obj_controller.temp[1050]) {
                        obj_controller.temp[1051] = self.escort_number + (self.frigate_number * 4) + (self.capital_number * 8);
                    }
                }

                strength[f] = obj_controller.temp[1051];

                if (f = 7) and(strength[7] > 0) then strength[f] = strength[f] * 0.8;
                if (f = 9) and(strength[9] > 0) then strength[f] = strength[f] * 1.1;
                if (f = 10) and(strength[10] > 0) then strength[f] = strength[f] * 1.1;
                if (f = 11) and(strength[13] > 0) then strength[13] = strength[13] * 2;

                // if (f=10) or (f=2) then show_message("["+string(f)+"] Fleet strength: "+string(strength[f]));

                with(obj_en_ship) {
                    if (x < -7000) and(y < -7000) {
                        x += 10000;
                        y += 10000;
                    }
                }
                with(obj_en_ship) {
                    if (x < -7000) and(y < -7000) {
                        x += 10000;
                        y += 10000;
                    }
                }
                with(obj_en_ship) {
                    if (x < -7000) and(y < -7000) {
                        x += 10000;
                        y += 10000;
                    }
                }
                // show_message(string(name)+"] Owner: "+string(f)+", strength: "+string(strength[f]));
            }
        } // This grabs the "strength" from all present fleets and adds it to the temporary variable for this AI battle


        // Determine who will attack who
        var still_battling, rond;
        still_battling = true;
        rond = 0;

        repeat(5) {
            rond += 1;
            still_battling = false;
            if (strength[2] + strength[3] > 0) and (strength[6] + strength[7] + strength[8] + strength[9] + strength[10] + strength[13] > 0) then still_battling = true;
            if (strength[6] > 0) and(strength[2] + strength[7] + strength[8] + strength[9] + strength[10] + strength[13] > 0) then still_battling = true;
            if (strength[7] > 0) and(strength[2] + strength[6] + strength[8] + strength[9] + strength[10] + strength[13] > 0) then still_battling = true;
            if (strength[8] > 0) and(strength[2] + strength[6] + strength[7] + strength[9] + strength[10] + strength[13] > 0) then still_battling = true;
            if (strength[9] > 0) and(strength[2] + strength[6] + strength[7] + strength[8] + strength[10] + strength[13] > 0) then still_battling = true;
            if (strength[10] > 0) and(strength[2] + strength[6] + strength[7] + strength[8] + strength[9] + strength[13] > 0) then still_battling = true;
            if (strength[13] > 0) and(strength[2] + strength[6] + strength[7] + strength[8] + strength[9] + strength[10] > 0) then still_battling = true;

            // show_message(string(name)+" Round "+string(rond)+": "+string(still_battling));

            if (still_battling = true) {
                var who;
                who = 0;

                // Imperial Fleet Attacks
                who = 2;
                if (strength[who] > 0) {
                    if (strength[9] > 0) and(attack[who] = 0) then attack[who] = 9;
                    if (strength[10] > 0) and(attack[who] = 0) then attack[who] = 10;
                    if (strength[13] > 0) and(attack[who] = 0) then attack[who] = 13;
                    if (strength[7] > 0) and(attack[who] = 0) then attack[who] = 7;
                    if (strength[8] > 0) and(attack[who] = 0) then attack[who] = 8;
                    if (strength[6] > 0) and(attack[who] = 0) then attack[who] = 6;
                    damage[attack[who]] += strength[who] / 2;

                    // if (attack[who]=10) then show_message("Imperial Fleet damage: "+string(damage[10])+", Strength: "+string(strength[2]));
                    // show_message(string(who)+" attacking "+string(attack[who])+" for "+string(strength[who]/2));
                }

                // Eldar Fleet Attacks
                who = 6;
                if (strength[who] > 0) {
                    i = 11;
                    if (strength[13] > 0) and(13 != who) then attack[who] = 13;
                    if (attack[who] != 13) then repeat(9) {
                        i -= 1;
                        if (strength[i] > 0) and(i != who) then attack[who] = i;
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Ork Fleet Attacks
                who = 7;
                if (strength[who] > 0) {
                    if (strength[9] > 0) and(attack[who] = 0) then attack[who] = 9;
                    if (strength[13] > 0) and(attack[who] = 0) then attack[who] = 13;
                    if (strength[10] > 0) and(attack[who] = 0) then attack[who] = 10;
                    if (strength[8] > 0) and(attack[who] = 0) then attack[who] = 8;
                    if (strength[2] > 0) and(attack[who] = 0) then attack[who] = 2;
                    if (strength[6] > 0) and(attack[who] = 0) then attack[who] = 6;
                    damage[attack[who]] += strength[who] / 2;
                    // show_message(string(who)+" attacking "+string(attack[who])+" for "+string(strength[who]/2));
                }

                // Tau Fleet Attacks
                who = 8;
                if (strength[who] > 0) {
                    if (strength[13] > 0) and(attack[who] = 0) then attack[who] = 13;
                    if (strength[9] > 0) and(attack[who] = 0) then attack[who] = 9;
                    if (strength[7] > 0) and(attack[who] = 0) then attack[who] = 7;
                    if (strength[10] > 0) and(attack[who] = 0) then attack[who] = 10;
                    if (strength[2] > 0) and(attack[who] = 0) then attack[who] = 2;
                    damage[attack[who]] += strength[who] / 2;
                }

                // Tyranid Fleet Attacks
                who = 9;
                if (strength[who] > 0) {
                    i = 1;
                    if (strength[13] > 0) and(13 != who) then attack[who] = 13;
                    if (attack[who] != 13) then repeat(9) {
                        i += 1;
                        if (strength[i] > 0) and(i != who) then attack[who] = i;
                    }
                    damage[attack[who]] += strength[who] / 2;
                }

                // Chaos Fleet Attacks
                who = 10;
                if (strength[who] > 0) {
                    if (strength[9] > 0) and(attack[who] = 0) then attack[who] = 9;
                    if (strength[13] > 0) and(attack[who] = 0) then attack[who] = 13;
                    if (strength[2] > 0) and(attack[who] = 0) then attack[who] = 2;
                    if (strength[6] > 0) and(attack[who] = 0) then attack[who] = 6;
                    if (strength[7] > 0) and(attack[who] = 0) then attack[who] = 7;
                    if (strength[8] > 0) and(attack[who] = 0) then attack[who] = 8;
                    damage[attack[who]] += strength[who] / 2;
                    // if (attack[who]=2) then show_message("Chaos Fleet damage: "+string(damage[2])+", Strength: "+string(strength[10]));
                }

                // Necron Fleet Attacks
                who = 13;
                if (strength[who] > 0) {
                    if (strength[6] > 0) and(attack[who] = 0) then attack[who] = 6;
                    if (strength[9] > 0) and(attack[who] = 0) then attack[who] = 9;
                    if (strength[2] > 0) and(attack[who] = 0) then attack[who] = 2;
                    if (strength[10] > 0) and(attack[who] = 0) then attack[who] = 10;
                    if (strength[7] > 0) and(attack[who] = 0) then attack[who] = 7;
                    if (strength[8] > 0) and(attack[who] = 0) then attack[who] = 8;
                    damage[attack[who]] += strength[who] / 2;
                }

                // Attacking has been determined, work out damage
                var i;
                i = 1;
                repeat(9) {
                    i += 1;
                    strength[i] -= damage[i];
                    damage[i] = 0;
                    //  if (strength[i]>0) and (present_fleet[i]>0) then show_message(string(name)+"] Fleet:"+string(i)+" surviving at "+string(strength[i])+" in round "+string(rond));
                    if (strength[i] <= 0) and(present_fleet[i] > 0) {
                        // show_message(string(name)+"] Fleet:"+string(i)+" beat to shit in round "+string(rond));
                        obj_controller.temp[1049] = i;
                        obj_controller.temp[1050] = self.id;
                        with(obj_en_fleet) {
                            if (owner = obj_controller.temp[1049]) and(orbiting = obj_controller.temp[1050]) then instance_destroy();
                        }
                    }
                }


                strength[13] -= damage[13];
                damage[13] = 0;
                //  if (strength[i]>0) and (present_fleet[i]>0) then show_message(string(name)+"] Fleet:"+string(i)+" surviving at "+string(strength[i])+" in round "+string(rond));
                if (strength[13] <= 0) and(present_fleet[13] > 0) {
                    // show_message(string(name)+"] Fleet:"+string(i)+" beat to shit in round "+string(rond));
                    obj_controller.temp[1049] = 13;
                    obj_controller.temp[1050] = self.id;
                    with(obj_en_fleet) {
                        if (owner = obj_controller.temp[1049]) and(orbiting = obj_controller.temp[1050]) then instance_destroy();
                    }
                }

            }
        }

        // Those 5 battle intervals have finished
        // Clean up the surviving fleet(s)


        var i;
        i = 1;
        repeat(10) {
            i += 1;
            if (i = 11) then i = 13;
            if (strength[i] > 0) and(present_fleet[i] > 0) {
                // Get RACE[X] ORBITING[Y] and STRENGTH[z]
                obj_controller.temp[1047] = strength[i];
                obj_controller.temp[1048] = 0;
                obj_controller.temp[1049] = i;
                obj_controller.temp[1050] = self.id;

                with(obj_en_fleet) {
                    if (owner != obj_controller.temp[1049]) and(orbiting != obj_controller.temp[1050]) {
                        x -= 10000;
                        y -= 10000;
                    }
                    if (owner = obj_controller.temp[1049]) and(orbiting = obj_controller.temp[1050]) {
                        obj_controller.temp[1048] += escort_number;
                        obj_controller.temp[1048] += frigate_number * 4;
                        obj_controller.temp[1048] += capital_number * 8;
                    }
                }

                // show_message("Fleet "+string(owner)+" has "+string(obj_controller.temp[1048])+" strength remaining after the battle");


                // if (i=10) and (strength[i]>0) then show_message("STR "+string(strength[10])+" < "+string(obj_controller.temp[1048])+" ?");

                if (strength[i] < obj_controller.temp[1048]) { // Need to remove ships if !=
                    repeat(40) {
                        if (obj_controller.temp[1047] > obj_controller.temp[1048]) then with(obj_en_fleet) {
                            if (owner = obj_controller.temp[1049]) and(orbiting = obj_controller.temp[1050]) {
                                if (escort_number > 0) and(escort_number + frigate_number + capital_number != 1) {
                                    escort_number -= 1;
                                    obj_controller.temp[1047] -= 1;
                                    // show_message("removed an escort, escorts left: "+string(escort_number));
                                    if (escort_number + frigate_number + capital_number <= 0) then instance_destroy();
                                }
                            }
                        }
                    }
                }
                if (strength[i] < obj_controller.temp[1048]) {
                    repeat(20) {
                        if (obj_controller.temp[1047] < obj_controller.temp[1048]) then with(obj_en_fleet) {
                            if (owner = obj_controller.temp[1049]) and(orbiting = obj_controller.temp[1050]) {
                                if (frigate_number > 0) and(escort_number + frigate_number + capital_number != 1) {
                                    frigate_number -= 1;
                                    obj_controller.temp[1047] -= 4;
                                    // show_message("removed a frigate, frigates left: "+string(frigate_number));
                                    if (escort_number + frigate_number + capital_number <= 0) then instance_destroy();
                                }
                            }
                        }
                    }
                    repeat(10) {
                        if (obj_controller.temp[1047] < obj_controller.temp[1048]) then with(obj_en_fleet) {
                            if (owner = obj_controller.temp[1049]) and(orbiting = obj_controller.temp[1050]) {
                                if (capital_number > 0) and(escort_number + frigate_number + capital_number != 1) {
                                    capital_number -= 1;
                                    obj_controller.temp[1047] -= 8;
                                    // show_message("removed a capital ship, capitals left: "+string(capital_number));
                                    if (escort_number + frigate_number + capital_number <= 0) then instance_destroy();
                                }
                            }
                        }
                    }
                }

                strength[i] = obj_controller.temp[1047];
                // show_message("Surviving fleet ("+string(i)+") strength: "+string(strength[i]));
                // I'd hope that removes enough ships from the survivor
            }
            with(obj_en_fleet) {
                if (x < -5000) and(y < -5000) {
                    x += 10000;
                    y += 10000;
                }
            }
        }
    } // End AI battle

    if (battle > 0) {
        if (present_fleet[1] > 0) and((present_fleet[6] + present_fleet[7] + present_fleet[8] + present_fleet[9] + present_fleet[10] + present_fleet[13] > 0) or((present_fleet[2] > 0) and(obj_controller.faction_status[2] = "War"))) {
            var i, onceh;
            i = 1;
            onceh = 0;

            repeat(9) {
                i += 1;
                var special_stop = false;;
                if (i = 10) or(i = 11) {
                    special_stop = has_problem_star("meeting")||has_problem_star("meeting_trap");
                }

                if (obj_controller.faction_status[i] = "War") and(onceh = 0) and(!special_stop) { // Quene battle
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = -50;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = i; // Who triggered it first
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    // obj_turn_end.battle_object[obj_turn_end.battles]=instance_nearest(x,y,obj_en_fleet);
                    obj_turn_end.battle_pobject[obj_turn_end.battles] = instance_nearest(x, y, obj_p_fleet);

                    if (i = 10) {
                        obj_controller.temp[1049] = string(name);
                        with(obj_temp2) {
                            instance_destroy();
                        }
                        with(obj_temp3) {
                            instance_destroy();
                        }
                        with(obj_en_fleet) {
                            if (action = "") and(orbiting = obj_controller.temp[1049]) and(owner = 10) {
                                if (string_count("Khorne_warband", trade_goods) > 0) then instance_create(x, y, obj_temp2);
                                if (string_lower(trade_goods) = "csm") then instance_create(x, y, obj_temp3);
                            }
                        }
                        if (instance_exists(obj_temp2)) {
                            obj_turn_end.battle_special[obj_turn_end.battles] = "BLOOD";
                            with(obj_temp2) {
                                instance_destroy();
                            }
                        }
                        if (instance_exists(obj_temp3)) {
                            obj_turn_end.battle_special[obj_turn_end.battles] = "CSM";
                            with(obj_temp2) {
                                instance_destroy();
                            }
                        }
                    }
                    onceh = 1;
                }
            }
        }
    }

    instance_activate_object(obj_p_fleet);
    instance_activate_object(obj_en_fleet);

    var run, force, beetle, chaos_meeting;
    var run = 0;
    var force = 1;
    var beetle = 0;
    var chaos_meeting = 0;

    var run, force, beetle, chaos_meeting;
    run = 0;
    force = 1;
    beetle = 0;
    chaos_meeting = 0;

    repeat(planets) {
        run += 1;
        force = 1;
        var forces_list = [];
        var force_count = 0;
        if (p_player[run] > 0 && struct_exists(obj_controller.location_viewer.garrison_log, name)){
            forces_list = scr_count_forces(name, run, true, true)
            force_count = forces_list[0] + forces_list[1];
        }

        if (p_player[run] > 0 && force_count > 0) {
            var spyrer, fallen;
            spyrer = 0;
            fallen = 0;

            if (p_player[run] > 0){
                if (has_problem_planet(run,  "meeting")) {
                    chaos_meeting = run;
                } else if (has_problem_planet(run,  "meeting_trap")){
                    chaos_meeting = run + 0.1;
                }
            } 
            if (has_problem_planet(run,  "spyrer")) {
                if (p_player[run] > 20){
                    var tixt;
                    tixt = "The Spyrer on " + planet_numeral_name(run);
                    tixt += " seems to have vanished, presumably gone into hiding.";
                    scr_popup("Spyrer Rampage", tixt, "spyrer", "");
                } else if ((p_player[run] <= 20)){
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = run;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = 30;
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    obj_turn_end.battle_object[obj_turn_end.battles] = id;
                    obj_turn_end.battle_special[obj_turn_end.battles] = "spyrer";                    
                }
            }

            if (p_player[run] > 0) and (has_problem_planet(run,  "fallen")) {
                var chan;
                chan = choose(1, 2, 3, 4);
                if (chan <= 2) {
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = run;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = 10;
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    obj_turn_end.battle_object[obj_turn_end.battles] = id;
                    if (chan = 1) then obj_turn_end.battle_special[obj_turn_end.battles] = "fallen1";
                    if (chan = 2) then obj_turn_end.battle_special[obj_turn_end.battles] = "fallen2";

                }else if (chan >= 3) {
                    if (remove_planet_problem(run, "fallen")){
                        tixt = "Your marines have scoured " + planet_numeral_name(run);
                        tixt += " in search of the Fallen.  Despite their best efforts, and meticulous searching, none have been found.  It appears as though the information was faulty or out of date.";
                        scr_popup("Hunt the Fallen", tixt, "fallen", "");
                        scr_event_log("", $"Mission Successful: No Fallen located upon {planet_numeral_name(run)}");
                    }
                }
            }

        }
        if (p_player[run] > 0) and(has_problem_planet(run,"bomb")) {
            var have_bomb;
            have_bomb = scr_check_equip("Plasma Bomb", name, run, 0);
            if (have_bomb > 0) {
                var tixt;
                tixt = "Your marines on " + planet_numeral_name(run);
                tixt += " are prepared and ready to enter the Necron Tombs.  A Plasma Bomb is in tow.";
                scr_popup("Necron Tomb Excursion", tixt, "necron_cave", "blarg|" + string(name) + "|" + string(run) + "|999|");
            }
        }
        if (p_player[run] > 0) and(force_count > 0) {
            for (force = 2; force < 14; force++) {
                battle_opponent = 0;

                switch (force) {
                    case 3: // mechanicus aren't quite in yet
                    case 4:
                    case 12:
                        continue;
                    case 2:
                        if (p_player[run] > 0 && p_owner[run] == 1 && p_guardsmen[run] > 0 && obj_controller.faction_status[2] == "War") {
                            battle_opponent = 2;
                        }
                        if (p_player[run] >= 10 && p_owner[run] != 1 && p_guardsmen[run] > 0 && obj_controller.faction_status[2] == "War") {
                            battle_opponent = 2;
                        }
                        break;
                    case 5:
                        if (p_player[run] > 0 && p_sisters[run] > 0 && obj_controller.faction_status[5] == "War") {
                            battle_opponent = 5;
                        }
                        break;
                    case 6:
                        if (p_player[run] > 0 && p_eldar[run] > 0 && obj_controller.faction_status[6] == "War") {
                            battle_opponent = 6;
                        }
                        break;
                    case 7:
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_orks[run] > 0) {
                            battle_opponent = 7;
                        }
                        break;
                    case 8:
                        if (p_guardsmen[run] == 0 && p_player[run] > 0 && p_tau[run] > 0) {
                            battle_opponent = 8;
                        }
                        break;
                    case 9:
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_tyranids[run] > 0) {
                            battle_opponent = 9;
                        }
                        break;
                    case 10:
                         var pause = has_problem_planet(run,"meeting")||has_problem_planet(run,"meeting_trap");
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_traitors[run] > 0 && pause == 0 && obj_controller.faction_status[10] == "War") {
                            battle_opponent = 10;
                        }
                        break;
                    case 11:
                        var pause = has_problem_planet(run,"meeting")||has_problem_planet(run,"meeting_trap");
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_chaos[run] > 0 && pause == 0 && obj_controller.faction_status[10] == "War") {
                            battle_opponent = 11;
                        }
                        break;
                    case 13:
                        if (p_guardsmen[run] + p_pdf[run] == 0 && p_player[run] > 0 && p_necrons[run] > 0) {
                            battle_opponent = 13;
                        }
                        break;
                }


                // other battle crap here
                if (battle_opponent > 0) {
                    // obj_controller.x=self.x;obj_controller.y=self.y;
                    obj_turn_end.battles += 1;
                    obj_turn_end.battle[obj_turn_end.battles] = 1;
                    obj_turn_end.battle_world[obj_turn_end.battles] = run;
                    obj_turn_end.battle_opponent[obj_turn_end.battles] = battle_opponent;
                    obj_turn_end.battle_location[obj_turn_end.battles] = name;
                    obj_turn_end.battle_object[obj_turn_end.battles] = id;
                }
            }
        }

        // Other planetary stuff

        var thirdpop;
        var halfpop;

        thirdpop = p_max_population[run] / 3;
        halfpop = p_max_population[run] / 2;

        if (array_length(p_feature[run]) != 0) {
            if (planet_feature_bool(p_feature[run], P_features.Recruiting_World) == 1) and(obj_controller.gene_seed = 0) and(obj_controller.recruiting > 0) {
                obj_controller.recruiting = 0;
                obj_controller.income_recruiting = 0;
                scr_alert("red", "recruiting", "The Chapter has run out of gene-seed!", 0, 0);
            }

            // Transforming billions pop number to a real number so the code can handle it
            // Otherwise, 3 and a half billions get translated as 3,50 instead of 3500000000
            var _planet_population = p_population[run];
            if (p_large[run] == 1) {
                _planet_population = _planet_population * 1000000000;
            }

            if (planet_feature_bool(p_feature[run], P_features.Recruiting_World) == 1) and(obj_controller.gene_seed > 0) and(p_owner[run] <= 5) and(obj_controller.faction_status[p_owner[run]] != "War") {
                if (_planet_population >= 50) {
                    // Commenting this for now, looks like debug code
                    //scr_alert("green","owner", "Recruitment is slowed due to lack of population on our recruitment worlds",0,0);
                    if (p_large[run] = 0) then p_population[run] -= 1;

                    var recruit_chance = 999;
                    var aspirant = 0;
                    var new_recruit_corruption = 10;
                    var months_to_neo = 72;
                    var dista = 0;
                    var onceh = 0;
                    var recruit_chance_array = [0, 250, 200, 150, 125, 100];
                    if (obj_controller.recruiting>0){
                        recruit_chance = irandom(recruit_chance_array[obj_controller.recruiting]) + 1;
                    }

                    // 135; recruiting
                    // new_recruit_corruption isn't really relevant as corruption in marines doesn't matter
                    // by default it takes 72 turns (6 years) to train

                    var planet_type_recruit_chance = {
                        "hive" : 40,
                        "Temperate" : 20,
                        "Feudal" : 20,
                        "Forge" : 15,
                        "Shrine" : 15,
                        "Desert" : 15,
                        "Ice" : 15,
                        "Agri" : 10,
                        "Death" : 10,
                        "Lava" : 7,
                    }
                    var planet_type = p_type[run];
                    if (struct_exists(planet_type_recruit_chance, planet_type)){
                        if (recruit_chance <= planet_type_recruit_chance[$ planet_type]){
                            aspirant = 1;
                        }
                    }

                    // if a planet type has less than half it's max pop, you get 20% less spacey marines
                    if (_planet_population <= halfpop) {
                        recruit_chance += 1.2;
                       // scr_alert("red", "owner", "The populations you attain aspirants from are less populant than required, chances of recruiting aspirants is 20% lower", 0, 0);
                    }

                    // This is the area has trial types that don't care about planet type 
                    // xp is given in a latter if loop

                    if (obj_controller.recruit_trial = "Blood Duel") { // blood duel is most numerous, but not great with gene seed
                        months_to_neo -= choose(24, 24, 36, 36, 36, 48);
                        new_recruit_corruption += choose(10, 15, 20);
                        recruit_chance -= choose(0.7, 0.7, 0.8, 0.8, 0, 8, 0.9);

                        if (obj_controller.recruiting > 0) {
                            var wasted_gene_seed = choose(0, 0, 0, 0, 0, 0, 0, 0, 1);
                            if (wasted_gene_seed = 1) {
                                wasted_gene_seed += (obj_controller.recruiting);
                                (obj_controller.gene_seed) -= wasted_gene_seed;
                                if (wasted_gene_seed >= 1) {
                                    scr_alert("red", "owner", "Blood Duels are efficient in time, but costly in risk with gene material. Gene-seed has been lost.", 0, 0);
                                }
                            }
                        }
                    }
                    else if (obj_controller.recruit_trial = "Challenge") {
                        new_recruit_corruption += choose(1, 2, 3)
                        months_to_neo -= choose(-6, 0, 6);
                    }
                    else if (obj_controller.recruit_trial = "Exposure") {
                        new_recruit_corruption += choose(1, 2, 3)
                    }
                    else if (obj_controller.recruit_trial = "Knowledge of Self") { // less time heavy than apprenticeship. Good on temperates (ppl are educated there idk)
                        months_to_neo += choose(18, 24, 24, 24, 36, 36);
                        new_recruit_corruption -= choose(4, 6, 8)
                    }
                    else if (obj_controller.recruit_trial = "Apprenticeship") { // the "I don't need any more astartes but have money to spend" one
                        months_to_neo += choose(48, 60);
                        new_recruit_corruption -= 10;
                    }

                    // xp gain for the recruit is here
                    // as well as planet type buffs or nerfs
                    if (aspirant != 0) {
                        var i, new_recruit;
                        i = 0;
                        new_recruit = 0;

                        // gets the next empty recruit space on the array
                        var new_recruit_exp = irandom(5);

                        // gives planet buffs

                        if (p_type[run] = "Death") {
                            new_recruit_exp += 6;
                        }
                        if (p_type[run] = "Ice") {
                            new_recruit_exp += 3;
                        }
                        if (p_type[run] = "Desert") {
                            new_recruit_exp += 3;
                        }
                        if (p_type[run] = "Lava") {
                            new_recruit_exp += 9;
                        }


                        if (obj_controller.recruit_trial = "Hunting the Hunter") {
                            if (p_type[run] = "Desert") or(p_type[run] = "Ice") or(p_type[run] == "Death") {
                                new_recruit_exp += irandom(13) + 7;
                            }
                        }

                        if (obj_controller.recruit_trial = "Exposure") {
                            if (p_type[run] == "Desert") or(p_type[run] == "Ice") or(p_type[run] == "Death") or(p_type[run] == "Lava") or(p_type[run] == "Forge") {
                                months_to_neo -= choose(12, 12, 12, 24, 24, 36);
                            }
                        }

                        if (obj_controller.recruit_trial = "Survival of the Fittest") {
                            if (p_type[run] = "Desert") or(p_type[run] = "Ice") or(p_type[run] = "Death") or(p_type[run] = "Lava") {
                                recruit_chance -= choose(0.7, 0.8, 0.8, 0.8, 0.9);
                            }
                            if (p_type[run] = "Feudal") {
                                recruit_chance -= choose(0.5, 0.6, 0.6, 0.7, 0.7, 0.8)
                            }
                        }
                        if (obj_controller.recruit_trial = "Challenge") {
                            new_recruit_exp += choose(0, 0, 0, 0, 0, 0, 0, 0, 10, 20);
                            scr_alert("green", "owner", "A worthy aspirant has risen to the rank of Neophyte, doing quite well against the challenger Astartes.", 0, 0);
                        }


                        if (obj_controller.recruit_trial = "Apprenticeship") {
                            if (p_type[run] = "Lava") {
                                recruit_chance -= choose(0.5, 0.6, 0.6, 0.7, 0.7);
                            } // nocturne gaming
                            new_recruit_exp += irandom(5) + 34;
                        }

                        if (obj_controller.recruit_trial = "Knowledge of Self") {
                            if (p_type[run] = "Temperate") then new_recruit_exp += irandom(5) + 5; // this is the only one that gives bonus for temperates
                            new_recruit_exp += irandom(10) + 15;
                        }

                        if (new_recruit_exp >= 40) then new_recruit_exp = 38;// we don't want immediate battle bros

                        for (var i=0;i<array_length(obj_controller.recruit_training);i++) {
                            if (obj_controller.recruit_training[i]<1 || months_to_neo<obj_controller.recruit_training[i]){
                                obj_controller.gene_seed -= 1;
                                array_insert(obj_controller.recruit_corruption, i, new_recruit_corruption);
                                array_insert(obj_controller.recruit_distance , i, 0);
                                array_insert(obj_controller.recruit_training, i, months_to_neo);
                                array_insert(obj_controller.recruit_exp, i, new_recruit_exp); 
                                array_insert(obj_controller.recruit_name, i, global.name_generator.generate_space_marine_name());                                                                                           
                                break;
                            }
                        }
                    }
                    // End aspirant!=0
                } // End pop>50
            } // End recruiting possible
            //fortress monestary
            if (p_owner[run] == 1) {
                var monestary = search_planet_features(p_feature[run], P_features.Monastery);
                if (array_length(monestary) > 0) {
                    monestary = p_feature[run][monestary[0]];
                    var md, ms, ml, build_rate, build_rate2;
                    md = 225;
                    ms = 300;
                    ml = 32;
                    build_rate = 4;
                    build_rate2 = 6;

                    if (string_count("Siege Masters", obj_ini.strin) > 0) {
                        md = 300;
                        ms = 400;
                        ml = 48;
                        build_rate2 = 5;
                    }
                    if (string_count("Crafters", obj_ini.strin) > 0) or(string_count("Crafters", obj_ini.strin) > 0) {
                        build_rate = 3;
                        if (choose(0, 1) = 1) {
                            if (p_silo[run] < ms) then p_silo[run] += 1;
                            if (p_defenses[run] < md) then p_defenses[run] += 1;
                        }
                    }
                    if (p_silo[run] < ms) then p_silo[run] += 1;
                    if (p_defenses[run] < md) then p_defenses[run] += 1;

                    if ((obj_controller.turn / build_rate) = round(obj_controller.turn / build_rate)) and(p_lasers[run] > ml) then p_lasers[run] += 1;
                    if ((obj_controller.turn / build_rate2) = round(obj_controller.turn / build_rate2)) and(p_fortified[run] < 5) then p_fortified[run] += 1;
                    if (monestary.forge>0){
                        obj_controller.player_forges += sqr(monestary.forge_data.size);
                    }
                }
            }            
        } // End p_feature!=""


        // Work on upgrades
        if (array_length(p_upgrades[run]) > 0) {
            var upgrade_type, tx, display_type, upgrade;
            for (var up = 0; up < array_length(p_upgrades[run]); up++) {
                upgrade = p_upgrades[run][up];
                if (struct_exists(upgrade, "built")) {
                    upgrade_type = upgrade.f_type;
                    if (upgrade.built == obj_controller.turn) {
                        if (upgrade_type == P_features.Arsenal) {
                            display_type = "Arsenal";
                            obj_controller.und_armouries++;
                        }else if (upgrade_type == P_features.Secret_Base) {
                            display_type = "Lair";
                            obj_controller.und_lairs++;
                        }else if (upgrade_type == P_features.Gene_Vault) {
                            display_type = "Gene Vault";
                            obj_controller.und_gene_vaults++;
                        }
                        tx = $"Hidden {display_type} on {name} {scr_roman(run)} has been completed.";
                        scr_alert("green", "owner", string(tx), x, y);
                        scr_event_log("", string(tx));
                    }
                    if (upgrade.built<=obj_controller.turn && upgrade_type == P_features.Secret_Base){
                        if (upgrade.forge > 0){
                            obj_controller.player_forges+=sqr(upgrade.forge_data.size);
                        }
                    }
                }
            }
        }

        if (p_population[run] < 0) then p_population[run] = 0;
    }

    if (chaos_meeting > 0) {
        // Run through forces and determine what all is there

        instance_create(0, 0, obj_temp_meeting);

        var i, co, ii, otm, good, master_present;
        ii = 0;
        i = 0;
        co = -1;
        good = 0;
        master_present = 0;
        repeat(11) {
            co += 1;
            i = 0;
            repeat(200) {
                i += 1;
                good = 0;
                if (obj_ini.role[co, i] != "") and(obj_ini.loc[co, i] = name) and(obj_ini.TTRP[co, i].planet_location == floor(chaos_meeting)) then good += 1;
                if (obj_ini.role[co, i] != obj_ini.role[100, 6]) and(obj_ini.role[co, i] != "Venerable " + string(obj_ini.role[100, 6])) then good += 1;
                if (string_count("Dread", obj_ini.armour[co, i]) = 0) or(obj_ini.role[co, i] = "Chapter Master") then good += 1;

                if (good = 3) {
                    obj_temp_meeting.dudes += 1;
                    otm = obj_temp_meeting.dudes;
                    obj_temp_meeting.present[otm] = 1;
                    obj_temp_meeting.co[otm] = co;
                    obj_temp_meeting.ide[otm] = i;
                    if (obj_ini.role[co, i] = "Chapter Master") then master_present = 1;
                }
            }
        }

        // title / text / image / speshul
        if (master_present = 1) and(otm <= 21) {
            var effect;
            effect = "meeting_1t";
            if (chaos_meeting == floor(chaos_meeting)) then effect = "meeting_1";
            scr_popup("Chaos Meeting", "A cloaked, ragged figure approaches your forces and hails you.  He is to bring you to meet with their master and you have few enough forces to be permitted.  What is thy will?", "chaos_messenger", effect);
        }
        if (master_present = 1) and(otm > 21) {
            scr_popup("Chaos Meeting", "A cloaked, ragged figure approaches your forces and hails you.  He is to bring you to their master, but before the meeting proceeds, you must bring fewer forces.  Only yourself and up to two squads will be allowed in the presence of " + string(obj_controller.faction_title[10]) + " " + string(obj_controller.faction_leader[10]) + ".", "chaos_messenger", "meeting_2");
            with(obj_temp_meeting) {
                instance_destroy();
            }
        }
        if (master_present = 0) and(otm > 21) {
            scr_popup("Chaos Meeting", "A cloaked, ragged figure approaches your forces and hails them.  The meeting was supposed to be with the Chaos Lord, and yourself, but you are not planet-side.  Land on the planet with up to two squads and the meeting will proceed.", "chaos_messenger", "meeting_3");
            with(obj_temp_meeting) {
                instance_destroy();
            }
        }
    }
    with (obj_p_fleet){
        if (array_length(complex_route)>0  && action == ""){
            set_new_player_fleet_course(complex_route);
        }
    }
    
}