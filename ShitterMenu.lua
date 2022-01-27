
-- READ BELOW --

-- CREDITS TO UPTOWN LUA & TOLLING LUA , human#7231
-- Combined/edited scripts from some of my fav luas and made my own.

-- much love, Braandon#0001

-- myped = player.get_player_ped(player.player_id()),
-- mypid = player.player_id(),
-- mygun = ped.get_current_ped_weapon(player.get_player_ped(player.player_id())),
-- myveh = ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())),
-- myaim = entity.get_entity_coords(player.get_entity_player_is_aiming_at(player.player_id()))
-- deathcheck = entity.is_entity_dead(player.get_player_ped(player.player_id()))
function loaded()
    menu.notify("Welcome to Shitter Menu, " .. player.get_player_name(player.player_id()) .. "Check Online Tab for more features!", ShitterMenu_ver, 10, 2)
end
loaded()

function loaded()
    menu.notify("V1 LOADED! made by Braandon#0001", ShitterMenu_ver, 10, 2)
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
local Vehicles = menu.add_feature("Vehicle Shit", "parent", ShitterLua).id
local Weapons = menu.add_feature("Weapon Shit", "parent", ShitterLua).id
local Entity = menu.add_feature("Entity Shit", "parent", ShitterLua).id
local Disables = menu.add_feature("UI Shit", "parent", ShitterLua).id


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


local Torque = menu.add_feature("Torque Modifier", "value_f", Vehicles, function(feat)
	if feat.on then
		vehicle.set_vehicle_engine_torque_multiplier_this_frame(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())), feat.value)
	end
	return HANDLER_CONTINUE
end)
	Torque.min = 0
	Torque.max = 100
	Torque.mod = 1
	Torque.value = 0

local LowSpeed = menu.add_feature("Set Low Rider Speed", "toggle", Vehicles, function(feat)
	if feat.on then
		entity.set_entity_max_speed(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())), 17.40)
	else
		entity.set_entity_max_speed(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())), 540)
	end
end)

local TopSpeed = menu.add_feature("Disable Top Speed", "toggle", Vehicles, function(feat)
	if feat.on then
		entity.set_entity_max_speed(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())), 2147483646)
	else
		entity.set_entity_max_speed(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())), 540)
	end
end)

local VehicleTraction = menu.add_feature("Slide Like A MF", "toggle", Vehicles, function(feat)
	if feat.on then
		vehicle.set_vehicle_reduce_grip(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())), true)
	else
	    vehicle.set_vehicle_reduce_grip(ped.get_vehicle_ped_is_using(player.get_player_ped(player.player_id())), false)
	end
	return	HANDLER_CONTINUE
end)


local GiveBasedGuns menu.add_feature("Give Basic Loadout", "action", Weapons, function(feat)
	if feat.on then
		for a=1, #weapon_g_hashes do
			weapon.give_delayed_weapon_to_ped(player.get_player_ped(player.player_id()), weapon_g_hashes[a], 2, false)
		end		
	end
	return	HANDLER_CONTINUE	
end)	

local RemoveGayGuns menu.add_feature("Remove Clutter Weapons", "action", Weapons, function(feat)
	if feat.on then
		for a=1, #weapon_r_hashes do
			weapon.remove_weapon_from_ped(player.get_player_ped(player.player_id()), weapon_r_hashes[a])
		end		
	end
	return	HANDLER_CONTINUE	
end)

local RainbowWeapon = menu.add_feature("Rainbow Weapon (ms)", "value_i", Weapons, function(feat)
    if feat.on and not entity.is_entity_dead(player.get_player_ped(player.player_id())) then
        weapon.set_ped_weapon_tint_index(player.get_player_ped(player.player_id()),
        ped.get_current_ped_weapon(player.get_player_ped(player.player_id())),
        math.random(0, weapon.get_weapon_tint_count(ped.get_current_ped_weapon(player.get_player_ped(player.player_id()))
                )
            )
        )
    end
    system.wait(feat.value)
    return HANDLER_CONTINUE
end)
	RainbowWeapon.min = 0
	RainbowWeapon.max = 1000
	RainbowWeapon.value = 100
	RainbowWeapon.mod = 100

