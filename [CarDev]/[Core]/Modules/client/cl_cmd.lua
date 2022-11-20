-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterCommand('car', function(source, args, rawCommand)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local veh = args[1]
    if veh == nil then veh = "adder" end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)
    
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end
        CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
    end)
end)


-- Stamina & Health Recharge
Citizen.CreateThread( function()
    while true do
       Citizen.Wait(1)
	   RestorePlayerStamina(PlayerId(), 1.0)
	   SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	   SetPedDropsWeaponsWhenDead(GetPlayerPed(-1), 0)
    end
end)
  

-- Always Sunny
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		WaterOverrideSetStrength(0.0)
		NetworkOverrideClockTime(11, 00, 00)
		SetWeatherTypePersist("EXTRASUNNY")
		SetWeatherTypeNowPersist("EXTRASUNNY")
		SetWeatherTypeNow("EXTRASUNNY")
		SetOverrideWeather("EXTRASUNNY")
		SetForcePedFootstepsTracks(false)
		SetForceVehicleTrails(false)
    end
end)