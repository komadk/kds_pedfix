local ESX = exports["es_extended"]:getSharedObject()

local function ClearProps()
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    ClearPedTasksImmediately(playerPed)
    
    -- Remove all attached props
    for i = 0, 16 do
        if GetPedPropIndex(playerPed, i) ~= -1 then
            ClearPedProp(playerPed, i)
        end
    end
    
    -- Remove attached entities
    local handle, entity = FindFirstObject(nil)
    local success = true
    
    repeat
        if IsEntityAttachedToEntity(entity, playerPed) then
            DetachEntity(entity, true, true)
            DeleteEntity(entity)
        end
        success, entity = FindNextObject(handle, nil)
    until not success
    
    EndFindObject(handle)
    
    -- Remove stuck NPCs/peds
    local handle, ped = FindFirstPed(nil)
    local success = true
    
    repeat
        if IsEntityAttachedToEntity(ped, playerPed) and not IsPedAPlayer(ped) then
            DetachEntity(ped, true, true)
            DeleteEntity(ped)
        end
        success, ped = FindNextPed(handle, nil)
    until not success
    
    EndFindPed(handle)
end

local function ClearStuckPeds()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Clear peds in a radius around the player (3.0 meters)
    local handle, ped = FindFirstPed(nil)
    local success = true
    
    repeat
        if not IsPedAPlayer(ped) and ped ~= playerPed then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(playerCoords - pedCoords)
            
            if distance < 1.0 then
                DeleteEntity(ped)
            end
        end
        success, ped = FindNextPed(handle, nil)
    until not success
    
    EndFindPed(handle)
end

-- Register the pedfix command
RegisterCommand('pedfix', function()
    ClearProps()
    ClearStuckPeds()
    
    ESX.ShowNotification('All stuck props and NPCs have been cleared.')
end, false)

-- Add a suggestion for the command
TriggerEvent('chat:addSuggestion', '/pedfix', 'Clear stuck props on your character and remove stuck NPCs') 