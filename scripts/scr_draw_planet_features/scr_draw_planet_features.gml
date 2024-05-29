// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function point_and_click(rect){
	return (point_in_rectangle(mouse_x, mouse_y, rect[0], rect[1],rect[2], rect[3]) && mouse_check_button_pressed(mb_left))
}


function feature_selected(Feature) constructor{
	feature = Feature;
	main_slate = new mk_two_data_slate();
	exit_sequence = false;
	entrance_sequence=true;
	remove=false;
	destroy=false;
	exit_count = 0;
	enter_count=18;

	if (feature.f_type == P_features.Forge){
		var worker_caps= [2,4,8];
		worker_capacity = worker_caps[feature.size-1];	
		techs = collect_role_group("forge", obj_star_select.target.name);
		feature.techs_working = 0;
		for (var i=0;i<array_length(techs);i++){
			if (techs[i].assignment()=="forge" && techs[i].job.planet == obj_controller.selecting_planet){
				feature.techs_working++;
				if (feature.techs_working==worker_capacity) then break;
			}
		}
	}

	draw_planet_features = function(xx,yy){
	    draw_set_halign(fa_center);
	    draw_set_font(fnt_40k_14);
	    //draw_sprite(spr_planet_screen,0,xx,yy);
	    if (exit_sequence){
	    	xx-=(25*exit_count);
	    	main_slate.draw(xx,yy, 1.38,1.38);
	    	exit_count++;
	    	if (xx-25<=obj_star_select.main_data_slate.XX) then remove=true;
	    } else if (entrance_sequence){
	    	enter_count--;
	    	xx-=(25*enter_count);
	    	if (enter_count==1) then entrance_sequence = false;
	    	main_slate.draw(xx,yy, 1.38,1.38);
	    }else {
	    	main_slate.draw(xx,yy, 1.4,1.4);
	    }
	    var area_width = main_slate.width;
	    var area_height = main_slate.height;
	    var generic = false;
	    var title="", body="";
	    //draw_glow_dot(xx+150, yy+150);
	    //rack_and_pinion(xx+230, yy+170);
	    var rectangle = [];
	    draw_set_color(c_green);
	    if (point_and_click(draw_unit_buttons([xx+12, yy+20], "<---",[1,1],c_red))){
	    	exit_sequence=true;
	    };
	    draw_set_halign(fa_center);
		switch (feature.f_type){
			case P_features.Forge:
				draw_text_transformed(xx+(area_width/2), yy +10, "Chapter Forge", 2, 2, 0);
				draw_set_halign(fa_left);
				draw_set_color(c_gray);

				draw_text(xx+10, yy+50, $"Working Techs : {feature.techs_working}/{worker_capacity}");
				if (point_and_click(draw_unit_buttons([xx+10, yy+70], "Assign To Forge",[1,1],c_red))){
					obj_controller.unit_profile = false;
					obj_controller.view_squad = false;
					group_selection(techs,{
						purpose:"Forge Assignment",
						purpose_code : "forge_assignment",
						number:worker_capacity,
						system:obj_controller.selected.id,
						feature:obj_star_select.feature,
						planet : obj_controller.selecting_planet,
						selections : []
					});
					destroy=true;

				}
				if (feature.size<3){
					var upgrade_cost = 2000 * feature.size;
					if (point_and_click(draw_unit_buttons([xx+10, yy+95], $"Upgrade Forge ({upgrade_cost} req)",[1,1],c_red)) && obj_controller.requisition>=upgrade_cost){
						obj_controller.requisition -=  upgrade_cost;
						feature.size++;
						worker_capacity*=2;
					}
				}
				break;
			case P_features.Necron_Tomb:

				generic=true;
				if (feature.awake==0 && feature.sealed==0){
					title = "Dormant Necron Tomb";
					body = "Scans indicate a Necron TOmb lies hidden under the surface of the planet, all signs indicate the tombis dormant as we must hope it remains";
				} else if (feature.sealed==1){
					title = "Sealed Necron Tomb";
					body = "Exterminatus and standard imperial armenants are no proof against the Necron Scourge with any luck those sealed within this tomb will remain there";
				} else if (feature.awake==1){
					title = "Awake Tomb";
					body = "The Cursed ranks of living metal spew forth from the Necron tomb below"
				}
				break;
			case P_features.Artifact:
				generic=true;
				title = "Unknown Artifact";
				body = "Unload Marines onto the planet to search for the artifact";
				break;	
			case P_features.Ancient_Ruins:
				generic=true;
				title = "Ancinet Ruins";
				body = "Unload Marines onto the planet to explore the ruins";
				break;
			case P_features.STC_Fragment:
				generic=true;
				title = "STC Fragment";
				body = $"Unload a {obj_ini.role[100][16]} and whatever entourage you deem necessary to recover the STC Fragment";
				break;	
			case P_features.Victory_Shrine:
				draw_text_transformed(xx+(area_width/2), yy +10, "Victory Shrine", 2, 2, 0);
				draw_set_halign(fa_left);
				draw_set_color(c_gray);				
				/*if (!feature.parade){
					if (point_and_click(draw_unit_buttons([xx+10, yy+70], "Parade (500 req)",[1,1],c_red))){
						obj_controller.requisition-=500;
						feature.forge=1;
						feature.forge_data = new player_forge();
					}
				}*/
				break;																	
			case P_features.Monastery:
				draw_text_transformed(xx+(area_width/2), yy +10, feature.name, 2, 2, 0);
				if (feature.forge==0){
					draw_text_transformed(xx+80, yy +50, "Forge", 1, 1, 0);
					if (draw_building_builder(xx+40, yy+70,500,spr_forge_holo)){
						obj_controller.requisition-=500;
						feature.forge=1;
						feature.forge_data = new player_forge();
					};
				}
				break;
		}
		if (generic){
			draw_text_transformed(xx+(area_width/2), yy +5, title, 2, 2, 0);
			draw_set_halign(fa_left);
			draw_set_color(c_gray);
			draw_text_ext(xx+10, yy+40,body,-1,area_width-20);
		}
		return "done";
	}
}

