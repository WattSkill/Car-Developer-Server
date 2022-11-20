print("^1Car Dev Menu")
print("^1Made By WattSkill")
print("^1Made on 14/07/2022")

cfg = {}
cfg.text = ""
cfg.vehicles = {
 -- {name = "vehname", spawncode = "spawncode"},
}

local b = false
local q = {"Speed", "Drift", "Handling", "City", "Airport"}
local r = {
    vector3(2370.8, 2856.58, 40.46),
    vector3(974.58, -3006.6, 5.9),
    vector3(1894.57, 3823.71, 31.98),
    vector3(-482.63, -664.24, 32.74),
    vector3(-1728.25, -2894.99, 13.94)
}
local s = 1
local savedCoords = nil

RMenu.Add('cardev', 'main', RageUI.CreateMenu("~b~Car Dev Menu", "~b~Car Dev Menu", 1300, 100))
RMenu.Add('cardev', 'vehicles', RageUI.CreateSubMenu(RMenu:Get("cardev", "main"), "", "~b~Vehicle Spawner", 1300, 100, "banners", "adminmenu"))
RMenu.Add('cardev', 'teleportation', RageUI.CreateSubMenu(RMenu:Get("cardev", "main"), "", "~b~Vehicle Spawner", 1300, 100, "banners", "adminmenu"))
RMenu.Add('cardev', 'vehiclelist', RageUI.CreateSubMenu(RMenu:Get("cardev", "main"), "", "~b~Vehicle Spawner", 1300, 100, "banners", "adminmenu"))
RMenu.Add('cardev', 'vehiclelistmain', RageUI.CreateSubMenu(RMenu:Get("cardev", "vehiclelist"), "", "~b~Vehicle Spawner", 1300, 100, "banners", "adminmenu"))
RMenu.Add('cardev', 'vehiclelistspawn', RageUI.CreateSubMenu(RMenu:Get("cardev", "vehiclelistmain"), "", "~b~Vehicle Spawner", 1300, 100, "banners", "adminmenu"))

RageUI.CreateWhile(1.0, RMenu:Get('cardev', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('cardev', 'main'), true, false, true, function()
        RageUI.Button("Spawn Vehicle (Full Mods)", nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                deleteVeh()
                customvehicle = getcustomcarmsg()
                spawnmaxupgraded(customvehicle)
                ShowInfo("~g~" .. customvehicle ..  "Spawned")
            end
        end)

        RageUI.Button("Spawn Vehicle (No Mods)", nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                deleteVeh()
                customvehicle = getcustomcarmsg()
                spawncustomvehicle(customvehicle)
                ShowInfo("~g~" .. customvehicle ..  "Spawned")
            end
        end)

        RageUI.Button("Fix Vehicle", nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                fixvehicle()
            end
        end)
        RageUI.Button("Delete Vehicle", nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                deleteVeh()
            end
        end)
        RageUI.Button("Open/Close Doors", nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                DoorControl()
            end
        end)
        RageUI.List("Teleport to ",q,s,nil,{},true,function(x, y, z, N)
            s = N
            if z then   
                if IsPedInAnyVehicle(PlayerPedId(), true) then
                    ped = GetVehiclePedIsIn(PlayerPedId(), true)
                else
                    ped = GetPlayerPed(-1)
                end
                SetEntityCoords(ped, vector3(r[s]), true,false,false,false)
            end
        end,
        function()
        end)
    RageUI.Button("~b~[My Vehicles]", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('cardev', 'vehicles'))
end)
-- Sub Menu --
    RageUI.IsVisible(RMenu:Get('cardev', 'vehicles'), true, false, true, function()
        for i , p in pairs(cfg.vehicles) do 
            RageUI.Button(cfg.text .. p.name , nil, "", true, function(Hovered, Active, Selected)
                if Selected then
                    deleteVeh()
                    spawnmaxupgraded(p.spawncode)
                    ShowInfo("~g~" .. p.name ..  " Spawned")
                end
            end)
        end
        RageUI.Button("~b~[Return]", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('cardev', 'main'))
    end)

RageUI.IsVisible(RMenu:Get('cardev', 'teleportation'), true, false, true, function()
    RageUI.Button("Teleport to Waypoint", nil, "", true, function(Hovered, Active, Selected)
        if Selected then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            teleportToWaypoint()
            SetVehicleOnGroundProperly(veh)
            ShowInfo("~g~Teleported to Waypoint")
        end
    end)
    RageUI.Button("Test Speed", nil, "", true, function(Hovered, Active, Selected)
        if Selected then
            local playerPed = PlayerPedId()
            SetPedCoordsKeepVehicle(playerPed, 2799.59,3384.42,57.0)
            ShowInfo("~g~Teleported to Speed Test")
        end
    end)

    RageUI.Button("Test Handling", nil, "", true, function(Hovered, Active, Selected)
        if Selected then
            local playerPed = PlayerPedId()
            SetPedCoordsKeepVehicle(playerPed, 920.37,-3131.03,5.90)
            ShowInfo("~g~Teleported to Handling Test")
        end
    end)

    RageUI.Button("Test Off-Road", nil, "", true, function(Hovered, Active, Selected)
        if Selected then
            local playerPed = PlayerPedId()
            SetPedCoordsKeepVehicle(playerPed, -2025.77,2709.65,3.7)
            ShowInfo("~g~Teleported to Off-Road Test")
        end
    end)

    RageUI.Button("~b~[Return]", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
    end, RMenu:Get('cardev', 'main'))
end)
end)

