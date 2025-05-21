-- Load UI Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Tạo cửa sổ chính
local Window = OrionLib:MakeWindow({
    Name = "MadiDepZai (BETA)", 
    HidePremium = false, 
    SaveConfig = false, 
    ConfigFolder = "MadiFlyConfig",
    IntroText = "Welcome to MadiDepZai!",
})

-- Tốc độ bay mặc định
local flySpeed = 50
local flying = false
local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

-- Fly Logic
local function FlyLoop()
    RunService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
        if flying then
            local cam = workspace.CurrentCamera
            local moveVec = Vector3.new()

            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end

            HumanoidRootPart.Velocity = moveVec.Unit * flySpeed
        end
    end)
end

-- Kích hoạt bay bằng phím F
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            FlyLoop()
        else
            RunService:UnbindFromRenderStep("Fly")
            HumanoidRootPart.Velocity = Vector3.zero
        end
    end
end)

-- Tạo tab "Fly"
local FlyTab = Window:MakeTab({
    Name = "Fly",
    Icon = "rbxassetid://7072719330", -- icon mẫu
    PremiumOnly = false
})

-- Hiển thị tốc độ bay
FlyTab:AddLabel("Fly Speed")

-- Giảm tốc độ
FlyTab:AddButton({
    Name = "- Giảm Speed",
    Callback = function()
        flySpeed = math.max(flySpeed - 5, 5)
        OrionLib:MakeNotification({
            Name = "Fly Speed",
            Content = "Giảm còn: "..flySpeed,
            Time = 2
        })
    end
})

-- Tăng tốc độ
FlyTab:AddButton({
    Name = "+ Tăng Speed",
    Callback = function()
        flySpeed = flySpeed + 5
        OrionLib:MakeNotification({
            Name = "Fly Speed",
            Content = "Tăng lên: "..flySpeed,
            Time = 2
        })
    end
})

-- Thành tựu nhỏ góc dưới phải
OrionLib:MakeNotification({
    Name = "Achievement",
    Content = "Loading ...",
    Time = 9999999
})