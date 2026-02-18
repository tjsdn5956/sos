local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())
pocoC = Tunnel.getInterface(GetCurrentResourceName(), GetCurrentResourceName())

poco = {}
Tunnel.bindInterface(GetCurrentResourceName(), poco)

local callID = 0

function poco.ReviveRequest(pos,inarea)
    local source = source
    local user_id = vRP.getUserId({source})
    if user_id == nil then return end

    -- if vRP.getBlacklist({user_id, "ems.service"}) then
    --     return pocoC.Notify(source, {"당신은 블랙리스트에 등재되어 있어 호출할 수 없습니다.", 10})
    -- end

    if inarea then
        SetTimeout(1000, function()
            vRPclient.notify(source, {"~g~RP 구역임으로 바로 소생됩니다."})
            pocoC.health(source)
        end)

        return
    end
    
    if vRP.hasPermission({user_id, "admin.score"}) then
        vRPclient.notify(source, {"~g~당신은 관리자 입니다. 즉시 소생됩니다."})
        return pocoC.health(source)
    end
    
    -- if vRP.hasPermission({user_id, "ems.private"}) then
    --     vRPclient.notify(source, {"~g~당신은 의료국 입니다. 즉시 소생됩니다."})
    --     return pocoC.health(source)
    -- end
    
    SetTimeout(3000, function()
        local emsUsers = vRP.getUsersByPermission({cfg.permission})
        
        if #emsUsers <= 0 then -- AI 호츌
            -- if vRP.tryFullPayment({user_id, cfg.AIsetting.money}) then
                math.randomseed(os.time())
                local time = math.random(cfg.AIsetting.delay[1], cfg.AIsetting.delay[2])
                pocoC.AiCall(source, {time})
            -- else
                -- vRPclient.killComa(source)
            -- end
            return
        end
        
        local isaccept = false
        callID = callID + 1
    
        local name = GetPlayerName(source)
        for _, player in pairs(emsUsers) do
            local player_source = vRP.getUserSource({player})
            if player_source ~= nil then
                vRP.request({player_source, "의료국 호출", name ..  "(" .. user_id .. ")님의 호출", "치명상을 입었습니다!",  callID .. "_SosCall", cfg.callTime, function(player_source, ok)
                    if ok and not isaccept then
                        isaccept = true
    
                        local player_ped = GetPlayerPed(player_source)
                        local distance = tonumber(string.format("%0.4f", round((#(GetEntityCoords(player_ped) - pos))) / 1000))
    
                        vRPclient.setGPS(player_source, {pos.x, pos.y})
                        pocoC.Notify(source, {"긴급구조를 위해 귀하의 휴대전화 위치를 조회하였습니다.<br>남은거리: " .. distance .. "Km", 30})
                    end
                end})
            end
        end
    end)
end

function poco.Button(type)
    local source = source
    local user_id = vRP.getUserId({source})
    if user_id == nil then return end

    local dataTable = cfg[type]
    if dataTable == nil then return end

    local template = dataTable.template

    TriggerClientEvent("checkProximityAndSendMessage", -1, type, template, GetPlayerName(source), source)
end
