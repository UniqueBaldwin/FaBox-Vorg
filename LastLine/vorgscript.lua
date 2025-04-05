local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
if not player then
    error("No se pudo obtener el jugador local.")
end
local playerGui = player:WaitForChild("PlayerGui")
print("Vorg LastLine Beta lanzado")

local gui = Instance.new("ScreenGui")
gui.Name = "OniX LastLine Beta"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local ballGrabDistance = 30
local autoGrabEnabled = false
local grabCooldown = 0.05
local discordLink = "https://discord.gg/SDshmWYCyh"

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 280)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local borderGlow = Instance.new("ImageLabel")
borderGlow.Name = "BorderGlow"
borderGlow.Size = UDim2.new(1, 20, 1, 20)
borderGlow.Position = UDim2.new(0, -10, 0, -10)
borderGlow.Image = "rbxassetid://8992231221"
borderGlow.ImageColor3 = Color3.fromRGB(0, 255, 200)
borderGlow.ScaleType = Enum.ScaleType.Slice
borderGlow.SliceCenter = Rect.new(20, 20, 280, 280)
borderGlow.BackgroundTransparency = 1
borderGlow.ZIndex = -1
borderGlow.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BackgroundTransparency = 0.7
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "Vorg LastLine Beta"
titleText.TextColor3 = Color3.fromRGB(0, 255, 200)
titleText.Font = Enum.Font.SciFi
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local discordButton = Instance.new("TextButton")
discordButton.Name = "DiscordButton"
discordButton.Size = UDim2.new(0, 30, 0, 30)
discordButton.Position = UDim2.new(1, -35, 0, 5)
discordButton.Text = "🡥"
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.Font = Enum.Font.SciFi
discordButton.TextSize = 20
discordButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
discordButton.BorderSizePixel = 0
discordButton.Parent = titleBar

discordButton.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    StarterGui:SetCore("SendNotification", {
        Title = "OniX LastLine Beta",
        Text = "Join our Discord to support us and discover more scripts!",
        Duration = 5
    })
end)

local hitboxContainer = Instance.new("Frame")
hitboxContainer.Name = "HitboxContainer"
hitboxContainer.Size = UDim2.new(1, -20, 0, 80)
hitboxContainer.Position = UDim2.new(0, 10, 0, 40)
hitboxContainer.BackgroundTransparency = 1
hitboxContainer.Parent = mainFrame

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Name = "SizeLabel"
sizeLabel.Size = UDim2.new(0.45, 0, 0, 25)
sizeLabel.Position = UDim2.new(0, 0, 0, 0)
sizeLabel.Text = "HitBox Size:"
sizeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.BackgroundTransparency = 1
sizeLabel.Font = Enum.Font.GothamBold
sizeLabel.Parent = hitboxContainer

local sizeBox = Instance.new("TextBox")
sizeBox.Name = "SizeBox"
sizeBox.Size = UDim2.new(0.5, 0, 0, 25)
sizeBox.Position = UDim2.new(0.5, 0, 0, 0)
sizeBox.PlaceholderText = "5"
sizeBox.Text = "5"
sizeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
sizeBox.BorderSizePixel = 1
sizeBox.BorderColor3 = Color3.fromRGB(50, 50, 70)
sizeBox.Font = Enum.Font.Code
sizeBox.Parent = hitboxContainer

local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(1, -20, 0, 40)
applyButton.Position = UDim2.new(0, 10, 0, 130)
applyButton.Text = "APLICAR HITBOX"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.Font = Enum.Font.SciFi
applyButton.TextSize = 16
applyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
applyButton.BorderSizePixel = 0
applyButton.Parent = mainFrame

local autoGrabToggle = Instance.new("TextButton")
autoGrabToggle.Name = "AutoGrabToggle"
autoGrabToggle.Size = UDim2.new(1, -20, 0, 40)
autoGrabToggle.Position = UDim2.new(0, 10, 0, 180)
autoGrabToggle.Text = "Auto Grab (GK): OFF"
autoGrabToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoGrabToggle.Font = Enum.Font.SciFi
autoGrabToggle.TextSize = 16
autoGrabToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
autoGrabToggle.BorderSizePixel = 0
autoGrabToggle.Parent = mainFrame

local mobileToggle = Instance.new("TextButton")
mobileToggle.Name = "MobileToggle"
mobileToggle.Size = UDim2.new(0, 50, 0, 50)
mobileToggle.Position = UDim2.new(0, 10, 0, 10)
mobileToggle.Text = "✱"
mobileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileToggle.Font = Enum.Font.Arial
mobileToggle.TextSize = 30
mobileToggle.BackgroundColor3 = Color3.fromRGB(0, 80, 140)
mobileToggle.BorderSizePixel = 0
mobileToggle.Visible = (UserInputService:GetPlatform() == Enum.Platform.Android or UserInputService:GetPlatform() == Enum.Platform.IOS)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mobileToggle
mobileToggle.Parent = gui

