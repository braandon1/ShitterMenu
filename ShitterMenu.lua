
-- READ BELOW --

-- CREDITS TO UPTOWN LUA for base. & TOLLING LUA , human#7231
-- Combined/edited scripts from some of my fav luas and made my own.

-- much love, Braandon#0001

-- myped = player.get_player_ped(player.player_id()),
-- mypid = player.player_id(),
-- mygun = ped.get_current_ped_weapon(player.get_player_ped(player.player_id())),
-- myveh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())),
-- myaim = entity.get_entity_coords(player.get_entity_player_is_aiming_at(player.player_id()))
-- deathcheck = entity.is_entity_dead(player.get_player_ped(player.player_id()))
function loaded()
    menu.notify("ShitterMenu v1.0.0 \nMade By Braandon#0001 \nGhostOne is a cutie", ShitterMenu_ver, 10, 2)
end
loaded()

function log(text, c_prefix)
    local path = os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu"
    local log_file = io.open(path.."\\FunnyScript.log", "a")
    local t = os.date("*t")
    io.output(log_file)
    io.write(text.."\n")
    io.close(log_file)
end

function GetGroundZ(coord)
    b=12
    groundz=-1000
    attempt = v3(0,0,-1000)
    while groundz == attempt.z and b ~= -1 do
        attempt = coord
        attempt.z = (b*100) + .69696969
        deadbool, groundz = gameplay.get_ground_z(attempt)
        b=b-1
    end
    return groundz
end

function MyCoords()
	return entity.get_entity_coords(player.get_player_ped(player.player_id()))
end

player_vehicles = {} 

function IsaPlayerVehicle(checkvehicle)
  for a=0, 30 do 
	player_vehicles[a+1] = player.get_player_vehicle(a)
  end 
  for a=0, 30 do
    if checkvehicle == player_vehicles[a+1] then return true end 
  end 
  return false
end

function ReqControl(reqent)
    NetChecks=0
    while (not network.has_control_of_entity(reqent)) and NetChecks < 10 do             
        network.request_control_of_entity(reqent)
        system.wait(1)
        NetChecks=NetChecks+1
    end
    if not network.has_control_of_entity(reqent) then
        menu.notify("Failed to get control of some entities", "Request Control", 5, 230)
        return false
    end
    return true
end

weapon_g_hashes = {
	0x99B507EA, -- Knife
	0x1B06D571, -- Pistol
	0x22D8FE39, -- AP Pistol
	0x47757124, -- Flare Gun
	0xAF3696A1, -- Up-N-Atomizer
	0xEFE7E2DF, -- Assault SMG
	0x5A96BA4, -- Combat Shotgun
	0xBFEFFF6D, -- Assault Rifle
	0x0C472FE2, -- Heavy Sniper
	0xB1CA77B1, -- RPG
	0xA284510B, -- Grenade Launcher
	0x42BF8A85, -- Minigun
	0x24B17070, -- Molotov
	0x2C3731D9, -- Sticky Bombs
	0xAB564B93 -- Proximity Mines
}

weapon_r_hashes = {
	0x958A4A8F, -- Bat
	0xF9E6AA4B, --Bottle
	0x84BD7BFD, -- Crowbar
	0x440E4788, -- Golf Club
	0x4E875F73, -- Hammer
	0x5EF9FEC4, -- Combat Pistol
	0xBFD21232, -- SNS Pistol
	0x83839C4, -- Vintage Pistol
	0x2B5EF5EC, -- Ceramic Pistol
	0x97EA20B8, -- Double Action Revolver
	0x917F6C8C, -- Navy Revolver
	0x476BF155, -- Unholy Hellbringer
	0x63AB0442, -- Homing Launcher
	0xB62D1F67, -- Widowmaker
	0x93E220BD, -- Grenade
	0xFDBC8A50 -- Tear Gas
}

ped_g_hash = {
	0x02B8FA80, -- Male Civilian 
	0x47033600, -- Female Civilians
	0xA49E591C, -- Cop
	0xF50B51B7, -- Security Guard
	0xA882EB57, -- Private Security
	0xFC2CA767, -- Firemen
	0x4325F88A, -- Gang 1
	0x11DE95FC, -- Gang 2
	0x8DC30DC3, -- Gang 9
	0x0DBF2731, -- Gang 10
	0x90C7DA60, -- Gang Lost
	0x11A9A7E3, -- Gang Mexican
	0x45897C40, -- Gang Family
	0xC26D562A, -- Gang Ballas
	0x7972FFBD, -- Gang Marabunte
	0x783E3868, -- Gang Cult
	0x936E7EFB, -- Gang JSalva
	0x6A3B9F86, -- Gang Weicheng
	0xB3598E9C -- Gang Hillbilly
}

ped_g_hash2 = {
	0x02B8FA80, -- Male Civilian 
	0x47033600, -- Female Civilians
	0xA49E591C, -- Cop
	0xF50B51B7, -- Security Guard
	0xA882EB57, -- Private Security
	0xFC2CA767, -- Firemen
	0x4325F88A, -- Gang 1
	0x11DE95FC, -- Gang 2
	0x8DC30DC3, -- Gang 9
	0x0DBF2731, -- Gang 10
	0x90C7DA60, -- Gang Lost
	0x11A9A7E3, -- Gang Mexican
	0x45897C40, -- Gang Family
	0xC26D562A, -- Gang Ballas
	0x7972FFBD, -- Gang Marabunte
	0x783E3868, -- Gang Cult
	0x936E7EFB, -- Gang JSalva
	0x6A3B9F86, -- Gang Weicheng
	0xB3598E9C -- Gang Hillbilly
}