local EntityMan = menu.add_feature("Entity Class", "autoaction_value_str", Entity, function(feat)
    if feat.value == 0 then
        menu.notify("Set entity group to Peds", "Entity Manager", 5, 230)
    end
    if feat.value == 1 then
        menu.notify("Set entity group to Vehicles", "Entity Manager", 5, 230)
    end
    if feat.value == 2 then 
        menu.notify("Set entity group to Objects", "Entity Manager", 5, 230)
    end
end)
      EntityMan:set_str_data({"Peds", "Vehicles", "Objects"})

local EntitySettings = menu.add_feature("Settings", "parent", Entity).id

local ESExplosion = menu.add_feature("Explosion Settings", "parent", EntitySettings).id

local ExpInvisible = false
local ExpAudible = true

local ExpShake = menu.add_feature("Camera Shake", "autoaction_value_i", ESExplosion, function(feat)
end)
	ExpShake.min = 0
	ExpShake.max = 1000
	ExpShake.value = 0
	ExpShake.mod = 10

local ExpAud = menu.add_feature("Silent Explosion", "toggle", ESExplosion, function(feat)
		if feat.on then
		ExpAudible = false
	else
		ExpAudible = true
	end
end)

local ExpVis = menu.add_feature("Invisible Explosion", "toggle", ESExplosion, function(feat)
	if feat.on then
		ExpInvisible = true
	else
		ExpInvisible = false
	end
end)

local WSDelay = menu.add_feature("Ped State Refresh Rate", "autoaction_value_i", EntitySettings, function(feat)
end)
	WSDelay.min = 5000
	WSDelay.max = 25000
	WSDelay.value = 15000
	WSDelay.mod = 250

local EntityTP = menu.add_feature("Teleport To Me", "action", Entity, function(feat)

mypos = player.get_player_coords(player.player_id())
mypos2 = mypos
distance = 5
mypos2.x = mypos2.x - (math.sin((player.get_player_heading(player.player_id())/57.2958)))*distance
mypos2.y = mypos2.y + (math.cos((player.get_player_heading(player.player_id())/57.2958)))*distance
	menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)
	if EntityMan.value == 0 then
		ped_table = ped.get_all_peds()
		pedcount = #ped_table
		for a=1, pedcount do
			if not ped.is_ped_a_player(ped_table[a]) then
				ReqControl(ped_table[a])
				entity.set_entity_coords_no_offset(ped_table[a], v3(mypos2.x+math.random(-2,2), mypos2.y+math.random(-2,2), MyCoords().z))
			end
		end
	end
	
	if EntityMan.value == 1 then 
		veh_table = vehicle.get_all_vehicles()
		vehcount = #veh_table
		for a=1, vehcount do
			while(entity.is_entity_dead(veh_table[a]) and a < vehcount) do
   			a = a+1
   			end
			if not IsaPlayerVehicle(veh_table[a]) then 
				ReqControl(veh_table[a])
				entity.set_entity_coords_no_offset(veh_table[a], v3(MyCoords().x+math.random(-12, 12), MyCoords().y+math.random(-12, 12), MyCoords().z))
			end
		end
	end

	if EntityMan.value == 2 then 
	obj_table = object.get_all_objects()
	objcount = #obj_table
		for a=1, objcount do
			ReqControl(obj_table[a])
			entity.set_entity_coords_no_offset(obj_table[a], v3(mypos2.x+math.random(-5,5), mypos2.y+math.random(-5,5), MyCoords().z))
		end
	end
	menu.notify("Done.", "Entity Manager", 5, 230)
end)

