poco = {}
Tunnel.bindInterface(GetCurrentResourceName(), poco)
Proxy.addInterface(GetCurrentResourceName(), poco)
pocoS = Tunnel.getInterface(GetCurrentResourceName(), GetCurrentResourceName())

local showUI = false

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        local ped = PlayerPedId()
        if GetEntityHealth(ped) <= 120 then
            if not showUI then
                showUI = true
                SendNUIMessage({type = "showUI"})
                SetNuiFocus(true, true)
            end
        else
            if showUI then
                showUI = false
                SendNUIMessage({type = "hideUI"})
                SetNuiFocus()
            end
        end

        Citizen.Wait(100)
    end
end)

function poco.Notify(text, time)
    SendNUIMessage({type = "notify", text = text, time = time})
end

function poco.AiCall(time)
    poco.Notify("현재 의료국 인원이 부족한 관계로 원격 소생을 진행합니다. <br> 소요시간 : 약 " .. time .. "초", time)

    SetTimeout(time * 1000, function()
        local ped = PlayerPedId()
        poco.health()

        SetTimeout(1000, function()
            if GetEntityHealth(ped) <= 120 then
                poco.health()
            end
        end)
    end)
end

function poco.health()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
end

function ReviveRequest()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    pocoS.ReviveRequest({pos,inarea})
    SetNuiFocus(true, false)
end

RegisterNUICallback("ReviveRequest", ReviveRequest)

RegisterNUICallback("NuiFocus", function(data,cb)
    if data.poco then
        SetNuiFocus(true, true)
        return
    end

    SetNuiFocus()
end)

RegisterNUICallback("Button", function(data,cb)
    if data == nil or data.type == nil then return end

    pocoS.Button({data.type})
end)


local zones = {
    {vector3(250.91539001465, 219.6602935791, 106.28674316406), radius = 30},
    {vector3(-622.13, -230.73, 38.07), radius = 30},
    {vector3(-1220.7711181641, -911.26257324219, 12.326360702515), radius = 30},
    {vector3(-106.6203994751, 6474.5952148438, 31.62672996521), radius = 30},
    {vector3(-1219.8359375, -915.93420410156, 11.3261899948121), radius = 30},
    {vector3(29.187158584595, -1340.0651855469, 29.49702835083), radius = 30},
    {vector3(-1479.2026367188, -374.38134765625, 39.163303375244), radius = 30},
    {vector3(-708.24731445312, -904.21948242188, 19.215585708618), radius = 30},
    {vector3(-1168.4737548828, 2718.1623535156, 37.157482147217), radius = 30},
    {vector3(1706.6136474609, 4919.8232421875, 42.063682556152), radius = 30},
    {vector3(2550.2224121094, 386.34689331055, 108.62289428711), radius = 30},
    {vector3(2728.5903320313, 3491.3208007813, 55.69686126709), radius = 30},
    {vector3(2674.2873535156, 3287.6662597656, 55.241115570068), radius = 30},
    {vector3(-2957.6743164063, 479.96490478516, 15.706813812256), radius = 30},
    {vector3(-1212.4215087891, -335.92651367188, 37.790756225586), radius = 30},
    {vector3(-11.706216812134, 332.63000488281, 113.16081237793), radius = 60},
    {vector3(-432.97415161133, 299.68103027344, 83.229125976563), radius = 50},
    {vector3(3649.9660644531, 300.25009155273, 126.78993225098), radius = 60},
    {vector3(-2703.7607421875, -768.5439453125, 173.93630981445), radius = 60},
    {vector3(3101.4116210938, 813.6298828125, 181.49728393555), radius = 60},
    ---스카이D
    {vector3(651.81207275391,-3936.2746582031,1321.8601074219), radius =60},
    {vector3(-3564.3188476562,1648.7478027344,1321.8558349609), radius =60},
    {vector3(650.02990722656,8237.3974609375,1321.8551025391), radius =60},
    {vector3(4220.4555664062,1652.1674804688,1321.8587646484), radius =60},
    ---스카이C

    {vector3(4019.4357910156,-3587.1826171875,741.14416503906), radius =60},
    {vector3(-4191.9956054688,-3582.1232910156,741.14453125), radius =60},
    {vector3(-3842.3386230469,7816.2983398438,741.14324951172), radius =60},
    {vector3(4595.8706054688,7817.689453125,741.14532470703), radius =60},
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, zone in ipairs(zones) do
            local distance = GetDistanceBetweenCoords(playerCoords, zone[1].x, zone[1].y, zone[1].z, true)
            
            if distance <= zone.radius then
                -- 플레이어가 영역 내에 있습니다.
                inarea = true
                break
            else
                inarea = false
            end
        end
    end
end)

RegisterNUICallback('rpdowun', function()
    pocoS.Down({'team'})
end)

RegisterNUICallback('rplose', function()
    pocoS.Down({'alone'})
end)

RegisterNetEvent("checkProximityAndSendMessage")
AddEventHandler("checkProximityAndSendMessage", function(type, template, name, sourceId)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(sourceId)

    if sonid == -1 then
        return
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(monid))
    local targetCoords = GetEntityCoords(GetPlayerPed(sonid))

    if sonid == monid or GetDistanceBetweenCoords(playerCoords, targetCoords, true) < 160.00 then
        TriggerEvent('chat:addMessage', {
            template = template,
            args = { name }
        })
    end
end)
