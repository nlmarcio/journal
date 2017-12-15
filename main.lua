--====================================================================================
-- #Author: GTAVFTRP 
--====================================================================================
 

ESX = nil
local CurrentActionData   = {}
local lastTime            = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--------------------------------  OPEN disp  --------------------------------

function OpenDisp()

  local playerPed = GetPlayerPed(-1)

	Citizen.CreateThread(function()
    
    local playerPed  = GetPlayerPed(-1)


    Citizen.CreateThread(function()
    Citizen.Wait(1000)
    TriggerServerEvent('journal:disp')
    ClearPedTasksImmediately(playerPed)
    end)
  end)

end

AddEventHandler('journal:newsdispEnteredEntityZone', function(entity)
  
    local playerPed = GetPlayerPed(-1)
  
      CurrentAction     = 'open_disp'
      CurrentActionMsg  = 'Appuyez sur ~INPUT_TALK~ pour prendre un journal'
      CurrentActionData = {entity = entity}
  
end)

AddEventHandler('journal:newsdisphasExitedEntityZone', function(entity)
  
    if CurrentAction == 'open_disp' then
      CurrentAction = nil
    end
  
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
	
		local coords    = GetEntityCoords(playerPed)
		local playerPed = GetPlayerPed(-1)

		local entity, distance = ESX.Game.GetClosestObject({
			'prop_news_disp_02a',
		})

		if distance ~= -1 and distance <= 1.50 then

 			if entity then
				TriggerEvent('journal:newsdispEnteredEntityZone', entity)
				LastEntity = entity
			end
		else
			if entity ~= nil then
				TriggerEvent('journal:newsdisphasExitedEntityZone', entity)
				entity = nil
			end
		end
	end
end)

---------------------------------utiliser le journal---------------------------------

RegisterNetEvent('journal:journal')
AddEventHandler('journal:journal', function()
  Citizen.CreateThread(function()
    local display = true
    local startTime = GetGameTimer()
    local delay = 180000 

    TriggerEvent('journal:display', true)

    while display do
      Citizen.Wait(1)
      ShowInfo('~w~ Appuyez sur ~INPUT_CONTEXT~ pour fermer le journal', 0)
      if (GetTimeDifference(GetGameTimer(), startTime) > delay) then
        display = false
        TriggerEvent('journal:display', false)
      end
      if (IsControlJustPressed(1, 51)) then
        display = false
        TriggerEvent('journal:display', false)
      end
    end
  end)
end)

RegisterNetEvent('journal:display')
AddEventHandler('journal:display', function(value)
  SendNUIMessage({
    type = "disclaimer",
    display = value
  })
end)

function ShowInfo(text, state)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, state, 0, -1)
end


--------------- KEY CONTROLS -----------------

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)

      if CurrentAction ~= nil then
         
        SetTextComponentFormat('STRING')
        AddTextComponentString(CurrentActionMsg)
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        
      if IsControlJustReleased(0, 38) then             
        if CurrentAction == 'open_disp' then
          if GetGameTimer() - lastTime >= 15000 then 
            OpenDisp()
            lastTime = GetGameTimer()
          end
        end

          CurrentAction = nil               
      end
	  
    end
	
  end
  
end)