local EntityPS = menu.add_feature("Player State", "value_str", Entity, function(feat)
if feat.value == 0 then
	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
		for a=1, pedcount do
			while(entity.is_entity_dead(ped_table[a]) and a < pedcount and entity.is_entity_dead(ped_table[a]) and a < pedcount) do
		   	a = a+1
		    end	
		     	if feat.on then
		     		for a=1, #ped_g_hash do
		    		ReqControl(ped_table[a])
					ped.set_relationship_between_groups(0, ped_g_hash[a], ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())))
					ped.set_relationship_between_groups(0, ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())), ped_g_hash[a])
		    	end
		    end
		end
	end
end
if feat.value == 1 then
	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
		for a=1, pedcount do
			while(entity.is_entity_dead(ped_table[a]) and a < pedcount and entity.is_entity_dead(ped_table[a]) and a < pedcount) do
		   	a = a+1
		    end	
		     	if feat.on then
		     		for a=1, #ped_g_hash do
		    		ReqControl(ped_table[a])
					weapon.give_delayed_weapon_to_ped(ped_table[a], weapon_a_hashes[math.random(1, #weapon_a_hashes)], 1, true)
					ped.set_relationship_between_groups(5, ped_g_hash[a], ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())))
					ped.set_relationship_between_groups(5, ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())), ped_g_hash[a])
		    	end
		    end
		end
	end
end
if feat.value == 2 then
	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
		for a=1, pedcount do
			while(entity.is_entity_dead(ped_table[a]) and a < pedcount and entity.is_entity_dead(ped_table[a]) and a < pedcount) do
		   	a = a+1
		    end	
		     	if feat.on then   
		     		for a=1, #ped_g_hash do		
		    		ReqControl(ped_table[a])
		    		ped.clear_ped_tasks_immediately(ped_table[a])
					ped.clear_relationship_between_groups(ped_g_hash[a], ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())))
					ped.clear_relationship_between_groups(ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())), ped_g_hash[a])
					ped.set_relationship_between_groups(255, ped_g_hash[a], ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())))
					ped.set_relationship_between_groups(255, ped.get_ped_relationship_group_hash(player.get_player_ped(player.player_id())), ped_g_hash[a])
		    	end
		    end
		end
	end
end
system.wait(WSDelay.value)
return HANDLER_CONTINUE	
end)
EntityPS:set_str_data({"Ignore Player", "Attack Player", "Reset"})

