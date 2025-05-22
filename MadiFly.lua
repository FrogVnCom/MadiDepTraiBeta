-- Kiểm tra nhân vật sẵn sàng
repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- Tải UI Lib Orion
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
end)

if not success or not OrionLib then
    warn("Không tải được OrionLib")
    return
end

-- UI cửa sổ
local Window = OrionLib:MakeWindow({
    Name = "MadiDepZai (BETA)",
    HidePremium = false,
    IntroEnabled = false,
    SaveConfig = false,
    ConfigFolder = "MadiFlyUI"
})

-- Tab Fly
local FlyTab = Window:MakeTab({
    Name = "Fly",
    Icon = "rbxassetid://7734053494",
    PremiumOnly = false
})

-- Biến Fly
local flySpeed = 50
local flying = false
local Player = game.Players.LocalPlayer
local HRP = Player.Character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Logic Fly
local function Fly()
    RunService:BindToRenderStep("MadiFly", Enum.RenderPriority.Input.Value, function()
        if flying then
            local cam = workspace.CurrentCamera
            local moveVec = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
            HRP.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * flySpeed or Vector3.zero
        end
    end)
end

-- Phím F để bay
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            Fly()
            OrionLib:MakeNotification({Name = "Fly", Content = "Bay đã bật", Time = 2})
        else
            RunService:UnbindFromRenderStep("MadiFly")
            HRP.Velocity = Vector3.zero
            OrionLib:MakeNotification({Name = "Fly", Content = "Bay đã tắt", Time = 2})
        end
    end
end)

-- Nút tăng/giảm speed
FlyTab:AddLabel("Fly Speed")
FlyTab:AddButton({
    Name = "+ Tăng Speed",
    Callback = function()
        flySpeed = flySpeed + 10
        OrionLib:MakeNotification({Name = "Speed", Content = tostring(flySpeed), Time = 1})
    end
})
FlyTab:AddButton({
    Name = "- Giảm Speed",
    Callback = function()
        flySpeed = math.max(10, flySpeed - 10)
        OrionLib:MakeNotification({Name = "Speed", Content = tostring(flySpeed), Time = 1})
    end
})

-- Thành tựu Loading...
OrionLib:MakeNotification({
    Name = "Loading...",
    Content = "Hệ thống đang khởi động",
    Time = 5
})