local function createHitboxVisual(target)
    if not target or not target.Parent or target.Parent.Name ~= "Football" then 
        warn("El objeto 'Hitbox' no está configurado correctamente.")
        return 
    end

    local oldVisual = workspace:FindFirstChild("FaBoxVisual_Football")
    if oldVisual then
        oldVisual:Destroy()
    end

    local visual = Instance.new("Part")
    visual.Name = "FaBoxVisual_Football"
    visual.Size = target.Size
    visual.Transparency = 0.7
    visual.Color = Color3.fromRGB(0, 150, 255)
    visual.Material = Enum.Material.Neon
    visual.Anchored = true
    visual.CanCollide = false
    visual.CastShadow = false

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if visual and target and target.Parent then
            visual.Size = target.Size
            visual.Position = target.Position
            visual.Orientation = target.Orientation
        else
            if connection then connection:Disconnect() end
            visual:Destroy()
        end
    end)

    visual.Parent = workspace
end

local function updateAllHitboxes()
    local existingVisual = workspace:FindFirstChild("FaBoxVisual_Football")
    if existingVisual then
        existingVisual:Destroy()
    end

    local football = workspace:FindFirstChild("Football")
    if football then
        local hitbox = football:FindFirstChild("Hitbox")
        if hitbox then 
            createHitboxVisual(hitbox) 
        end
    end
end

local function applyHitboxChanges()
    local size = tonumber(sizeBox.Text) or 5
    local newSize = Vector3.new(size, size, size)

    local football = workspace:FindFirstChild("Football")
    if not football then
        warn("El objeto 'Football' no existe en el Workspace.")
        return
    end

    local hitbox = football:FindFirstChild("Hitbox")
    if not hitbox then
        hitbox = Instance.new("Part")
        hitbox.Name = "Hitbox"
        hitbox.Parent = football
    end

    hitbox.Size = newSize
    hitbox.Transparency = 1
    hitbox.CanCollide = false
    hitbox.Anchored = false

    updateAllHitboxes()
    applyButton.Text = "¡HITBOX APLICADO!"
    task.wait(0.8)
    applyButton.Text = "APLICAR HITBOX"
end

local function getBall()
    local football = workspace:FindFirstChild("Football")
    if football then
        return football:FindFirstChild("Handle") or football:FindFirstChildOfClass("Part")
    end
end

local function autoGrabUpdate()
    while autoGrabEnabled do
        local character = player.Character
        if not character then
            warn("El jugador no tiene un personaje activo.")
            task.wait(grabCooldown)
            continue
        end

        local ball = getBall()
        if not ball then
            warn("El balón no existe en el Workspace.")
            task.wait(grabCooldown)
            continue
        end

        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then
            warn("El jugador no tiene un HumanoidRootPart.")
            task.wait(grabCooldown)
            continue
        end

        local ballPos = ball.Position
        local distancia = (root.Position - ballPos).Magnitude

        if distancia <= ballGrabDistance then
            local direction = (ballPos - root.Position).Unit
            local targetCFrame = CFrame.new(ballPos - (direction * 2.5), ballPos)
            local _, ySize = ball.Size.Y, root.Size.Y
            targetCFrame = targetCFrame + Vector3.new(0, ySize / 2, 0)
            local lerpFactor = 0.5
            if ball.Velocity.Magnitude > 100 then
                lerpFactor = 0.8
            end
            root.CFrame = targetCFrame:Lerp(root.CFrame, lerpFactor)
            ball.Velocity = Vector3.new(0, 0, 0)
            ball.RotVelocity = Vector3.new(0, 0, 0)
        end

        task.wait(grabCooldown)
    end
end

discordButton.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    StarterGui:SetCore("SendNotification", {
        Title = "Vorg LastLine Beta",
        Text = "Join our Discord to support us and discover more scripts!",
        Duration = 5
    })
end)

applyButton.MouseButton1Click:Connect(applyHitboxChanges)

mobileToggle.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        updateAllHitboxes()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.H then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then updateAllHitboxes() end
    end
end)

autoGrabToggle.MouseButton1Click:Connect(function()
    autoGrabEnabled = not autoGrabEnabled
    autoGrabToggle.Text = autoGrabEnabled and "Auto Grab (GK): ON 🌟" or "Auto Grab (GK): OFF"
    autoGrabToggle.BackgroundColor3 = autoGrabEnabled and Color3.fromRGB(0, 150, 50) or Color3.fromRGB(40, 40, 60)
    if autoGrabEnabled then
        task.spawn(autoGrabUpdate)
    end
end)

updateAllHitboxes()