local EntityWS = menu.add_feature("World State", "value_str", Entity, function(feat)
	if feat.on and feat.value == 0 then
		if EntityMan.value == 0 then
			ped_table = ped.get_all_peds()
			pedcount = #ped_table
			for a=1, pedcount do
				while(entity.is_entity_dead(ped_table[a]) and a < pedcount and entity.is_entity_dead(ped_table[a]) and a < pedcount) do
			   	a = a+1
			    end	
			     if not ped.is_ped_a_player(ped_table[a]) then   		
			    	ReqControl(ped_table[a])
			    	weapon.remove_all_ped_weapons(ped_table[a])
					ped.clear_ped_tasks_immediately(ped_table[a])
				end
			end
		end
	end
	if feat.on and feat.value == 1 then
		if EntityMan.value == 0 then
			ped_table = ped.get_all_peds()
			pedcount = #ped_table
			while(pedcount == 0) do
			ped_table = ped.get_all_peds()
			pedcount = #ped_table		
			end	
			ped_table_result = {}
		for a=1, #ped_table do
			if not ped.is_ped_a_player(ped_table[a]) then
			ped_table_result[#ped_table_result+1] = ped_table[a]
			end
		end
			pedcountresult = #ped_table_result	   
			for a=1, pedcountresult do
				while(entity.is_entity_dead(ped_table[a]) and a < pedcount and entity.is_entity_dead(ped_table[a]) and a < pedcount) do
			   	a = a+1
			    end	
			     if not ped.is_ped_a_player(ped_table_result[a]) and not ped.is_ped_in_any_vehicle(ped_table_result[a]) then 
			     	ReqControl(ped_table_result[a])
			     	ped.clear_ped_tasks_immediately(ped_table_result[a])
					weapon.give_delayed_weapon_to_ped(ped_table_result[a], weapon_a_hashes[math.random(1, #weapon_a_hashes)], 1, true)
			 		ai.task_combat_ped(ped_table_result[a], ped_table_result[math.random(#ped_table_result)], 0, 16) 	
			     end
			end
		end
	end
system.wait(WSDelay.value)
return HANDLER_CONTINUE
end)
EntityWS:set_str_data({"Neutral", "Anarchic"})

local EntityGod = menu.add_feature("Set God Mode", "action", Entity, function(feat)
menu.notify("Parsing table, please wait.", "Entity Manager", 5, 230)
	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
	system.wait(5)
		for a=1, pedcount do
			if not ped.is_ped_a_player(ped_table[a]) then 
    			ReqControl(ped_table[a])
    			entity.set_entity_god_mode(ped_table[a], (not entity.get_entity_god_mode(ped_table[a])))
        	end
        end
    end
    if EntityMan.value == 1 then
	veh_table = vehicle.get_all_vehicles()
	vehcount = #veh_table
	system.wait(5)
		for a=1, vehcount do
        	if not IsaPlayerVehicle(veh_table[a]) then 
    			ReqControl(veh_table[a])
    			entity.set_entity_god_mode(veh_table[a], (not entity.get_entity_god_mode(veh_table[a])))
    		end
    	end
    end
    if EntityMan.value == 2 then
	obj_table = object.get_all_objects()
	objcount = #obj_table
	system.wait(5)
		for a=1, objcount do
        	if not IsaPlayerVehicle(obj_table[a]) then 
    			ReqControl(obj_table[a])
    			entity.set_entity_god_mode(obj_table[a], (not entity.get_entity_god_mode(obj_table[a])))
    		end
    	end
    end
menu.notify("Done.", "Entity Manager", 5, 230) 
end)

local EntityRevive = menu.add_feature("Revive", "action", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)
	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
	system.wait(5)
		for a=1, pedcount do
				if not ped.is_ped_a_player(ped_table[a]) and entity.is_entity_dead(ped_table[a]) then
					ReqControl(ped_table[a])
					ped.resurrect_ped(ped_table[a])
					ped.set_ped_health(ped_table[a], 200)
					ped.clear_ped_tasks_immediately(ped_table[a])
			end
		end
	end
menu.notify("Done.", "Entity Manager", 5, 230)
end)

local EntityFix = menu.add_feature("Fix", "action", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)	
	if EntityMan.value == 1 then
        veh_table = vehicle.get_all_vehicles()
    	vehcount = #veh_table
    	system.wait(5)  		
    	for a=1, vehcount-1 do       			
        	ReqControl(veh_table[a])
        	vehicle.set_vehicle_engine_health(veh_table[a], 1000)
        	vehicle.set_vehicle_fixed(veh_table[a])
        	vehicle.set_vehicle_deformation_fixed(veh_table[a])
		end
	end
	menu.notify("Done.", "Entity Manager", 5, 230)
end)

local EntityUpg = menu.add_feature("Performance Upgrade", "action", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)	
	if EntityMan.value == 1 then
        veh_table = vehicle.get_all_vehicles()
    	vehcount = #veh_table
    	system.wait(5)  		
    	for a=1, vehcount-1 do       			
        	ReqControl(veh_table[a])
        	vehicle.set_vehicle_mod_kit_type(veh_table[a], 0)
        	vehicle.set_vehicle_mod(veh_table[a], 11, vehicle.get_num_vehicle_mods(veh_table[a], 11)-1, false)
        	vehicle.set_vehicle_mod(veh_table[a], 12, vehicle.get_num_vehicle_mods(veh_table[a], 12)-1, false)
       	    vehicle.set_vehicle_mod(veh_table[a], 13, vehicle.get_num_vehicle_mods(veh_table[a], 13)-1, false)
        	vehicle.set_vehicle_mod(veh_table[a], 15, vehicle.get_num_vehicle_mods(veh_table[a], 15)-1, false)
        	vehicle.set_vehicle_mod(veh_table[a], 16, vehicle.get_num_vehicle_mods(veh_table[a], 16)-1, false)
        	-- vehicle.set_vehicle_mod(veh_table[a], 18, vehicle.get_num_vehicle_mods(veh_table[a], 18)+1, false) gay turbo
			vehicle.set_vehicle_bulletproof_tires(veh_table[a], true)
		end
	end 
menu.notify("Done.", "Entity Manager", 5, 230)       	
end)

local EntityAlpha = menu.add_feature("Set Opacity", "action_value_str", Entity, function(feat)
	menu.notify("Parsing table, please wait.", "Entity Manager", 5, 230)
	if feat.value == 0 then
		ox=255
	end
	if feat.value == 1 then
		ox=215
	end	
	if feat.value == 2 then
		ox=155
	end	 
	if feat.value == 3 then
		ox=85
	end	 
	if feat.value == 4 then
		ox=0
	end

	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
		for a=1, pedcount do
			if not ped.is_ped_a_player(ped_table[a]) then 
				ReqControl(ped_table[a])
				entity.set_entity_alpha(ped_table[a], ox, true)
			end
		end
	end
	if EntityMan.value == 1 then
	veh_table = vehicle.get_all_vehicles()
	vehcount = #veh_table
		for a=1, vehcount do
        	if not IsaPlayerVehicle(veh_table[a]) then 
				ReqControl(veh_table[a])
				entity.set_entity_alpha(veh_table[a], ox, true)
			end
		end
	end
	if EntityMan.value == 2 then
	obj_table = object.get_all_objects()
	objcount = #obj_table
		for a=1, objcount do 
			ReqControl(obj_table[a])
			entity.set_entity_alpha(obj_table[a], ox, true)
			system.wait(15)
		end
	end
	menu.notify("Done.", "Entity Manager", 5, 230)
end)
EntityAlpha:set_str_data({"Visible", "Semi-Translucent", "Translucent", "Ghost-Like", "Invisible"})

local EntityKill = menu.add_feature("Kill", "action", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)
	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
	system.wait(5)
		for a=1, pedcount do 		
			while(entity.is_entity_dead(ped_table[a]) and a < pedcount) do
   			a = a+1
    		end		
    		if not ped.is_ped_a_player(ped_table[a]) then 
    			ReqControl(ped_table[a])
    			ped.set_ped_health(ped_table[a], 0)
        	end
        end
    end
    menu.notify("Done.", "Entity Manager", 5, 230)
end)

local EntityVkill = menu.add_feature("Kill Engine", "action_value_str", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)
	if feat.value == 0 then
		x=0
	end
	if feat.value == 1 then
		x=-1
	end
	if EntityMan.value == 1 then 
    	veh_table = vehicle.get_all_vehicles()
    	vehcount = #veh_table
    	system.wait(5)
    	for a=1, vehcount do
    		while(entity.is_entity_dead(veh_table[a]) and a < vehcount) do
       		a = a+1
        	end		
        	if not IsaPlayerVehicle(veh_table[a]) then 
        		ReqControl(veh_table[a])
        		vehicle.set_vehicle_engine_health(veh_table[a], x)
        	end
        end       
    end
menu.notify("Done.", "Entity Manager", 5, 230)  
end)
EntityVkill:set_str_data({"Smoking Engine", "Flaming Engine"})

local EntityTires = menu.add_feature("Pop Tires", "action", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)
	if EntityMan.value == 1 then
        veh_table = vehicle.get_all_vehicles()
    	vehcount = #veh_table
    	system.wait(5)  		
    	for a=1, vehcount-1 do
	    	while(entity.is_entity_dead(veh_table[a]) and a < vehcount) do
	       	a = a+1
	        end		       			
			wheelcount = vehicle.get_vehicle_wheel_count(veh_table[a])
			if wheelcount ~= nil then
			    for c=0, wheelcount+1 do
				    if not IsaPlayerVehicle(veh_table[a]) then 
				    ReqControl(veh_table[a])
				    vehicle.set_vehicle_tire_burst(
				    veh_table[a],
				    c,
				    true,
				    1000)
				    end
				end
			end
        end
    end
menu.notify("Done.", "Entity Manager", 5, 230)
end)

local EntityExp = menu.add_feature("Explode", "action", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)
	if EntityMan.value == 0 then	
		ped_table = ped.get_all_peds()
		pedcount = #ped_table
		system.wait(5)
		for a=1, pedcount do 		
			while(entity.is_entity_dead(ped_table[a]) and a < pedcount) do
   			a = a+1
    		end
			if not ped.is_ped_a_player(ped_table[a]) then 
				fire.add_explosion(
				entity.get_entity_coords(ped_table[a]), 
				4, 
				ExpAudible,
				ExpInvisible,
				ExpShake.value,
				player.get_player_ped(player.player_id()))
			end
		end
	end

	if EntityMan.value == 1 then
		veh_table = vehicle.get_all_vehicles()
		vehcount = #veh_table
		system.wait(5) 
	 	for a=1, vehcount do 
			while(entity.is_entity_dead(veh_table[a]) and a < vehcount) do
   			a = a+1
   			end
			if not IsaPlayerVehicle(veh_table[a]) then 
				fire.add_explosion(
				entity.get_entity_coords(veh_table[a]), 
				4, 
				ExpAudible,
				ExpInvisible,
				ExpShake.value,
				player.get_player_ped(player.player_id()))
			end
		end
	end
	
	if EntityMan.value == 2 then
		obj_table = object.get_all_objects()
		objcount = #obj_table
		system.wait(5) 
		for a=1, objcount do 
			while(entity.is_entity_dead(obj_table[a]) and a < objcount) do
   			a = a+1
   			end
			fire.add_explosion(
			entity.get_entity_coords(obj_table[a]), 
			4, 
			ExpAudible,
			ExpInvisible,
			ExpShake.value,
			player.get_player_ped(player.player_id()))
		end
	end
menu.notify("Done.", "Entity Manager", 5, 230)
end)

