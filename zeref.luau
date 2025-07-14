-- // ⚠️ Advanced Loader + ESP + AutoHop in One File
local _ENV = (getgenv and getgenv()) or _ENV

-- ✅ Features Toggle
getgenv().AdvancedFeatures = {
    AutoHop = true,
    SmartESP = true,
    MemoryCleaner = true,
    AntiBan = true,
    UIShortcutKey = Enum.KeyCode.F4,
}

-- ✅ Notification Function
local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⚙️ Enhanced Loader",
            Text = msg,
            Duration = 5
        })
    end)
end

-- ✅ Memory Cleaner
task.spawn(function()
    while getgenv().AdvancedFeatures.MemoryCleaner do
        collectgarbage("collect")
        task.wait(10)
    end
end)

-- ✅ SmartESP
if getgenv().AdvancedFeatures.SmartESP then
    local function highlightPlayer(plr)
        if plr == game.Players.LocalPlayer then return end
        local char = plr.Character or plr.CharacterAdded:Wait()
        task.wait(1)
        local highlight = Instance.new("Highlight", char)
        highlight.Name = "SmartESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end

    for _, plr in pairs(game.Players:GetPlayers()) do
        highlightPlayer(plr)
    end

    game.Players.PlayerAdded:Connect(highlightPlayer)
end

-- ✅ AutoHop
if getgenv().AdvancedFeatures.AutoHop then
    task.spawn(function()
        while true do
            task.wait(15)
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Team ~= game.Players.LocalPlayer.Team then
                    notify("⚠️ Enemy Detected - Hopping Servers")
                    local tpService = game:GetService("TeleportService")
                    local placeId = game.PlaceId
                    tpService:Teleport(placeId)
                    return
                end
            end
        end
    end)
end

-- ✅ Load Specific Game Logic (Simplified)
local GameScripts = {
    [2753915549] = "BloxFruits.luau",
    [4442272183] = "BloxFruits.luau",
    [7449423635] = "BloxFruits.luau",
    [10260193230] = "MemeSea.luau",
}

local GameId = GameScripts[game.PlaceId]
if not GameId then
    notify("Unsupported Game")
    return
end

-- ✅ Main Loader
local base = "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/Games/"
local function fetch(path)
    local success, result = pcall(function()
        return game:HttpGet(base .. path)
    end)
    if success then
        notify("✔ Executing: " .. GameId)
        return loadstring(result)()
    else
        notify("❌ Error loading game script.")
    end
end

fetch(GameId)