function draw_building_builder(xx, yy, req_require, building_sprite){
	var clicked =false;
	draw_sprite_ext(building_sprite, 0, xx, yy, 0.5, 0.5, 0, c_white, 1);
	var image_bottom = yy+50;
	var image_middle = xx-15;
	if (obj_controller.requisition>=req_require){
		if (scr_hit(image_middle+30, image_bottom+28, image_middle+78, image_bottom+44)){
			draw_sprite_ext(spr_slate_2, 5, image_middle-10, image_bottom, 1, 1, 0, c_white, 1);
			if (mouse_check_button(mb_left)){
				clicked=true;								
			}
		} else {
			draw_sprite_ext(spr_slate_2, 3, image_middle-10, image_bottom, 1, 1, 0, c_white, 1);
		}
	} else {
		draw_sprite_ext(spr_slate_2, 7, image_middle-10, image_bottom, 1, 1, 0, c_white, 1);
	}
	draw_sprite_ext(spr_requisition,0,image_middle+65,image_bottom+30,1,1,0,c_white,1);
	draw_set_halign(fa_left);
	draw_text(image_middle+32, image_bottom+30, req_require);
	return clicked;
}

function mk_two_data_slate()constructor{
	height=0;
	width=0;
	XX=0;
	YY=0;
	static draw = function(xx,yy,x_scale, y_scale){
		XX=xx;
		YY=yy;
		height = 250*y_scale;
		width=365*x_scale;
		draw_sprite_ext(spr_slate_2, 1, xx, yy, x_scale, y_scale, 0, c_white, 1);
		draw_sprite_ext(spr_slate_2, 0, xx, yy, x_scale, y_scale, 0, c_white, 1);
		draw_sprite_ext(spr_slate_2, 2, xx, yy, x_scale, y_scale, 0, c_white, 1);
		//draw_sprite_ext(spr_slate_2, 0, xx, yy, 1, 1, 0, c_white, 1)
	}
}

