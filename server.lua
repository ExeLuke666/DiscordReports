-- Config --
local webhookURL = ''
local displayIdentifiers = true

-- CODE --
function GetActivePlayers()
    local players = {}

    for _, playerId in ipairs(GetPlayers()) do
        if NetworkIsPlayerActive(playerId) then
            table.insert(players, playerId)
        end
    end

    return players
end

RegisterCommand("report", function(source, args, rawCommand)
    local splitCommand = stringsplit(rawCommand, " ")
    if #args < 2 then
        TriggerClientEvent('chatMessage', source, "^1ERROR: Invalid Usage. ^2Proper Usage: /report <id> <reason>")
        return
    end

    local reportedPlayerId = splitCommand[2]
    if GetPlayerIdentifiers(reportedPlayerId)[1] == nil then
        TriggerClientEvent('chatMessage', source, "^1ERROR: The specified ID is not currently online...")
        return
    end

    local message = ""
    for i = 3, #splitCommand do
        message = message .. splitCommand[i] .. " "
    end

    TriggerClientEvent("Reports:CheckPermission:Client", -1, source, reportedPlayerId, message)

    TriggerClientEvent('chatMessage', source, "^9[^1Badger-Reports^9] ^2Report has been submitted! Thank you for helping us :)")
end)

function sendToDisc(title, message, footer)
    local embed = {
        {
            ["color"] = 16711680, -- RED
            ["title"] = "**".. title .."**",
            ["description"] = "" .. message ..  "",
            ["footer"] = {
                ["text"] = footer,
            },
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

local function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

RegisterNetEvent("Reports:CheckPermission")
AddEventHandler("Reports:CheckPermission", function(source, reportedPlayerId, message)
    if IsPlayerAceAllowed(source, "BadgerReports.See") then 
        TriggerClientEvent('chatMessage', source, "^9[^1Report^9] ^8" .. message)
    end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    local i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function ExtractIdentifiers(playerId)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local id = GetPlayerIdentifier(playerId, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end