local EntityD = menu.add_feature("Delete", "action", Entity, function(feat)
menu.notify("Parsing Table, please wait.", "Entity Manager", 5, 230)
	if EntityMan.value == 0 then
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
	system.wait(5)
		for a=1, pedcount do
			if not ped.is_ped_a_player(ped_table[a]) then
				ReqControl(ped_table[a])
				entity.delete_entity(ped_table[a])
			end
		end
	end

	if EntityMan.value == 1 then
	veh_table = vehicle.get_all_vehicles()
	vehcount = #veh_table
	ped_table = ped.get_all_peds()
	pedcount = #ped_table
	system.wait(5)
		for a=1, pedcount do
			if ped.is_ped_in_any_vehicle(ped_table[a]) and not ped.is_ped_a_player(ped_table[a]) then
				ReqControl(ped_table[a])
				ped.clear_ped_tasks_immediately(ped_table[a])
			end
		end
		for a=1, vehcount do
      		if not IsaPlayerVehicle(veh_table[a]) then 
      			ReqControl(veh_table[a])
				entity.delete_entity(veh_table[a])
			end
		end
	end

	if EntityMan.value == 2 then 
	obj_table = object.get_all_objects()
	objcount = #obj_table
	system.wait(5) 
		for a=1, objcount do
			ReqControl(obj_table[a])
			entity.set_entity_coords_no_offset(obj_table[a], v3(-5784.258301, -8289.385742, -136.411270))
			entity.set_entity_as_no_longer_needed(obj_table[a])
			entity.delete_entity(obj_table[a])
		end
	end
menu.notify("Done.", "Entity Manager", 5, 230)
end)

