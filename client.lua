ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local zone = {
	["PD"] = {x=423.23580932617,y=-1000.4470825195,z=30.709135055542,radius = 80.0}
}

local distance = {laba = false,x=nil,y=nil,z=nil,radius=nil}

function coliziune(entitate)
	for _, lr in ipairs(GetActivePlayers()) do
		if(Vdist(GetEntityCoords(GetPlayerPed(lr)),distance.x,distance.y,distance.z) <= distance.radius) then
			SetEntityNoCollisionEntity(GetPlayerPed(lr),entitate,true)
		end
	end
end



Citizen.CreateThread(function()
	
	while true do

		
		Citizen.Wait(0)
		local jucatorimuie = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(jucatorimuie, true))

		local PlayerData = ESX.GetPlayerData()
		

		
		if(distance.laba == false) then
			for i,v in pairs(zone) do
				if(Vdist(x,y,z,v.x,v.y,v.z) <= v.radius) then
					distance.laba = true
					distance.x,distance.y,distance.z,distance.radius = v.x,v.y,v.z,v.radius
					
				
					if PlayerData.job.name ~= 'police' then
						SetCurrentPedWeapon(jucatorimuie,GetHashKey("WEAPON_UNARMED"),true)
						ClearPlayerWantedLevel(PlayerId())
					end
				end
			end
		end

		
	
		if distance.laba then
			if PlayerData.job.name ~= 'police' then
				NetworkSetFriendlyFireOption(true)
				DisableControlAction(2, 37, true)
				DisableControlAction(0, 138, true)
				DisableControlAction(0, 141, true)
				DisablePlayerFiring(jucatorimuie,true)
				DisableControlAction(0, 106, true)
				Draw3DText(x,y,z, "~r~NCZ", 0.7)
	
				coliziune(player)
				if(Vdist(x,y,z,distance.x,distance.y,distance.z) > 50.0) then
					distance.laba = false
					distance.x,distance.y,distance.z,distance.radius = nil,nil,nil,nil
					NetworkSetFriendlyFireOption(true)
					DisableControlAction(2, 37, false)
					DisablePlayerFiring(jucatorimuie,false)
					DisableControlAction(0, 106, false)
				end
			
				else
				Draw3DText(x,y,z, "~g~NCZ", 0.7)
				if(Vdist(x,y,z,distance.x,distance.y,distance.z) > 50.0) then
					distance.laba = false
					distance.x,distance.y,distance.z,distance.radius = nil,nil,nil,nil
					NetworkSetFriendlyFireOption(true)
					DisableControlAction(2, 37, false)
					DisablePlayerFiring(jucatorimuie,false)
					DisableControlAction(0, 106, false)
				end
				end
		end
	end
end)

function drawtxt(text,font,centre,x,y,scale,r,g,b,a)
    y = y - 0.010
    scale = scale/2
    y = y + 0.002
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextFont(fontId)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end


function Draw3DText(x,y,z, text,scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString("~a~"..text)
        DrawText(_x,_y)
    end
end