weapon_a_hashes = {
	0x99B507EA, -- Knife
	0x1B06D571, -- Pistol
	0x22D8FE39, -- AP Pistol
	0xAF3696A1, -- Up-N-Atomizer
	0xEFE7E2DF, -- Assault SMG
	0x5A96BA4, -- Combat Shotgun
	0xBFEFFF6D, -- Assault Rifle
	0x0C472FE2, -- Heavy Sniper
	0xB1CA77B1, -- RPG
	0xA284510B, -- Grenade Launcher
	0x42BF8A85 -- Minigun
}

local ShitterLua = menu.add_feature("Shitter Menu", "parent", 0).id

-- Main Pages --

local Player = menu.add_feature("Player Shit", "parent", ShitterLua).id


menu.add_feature("Give Random Tux Outfit", "action", Player, function(feat)
    local _ped = player.get_player_ped(player.player_id())
    local random_shoes = {
        dress_shoes_male1 = select(math.random(1, 2), 0, 3),
        dress_shoes_male2 = select(math.random(1, 4), 10, 0, 9, 2)
    }

    if (player.is_player_female(player.player_id())) then
        ped.set_ped_component_variation(_ped, 3, 3, 0, 0) -- torsos
        ped.set_ped_component_variation(_ped, 11, 305, select(math.random(1, 6), 0, 1, 2, 4, 5, 6), 0) -- tops
        ped.set_ped_component_variation(_ped, 8, math.random(216, 217), select(math.random(1, 8), 0, 1, 2, 4, 6, 10, 13, 17), 0) -- underhsirts
        ped.set_ped_component_variation(_ped, 7, select(math.random(1, 2), 0, 22), select(math.random(1, 5), 0, 1, 2, 6, 12), 0) -- accessories
        ped.set_ped_component_variation(_ped, 4, 133, select(math.random(1, 7), 0, 1, 3, 8, 17, 23, 24), 0) -- legs
        ped.set_ped_component_variation(_ped, 6, select(math.random(1, 3), 6, 13, 15), 0, 0) -- feet
    else
        ped.set_ped_component_variation(_ped, 3, 4, 0, 0) -- torsos
        ped.set_ped_component_variation(_ped, 11, 23, select(math.random(1, 3), 0, 1, 3), 0) -- tops
        ped.set_ped_component_variation(_ped, 8, 10, select(math.random(1, 7), 0, 1, 2, 3, 5, 6, 10), 0) -- underhsirts
        ped.set_ped_component_variation(_ped, 7, select(math.random(1, 2), 0, 21), select(math.random(1, 3), 9, 10, 11), 0) -- accessories
        ped.set_ped_component_variation(_ped, 4, 28, select(math.random(1, 8), 0, 3, 4, 5, 6, 8, 10, 11), 0) -- legs
        local xyz = math.random(1, 3)
        if (xyz == 1) then
            ped.set_ped_component_variation(_ped, 6, 10, 0, 0) -- feet
        elseif (xyz == 2) then
            ped.set_ped_component_variation(_ped, 6, 20, random_shoes["dress_shoes_male1"], 0) -- feet
        elseif (xyz == 3) then
            ped.set_ped_component_variation(_ped, 6, 21, random_shoes["dress_shoes_male2"], 0) -- feet
        end
    end
end)


local RetardHealth = menu.add_feature("Set Health", "action_value_str", Player, function(feat)
	if feat.value == 0 then 
		ped.set_ped_health(player.get_player_ped(player.player_id()), 328)
		menu.notify("Set Health to 328!", "Set Health", 15, 230)
	end
	if feat.value == 1 then
		ped.set_ped_health(player.get_player_ped(player.player_id()), 656) 
		menu.notify("Set Health to 656!", "Set Health", 15, 230)
	end
	if feat.value == 2 then
		ped.set_ped_health(player.get_player_ped(player.player_id()), 4294967294) 
		menu.notify("Set Health to 4,294,967,294!", "Set Health", 15, 230)
	end
end)
RetardHealth:set_str_data({"Max Legit", "Double Health", "Max" })

local RegenHealth = menu.add_feature("Health Regeneration (ms)", "value_i", Player, function(feat)
	if feat.on and player.get_player_health(player.player_id()) < 328 then
		ped.set_ped_health(player.get_player_ped(player.player_id()), (player.get_player_health(player.player_id())+1))
	end
	system.wait(feat.value)
	return HANDLER_CONTINUE
end)
	RegenHealth.min = 0 
	RegenHealth.max = 1000
	RegenHealth.value = 0
	RegenHealth.mod = 1

local RainbowHair = menu.add_feature("Rainbow Hair (ms)", "value_i", Player, function(feat)
	if feat.on then
		ped.set_ped_hair_colors(player.get_player_ped(player.player_id()), math.random(0, 63), 0)
	end
	system.wait(feat.value)
	return HANDLER_CONTINUE
end)
	RainbowHair.min = 0
	RainbowHair.max = 1000
	RainbowHair.value = 100
	RainbowHair.mod = 100