local DisableHud = menu.add_feature("Disable Mini-Map", "toggle", Disables, function(feat)
	if feat.on then
		ui.hide_hud_and_radar_this_frame()
	end
	return HANDLER_CONTINUE
end) 

local DisableHud = menu.add_feature("Disable Vehicle Information", "toggle", Disables, function(feat)
	if feat.on then
		ui.hide_hud_component_this_frame(6)
		ui.hide_hud_component_this_frame(8)
	end
	return HANDLER_CONTINUE
end)

local DisableHud = menu.add_feature("Disable On Screen Information", "toggle", Disables, function(feat)
	if feat.on then
		ui.hide_hud_component_this_frame(5)
		ui.hide_hud_component_this_frame(10)
		ui.hide_hud_component_this_frame(11)
		ui.hide_hud_component_this_frame(12)
		ui.hide_hud_component_this_frame(15)
	end
	return HANDLER_CONTINUE
end)


local DisableHud = menu.add_feature("Disable Location Information", "toggle", Disables, function(feat)
	if feat.on then
		ui.hide_hud_component_this_frame(7)
		ui.hide_hud_component_this_frame(9)
	end
	return HANDLER_CONTINUE
end)

local DisableHud = menu.add_feature("Disable Miscellaneous Information", "toggle", Disables, function(feat)
	if feat.on then
		ui.hide_hud_component_this_frame(1)
		ui.hide_hud_component_this_frame(2)
		ui.hide_hud_component_this_frame(3)
		ui.hide_hud_component_this_frame(4)
		ui.hide_hud_component_this_frame(13)
		ui.hide_hud_component_this_frame(17)
		ui.hide_hud_component_this_frame(21)
		ui.hide_hud_component_this_frame(22)
	end
	return HANDLER_CONTINUE
end)

