local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- 🪶 Fly State
local flying = false
local flySpeed = 50
local moveDir = Vector3.zero
local keysHeld = {}

-- Create BodyVelocity for fly
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
bv.P = 1250
bv.Velocity = Vector3.zero
bv.Parent = hrp

-- 🌟 UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "MadiFlyUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Blur Effect
local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Parent = game:GetService("Lighting")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Header Bar
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
header.BorderSizePixel = 0
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Text = "MadiDepZai (BETA)"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Parent = header

def createHeaderButton(text, color, position)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0, 25, 0, 25)
    btn.Position = position
    btn.Parent = header
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    return btn
end

local closeBtn = createHeaderButton("X", Color3.fromRGB(255, 80, 80), UDim2.new(1, -30, 0.5, -12))
local minimizeBtn = createHeaderButton("-", Color3.fromRGB(255, 200, 0), UDim2.new(1, -60, 0.5, -12))

closeBtn.MouseButton1Click:Connect(function()
	blur:Destroy()
	gui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Sidebar Tabs
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, -30)
sideBar.Position = UDim2.new(0, 0, 0, 30)
sideBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sideBar.BorderSizePixel = 0
sideBar.Parent = mainFrame

local tabBtn = Instance.new("TextButton")
tabBtn.Size = UDim2.new(1, 0, 0, 40)
tabBtn.Position = UDim2.new(0, 0, 0, 10)
tabBtn.Text = "Fly"
tabBtn.Font = Enum.Font.SourceSansBold
tabBtn.TextSize = 20
tabBtn.TextColor3 = Color3.new(1, 1, 1)
tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tabBtn.Parent = sideBar
Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

-- Fly Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -100, 1, -30)
content.Position = UDim2.new(0, 100, 0, 30)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
content.BorderSizePixel = 0
content.Parent = mainFrame

Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)

local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "Fly Speed: " .. flySpeed
speedLabel.Font = Enum.Font.SourceSansSemibold
speedLabel.TextSize = 22
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Size = UDim2.new(1, -20, 0, 40)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.BackgroundTransparency = 1
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = content

local function createAdjustButton(text, posX, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 26
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0, 50, 0, 40)
    btn.Position = UDim2.new(0, posX, 0, 60)
    btn.Parent = content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local plusBtn = createAdjustButton("+", 10, Color3.fromRGB(0, 200, 0))
local minusBtn = createAdjustButton("-", 70, Color3.fromRGB(200, 0, 0))

plusBtn.MouseButton1Click:Connect(function()
	flySpeed += 10
	speedLabel.Text = "Fly Speed: " .. flySpeed
end)

minusBtn.MouseButton1Click:Connect(function()
	flySpeed = math.max(10, flySpeed - 10)
	speedLabel.Text = "Fly Speed: " .. flySpeed
end)

-- Achievement UI (bottom right)
local status = Instance.new("TextLabel")
status.Text = "Loading..."
status.Font = Enum.Font.SourceSansItalic
status.TextSize = 16
status.TextColor3 = Color3.new(1, 1, 1)
status.Size = UDim2.new(0, 180, 0, 30)
status.Position = UDim2.new(1, -190, 1, -40)
status.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
status.BackgroundTransparency = 0.2
status.BorderSizePixel = 0
status.Parent = gui
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 6)

-- ✈️ Fly Movement
local keyMap = {
	[Enum.KeyCode.W] = Vector3.new(0, 0, -1),
	[Enum.KeyCode.S] = Vector3.new(0, 0, 1),
	[Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
	[Enum.KeyCode.D] = Vector3.new(1, 0, 0),
}

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F then
		flying = not flying
	end
	if keyMap[input.KeyCode] then
		keysHeld[input.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if keyMap[input.KeyCode] then
		keysHeld[input.KeyCode] = nil
	end
end)

RunService.RenderStepped:Connect(function()
	if flying then
		moveDir = Vector3.zero
		for key, vec in pairs(keyMap) do
			if keysHeld[key] then
				moveDir += vec
			end
		end
		if moveDir.Magnitude > 0 then
			moveDir = moveDir.Unit
			local cam = workspace.CurrentCamera
			local camDir = (cam.CFrame.RightVector * moveDir.X + cam.CFrame.LookVector * moveDir.Z)
			bv.Velocity = camDir * flySpeed + Vector3.new(0, 0.1, 0)
		else
			bv.Velocity = Vector3.new(0, 0.1, 0)
		end
	else
		bv.Velocity = Vector3.zero
	end
end)