function rack_and_pinion(Type="forward") constructor{
	reverse =false;
	rack_y=0;
	rotation = 360;
	type=Type
	if (type="forward"){
		draw = function(x, y, freeze=false, Reverse=""){
			x+=19;
			if (!freeze){
				if (Reverse != ""){
					if (Reverse){
						reverse=true;
					} else {
						reverse=false;
					}
				}
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				if (!reverse){
					rotation-=4;
				} else {
					rotation+=4;
				}
				rack_y = (75.3982236862/360)*(360-rotation)
				if (rack_y > 70){
					reverse = true;
				} else if (rack_y < 2){
					reverse = false;
				}
				draw_sprite_ext(spr_rack, 0, x-13, y-rack_y, 1, 1, 0, c_white, 1)
			} else {
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				draw_sprite_ext(spr_rack, 0, x-13, y-rack_y, 1, 1, 0, c_white, 1)
			}		
		}
	} else if (type="backward"){
		draw = function(x, y, freeze=false, Reverse=""){
			x-=19;
			if (!freeze){
				if (Reverse != ""){
					if (Reverse){
						reverse=true;
					} else {
						reverse=false;
					}
				}
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				if (!reverse){
					rotation+=4;
				} else {
					rotation-=4;
				}
				rack_y = (75.3982236862/360)*(360-rotation)
				if (rack_y > 70){
					reverse = true;
				} else if (rack_y < 2){
					reverse = false;
				}
				draw_sprite_ext(spr_rack, 0, x+13, y+rack_y, -1, 1, 0, c_white, 1)
			} else {
				draw_sprite_ext(spr_cog_pinion, 0, x, y, 1, 1, rotation, c_white, 1)
				draw_sprite_ext(spr_rack, 0, x+13, y+rack_y, -1, 1, 0, c_white, 1)
			}		
		}		
	}
}
function speeding_dot(XX,YY, limit) constructor{
	bottom_limit = limit;
	stack = 0;
	yyy=YY;
	xxx=XX;
	draw = function(xx,yy){
		if (bottom_limit+(48*0.7)<stack){
			stack=0;
		}
		var top_cut = 36-stack>0 ? 36-stack :0;
		var bottom_cut = bottom_limit<stack? 46-stack-bottom_limit:46;
		draw_sprite_part_ext(spr_research_bar, 2, 0, top_cut, 200, bottom_cut, xx-105, yy+stack, 1, 0.7, c_white, 1);
		stack+=3;
	}
	current_y = function(){
		return yy+stack;
	}
}
function glow_dot() constructor{
	flash = 0
	flash_size = 5;
	one_flash_finished = true;
	draw = function(xx, yy){
		draw_set_color(c_green);
		for (var i=0; i<=flash_size;i++){
			draw_set_alpha(1 - ((1/40)*i))
			draw_circle(xx, yy, (i/3), 1);
		}
		if (flash==0){
			if (flash_size<40){
				flash_size++;
			} else {
				flash = 1;
				flash_size--;
			}
		} else {
			if (flash_size > 1){
				flash_size--;
			}else {
				flash_size++;
				flash = 0;
			}
		}		
	}
	draw_one_flash = function(xx, yy){
		if (one_flash_finished) then exit;
		draw_set_color(c_green);
		for (var i=0; i<=flash_size;i++){
			draw_set_alpha(1 - ((1/40)*i))
			draw_circle(xx, yy, (i/3), 1);
		}
		if (flash==0){
			if (flash_size<40){
				flash_size++;
			} else {
				flash = 1;
				flash_size--;
			}
		} else {
			if (flash_size > 1){
				flash_size--;
			}else {
				flash_size++;
				flash = 0;
				one_flash_finished = true;
			}
		}		
	}
}