-- Open Menu --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 311) then 
            RageUI.Visible(RMenu:Get("cardev", "main"), true)
        end
    end
end)

-- Functions --

function ShowInfo(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

-- Spawn Veh --
function deleteVeh()
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then 
        local pos = GetEntityCoords(ped)

		if (IsPedSittingInAnyVehicle(ped)) then 
			local handle = GetVehiclePedIsIn(ped, false)
			NetworkRequestControlOfEntity(handle)
			SetEntityHealth(handle, 100)
			SetEntityAsMissionEntity(handle, true, true)
			SetEntityAsNoLongerNeeded(handle)
			DeleteEntity(handle)
            ShowInfo("The vehicle you were in has been deleted.")
        end
    end
end

function maxupgradeveh()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleOnGroundProperly(veh)
    SetEntityInvincible(veh, false)
    SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, 11, 2, false)
    SetVehicleMod(veh, 13, 2, false)
    SetVehicleMod(veh, 12, 2, false)
    SetVehicleMod(veh, 15, 3, false)
end

function spawncustomvehicle(customvehicle)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local color = "~y~"
    local color2 = "~b~"
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) then
        vehiclehash = GetHashKey(customvehicle)
        RequestModel(vehiclehash)
        Citizen.CreateThread(function() 
            local waiting = 0
            while not HasModelLoaded(vehiclehash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    ShowInfo(color2 .."Could not load model in time. Crash was prevented.")
                    break
                end
            end
            local spawnedVeh = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
            SetPedIntoVehicle(PlayerPedId(), spawnedVeh, -1)
            SetVehicleDirtLevel(spawnedVeh, 0.0)
        end)
        Wait(1000)
        return true
end
return false
end

function spawnmaxupgraded(customvehicle)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local color = "~y~"
    local color2 = "~b~"
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) then
        vehiclehash = GetHashKey(customvehicle)
        RequestModel(vehiclehash)
        Citizen.CreateThread(function() 
            local waiting = 0
            while not HasModelLoaded(vehiclehash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    ShowInfo(color2 .."Could not load model in time. Crash was prevented.")
                    break
                end
            end
            local spawnedVeh = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
            SetPedIntoVehicle(PlayerPedId(), spawnedVeh, -1)
            SetVehicleOnGroundProperly(spawnedVeh)
            SetVehicleDirtLevel(spawnedVeh, 0.0)
            SetEntityInvincible(spawnedVeh, false)
            SetVehicleModKit(spawnedVeh, 0)
            SetVehicleMod(spawnedVeh, 11, 3, false)
            SetVehicleMod(spawnedVeh, 13, 2, false)
            SetVehicleMod(spawnedVeh, 12, 2, false)
            SetVehicleMod(spawnedVeh, 15, 3, false)
            ToggleVehicleMod(spawnedVeh, 18, true)
        end)
        Wait(1000)
        return true
end
return false
end

-- End of Vehicle Spawner --
-- Message Input --

function getcustomcarmsg()
	AddTextEntry('FMMC_MPM_NA', "Enter Spawn Code")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Spawn Code", "", "", "", "", 100)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end



-- End of Message Input

function teleportToWaypoint()
	local targetPed = GetPlayerPed(-1)
	local targetVeh = GetVehiclePedIsUsing(targetPed)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = targetVeh
    end

	if(not IsWaypointActive())then
		return
	end

	local waypointBlip = GetFirstBlipInfoId(8) -- 8 = waypoint Id
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 

	-- ensure entity teleports above the ground
	local ground
	local groundFound = false
	local groundCheckHeights = {100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		Wait(10)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end

	if(not groundFound)then
		z = 1000
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- parachute
	end

	SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
end

function fixvehicle()
    local player = PlayerPedId()
    local veh = GetVehiclePedIsIn(player, false)
    if IsPedSittingInVehicle(player, veh) then
    SetVehicleEngineHealth(veh, 9999)
    SetVehiclePetrolTankHealth(veh, 9999)
    SetVehicleFixed(veh)
    ShowInfo("~g~Vehicle Fixed")
    else
    ShowInfo("~b~Not in Vehicle")
    end
end

function DoorControl()
    local player = GetPlayerPed(-1)
    vehicle = GetVehiclePedIsIn(player,true)
    local isopen = GetVehicleDoorAngleRatio(vehicle,0) and GetVehicleDoorAngleRatio(vehicle,1) and GetVehicleDoorAngleRatio(vehicle,2) and GetVehicleDoorAngleRatio(vehicle,3)

    if (isopen == 0) then
        SetVehicleDoorOpen(vehicle,0,0,0)
        SetVehicleDoorOpen(vehicle,1,0,0)
        SetVehicleDoorOpen(vehicle,2,0,0)
        SetVehicleDoorOpen(vehicle,3,0,0)
        else
        SetVehicleDoorShut(vehicle,0,0)
        SetVehicleDoorShut(vehicle,1,0)
        SetVehicleDoorShut(vehicle,2,0)
        SetVehicleDoorShut(vehicle,3,0)
        end
    end