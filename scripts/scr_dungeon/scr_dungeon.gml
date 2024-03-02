// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function unit_map_sprite() constructor{
	is_walking = true;
	walking_no=0;
	walk_sprite = spr_mar_walk_body1;
	walk_legs = spr_mar_walk_legs1
	current_x=0;
	current_y=0;
	static draw = function(draw_x, draw_y){
		var xx=draw_x+current_x;
		var yy = current_y +draw_y;
		draw_sprite_ext(walk_sprite, floor(walking_no), xx, yy, 2, 2, 0, c_white, 1);
		draw_sprite_ext(walk_legs,floor(walking_no), xx, yy, 2, 2, 0, c_white, 1);
		if (is_walking){
			walking_no +=0.25;
			if (walking_no==17) then walking_no=0;
		}
	}
	static stop_walking = function(){
		is_walking=false;
		walking_no=0;
	}
}

function dungeon_struct() constructor{
	unit_data_slate = new data_slate();
	map_data_slate = new data_slate();
	decision_data_slate = new data_slate();
	dungeon = new dungeon_map_maker();
	enter_sequence_completed=false;
	mission_objectives = [{title:"Complete Dungeon", finished:false}]
	units_set=false;
	obs_calcs=false;
	members=[];
	mission_log = [];
	current_view = "unit";
	selected_unit = "none";

	static attempt_solution(){
		if (dungeon.solution>-1 && !is_string(selected_unit)){
			var test;
			var mem = members[selected_unit];
			var ob = dungeon.current_obstacle.base_data;
			var solution = ob.solutions[dungeon.solution];
			for (var t = 0; t<array_length(solution.tests);t++){
				test = solution.tests;
				if (struct_exists(test, "modifiers")){
					if (struct_exists(test.modifiers,"weapon")){
						var weapon_mods = test.modifiers.weapon
						if (struct_exists(weapon_mods, "tag")){
							for (var s=0;s)
						}
					}
				}
			}
		}
	}

	static add_mission_log = function(){
	}
	static calculate_solution_members = function(){
		var mem, unit;
		var obsticle = dungeon.current_obstacle.base_data;
		var solution = obsticle.solutions[dungeon.solution];
		for (var i=0;i<array_length(members);i++){
			mem = members[i];
			mem.action_able = (mem.actions!=0 && mem.struct.hp()>0)
		}
		if (struct_exists(solution, "requirements")){
			var requirements = solution.requirements;
			if (struct_exists(requirements,"weapon")){
				var needed_weapon = requirements.weapon;
				if (struct_exists(needed_weapon, "name")){
					for (var i=0;i<array_length(members);i++){
						if (!members[i].action_able) then continue;
						mem = members[i];
						unit = mem.struct;
						if (!array_contains(needed_weapon.name, unit.weapon_one())&&!array_contains(needed_weapon.name, unit.weapon_two())){
							mem.action_able=false;
						}
					}
				}
				if (struct_exists(needed_weapon, "tag")){
					var _wep1;
					var _wep2;
					for (var i=0;i<array_length(members);i++){
						if (!members[i].action_able) then continue;
						mem = members[i];
						unit = mem.struct;
						_wep1 = unit.get_weapon_one_data();
						_wep2 = unit.get_weapon_two_data();
						if (is_struct(_wep1)){
							if (_wep1.has_tags(needed_weapon.tag)){
								continue;
							}
						}
						if (is_struct(_wep2)){
							if (_wep2.has_tags(needed_weapon.tag)){
								continue;
							}
						}
						mem.action_able=false;
					}
				}
				if (struct_exists(needed_weapon, "tags")){
					var _wep1;
					var _wep2;
					for (var i=0;i<array_length(members);i++){
						if (!members[i].action_able) then continue;
						mem = members[i];
						unit = mem.struct;
						_wep1 = unit.get_weapon_one_data();
						_wep2 = unit.get_weapon_two_data();
						if (is_struct(_wep1)){
							if (_wep1.has_tags_all(needed_weapon.tags)){
								continue;
							}
						}
						if (is_struct(_wep2)){
							if (_wep2.has_tags_all(needed_weapon.tags)){
								continue;
							}
						}
					}					
				}
			}
		}

	}
	unit_data_slate.inside_method = function(){
		selected_unit = "none";
		var unit, mem;
		var xx =__view_get( e__VW.XView, 0 );
		var yy =__view_get( e__VW.YView, 0 );		
		var x_depth=0;
		var y_depth=0;
		var _draw_colour = c_red;
		var mis_obj_cords = draw_unit_buttons([xx+70,yy+70], "Mission Objectives",[1.5,1.5],c_red);
		if (point_and_click(mis_obj_cords)){
			current_view="mission";
		}
		var mission_log_chords = draw_unit_buttons([mis_obj_cords[2]+20,yy+70], "Mission Log",[1.5,1.5],c_red);
		if (point_and_click(mission_log_chords)){
			current_view="log";
		}
		_draw_colour = current_view == "unit"?c_gray:c_red;
		var unit_overviews = draw_unit_buttons([mission_log_chords[2]+20,yy+70], "Unit Overviews",[1.5,1.5],_draw_colour);
		var start_y = unit_overviews[3]+10;
		var start_x =mis_obj_cords[0]+50;
		var health_bar;
		if (current_view=="unit"){
			var unit_draw = [0,0];
			var banner_x_scale = (166/161);
			var banner_y_scale = (271/198)/2;
			for (var i=0;i<array_length(members);i++){
				mem = members[i];
				unit = mem.struct;
				unit_draw=[start_x+(170*x_depth),start_y+(250*y_depth)];
				unit.draw_unit_image(unit_draw[0]-xx,unit_draw[1]-yy);
				if (point_in_rectangle(mouse_x, mouse_y, unit_draw[0], unit_draw[1]+21, unit_draw[0]+166,unit_draw[1]+271)){
					selected_unit=i;
					if (dungeon.solution>-1 && mem.action_able){
						if (mouse_check_button(mb_left)){

						}
					}
				};
				x_depth++;
				if (x_depth==4){
					x_depth=0;
					y_depth++;
				}				
			}
			draw_set_color(c_black);
			draw_rectangle(start_x,start_y,start_x+(170*4), start_y+21, 0);
			x_depth=0;
			y_depth=0;
			for (var i=0;i<array_length(members);i++){
				unit = members[i].struct;
				unit_draw=[start_x+(170*x_depth),start_y+(250*y_depth)];
				draw_sprite_ext(spr_new_banner, 0, unit_draw[0], unit_draw[1]+135, banner_x_scale, banner_y_scale, 0, c_white, 1);
				draw_set_color(c_green);
				health_bar = 136*(unit.hp()/unit.max_health())+15;
				draw_rectangle(unit_draw[0]+15,unit_draw[1]+150, unit_draw[0]+health_bar, unit_draw[1]+158,0)
				draw_set_color(c_black);
				draw_rectangle(unit_draw[0]+15,unit_draw[1]+150, unit_draw[0]+151, unit_draw[1]+158,1)
				draw_set_color(c_blue);
				for (var a=0;a<members[i].actions;a++){
					draw_circle(unit_draw[0]+40 + (a*30), unit_draw[1]+188, 10, 0);
				}
				draw_set_color(c_gray);
				x_depth++;
				if (x_depth==4){
					x_depth=0;
					y_depth++;
				}
				if (dungeon.solution>-1){
					if(!members[i].action_able){
						draw_set_alpha(0.7)
						draw_rectangle(unit_draw[0], unit_draw[1]+21, unit_draw[0]+166,unit_draw[1]+250, 0);
					}
				}
				draw_set_alpha(1)				
			}
		} else if (current_view="mission"){

		}
	}


	map_data_slate.inside_method = function(){
		var xx =map_data_slate.XX;
		var yy =map_data_slate.YY;
		if (enter_sequence_completed){		
			if (!is_string(selected_unit)){
				members[selected_unit].struct.stat_display(true, [xx+unit_data_slate.width, yy+10]);
			}
		} else {
			var cur_fig;
			if (!units_set){
				unit_count = array_length(members);
				var x_scatter = 0;
				var y_scatter = 0;
				for (var i=0; i <unit_count;i++){
					x_scatter++;
					members[i].map_figure = new unit_map_sprite();
					cur_fig = members[i].map_figure;
					cur_fig.current_x =  70 + (x_scatter*40);
					cur_fig.current_y = 150+(50*y_scatter);
					cur_fig.is_walking =true;
					cur_fig.walking_no = irandom(16);
					if (x_scatter == 4){
						x_scatter = 0.5;
						y_scatter++;
					} else if (x_scatter == 4.5){
						x_scatter = 0;
						y_scatter++;
					}
				}
				units_set=true;
			}
			for (var i=0; i <unit_count;i++){
				cur_fig = members[i].map_figure;
				members[i].struct.set_unit_shader();
				cur_fig.draw(xx,yy);
				shader_reset();
			}
		}

	}
	decision_data_slate.inside_method = function(){
		if (is_struct(dungeon.current_obstacle)){
			xx=decision_data_slate.XX;
			yy = decision_data_slate.YY;
			var ob = dungeon.current_obstacle.base_data;
			draw_set_halign(fa_center);
			draw_text_ext(xx+(decision_data_slate.width/2), yy+40, ob.description, -1, decision_data_slate.width-50);
			solutions_found = 0;
			y_tier=0;
			if (obs_calcs = false){
				for (var i=0;i<array_length(ob.solutions);i++){
					ob.solutions[i].valid=true; 
				}
			}
			if (dungeon.solution=-1){
				
				for (var i=0;i<array_length(ob.solutions);i++){
					if (ob.solutions[i].valid){
						if (point_and_click(draw_unit_buttons([xx+90+(200*solutions_found), yy+100+(50*y_tier)],ob.solutions[i].name,[1.5,1.5],c_red))){
							dungeon.solution = i;
							calculate_solution_members();
						}
						solutions_found++;
						if (solutions_found==3){
							solutions_found=0;
							y_tier++;
						}
					}
				}
			} else {
				var solution = ob.solutions[dungeon.solution];
				draw_text_ext(xx+(decision_data_slate.width/2), yy+70, $"Who will attempt to {solution.description}", -1, decision_data_slate.width-50);
			}

		}
	}
	static draw = function(){
		var xx =__view_get( e__VW.XView, 0 );
		var yy =__view_get( e__VW.YView, 0 );
		unit_data_slate.draw(xx,yy,1.08,1.07);
		map_data_slate.draw(xx+unit_data_slate.width-10,yy,0.80, 0.63);
		decision_data_slate.draw(xx+unit_data_slate.width-10, yy+map_data_slate.height,0.80, 0.55);
	}
}
global.obstacles = {
	name : "Blast Door",
	description : "a sturdy blast door stands in the way of your progress",
	solutions : [
		{
			name :"bypass",
			tests :{
				technology : {
					base : 50,
					modfiers : {
						equipment : [["servo harness", 10]]
					}
				}
			},
			description : "attempt to bypass the door at the control panel",
		},
		{
			name :"divine",
			requirements : {
				class:"psyker", 
				skill:"divination",
			},
			tests :{
				"intelligence" : {
					base : 40,
					modfiers : {
					}
				}
			},
			description : "attempt to divine the door code",
		},
		{
			name :"Melta Blast",
			requirements : {
				weapon:{
					tag:["melta"]
				},
			},
			tests :[
				/*{
					attribute : "luck",
					base : 10,
				},*/
				{
					attribute : "ballistic_skill",
					base : 40,
					modifiers : {
						weapon : {
							tag : [["Heavy Weapon",20],["pistol",-20]]
						}
					}					
				}				
			],
			description : "Melt the Door with a melta blast",
		},
		{
			name :"Find Way Round",
			//requirements : ["melta"],
			tests :[
				 /*{
				 	attribute : "luck",
					base : 10,
				},*/
				{
					attribute : "luck",
					base : -40,					
				}				
			],
			classs : ["perception"],
			description : "Try find another way through",
		}			
	]
}
function dungeon_map_maker() constructor{
	var i;
	rooms = {
		room_type : "enterance",
		obstacles : new obstacle(global.obstacles)
	}
	current_room = rooms;
	current_obstacle = current_room.obstacles;
	solution=-1;
	viable_members=[];
}
function obstacle(bd) constructor{
	base_data = bd;
}