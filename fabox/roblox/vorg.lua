-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Variables
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "VorgFaBoxBeta"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local currentHitboxVisual = nil
local football = nil
local hitbox = nil
local heartbeatConnection = nil

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local borderEffect = Instance.new("Frame")
borderEffect.Name = "BorderEffect"
borderEffect.Size = UDim2.new(1, 10, 1, 10)
borderEffect.Position = UDim2.new(0, -5, 0, -5)
borderEffect.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
borderEffect.BackgroundTransparency = 0.8
borderEffect.BorderSizePixel = 0
borderEffect.ZIndex = -1
borderEffect.Parent = mainFrame

coroutine.wrap(function()
    local angle = 0
    while true do
        angle = (angle + 2) % 360
        borderEffect.BackgroundColor3 = Color3.fromHSV(angle/360, 0.8, 1)
        task.wait(0.016)
    end
end)()

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleBar.BackgroundTransparency = 0.5
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "Vorg FaBox Beta"
titleText.TextColor3 = Color3.fromRGB(0, 255, 200)
titleText.Font = Enum.Font.SciFi
titleText.TextSize = 18
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar
Ñ
local widthLabel = Instance.new("TextLabel")
widthLabel.Name = "WidthLabel"
widthLabel.Size = UDim2.new(0.8, 0, 0, 25)
widthLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
widthLabel.Text = "Hitbox Width:"
widthLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
widthLabel.TextXAlignment = Enum.TextXAlignment.Left
widthLabel.BackgroundTransparency = 1
widthLabel.Font = Enum.Font.GothamBold
widthLabel.Parent = mainFrame

local widthBox = Instance.new("TextBox")
widthBox.Name = "WidthBox"
widthBox.Size = UDim2.new(0.3, 0, 0, 25)
widthBox.Position = UDim2.new(0.7, 0, 0.2, 0)
widthBox.PlaceholderText = "5"
widthBox.Text = "5"
widthBox.TextColor3 = Color3.fromRGB(255, 255, 255)
widthBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
widthBox.BorderSizePixel = 0
widthBox.Font = Enum.Font.Code
widthBox.Parent = mainFrame

local heightLabel = widthLabel:Clone()
heightLabel.Name = "HeightLabel"
heightLabel.Position = UDim2.new(0.1, 0, 0.35, 0)
heightLabel.Text = "Hitbox Height:"
heightLabel.Parent = mainFrame

local heightBox = widthBox:Clone()
heightBox.Name = "HeightBox"
heightBox.Position = UDim2.new(0.7, 0, 0.35, 0)
heightBox.Parent = mainFrame

local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(0.6, 0, 0, 40)
applyButton.Position = UDim2.new(0.2, 0, 0.6, 0)
applyButton.Text = "APPLY CHANGES"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.Font = Enum.Font.SciFi
applyButton.TextSize = 16
applyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
applyButton.BorderSizePixel = 0
applyButton.Parent = mainFrame

applyButton.MouseEnter:Connect(function()
    TweenService:Create(applyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
end)

applyButton.MouseLeave:Connect(function()
    TweenService:Create(applyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
end)

local dragging = false
local dragStartPos = Vector2.new(0, 0)
local frameStartPos = UDim2.new()

local function updateFramePosition(input)
    local delta = input.Position - dragStartPos
    mainFrame.Position = UDim2.new(
        frameStartPos.X.Scale,
        math.clamp(frameStartPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - mainFrame.AbsoluteSize.X),
        frameStartPos.Y.Scale,
        math.clamp(frameStartPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - mainFrame.AbsoluteSize.Y)
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
        frameStartPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateFramePosition(input)
    end
end)

local function createHitboxVisual()
    -- Cleanup previous visual
    if currentHitboxVisual then
        currentHitboxVisual:Destroy()
        currentHitboxVisual = nil
    end

    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end

    -- Find football and hitbox
    football = workspace:FindFirstChild("Football")
    if not football then
        warn("Football not found!")
        return
    end
    
    hitbox = football:FindFirstChild("Hitbox")
    if not hitbox then
        warn("Hitbox not found in Football!")
        return
    end

    -- Create visual part
    currentHitboxVisual = Instance.new("Part")
    currentHitboxVisual.Name = "FaBoxVisual"
    currentHitboxVisual.Size = hitbox.Size
    currentHitboxVisual.Transparency = 0.7
    currentHitboxVisual.Color = Color3.fromRGB(0, 150, 255)
    currentHitboxVisual.Material = Enum.Material.Neon
    currentHitboxVisual.Anchored = true
    currentHitboxVisual.CanCollide = false
    currentHitboxVisual.CastShadow = false

    -- Add outline effect
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Top
    surfaceGui.AlwaysOnTop = true
    surfaceGui.Parent = currentHitboxVisual
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    frame.Parent = surfaceGui

    -- Sync with hitbox
    local function updateVisual()
        if currentHitboxVisual and hitbox then
            currentHitboxVisual.Size = hitbox.Size
            currentHitboxVisual.Position = hitbox.Position
            currentHitboxVisual.Orientation = hitbox.Orientation
        end
    end

    heartbeatConnection = RunService.Heartbeat:Connect(updateVisual)
    currentHitboxVisual.Parent = workspace
end

local function applyChanges()
    local width = tonumber(widthBox.Text) or 5
    local height = tonumber(heightBox.Text) or 5

    football = workspace:FindFirstChild("Football")
    if not football then
        warn("Football not found!")
        return
    end

    hitbox = football:FindFirstChild("Hitbox")
    if not hitbox then
        warn("Hitbox not found!")
        return
    end


    hitbox.Size = Vector3.new(width, height, width)
    

    createHitboxVisual()
    
   
    applyButton.Text = "CHANGES APPLIED!"
    task.wait(0.8)
    applyButton.Text = "APPLY CHANGES"
end

applyButton.MouseButton1Click:Connect(applyChanges)


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.H then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            createHitboxVisual()
        elseif currentHitboxVisual then
            currentHitboxVisual:Destroy()
            currentHitboxVisual = nil
        end
    end
end)

-- Initialize
gui.Parent = player:WaitForChild("PlayerGui")
          createHitboxVisual()