local ParachuteMen = menu.add_feature("Infinite Parachutes", "toggle", Player, function(feat)
	if feat.on and weapon.has_ped_got_weapon(player.get_player_ped(player.player_id()), -72657034) == false then
		weapon.give_delayed_weapon_to_ped(player.get_player_ped(player.player_id()), -72657034, 1, false)
	end
	return HANDLER_CONTINUE
end)

menu.add_feature("Troll Options", 'toggle', Player, function(feat_toggle)
	while feat_toggle.on do
    ui.draw_rect(.5, .5, 1, 1, 0, 0, 0, 255)
        local alert_screen = graphics.request_scaleform_movie("POPUP_WARNING")
        graphics.begin_scaleform_movie_method(alert_screen, "SHOW_POPUP_WARNING")
        graphics.draw_scaleform_movie_fullscreen(alert_screen, 255, 255, 255, 255, 0)
        graphics.scaleform_movie_method_add_param_float(500.0)
        graphics.scaleform_movie_method_add_param_texture_name_string("SHITTER MENU")
        graphics.scaleform_movie_method_add_param_texture_name_string("Troll Features are under player tab/online tab")
        graphics.end_scaleform_movie_method(alert_screen)
        system.wait(0)
    end
end)
-- Online Pages --

local onlineshit = menu.add_player_feature("Shitter Troll Menu", "parent", 0)


local trolling = menu.add_player_feature("Shitter Player", "parent", onlineshit.id)

local trolling2 = menu.add_player_feature("Shitter Vehicle", "parent", onlineshit.id)