local DisableHud = menu.add_feature("Disable Menu Notifications", "toggle", Disables, function(feat)
	if feat.on then
		menu.clear_all_notifications()
	end
	return HANDLER_CONTINUE
end)

local DisableHud = menu.add_feature("Game Notifcation Cleanup", "toggle", Disables, function(feat)
	if feat.on then
		ui.remove_notification(ui.get_current_notification())
	end
	return HANDLER_CONTINUE
end)

local DisableHud = menu.add_feature("Notifcation Cleanup Info", "action", Disables, function(feat)
	menu.notify("This cleans up some notifications from the screen I could not find the HUD componets for. Some notifs such as players leaving will persist.", "Notification Cleanup", 15, 255)
end)

local DisableCS = menu.add_feature("Disable Cutscenes", "toggle", Disables, function(feat)
	if feat.on then
		cutscene.is_cutscene_playing(cutscene.stop_cutscene_immediately())
	end
	return HANDLER_CONTINUE
end)

local EntityPSM = menu.add_feature ("Player State Shit", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityPS.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityPS.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityPS.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityPSM.on = true
	EntityPSM.hidden = true

local EntityWSM = menu.add_feature ("World State Shit", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityWS.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityWS.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityWS.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityWSM.on = true
	EntityWSM.hidden = true

local EntityReviveM = menu.add_feature ("Revive Manager", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityRevive.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityRevive.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityRevive.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityReviveM.on = true
	EntityReviveM.hidden = true

local EntityKillM = menu.add_feature ("Killing Stuff", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityKill.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityKill.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityKill.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityKillM.on = true
	EntityKillM.hidden = true

local EntityFixM = menu.add_feature ("Fix Manager", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityFix.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityFix.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityFix.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityFixM.on = true
	EntityFixM.hidden = true

local EntityUpgM = menu.add_feature ("Upgrade Shit", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityUpg.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityUpg.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityUpg.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityUpgM.on = true
	EntityUpgM.hidden = true


local EntityVKillM = menu.add_feature ("Vehicle Kill Manager", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityVkill.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityVkill.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityVkill.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityVKillM.on = true
	EntityVKillM.hidden = true

local EntityTireM = menu.add_feature ("Tire Manager", "value_i", Entity, function(feat)
	if EntityMan.value == 0 then
		EntityTires.hidden = true
	end
	system.wait(5)
	if EntityMan.value == 1 then
		EntityTires.hidden = false
	end
	system.wait(5)
	if EntityMan.value == 2 then
		EntityTires.hidden = true
	end
	system.wait(5)
	return HANDLER_CONTINUE
end)
	EntityTireM.on = true
	EntityTireM.hidden = true

-- Online Pages --

local onlineshit = menu.add_player_feature("Shitter Menu", "parent", 0)





local trolling = menu.add_player_feature("Shitter Trolling", "parent", onlineshit.id)

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

menu.add_player_feature("Slow-mo Vehicle", "action", trolling.id, function(playerfeat, pid)
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

menu.add_player_feature("Remove any Vehicle god mode", "action", trolling.id, function(feat, pid) 
	if feat.on then
	menu.notify("works best if your close to them or spectating", "ShitterMenu lua", 9, 50) player.get_player_ped(pid) local veh = player.get_player_vehicle(pid) network.request_control_of_entity(veh) entity.set_entity_god_mode(veh, false) if entity.get_entity_god_mode(veh) == false then print("there car has been removed from god mode successful") end if entity.get_entity_god_mode(veh) == true then print("there car has been removed from god mode failed \n try teleporting to them if it still dose not work then theres problay another modder around") end end
	end)

menu.add_player_feature("Freeze there Vehicle", "action", trolling.id, function(feat, pid)
	if feat.on then
	local veh = player.get_player_vehicle(pid) network.request_control_of_entity(veh) entity.freeze_entity(veh, true) end
	end)

menu.add_player_feature("Un-freeze there Vehicle", "action", trolling.id, function(feat, pid)
	if feat.on then
	local veh = player.get_player_vehicle(pid) network.request_control_of_entity(veh) entity.freeze_entity(veh, false) end
	end)	

menu.add_player_feature("Kick from vehicle", "action", trolling.id, function(feat, pid)
	if feat.on then
	local there_ped = player.get_player_ped(pid) script.trigger_script_event(-1333236192, pid, {-1, 0}) script.trigger_script_event(-1089379066, pid, {-1, 0}) script.trigger_script_event(0xc40f66ca, pid, {}) ped.clear_ped_tasks_immediately(there_ped) end
	end)

menu.add_player_feature("Turn Vehicle To Shit", "action", trolling.id, function(playerfeat, pid)
	local player_veh = ped.get_vehicle_ped_is_using(player.get_player_ped(pid))
	if (player.is_player_in_any_vehicle(pid)) then
			menu.notify("Shit On " .. player.get_player_name(pid) .. "'s " .. vehicle.get_vehicle_model(player_veh), ShitterMenu_ver, 10, 2)
			network.request_control_of_entity(player_veh)
			vehicle.set_vehicle_engine_health(player_veh, -1)
		else
			menu.notify(player.get_player_name(pid) .. " is not in a vehicle", ShitterMenu_ver, 10, 2)
		end
	end)

menu.add_player_feature("Spawn Goofy Terrorist", "action_value_str", trolling.id, function(playerfeat_val, pid)
    menu.notify("Spawned a pole dancing terrorist near "..player.get_player_name(pid)..". This only works if you're in range or spectating the player.", ShitterMenu_ver, 10, 2)
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

menu.add_player_feature("Cause Player to Shit", "toggle", trolling.id, function(playerfeat_toggle, pid)
    local player_heading = player.get_player_heading(pid)
    while playerfeat_toggle.on do
        graphics.set_next_ptfx_asset("core_snow")
        while not graphics.has_named_ptfx_asset_loaded("core_snow") do
            graphics.request_named_ptfx_asset("core_snow")
            system.wait(0)
        end

        if (graphics.has_named_ptfx_asset_loaded("core_snow")) then
            graphics.start_networked_ptfx_non_looped_at_coord("cs_mich1_spade_dirt_trail", player.get_player_coords(pid) + v3(0.35, 0, 0), v3(0, 0, player_heading - 180), 1, false, false, true)
            system.wait(500)
        end
    end
end)

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
menu.add_player_feature("Shitty Crash v1", "action", shittyc.id, function(playerfeat_val, pid)
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