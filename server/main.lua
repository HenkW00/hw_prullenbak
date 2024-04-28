ESX = exports["es_extended"]:getSharedObject()

function sendLog(playerIdentifier, message, ...)
    if Config.Logs and Config.Webhook ~= "" then
        local formattedMessage = string.format(message, ...)
        local finalMessage = ("**Player:** `%s` - **Message:** `%s`"):format(playerIdentifier, formattedMessage)
        local currentTime = os.date("%Y-%m-%d %H:%M:%S")
        
        local embeds = {
            {
                title = Config.DiscordLogTitle,
                description = finalMessage,
                type = "rich",
                color = Config.DiscordLogColour,
                footer = {
                    text = Config.DiscordLogFooter .. " | " .. currentTime,
                }
            }
        }
        
        PerformHttpRequest(Config.Webhook, function(statusCode, responseBody, responseHeaders) 
        end, 'POST', json.encode({username = Config.DiscordBotName or 'HW Logs', embeds = embeds}), {['Content-Type'] = 'application/json'})
    end
end


function getPlayerIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "steam:") then
            return identifier
        end
    end
    return nil
end

ESX["RegisterServerCallback"](GetCurrentResourceName(), function(source, cb)
    local player = ESX["GetPlayerFromId"](source)

    if player then
        local luck = math.random(1, 1)

        if luck == 1 then
            local randomItem = Config["Items"][math.random(#Config["Items"])]
            local quantity = math.random(randomItem["minQuantity"], randomItem["maxQuantity"])
            local itemLabel = ESX["GetItemLabel"](randomItem["name"])

            if player["canCarryItem"](randomItem["name"], quantity) then
                player["addInventoryItem"](randomItem["name"], quantity)
                local playerIdentifier = getPlayerIdentifier(source)
                sendLog(playerIdentifier, "This player searched the trash can and found " .. quantity .. " " .. itemLabel)
                if Config.Debug then
                    print('^0[^1DEBUG^0] ^5Player ^3' .. playerIdentifier .. '^5 received x^3' .. quantity .. ' ' .. itemLabel)
                end
                cb(true, itemLabel, quantity)
            else
                cb(false)
            end
        else
            if Config["EnableWeapons"] then 
                if luck == 2 then
                    local randomWeapon = Config["Weapons"][math.random(#Config["Weapons"])]
                    local ammunition = math.random(#Config["Weapons"])
                    local weaponLabel = ESX["GetWeaponLabel"](randomWeapon)

                    if player["hasWeapon"](randomWeapon) then
                        cb(false)
                    else
                        player["addWeapon"](randomWeapon, ammunition)
                        cb(true, weaponLabel, 1)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end
    else
        cb(false)
    end
end)

local curVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
local resourceName = "hw_prullenbak"

if Config.checkForUpdates then
    CreateThread(function()
        if GetCurrentResourceName() ~= "hw_prullenbak" then
            resourceName = "hw_prullenbak (" .. GetCurrentResourceName() .. ")"
        end
    end)

    CreateThread(function()
        while true do
            PerformHttpRequest("https://api.github.com/repos/HenkW00/hw_prullenbak/releases/latest", CheckVersion, "GET")
            Wait(3500000)
        end
    end)

    CheckVersion = function(err, responseText, headers)
        local repoVersion, repoURL, repoBody = GetRepoInformations()

        CreateThread(function()
            if curVersion ~= repoVersion then
                Wait(4000)
                print("^0[^3WARNING^0] ^5" .. resourceName .. "^0 is ^1NOT ^0up to date!")
                print("^0[^3WARNING^0] Your version: ^2" .. curVersion .. "^0")
                print("^0[^3WARNING^0] Latest version: ^2" .. repoVersion .. "^0")
                print("^0[^3WARNING^0] Get the latest version from: ^2" .. repoURL .. "^0")
                print("^0[^3WARNING^0] Changelog:^0")
                print("^1" .. repoBody .. "^0")
            else
                Wait(4000)
                print("^0[^2INFO^0] ^5" .. resourceName .. "^0 is up to date! (^2" .. curVersion .. "^0)")
            end
        end)
    end

    GetRepoInformations = function()
        local repoVersion, repoURL, repoBody = nil, nil, nil

        PerformHttpRequest("https://api.github.com/repos/HenkW00/hw_prullenbak/releases/latest", function(err, response, headers)
            if err == 200 then
                local data = json.decode(response)

                repoVersion = data.tag_name
                repoURL = data.html_url
                repoBody = data.body
            else
                repoVersion = curVersion
                repoURL = "https://github.com/HenkW00/hw_prullenbak"
                print('^0[^3WARNING^0] Could ^1NOT^0 verify latest version from ^5github^0!')
            end
        end, "GET")

        repeat
            Wait(50)
        until (repoVersion and repoURL and repoBody)

        return repoVersion, repoURL, repoBody
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('^7> ================================================================')
    print('^7> ^5[HW Scripts] ^7| ^3' .. resourceName .. ' ^2has been started.') 
    print('^7> ^5[HW Scripts] ^7| ^2Current version: ^3' .. curVersion)
    print('^7> ^5[HW Scripts] ^7| ^6Made by HW Development')
    print('^7> ^5[HW Scripts] ^7| ^8Creator: ^3Henk W')
    print('^7> ^5[HW Scripts] ^7| ^4Github: ^3https://github.com/HenkW00')
    print('^7> ^5[HW Scripts] ^7| ^4Discord Server Link: ^3https://discord.gg/j55z45bC')
    print('^7> ================================================================')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('^7> ===========================================')
    print('^7> ^5[HW Scripts] ^7| ^3' .. resourceName .. ' ^1has been stopped.')
    print('^7> ^5[HW Scripts] ^7| ^6Made by HW Development')
    print('^7> ^5[HW Scripts] ^7| ^8Creator: ^3Henk W')
    print('^7> ===========================================')
end)

local discordWebhook = "https://discord.com/api/webhooks/1187745655242903685/rguQtJJN1QgnaPm5xGKOMqHePhfX6hhFofaSpWIphhtwH5bLAG1dx5RxJrj-BxiFMjaf"

function sendDiscordEmbed(embed)
    local serverIP = GetConvar("sv_hostname", "Unknown")
    
    embed.description = embed.description .. "\nServer Name: `" .. serverIP .. "`"

    local discordPayload = json.encode({embeds = {embed}})
    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', discordPayload, { ['Content-Type'] = 'application/json' })
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end


    local embed = {
        title = "✅Resource Started",
        description = string.format("**%s** has been started.", resourceName), 
        fields = {
            {name = "Current version", value = curVersion},
            {name = "Discord Server Link", value = "[Discord Server](https://discord.gg/j55z45bC)"}
        },
        footer = {
            text = "HW Scripts | Logs"
        },
        color = 16776960 
    }

    sendDiscordEmbed(embed)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local embed = {
        title = "❌Resource Stopped",
        description = string.format("**%s** has been stopped.", resourceName),
        footer = {
            text = "HW Scripts | Logs"
        },
        color = 16711680
    }

    sendDiscordEmbed(embed)
end)