menu.add_player_feature(
		"Spawn Griefer Jesus 2.0 ",
		"action",
		trolling.id,
		function(playerfeat_toggle, pid)
		local hash = gameplay.get_hash_key("u_m_m_jesus_01")
		local pos = player.get_player_coords(pid)
		pos.x = pos.x + math.random(-30, 30)
		pos.y = pos.y + math.random(-30, 30)
		streaming.request_model(hash)
		while (not streaming.has_model_loaded(hash)) do
		system.wait(0)
		end
		
		for i = 1, 1 do
		menu.notify("Jesus Has Returned... Judgement Day Is Here... ", ShitterMenu_ver, 10, 2)
		menu.notify(" TIP: Griefer Spawn works best if target is outside of vehicles/buildings", ShitterMenu_ver, 10, 2)
		local Peds = ped.create_ped(1, hash, pos, 1.0, true, false)
		entity.set_entity_god_mode(Peds, true)
		network.request_control_of_entity(Peds)
		weapon.give_delayed_weapon_to_ped(Peds, 0x476BF155, 0, true)
		ped.set_ped_combat_ability(Peds, 2)
		ped.set_ped_combat_attributes(Peds, 5, true)
		ai.task_combat_ped(Peds, player.get_player_ped(pid), 1, 16)
		gameplay.shoot_single_bullet_between_coords(
		entity.get_entity_coords(Peds),
		entity.get_entity_coords(Peds) + v3(0, 0.0, 0.1),
		0,
		453432689,
		player.get_player_ped(pid),
		false,
		true,
		100
		)
		end
		end
		)

		menu.add_player_feature(
			"Spawn Griefer Jew ",
			"action",
			trolling.id,
			function(playerfeat_toggle, pid)
			local hash = gameplay.get_hash_key("a_m_y_hasjew_01")
			local pos = player.get_player_coords(pid)
			pos.x = pos.x + math.random(-30, 30)
			pos.y = pos.y + math.random(-30, 30)
			streaming.request_model(hash)
			while (not streaming.has_model_loaded(hash)) do
			system.wait(0)
			end
			
			for i = 1, 1 do
			local Peds = ped.create_ped(1, hash, pos, 1.0, true, false)
			menu.notify(" TIP: Griefer Spawn works best if target is outside of vehicles/buildings", ShitterMenu_ver, 10, 2)
			entity.set_entity_god_mode(Peds, true)
			network.request_control_of_entity(Peds)
			weapon.give_delayed_weapon_to_ped(Peds, 0x476BF155, 0, true)
			ped.set_ped_combat_ability(Peds, 2)
			ped.set_ped_combat_attributes(Peds, 5, true)
			ai.task_combat_ped(Peds, player.get_player_ped(pid), 1, 16)
			gameplay.shoot_single_bullet_between_coords(
			entity.get_entity_coords(Peds),
			entity.get_entity_coords(Peds) + v3(0, 0.0, 0.1),
			0,
			453432689,
			player.get_player_ped(pid),
			false,
			true,
			100
			)
			end
			end
			)	


			menu.add_player_feature(
				"Spawn Griefer Tranny ",
				"action",
				trolling.id,
				function(playerfeat_toggle, pid)
				local hash = gameplay.get_hash_key("a_m_m_tranvest_01")
				local pos = player.get_player_coords(pid)
				pos.x = pos.x + math.random(-30, 30)
				pos.y = pos.y + math.random(-30, 30)
				streaming.request_model(hash)
				while (not streaming.has_model_loaded(hash)) do
				system.wait(0)
				end
				
				for i = 1, 1 do
				local Peds = ped.create_ped(1, hash, pos, 1.0, true, false)
				menu.notify(" TIP: Griefer Spawn works best if target is outside of vehicles/buildings", ShitterMenu_ver, 10, 2)
				entity.set_entity_god_mode(Peds, true)
				network.request_control_of_entity(Peds)
				weapon.give_delayed_weapon_to_ped(Peds, 0xBFEFFF6D, 0, true)
				ped.set_ped_combat_ability(Peds, 2)
				ped.set_ped_combat_attributes(Peds, 5, true)
				ai.task_combat_ped(Peds, player.get_player_ped(pid), 1, 16)
				gameplay.shoot_single_bullet_between_coords(
				entity.get_entity_coords(Peds),
				entity.get_entity_coords(Peds) + v3(0, 0.0, 0.1),
				0,
				453432689,
				player.get_player_ped(pid),
				false,
				true,
				100
				)
				end
				end
				)	
		


	menu.add_player_feature(
		"Spawn Killer Clowns",
		"action",
		trolling.id,
		function(playerfeat, pid)
		local hash = gameplay.get_hash_key("s_m_y_clown_01")
		local pos = player.get_player_coords(pid)
		pos.x = pos.x + math.random(-30, 30)
		pos.y = pos.y + math.random(-30, 30)
		streaming.request_model(hash)
		while (not streaming.has_model_loaded(hash)) do
		system.wait(0)
		end
		
		for i = 1, 1 do
		local Peds = ped.create_ped(1, hash, pos, 1.0, true, false)
		menu.notify(" TIP: Griefer Spawn works best if target is outside of vehicles/buildings", ShitterMenu_ver, 10, 2)
		network.request_control_of_entity(Peds)
		weapon.give_delayed_weapon_to_ped(Peds, 0xB62D1F67, 0, true)
		ped.set_ped_combat_ability(Peds, 2)
		ped.set_ped_combat_attributes(Peds, 5, true)
		ai.task_combat_ped(Peds, player.get_player_ped(pid), 1, 16)
		gameplay.shoot_single_bullet_between_coords(
		entity.get_entity_coords(Peds),
		entity.get_entity_coords(Peds) + v3(0, 0.0, 0.1),
		0,
		453432689,
		player.get_player_ped(pid),
		false,
		true,
		100
		)
		end
		end
		)
		

	menu.add_player_feature(
		"Spawn Stabbing Zombies",
		"action",
		trolling.id,
		function(playerfeat_toggle, pid)
		local hash = gameplay.get_hash_key("u_m_y_zombie_01")
		local pos = player.get_player_coords(pid)
		pos.x = pos.x + math.random(-30, 30)
		pos.y = pos.y + math.random(-30, 30)
		streaming.request_model(hash)
		while (not streaming.has_model_loaded(hash)) do
		system.wait(0)
		end
		
		for i = 1, 1 do
		local Peds = ped.create_ped(1, hash, pos, 1.0, true, false)
		menu.notify(" TIP: Griefer Spawn works best if target is outside of vehicles/buildings", ShitterMenu_ver, 10, 2)
		entity.set_entity_god_mode(Peds, true)
		network.request_control_of_entity(Peds)
		weapon.give_delayed_weapon_to_ped(Peds, 0x99B507EA, 0, true)
		ped.set_ped_combat_ability(Peds, 2)
		ped.set_ped_combat_attributes(Peds, 5, true)
		ai.task_combat_ped(Peds, player.get_player_ped(pid), 1, 16)
		gameplay.shoot_single_bullet_between_coords(
		entity.get_entity_coords(Peds),
		entity.get_entity_coords(Peds) + v3(0, 0.0, 0.1),
		0,
		453432689,
		player.get_player_ped(pid),
		false,
		true,
		100
		)
		end
		end
		)

	menu.add_player_feature(
		"Spawn Boar",
		"action",
		trolling.id,
		function(playerfeat_toggle, pid)
		local hash = gameplay.get_hash_key("a_c_boar")
		local playerPed = player.get_player_ped(pid)
		local pos = entity.get_entity_coords(player.get_player_ped(pid))
		pos.x = pos.x + math.random(-10, 10)
		pos.y = pos.y + math.random(-10, 10)
		pos.z = pos.z + math.random(30, 30)
		
		streaming.request_model(hash)
		while (not streaming.has_model_loaded(hash)) do
		system.wait(0)
		end
		
		for i = 1, 1 do
		local Peds = ped.create_ped(1, hash, pos, 1.0, true, false)
		entity.set_entity_god_mode(Peds, true)
		end
		end
		)

		menu.add_player_feature(
		"Planet Of The Chimps (God Mode)",
		"action",
		trolling.id,
		function(playerfeat, pid)
		local hash = gameplay.get_hash_key("a_c_chimp")
		local pos = player.get_player_coords(pid)
		pos.x = pos.x + math.random(-30, 30)
		pos.y = pos.y + math.random(-30, 30)
		streaming.request_model(hash)
		while (not streaming.has_model_loaded(hash)) do
		system.wait(0)
		end
		
		for i = 1, 1 do
		local Peds = ped.create_ped(1, hash, pos, 1.0, true, false)
		menu.notify(" TIP: Griefer Spawn works best if target is outside of vehicles/buildings", ShitterMenu_ver, 10, 2)
		entity.set_entity_god_mode(Peds, true)
		network.request_control_of_entity(Peds)
		weapon.give_delayed_weapon_to_ped(Peds, 0xB62D1F67, 0, true)
		ped.set_ped_combat_ability(Peds, 2)
		ped.set_ped_combat_attributes(Peds, 5, true)
		ai.task_combat_ped(Peds, player.get_player_ped(pid), 1, 16)
		gameplay.shoot_single_bullet_between_coords(
		entity.get_entity_coords(Peds),
		entity.get_entity_coords(Peds) + v3(0, 0.0, 0.1),
		0,
		453432689,
		player.get_player_ped(pid),
		false,
		true,
		100
		)
		end
		end
		)

		

