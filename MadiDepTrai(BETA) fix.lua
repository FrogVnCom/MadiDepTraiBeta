--// Load UI Library (OrionLib) – an toàn và phổ biến
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

--// Tạo cửa sổ chính
local Window = OrionLib:MakeWindow({
	Name = "MadiDepZai (BETA)",
	HidePremium = false,
	IntroEnabled = false,
	SaveConfig = false,
	ConfigFolder = "MadiFlyConfig"
})

--// Fly biến & cài đặt
local flySpeed = 50
local flying = false
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

--// Fly Logic
local function StartFlying()
	local cam = workspace.CurrentCamera
	RunService:BindToRenderStep("Flying", Enum.RenderPriority.Character.Value, function()
		if flying then
			local direction = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then direction += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then direction -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then direction -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then direction += cam.CFrame.RightVector end
			if direction.Magnitude > 0 then
				HRP.Velocity = direction.Unit * flySpeed
			else
				HRP.Velocity = Vector3.zero
			end
		end
	end)
end

--// Phím F để bật/tắt bay
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		flying = not flying
		if flying then
			StartFlying()
			OrionLib:MakeNotification({Name="Fly Mode", Content="Đã bật!", Time=2})
		else
			RunService:UnbindFromRenderStep("Flying")
			HRP.Velocity = Vector3.zero
			OrionLib:MakeNotification({Name="Fly Mode", Content="Đã tắt!", Time=2})
		end
	end
end)

--// Tab Fly
local FlyTab = Window:MakeTab({
	Name = "Fly",
	Icon = "rbxassetid://6034509993",
	PremiumOnly = false
})

FlyTab:AddLabel("Fly Speed")

FlyTab:AddButton({
	Name = "➕ Tăng Tốc",
	Callback = function()
		flySpeed += 10
		OrionLib:MakeNotification({Name="Fly Speed", Content="Speed: "..flySpeed, Time=2})
	end
})

FlyTab:AddButton({
	Name = "➖ Giảm Tốc",
	Callback = function()
		flySpeed = math.max(10, flySpeed - 10)
		OrionLib:MakeNotification({Name="Fly Speed", Content="Speed: "..flySpeed, Time=2})
	end
})

--// Thành tựu góc dưới
OrionLib:MakeNotification({
	Name = "Achievement",
	Content = "Loading...",
	Image = "rbxassetid://7733964649", -- icon hiệu ứng
	Time = 15
})