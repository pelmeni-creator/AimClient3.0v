--[[
    Aim Client v3.0 - Advanced Script with Webhook (Educational Purpose)
    Features: ESP, Chams, Aimbot, Keybind Toggle, Fullbright, Webhook Logger
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Webhook Bildirimi Gönderme Fonksiyonu (Eğitim Amaçlı Loglama)
local function SendWebhookLog()
    local webhookUrl = "https://discord.com/api/webhooks/1550937197396492321/bWFcWS2QmK0RsiA5nLbeNh99oB4LZ_uf8QxldcfiZzuH0poeCduAu6NaTgokoIOvgs1W" -- Kendi Webhook adresini buraya yapıştır
    
    if webhookUrl == "https://discord.com/api/webhooks/1550937197396492321/bWFcWS2QmK0RsiA5nLbeNh99oB4LZ_uf8QxldcfiZzuH0poeCduAu6NaTgokoIOvgs1W" then return end
    
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Aim Client v3.0 - Script Executed",
            ["description"] = "A user has successfully executed the script.",
            ["color"] = 65280, -- Yeşil renk
            ["fields"] = {
                {
                    ["name"] = "Username",
                    ["value"] = LocalPlayer.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "User ID",
                    ["value"] = tostring(LocalPlayer.UserId),
                    ["inline"] = true
                },
                {
                    ["name"] = "Game ID",
                    ["value"] = tostring(game.GameId),
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Educational Logging System"
            }
        }}
    }
    
    local encodedData = HttpService:JSONEncode(data)
    
    -- Executor destekleyen HTTP istek fonksiyonu
    local requestFunc = syn and syn.request or http and http.request or http_request or request
    
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = encodedData
            })
        end)
    end
end

-- Script açıldığında webhook tetiklenir
task.spawn(SendWebhookLog)

-- Clean up previous UI
if CoreGui:FindFirstChild("AimClientV3") then
    CoreGui.AimClientV3:Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimClientV3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame (Modern & Big UI)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.Size = UDim2.new(0, 520, 0, 440)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Top Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -15, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Aim Client v3.0 | Educational Panel"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Container for Toggles
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 15, 0, 55)
Container.Size = UDim2.new(1, -30, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 1.4, 0)
Container.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Settings Table
local Settings = {
    ESPName = false,
    ESPHealth = false,
    Chams = false,
    Aimbot = false,
    Fullbright = false
}

-- UI Toggle Keybind (Right Shift)
local UIHidden = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        UIHidden = not UIHidden
        MainFrame.Visible = not UIHidden
    end
end)

-- Button Creator Function (English)
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 14
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. " : ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Text = name .. " : OFF"
        end
        callback(state)
    end)
    return btn
end

-- Controls
CreateButton("Name ESP", function(v) Settings.ESPName = v end)
CreateButton("Health Bar ESP", function(v) Settings.ESPHealth = v end)
CreateButton("Chams (Highlight)", function(v) Settings.Chams = v end)
CreateButton("Aimbot (Hold Right-Click)", function(v) Settings.Aimbot = v end)
CreateButton("Fullbright (Night Vision)", function(v) 
    Settings.Fullbright = v 
    Lighting.Brightness = v and 2 or 1
    Lighting.ClockTime = v and 14 or 12
    Lighting.GlobalShadows = not v
end)

-- Info Footer
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = Container
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(1, 0, 0, 50)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "Info: Press [Right Shift] to hide/show UI. Hold [Right Mouse Button] for Aimbot."
InfoLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
InfoLabel.TextSize = 12
InfoLabel.TextWrapped = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ESP Storage Cache
local espCache = {}

local function setupESP(player)
    if player == LocalPlayer then return end
    
    local bg = Instance.new("BillboardGui")
    bg.Name = "ESP_Container"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 130, 0, 60)
    bg.StudsOffset = Vector3.new(0, 2.5, 0)
    
    local nameLab = Instance.new("TextLabel")
    nameLab.Name = "NameLabel"
    nameLab.Parent = bg
    nameLab.BackgroundTransparency = 1
    nameLab.Size = UDim2.new(1, 0, 0, 20)
    nameLab.Font = Enum.Font.GothamBold
    nameLab.Text = player.Name
    nameLab.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLab.TextSize = 13
    nameLab.TextStrokeTransparency = 0.3
    nameLab.Visible = false
    
    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBg"
    healthBg.Parent = bg
    healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBg.BorderSizePixel = 0
    healthBg.Position = UDim2.new(0.15, 0, 0, 22)
    healthBg.Size = UDim2.new(0.7, 0, 0, 5)
    healthBg.Visible = false
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Parent = healthBg
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    healthBar.BorderSizePixel = 0
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    
    espCache[player] = bg
end

Players.PlayerAdded:Connect(setupESP)
for _, p in ipairs(Players:GetPlayers()) do setupESP(p) end

Players.PlayerRemoving:Connect(function(player)
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end
end)

-- Main Execution Loop (Optimized for performance and compatibility)
RunService.RenderStepped:Connect(function()
    local isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local closestTarget = nil
    local shortestDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            -- ESP Render Update
            local cache = espCache[player]
            if cache and head then
                cache.Parent = (Settings.ESPName or Settings.ESPHealth) and head or nil
                cache.NameLabel.Visible = Settings.ESPName
                cache.HealthBg.Visible = Settings.ESPHealth
                
                if hum and hum.MaxHealth > 0 then
                    cache.HealthBg.HealthBar.Size = UDim2.new(math.clamp(hum.Health / hum.MaxHealth, 0, 1), 0, 1, 0)
                end
            end
            
            -- Chams (Highlight) Manager
            if Settings.Chams then
                if not char:FindFirstChild("AimClientHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "AimClientHighlight"
                    hl.Parent = char
                    hl.FillColor = Color3.fromRGB(255, 40, 40)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                end
            else
                if char:FindFirstChild("AimClientHighlight") then
                    char.AimClientHighlight:Destroy()
                end
            end
            
            -- Aimbot Target Resolver
            if Settings.Aimbot and isAiming and hum and hum.Health > 0 and head then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mouseLoc = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLoc).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = head
                    end
                end
            end
        end
    end
    
    -- Aimbot Lock Execution
    if Settings.Aimbot and isAiming and closestTarget then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
    end
end)

print("Aim Client v3.0 Loaded Successfully!")