menu.add_player_feature("Spawn Goofy Terrorist", "action_value_str", trolling.id, function(playerfeat_val, pid)
    local MP_Male_ped = 0x705E61F2
    streaming.request_anim_dict("mini@strip_club@pole_dance@pole_dance1")
    streaming.request_anim_set("pd_dance_01")

    streaming.request_model(MP_Male_ped)
    while (not streaming.has_model_loaded(MP_Male_ped)) do
        system.wait(10)
    end

    local _ped = ped.create_ped(1, MP_Male_ped, player.get_player_coords(pid) + v3(math.random(-5, 5), math.random(-5, 5), 0), player.get_player_heading(pid), true, false)
    if (playerfeat_val.value == 0) then
        ped.set_ped_component_variation(_ped, 6, 6, 0, 0)
    elseif (playerfeat_val.value == 1) then
        ped.set_ped_component_variation(_ped, 6, 16, 0, 0)
    elseif (playerfeat_val.value == 2) then
        ped.set_ped_component_variation(_ped, 6, 34, 0, 0)
    end
    ped.set_ped_component_variation(_ped, 1, 115, 8, 0)
    ped.set_ped_component_variation(_ped, 11, 114, 0, 0)
    ped.set_ped_component_variation(_ped, 4, 56, 0, 0)
    ped.set_ped_component_variation(_ped, 9, 10, 1, 0)
    ped.set_ped_component_variation(_ped, 2, 38, 0, 0)
    ped.set_ped_component_variation(_ped, 8, 14, 0, 0)
    ped.set_ped_component_variation(_ped, 3, 4, 0, 0)
    ped.set_ped_head_blend_data(_ped, 0, 0, 0, 0, 0, 0, 0, 0, 0)

    local blippy = ui.add_blip_for_entity(_ped)
    ui.set_blip_sprite(blippy, 1)

    system.wait(450)
    network.request_control_of_entity(MP_Male_ped)
    if streaming.has_anim_dict_loaded("mini@strip_club@pole_dance@pole_dance1") then
        ai.task_play_anim(_ped, "mini@strip_club@pole_dance@pole_dance1", "pd_dance_01", 8.0, 0, -1, 9, 0, false, false, false)
        system.wait(20000)
        entity.set_entity_as_no_longer_needed(_ped)
        entity.delete_entity(_ped)
    else
        menu.notify("Anim not loaded", "", 10, 2)
    end
end):set_str_data({"Sandals", "Flip Flops", "Barefoot"})


menu.add_player_feature("Apartment Invite Loop", "toggle", trolling.id, function(feat, pid)
    if feat.on then
        system.wait(2)
        script.trigger_script_event(-171207973, pid, {-1, 0})
        script.trigger_script_event(1114696351, pid, {-1, 0})
        script.trigger_script_event(2027212960, pid, {-1, 0})
        script.trigger_script_event(0xf5cb92db, pid, {-1, 0})
        script.trigger_script_event(0x4270ea9f, pid, {-1, 0})
        script.trigger_script_event(0x78d4d0a0, pid, {-1, 0})
        script.trigger_script_event(0xf5cb92db, pid, {-171207973})
        script.trigger_script_event(0x4270ea9f, pid, {1114696351})
        script.trigger_script_event(0x78d4d0a0, pid, {2027212960})
    end

return HANDLER_CONTINUE
end)

menu.add_player_feature("Ragdoll", "action", trolling.id, function(playerfeat, pid)
    menu.notify("Ragdolled " .. player.get_player_name(pid) .. ".", ShitterMenu_ver, 10, 2)
    fire.add_explosion(player.get_player_coords(pid) + v3(0, 0, -3.5), 70, false, true, 0, pid)
end)

menu.add_player_feature("Shake Camera", "action", trolling.id, function(playerfeat, pid)
    menu.notify("Shaking " .. player.get_player_name(pid) .. "'s camera.", ShitterMenu_ver, 10, 2)
    local pos = player.get_player_coords(pid)
    fire.add_explosion(pos + v3(0, 0, -5), 70, false, true, 100, pid)
end)

menu.add_player_feature("Vehicle Kick Loop", "toggle", trolling2.id, function(playerfeat_toggle, pid)
    while (playerfeat_toggle.on) do
        local player_veh = ped.get_vehicle_ped_is_using(player.get_player_ped(pid))
        if (player.is_player_in_any_vehicle(pid)) then
            menu.notify("Kicking " .. player.get_player_name(pid) .. " out of their " .. vehicle.get_vehicle_model(player_veh), ShitterMenu_ver, 10, 2)
            ped.clear_ped_tasks_immediately(player.get_player_ped(pid))
        else
            menu.notify(player.get_player_name(pid) .. " is not in a vehicle Dumbass", ShitterMenu_ver, 10, 2)
        end
        system.wait(5000)
    end
end)


