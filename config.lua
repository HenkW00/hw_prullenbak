Config = {
-- Util Settings
    Debug = true,
    Logs = true,
    Webhook = "https://discord.com/api/webhooks/1233946774826385408/oScL4H5FGLr2lGH-_H4DvKOkZIvqsFmsJML-ACBEdYFg8tdP_MzdProkHohsdFBFFxOC",
    
-- Discord Logs
    DiscordBotName = "HW Development",
    DiscordLogTitle = "__🗑️Trash Search🗑️__",
    DiscordEmbedStyle = "rich",
    DiscordLogColour = 0xFfff33,
    DiscordLogFooter = "HW Logs",

-- Script Settings
    EnableWeapons = false,
    SearchTime = 5000, 

    Dumpsters = { 
        "prop_dumpster_01a",
        "prop_dumpster_02a",
        "prop_dumpster_02b",
        "prop_cs_bin_02",
        "prop_bin_01a",
    },

    Items = { 
        { name = "lockpick", minQuantity = 1, maxQuantity = 2 },
        { name = "diamond", minQuantity = 1, maxQuantity = 1 },
        { name = "copper", minQuantity = 1, maxQuantity = 3 },
        { name = "steel", minQuantity = 1, maxQuantity = 2 },
        { name = "aluminium", minQuantity = 1, maxQuantity = 3 },
        { name = "plastic", minQuantity = 1, maxQuantity = 2 },
        { name = "iron", minQuantity = 1, maxQuantity = 1 },
        { name = "sandwich", minQuantity = 1, maxQuantity = 2 },
    },

    Weapons = { 
        "weapon_bottle"
    }
}

-- Locale strings
Strings = { 
    ["Search"] = "Druk [~g~E~s~] om te zoeken",
    ["Searched"] = "Je hebt deze prullenbak al doorzocht!",
    ["Found"] = "Je vond ",
    ["Searching"] = "Zoeken...",
    ["Nothing"] = "Je hebt niks gevonden...",
    ["Vehicle"] = "You are not allowed to search while in a vehicle!"
}