function shutter_button() constructor{
	time_open = 0;
	click_timer = 0;
	Width = 315;
	Height = 90;
	XX=0;
	YY=0;
	width=0;
	height=0;
	right_rack = new rack_and_pinion();
	left_rack = new rack_and_pinion("backward");
	draw_shutter = function(xx,yy,text, scale=1, entered = ""){
		XX=xx;
		YY=yy;
        draw_set_alpha(1);

        draw_set_font(fnt_40k_12);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);		
		width = Width *scale;
		height = Height *scale;
		if (text=="") then entered = false;
		if (entered==""){
			entered = point_in_rectangle(mouse_x, mouse_y, xx, yy, xx+width, yy+height);
		} else {
			entered=entered;
		}
		var shutter_backdrop = 5;
		if (entered || click_timer>0){
			if (time_open<20){
				time_open++;
				right_rack.draw(xx+width, yy, false, false);
				left_rack.draw(xx, yy, false, false);
			} else {
				right_rack.draw(xx+width, yy, true);
				left_rack.draw(xx, yy, true);
			}
			if ((mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, xx, yy, xx+width, yy+height))||click_timer>0 ){
				shutter_backdrop = 6;
				click_timer++;
			}
		} else if (time_open>0){
			time_open--;
			right_rack.draw(xx+width, yy, false, true);
			left_rack.draw(xx, yy, false, true);
		} else {
			right_rack.draw(xx+width, yy, true);
			left_rack.draw(xx, yy, true);
		}
		var text_draw = xx+(width/2)-(string_width(text)*(3*scale)/2);
		var main_sprite = 0;
		if (time_open<2){
			draw_sprite_ext(spr_shutter_button, main_sprite, xx, yy, scale, scale, 0, c_white, 1)
		} else if (time_open<8 && time_open>=2){
			main_sprite=1;
		}else if  (time_open<13 && time_open>=8){
			main_sprite=2;
		}else if  (time_open<18 && time_open>=13){
			main_sprite=3;
		} else if (time_open>=18){
			main_sprite=4;
		}
		if (time_open>=2){
			draw_sprite_ext(spr_shutter_button, shutter_backdrop, xx, yy, scale, scale, 0, c_white, 1)
			draw_set_color(c_red);
			if (click_timer>0){
				draw_text_transformed(text_draw, yy+(24*scale), text, 3*scale, 3*scale, 0);
			} else {
				draw_text_transformed(text_draw, yy+(20*scale), text, 3*scale, 3*scale, 0);
			}
			draw_sprite_ext(spr_shutter_button, main_sprite, xx, yy, scale, scale, 0, c_white, 1)			
		}
		draw_set_color(c_grey);
		if (click_timer>7){
			click_timer = 0;
			return true;
		} else {
			return false;
		}
	}
}

function data_slate() constructor{
	static_line=1;
	title="";
	sub_title="";
	body_text = "";
	inside_method = "";
	XX=0;
	YY=0;
	width=0;
	height=0;
	static draw = function(xx,yy, scale_x=1, scale_y=1){
		XX=xx;
		YY=yy;
		width = 860*scale_x;
		height = 850*scale_y;
		draw_sprite_ext(spr_data_slate,1, xx,yy, scale_x, scale_y, 0, c_white, 1);
		if (is_method(inside_method)){
			inside_method();
		}
	    if (static_line<=10) then draw_set_alpha(static_line/10);
	    if (static_line>10) then draw_set_alpha(1-((static_line-10)/10));		
		draw_set_color(5998382);
		var line_move = yy+(70*scale_y)+((36*scale_y)*static_line);
		draw_line(xx+(30*scale_x),line_move,xx+(820*scale_x),line_move);
		draw_set_alpha(1);
		if (irandom(75)=0 && static_line>1){static_line--;}
		else{
			static_line+=0.1;
		}
		if (static_line>20) then static_line=1;
		draw_set_color(c_gray);
		draw_set_halign(fa_center);
		var draw_height = 	5;
		if (title!=""){
			draw_text_transformed(xx+(0.5*width), yy+(50*scale_y), title, 3*scale_x, 3*scale_y, 0);
			draw_height += (string_height(title)*3)*scale_y;
		}
		if (sub_title!=""){
			draw_text_transformed(xx+(0.5*width), yy+(50*scale_y)+draw_height, sub_title, 2*scale_x, 2*scale_y, 0);
			draw_height+=(25*scale_y) +(string_height(sub_title)*2)*scale_y;
		}
		if (body_text!=""){
			draw_text_ext(xx+(0.5*width), yy+(50*scale_y)+draw_height, string_hash_to_newline(body_text), -1, width-60);
		}
	}
	static draw_cut = function(xx,yy, scale_x=1, scale_y=1, middle_percent=0){
		XX=xx;
		YY=yy;
		draw_sprite_part_ext(spr_data_slate,1, 0, 0, 850, 69, XX, YY, scale_x, scale_y, c_white, 1);
		draw_sprite_part_ext(spr_data_slate,1, 0, 69, 850, 683*(middle_percent/100), XX, YY+(69*scale_y), scale_x, scale_y, c_white, 1);
		draw_sprite_part_ext(spr_data_slate,1, 0, 752, 850, 98, XX, YY+(69+683*((middle_percent/100)))*scale_y, scale_x, scale_y, c_white, 1);
		width = 860*scale_x;
		height = (69+(683*(middle_percent/100))+98 )*scale_y;
		if (is_method(inside_method)){
			inside_method();
		}		
	}
}