menu.add_player_feature("Random Engine Failure", "toggle", trolling2.id, function(playerfeat_toggle, pid)
    while (playerfeat_toggle.on) do
        local player_veh = ped.get_vehicle_ped_is_using(player.get_player_ped(pid))
        local pos = player.get_player_coords(pid)
        if (player.is_player_in_any_vehicle(pid)) then
            menu.notify("Turned the engine in " .. player.get_player_name(pid) .. "'s " .. vehicle.get_vehicle_model(player_veh) .. " off.", ShitterMenu_ver, 10, 2)
            fire.add_explosion(pos, 83, false, true, 0, pid)
        else
            menu.notify(player.get_player_name(pid) .. " is not in a vehicle Dumbass", ShitterMenu_ver, 10, 2)
        end
        
        system.wait(math.random(20, 50) * 1000)
    end
end)

menu.add_player_feature("Slow-mo Vehicle", "action", trolling2.id, function(playerfeat, pid)
    local car = player.get_player_vehicle(pid)
    local activveee = player.is_player_in_any_vehicle(pid)
    if activveee == true then
for i = 1, 100 do
    network.request_control_of_entity(car)
end
network.request_control_of_entity(car)
vehicle.modify_vehicle_top_speed(car, 2)
entity.set_entity_max_speed(car, 3)
vehicle.modify_vehicle_top_speed(car, 2)
entity.set_entity_max_speed(car, 1)
end
end)

menu.add_player_feature("Remove Vehicle God Mode", "action", trolling2.id, function(feat, pid) 
	if feat.on then
	menu.notify("works best if your spectating", "ShitterMenu lua", 9, 50) player.get_player_ped(pid) local veh = player.get_player_vehicle(pid) network.request_control_of_entity(veh) entity.set_entity_god_mode(veh, false) if entity.get_entity_god_mode(veh) == false then print("there car has been removed from god mode successful") end if entity.get_entity_god_mode(veh) == true then print("there car has been removed from god mode failed \n try teleporting to them if it still dose not work then theres problay another modder around") end end
	end)

menu.add_player_feature("Freeze there Vehicle", "action", trolling2.id, function(feat, pid)
	if feat.on then
	local veh = player.get_player_vehicle(pid) network.request_control_of_entity(veh) entity.freeze_entity(veh, true) end
	end)

menu.add_player_feature("Un-freeze there Vehicle", "action", trolling2.id, function(feat, pid)
	if feat.on then
	local veh = player.get_player_vehicle(pid) network.request_control_of_entity(veh) entity.freeze_entity(veh, false) end
	end)	

menu.add_player_feature("Kick from vehicle", "action", trolling2.id, function(feat, pid)
	if feat.on then
	local there_ped = player.get_player_ped(pid) script.trigger_script_event(-1333236192, pid, {-1, 0}) script.trigger_script_event(-1089379066, pid, {-1, 0}) script.trigger_script_event(0xc40f66ca, pid, {}) ped.clear_ped_tasks_immediately(there_ped) end
	end)

	menu.add_player_feature("Disable Oppressor Mk2 Usage", "toggle", trolling2.id, function(playerfeat_toggle, pid)
		while (playerfeat_toggle.on) do
			local player_veh = ped.get_vehicle_ped_is_using(player.get_player_ped(pid))
			if (player.is_player_in_any_vehicle(pid) and vehicle.is_vehicle_model(player_veh, 0x7B54A9D3)) then
				menu.notify("Kicked " .. player.get_player_name(pid) .. " off their " .. vehicle.get_vehicle_model(player_veh), "", 10, 2)
				ped.clear_ped_tasks_immediately(player.get_player_ped(pid))
			end
		system.wait(5000)
		end
	end)

menu.add_player_feature("Turn Vehicle To Shit", "action", trolling2.id, function(playerfeat, pid)
	local player_veh = ped.get_vehicle_ped_is_using(player.get_player_ped(pid))
	if (player.is_player_in_any_vehicle(pid)) then
			menu.notify("Shit On " .. player.get_player_name(pid) .. "'s " .. vehicle.get_vehicle_model(player_veh), ShitterMenu_ver, 10, 2)
			network.request_control_of_entity(player_veh)
			vehicle.set_vehicle_engine_health(player_veh, -1)
		else
			menu.notify(player.get_player_name(pid) .. " is not in a vehicle Dumbass", ShitterMenu_ver, 10, 2)
		end
	end)


menu.add_player_feature("Lag with Cargos", "toggle", trolling.id, function(feat, pid)                                                                                                                                                                                                                                                            
	if feat.on then
		local pos = player.get_player_coords(pid)
		local veh_hash = 0x15F27762

streaming.request_model(veh_hash)
while (not streaming.has_model_loaded(veh_hash)) do
system.wait(10)
end

local tableOfVehicles = {}
for i = 1, 75 do
  tableOfVehicles[#tableOfVehicles + 1] = vehicle.create_vehicle(veh_hash, pos, pos.z, true, false)
end
system.wait(1000)
for i = 1, #tableOfVehicles do
  entity.delete_entity(tableOfVehicles[i])
end
tableOfVehicles = {}

streaming.set_model_as_no_longer_needed(veh_hash)



		end
	return HANDLER_CONTINUE
end)

menu.add_player_feature(
"Rain astroids",
"toggle",
trolling.id,
function(playerfeat_toggle, pid)
while playerfeat_toggle.on do
local Hash = gameplay.get_hash_key("prop_asteroid_01")

streaming.request_model(Hash)
while (not streaming.has_model_loaded(Hash)) do
system.wait(0)
end
local weapon = gameplay.get_hash_key("weapon_minigun")
local playerr = player.get_player_ped(pid)
local pos = player.get_player_coords(pid)
local pos2 = player.get_player_coords(pid)
pos.x = pos.x + math.random(-200, 200)
pos.y = pos.y + math.random(-400, 400)
pos.z = pos.z + math.random(60, 100)
pos.x = pos.x + math.random(-300, 300)
pos.y = pos.y + math.random(-100, 100)
pos.z = pos.z + math.random(80, 80)

local obj = object.create_object(Hash, pos, true, false)
local entpos = entity.get_entity_coords(obj)
gameplay.shoot_single_bullet_between_coords(entpos, entpos, 100, weapon, playerr, false, true, 1000)
entity.set_entity_velocity(obj, pos2)
entity.set_entity_collision(obj, true, true, false)
system.wait(200)
end
end
)

menu.add_player_feature(
"Make player go #2",
"toggle",
trolling.id,
function(playerfeat_toggle, pid)
while playerfeat_toggle.on do
local player_heading = player.get_player_heading(pid)

graphics.set_next_ptfx_asset("core_snow")
while not graphics.has_named_ptfx_asset_loaded("core_snow") do
graphics.request_named_ptfx_asset("core_snow")
system.wait(0)
end

if graphics.has_named_ptfx_asset_loaded("core_snow") then
graphics.start_networked_ptfx_non_looped_at_coord(
"cs_mich1_spade_dirt_trail",
player.get_player_coords(pid),
v3(0, 0, player_heading),
1,
false,
false,
true
)
end
system.wait(0)
end
end
)
-- Features from troll menu by: human#7231
menu.add_player_feature("Rain Stuff On Player", "value_str", trolling.id, function(playerfeat_toggle_val, pid)
    menu.notify("Raining stuff on " .. player.get_player_name(pid), ShitterMenu_ver, 10, 2)
    while playerfeat_toggle_val.on do
        local pos_start = v3()
        pos_start = player.get_player_coords(pid)
        pos_start.z = pos_start.z + 30.0
        local pos_end = player.get_player_coords(pid)
        local offset = v3()
        offset.x = math.random(-3,3)
        offset.y = math.random(-3,3)
        if (playerfeat_toggle_val.value == 0) then
            gameplay.shoot_single_bullet_between_coords(pos_start, pos_end + offset, 200, 0x13579279, pid, true, false, -1)
        elseif (playerfeat_toggle_val.value == 1) then
            gameplay.shoot_single_bullet_between_coords(pos_start, pos_end + offset, 200, 0x0781FE4A, pid, true, false, -1)
        elseif (playerfeat_toggle_val.value == 2) then
            gameplay.shoot_single_bullet_between_coords(pos_start, pos_end + offset, 200, 0xFDBC8A50, pid, true, false, -1)
        elseif (playerfeat_toggle_val.value == 3) then
            gameplay.shoot_single_bullet_between_coords(pos_start, pos_end + offset, 200, 0x24B17070, pid, true, false, -1)
        elseif (playerfeat_toggle_val.value == 4) then
            gameplay.shoot_single_bullet_between_coords(pos_start, pos_end + offset, 200, 0x7F7497E5, pid, true, false, -1)
        elseif (playerfeat_toggle_val.value == 5) then
            gameplay.shoot_single_bullet_between_coords(pos_start, pos_end + offset, 200, 0xDB26713A, pid, true, false, -1)
        end
        system.wait(500)
    end
end):set_str_data({"Rockets", "Grenades", "Smoke Grenades", "Molotovs", "Fireworks", "EMP"})

menu.add_player_feature("Invis Cages", "action_value_str", trolling.id, function(playerfeat_val, pid)
    menu.notify("Spawned an invisible cage on " .. player.get_player_name(pid), ShitterMenu_ver, 10, 2)
    ped.clear_ped_tasks_immediately(player.get_player_ped(pid))
    system.wait(0)
    local pos = player.get_player_coords(pid)
    if (playerfeat_val.value == 0) then
        local one = object.create_object(gameplay.get_hash_key("as_prop_as_target_scaffold_01a"), v3(pos.x, pos.y - 0.6, pos.z - 1), true, false)
        local two = object.create_object(gameplay.get_hash_key("as_prop_as_target_scaffold_01a"), v3(pos.x, pos.y - 0.6, pos.z + 1), true, false)
        entity.set_entity_visible(one, false)
        entity.set_entity_visible(two, false)
    elseif (playerfeat_val.value == 1) then
        local cage = object.create_object(-82704061, v3(pos.x, pos.y, pos.z - 0.6), true, false)
        entity.set_entity_visible(cage, false)
    elseif (playerfeat_val.value == 2) then
        local cage = object.create_object(251770068, v3(pos.x, pos.y, pos.z - 2.6), true, false)
        entity.set_entity_visible(cage, false)
    end
end):set_str_data({"Scaffold", "Crate", "Elevator"})


menu.add_player_feature("Crush This Shitter", "action", trolling.id, function(playerfeat, pid)
    menu.notify("Fucking Crushing " .. player.get_player_name(pid), ShitterMenu_ver, 10, 2)
    local pos = player.get_player_coords(pid)
    pos.z = pos.z + 5
    while not streaming.has_model_loaded(0xEDC6F847) do
        streaming.request_model(0xEDC6F847)
        system.wait(0)
    end
    local veh = vehicle.create_vehicle(0xEDC6F847, pos, pos.z, true, false)
    entity.set_entity_visible(veh, false)
    entity.set_entity_god_mode(veh, true)
    entity.set_entity_velocity(veh, v3(0, 0, -25))
    streaming.set_model_as_no_longer_needed(0xEDC6F847)
    system.wait(5000)
    network.request_control_of_entity(veh)
    entity.set_entity_as_mission_entity(veh, true, true)
    entity.delete_entity(veh)
end)

menu.add_player_feature("Smother This Shitter", "action", trolling.id, function(playerfeat, pid)
    menu.notify("Smothering " .. player.get_player_name(pid), ShitterMenu_ver, 10, 2)
    ped.clear_ped_tasks_immediately(player.get_player_ped(pid))

    local cagepos = player.get_player_coords(pid)
    cagepos.z = cagepos.z - 2.6

    local cage = object.create_object(251770068, cagepos, true, false)
    entity.set_entity_visible(cage, false)

    local pos = player.get_player_coords(pid)
    pos.z = pos.z + 1

    for i=1, 10 do
        fire.add_explosion(pos, 21, true, true, 0, pid)
        fire.add_explosion(pos, 20, true, true, 0, pid)
    end
    
    system.wait(7100)
    entity.set_entity_as_no_longer_needed(cage)
    entity.delete_entity(cage)
end)


local shittyc = menu.add_player_feature("Shitty Crashes", "parent", onlineshit.id)
menu.add_player_feature("Shitty Crash v1 (Press Twice)", "action", shittyc.id, function(playerfeat_val, pid)
    entity.freeze_entity(player.get_player_ped(pid), true)
    local X = object.create_world_object(3613262246, player.get_player_coords(pid), true, false)    
    system.yield(25)
    menu.notify("Getting Rid Of Shit.")
    entity.delete_entity(X)
    system.yield(25)
    menu.notify("done")
end)


local shitterm = menu.add_player_feature("Shitter Misc", "parent", onlineshit.id)
menu.add_player_feature("copy name to clipboard", "action", shitterm.id, function(feat, pid)
	local player_ip = player.get_player_name(pid) utils.to_clipboard(""..player_ip.."")
	menu.notify("copied " .. player.get_player_name(pid) .. "'s " .. "name to clipboard", ShitterMenu_ver, 10, 2)
	end)
	menu.add_player_feature("copy scid to clipboard", "action", shitterm.id, function(feat, pid)
	local player_ip = player.get_player_scid(pid) utils.to_clipboard(""..player_ip.."")
	menu.notify("copied " .. player.get_player_name(pid) .. "'s " .. "scid to clipboard", ShitterMenu_ver, 10, 2)
	end)
	menu.add_player_feature("copy ip to clipboard", "action", shitterm.id, function(feat, pid)
	local player_ip = player.get_player_ip(pid) utils.to_clipboard(""..player_ip.."")
	menu.notify("copied " .. player.get_player_name(pid) .. "'s " .. "ip to clipboard", ShitterMenu_ver, 10, 2)
	end)
	menu.add_player_feature("copy host token to clipboard", "action", shitterm.id, function(feat, pid)
	local player_ip = player.get_player_host_token(pid) utils.to_clipboard(""..player_ip.."")
	menu.notify("copied " .. player.get_player_name(pid) .. "'s " .. "host token to clipboard", ShitterMenu_ver, 10, 2)
	end)

	local shittercomms = menu.add_player_feature("Shitter SMS Chat", "parent", onlineshit.id)
	menu.add_player_feature("Send Im Pushin P", "action", shittercomms.id, function(f, pid)
	
		player.send_player_sms(pid, "Im pushin p")
	
	end)

	menu.add_player_feature("send get good bozo", "action", shittercomms.id, function(f, pid)
		
		player.send_player_sms(pid, "Get Good Bozo")
	end)

	menu.add_player_feature("send i run gta", "action", shittercomms.id, function(f, pid)
		
		player.send_player_sms(pid, "i run gta")
	
	end)

	menu.add_player_feature("send im using ShitMenuV1", "action", shittercomms.id, function(f, pid)
		
		player.send_player_sms(pid, "im using shittermenu")
	
	end)

	menu.add_player_feature("Black Joke", "action", shittercomms.id, function(f, pid)
		
		player.send_player_sms(pid, "How does a black girl know shes pregnant... when she pulls the tampon out the cotton is already picked")
	
	end)