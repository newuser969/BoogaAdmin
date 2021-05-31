-- BoogaAdmin:
-- An open source project for the game BOOGA BOOGA (https://www.roblox.com/games/4787629450/MAG-STICK-BOOGA-BOOGA-CLASSIC) on roblox.
-- Created by SecretSupply#6929

-- Enjoy. The script only works for Synapse X.
-- If you don't use Synapse X, some features might not work.

--[[ Services ]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--[[ Variables ]]--

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local PlayerFlying, flyKeyDown, flyKeyUp = false, nil, nil

local Admin = {
	Prefix = Enum.KeyCode.Minus,
	
	Keys = {
		Pickup = Enum.KeyCode.LeftBracket
	},
	
	OpenBarPosition = UDim2.fromScale(0.5, 0.97),
	ClosedBarPosition = UDim2.fromScale(0.5, 1.15),
	
	Commands = {},
	CommandLoops = {},
	
	Connections = {},
	
	CurrentlyTeleporting = false,
	CurrentlyKilling = false
}

--[[ Functions ]]--

function Admin:AddCommand(name, aliases, func)
	return table.insert(
		Admin.Commands,
		{
			Name = name,
			Aliases = aliases,
			Function = func
		}
	)
end

function Admin:GetCommand(name)
	if not name or name == "" then return end
	name = name:lower()
	for _, Command in ipairs(Admin.Commands) do
		if Command.Name:lower() == name then
			return Command
		end
		for __, alias in ipairs(Command.Aliases) do
			if alias:lower() == name then
				return Command
			end
		end
	end
end

function Admin:CreateGui()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Name = "BoogaAdmin"
	ScreenGui.Parent = PlayerGui
	pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end)
	
	local CommandBar = Instance.new("Frame")
	CommandBar.Name = "CommandBar"
	CommandBar.AnchorPoint = Vector2.new(0.5, 1)
	CommandBar.Size = UDim2.new(0, 538, 0, 28)
	CommandBar.Position = Admin.ClosedBarPosition
	CommandBar.BorderSizePixel = 0
	CommandBar.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
	CommandBar.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = CommandBar

	local Shadow = Instance.new("Folder")
	Shadow.Name = "Shadow"
	Shadow.Parent = CommandBar

	local AmbientShadow = Instance.new("ImageLabel")
	AmbientShadow.Name = "AmbientShadow"
	AmbientShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	AmbientShadow.ZIndex = 0
	AmbientShadow.Size = UDim2.new(1, 5, 1, 5)
	AmbientShadow.BackgroundTransparency = 1
	AmbientShadow.Position = UDim2.new(0.5, 0, 0.5, 3)
	AmbientShadow.BorderSizePixel = 0
	AmbientShadow.ScaleType = Enum.ScaleType.Slice
	AmbientShadow.ImageTransparency = 0.8
	AmbientShadow.Image = "rbxassetid://1316045217"
	AmbientShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	AmbientShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	AmbientShadow.Parent = Shadow

	local PenumbraShadow = Instance.new("ImageLabel")
	PenumbraShadow.Name = "PenumbraShadow"
	PenumbraShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	PenumbraShadow.ZIndex = 0
	PenumbraShadow.Size = UDim2.new(1, 18, 1, 18)
	PenumbraShadow.BackgroundTransparency = 1
	PenumbraShadow.Position = UDim2.new(0.5, 0, 0.5, 1)
	PenumbraShadow.BorderSizePixel = 0
	PenumbraShadow.ScaleType = Enum.ScaleType.Slice
	PenumbraShadow.ImageTransparency = 0.88
	PenumbraShadow.Image = "rbxassetid://1316045217"
	PenumbraShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	PenumbraShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	PenumbraShadow.Parent = Shadow

	local UmbraShadow = Instance.new("ImageLabel")
	UmbraShadow.Name = "UmbraShadow"
	UmbraShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	UmbraShadow.ZIndex = 0
	UmbraShadow.Size = UDim2.new(1, 10, 1, 10)
	UmbraShadow.BackgroundTransparency = 1
	UmbraShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
	UmbraShadow.BorderSizePixel = 0
	UmbraShadow.ScaleType = Enum.ScaleType.Slice
	UmbraShadow.ImageTransparency = 0.86
	UmbraShadow.Image = "rbxassetid://1316045217"
	UmbraShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	UmbraShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	UmbraShadow.Parent = Shadow

	local TextBox = Instance.new("TextBox")
	TextBox.Size = UDim2.new(0.9888476, 0, 1, 0)
	TextBox.BackgroundTransparency = 1
	TextBox.Position = UDim2.new(0.0111524, 0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.PlaceholderColor3 = Color3.fromRGB(211, 211, 211)
	TextBox.FontSize = Enum.FontSize.Size14
	TextBox.TextSize = 14
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.Text = ""
	TextBox.Font = Enum.Font.SourceSansBold
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.PlaceholderText = "command here"
	TextBox.Parent = CommandBar
	
	Admin.Gui = ScreenGui
	Admin.CommandBar = CommandBar
	Admin.CommandShadow = Shadow
	Admin.CommandBox = TextBox
end

function Admin:Notify(text, num)
	if Admin.LastNotification and Admin.LastNotification.Parent ~= nil then
		Admin.LastNotification:Destroy()
	end
	local Notification = Instance.new("Frame")
	Notification.Name = "Notification"
	--Notification.Size = UDim2.new(0, 325, 0, 28)
	Notification.AnchorPoint = Vector2.new(0.5, 0)
	Notification.Position = UDim2.new(0.5, 0, -0.1, 0)
	Notification.BorderSizePixel = 0
	Notification.BackgroundColor3 = Color3.fromRGB(46, 46, 46)

	local Shadow = Instance.new("Folder")
	Shadow.Name = "Shadow"
	Shadow.Parent = Notification

	local AmbientShadow = Instance.new("ImageLabel")
	AmbientShadow.Name = "AmbientShadow"
	AmbientShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	AmbientShadow.ZIndex = 0
	AmbientShadow.Size = UDim2.new(1, 5, 1, 5)
	AmbientShadow.BackgroundTransparency = 1
	AmbientShadow.Position = UDim2.new(0.5, 0, 0.5, 3)
	AmbientShadow.BorderSizePixel = 0
	AmbientShadow.ScaleType = Enum.ScaleType.Slice
	AmbientShadow.ImageTransparency = 0.8
	AmbientShadow.Image = "rbxassetid://1316045217"
	AmbientShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	AmbientShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	AmbientShadow.Parent = Shadow

	local PenumbraShadow = Instance.new("ImageLabel")
	PenumbraShadow.Name = "PenumbraShadow"
	PenumbraShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	PenumbraShadow.ZIndex = 0
	PenumbraShadow.Size = UDim2.new(1, 18, 1, 18)
	PenumbraShadow.BackgroundTransparency = 1
	PenumbraShadow.Position = UDim2.new(0.5, 0, 0.5, 1)
	PenumbraShadow.BorderSizePixel = 0
	PenumbraShadow.ScaleType = Enum.ScaleType.Slice
	PenumbraShadow.ImageTransparency = 0.88
	PenumbraShadow.Image = "rbxassetid://1316045217"
	PenumbraShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	PenumbraShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	PenumbraShadow.Parent = Shadow

	local UmbraShadow = Instance.new("ImageLabel")
	UmbraShadow.Name = "UmbraShadow"
	UmbraShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	UmbraShadow.ZIndex = 0
	UmbraShadow.Size = UDim2.new(1, 10, 1, 10)
	UmbraShadow.BackgroundTransparency = 1
	UmbraShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
	UmbraShadow.BorderSizePixel = 0
	UmbraShadow.ScaleType = Enum.ScaleType.Slice
	UmbraShadow.ImageTransparency = 0.86
	UmbraShadow.Image = "rbxassetid://1316045217"
	UmbraShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	UmbraShadow.SliceCenter = Rect.new(10, 10, 118, 118)
	UmbraShadow.Parent = Shadow

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = Notification

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.Position = UDim2.fromScale(0.5, 0.5)
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.FontSize = Enum.FontSize.Size18
	TextLabel.TextSize = 16
	TextLabel.TextWrapped = true
	if (#text >= 55) then
		TextLabel.TextScaled = true
		TextLabel.Size = UDim2.fromScale(0.92, 0.92)
	end
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Text = text
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.Parent = Notification
	
	Notification.Size = UDim2.new(0, 450 + #text, 0, 38)
	
	Notification.Parent = Admin.Gui
	
	Notification:TweenPosition(
		UDim2.new(0.5, 0, 0.03, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Sine,
		0.3
	)
	
	Admin.LastNotification = Notification
	game:GetService("Debris"):AddItem(Notification, (num or 4))
end

local function HasRootPart()
	return (LocalPlayer.Character) and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (true)
end

local function HasHumanoid()
	return (LocalPlayer.Character) and (LocalPlayer.Character:FindFirstChild("Humanoid")) and (true)
end

--local function TeleportTo(CF)
--	if HasRootPart() and typeof(CF) == "CFrame" then
--		for i = 0.01, 1, 0.02 do
--			LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame:Lerp(
--				CF * CFrame.new(0, 2.5, 0),
--				i
--			)
--			wait(i * 2)
--		end
--	end
--end

local function PickupNearbyItems()
	if HasRootPart() and fireproximityprompt then
		local currentPosition = LocalPlayer.Character.HumanoidRootPart.Position

		for _, Item in ipairs(workspace:GetChildren()) do
			local CanPickup = ((Item:FindFirstChild("Pickup") and Item:FindFirstChildOfClass("ProximityPrompt")) and true) or false

			if CanPickup and (Item:IsA("Model") or Item:IsA("BasePart")) then

				local ItemPart = (
					Item:IsA("Model") and (Item.PrimaryPart or Item:FindFirstChild("Reference") or Item:FindFirstChildOfClass("BasePart"))
				) or Item:IsA("BasePart") and Item

				if ItemPart then
					local Magnitude = (currentPosition - ItemPart.Position).Magnitude
					if Magnitude <= 25 then
						fireproximityprompt(Item:FindFirstChildOfClass("ProximityPrompt"))
					end
				end
			end
		end
	end
end

local function TeleportTo(Position)
	local PositionType = typeof(Position)
	if not HasRootPart() or not HasHumanoid() or not Position then return end
	if PositionType ~= "Vector3" and PositionType ~= "CFrame" then return end
	if Admin.CurrentlyTeleporting then return end
	if typeof(Position) == "CFrame" then
		Position = Position.Position
	end
	
	local RootPart = LocalPlayer.Character.HumanoidRootPart
	local Humanoid = LocalPlayer.Character.Humanoid
	local Looking = CFrame.new(RootPart.Position, Position).LookVector
	
	local Magnitude = (RootPart.Position - Position).Magnitude
	local WaitTime = (0.3 / Magnitude) * 3.15
	
	RootPart.Anchored = true
	Admin.CurrentlyTeleporting = true
	
	for a = 0, Magnitude, 2 do
		
		if not Humanoid or not RootPart then
			Admin.CurrentlyTeleporting = false
			break
		end
		
		if Humanoid.Health <= 0 then
			Admin.CurrentlyTeleporting = false
		end
		
		RootPart.CFrame = RootPart.CFrame + (Looking * 2)
		wait(WaitTime)
	end
	
	Admin.CurrentlyTeleporting = false
	RootPart.Anchored = false
end

local function SwingTool(Targets)
	if not Targets then
		return
	end
	
	if typeof(Targets) ~= "table" then
		Targets = {Targets}
	end
	
	for Index, v in ipairs(Targets) do
		if v:IsA("Model") then
			if v:FindFirstChildOfClass("BasePart") then
				Targets[Index] = v:FindFirstChildOfClass("BasePart")
			else
				table.remove(Targets, Index)
			end
		end
	end
	
	ReplicatedStorage.Events.SwingTool:FireServer(
		ReplicatedStorage.RelativeTime.Value,
		Targets
	)
end

local function IsDead(Model)
	if Model then
		if Model:FindFirstChildOfClass("Humanoid") then
			return Model:FindFirstChildOfClass("Humanoid").Health <= 0
		end
	end
end

local function GetTarget(name)
	if not name or typeof(name) ~= "string" or name == "" then
		return
	end
	
	local Name = string.lower(name)
	local ReturnOne = true
	local PlayerList = Players:GetPlayers()
	
	if Name == "all" then
		return (ReturnOne and PlayerList[1]) or PlayerList
	elseif Name == "me" then
		return (ReturnOne and LocalPlayer) or {LocalPlayer}
	elseif Name == "others" then
		local Others = {}
		for _, v in ipairs(PlayerList) do
			if v ~= LocalPlayer then
				table.insert(Others, v)
			end
		end
		return (ReturnOne and Others[1]) or Others
	elseif Name == "random" then
		local Return = PlayerList[math.random(1, #PlayerList)]
		return (ReturnOne and Return) or {Return}
	else
		local Returns = {}
		for _, v in ipairs(PlayerList) do
			if string.sub(string.lower(v.Name), 1, #name) == name then
				table.insert(Returns, v)
			end
		end
		return (ReturnOne and Returns[1]) or Returns
	end
end

local function Fly(vfly)
	if not HasRootPart() or not HasHumanoid() then return end
	local Flying_Mouse = LocalPlayer:GetMouse()
	local QEfly = true
	local iyflyspeed = 1
	local vehicleflyspeed = 1
	
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = LocalPlayer.Character.HumanoidRootPart
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		PlayerFlying = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not PlayerFlying
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = Flying_Mouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = Flying_Mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

local function Unfly()
	PlayerFlying = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

--[[ Main ]]--

Admin.PrefixString = UserInputService:GetStringForKeyCode(Admin.Prefix)

Admin:CreateGui()

table.insert(Admin.Connections, LocalPlayer.Chatted:Connect(function(message)
	if message:sub(1, 1) == Admin.PrefixString or message:sub(4, 4) == Admin.PrefixString then
		local args = string.split(
			((message:sub(1, 1) == Admin.PrefixString) and message:sub(2)) or message:sub(5),
			" "
		)
		local cmd = Admin:GetCommand(args[1])
		if cmd then
			table.remove(args, 1)
			cmd.Function(
				args,
				message
			)
		end
	end
end))

Admin.CommandBox.FocusLost:Connect(function()
	Admin.CommandBar:TweenPosition(
		Admin.ClosedBarPosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Sine,
		0.3
	)
	local text = Admin.CommandBox.Text
	local args = string.split(
		text,
		" "
	)
	local cmd = Admin:GetCommand(args[1])
	if cmd then
		table.remove(args, 1)
		cmd.Function(
			args,
			text
		)
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe then
		if input.KeyCode == Admin.Prefix then
			-- enable commandbar
			Admin.CommandBar:TweenPosition(
				Admin.OpenBarPosition,
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Sine,
				0.3
			)
			RunService.RenderStepped:Wait()
			Admin.CommandBox:CaptureFocus()
		elseif input.KeyCode == Admin.Keys.Pickup then
			PickupNearbyItems()
		end
	end
end)

Admin:AddCommand("waterwalker", {"waterwalk"}, function(arguments)
	if getconnections then
		for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BodyGyro") then
				v:Destroy()
			end
		end
		for _, connection in ipairs(getconnections(RunService.RenderStepped)) do
			connection:Disable()
		end
	end
end)

Admin:AddCommand("speed", {"tspeed", "togglespeed"}, function(arguments)
	local speed = tonumber(arguments[1]) or 1.5
	if not Admin.CommandLoops["Speed"] then
		Admin.CommandLoops["Speed"] = false
	end
	Admin.CommandLoops["Speed"] = not Admin.CommandLoops["Speed"]
	while Admin.CommandLoops["Speed"] do
		if HasRootPart() and HasHumanoid() then
			if LocalPlayer.Character.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
				LocalPlayer.Character.HumanoidRootPart.CFrame = (LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * speed)
			end
			RunService.RenderStepped:Wait()
		else
			Admin.CommandLoops["Speed"] = false
			break
		end
	end
end)

Admin:AddCommand("untspeed", {"unspeed"}, function(arguments)
	Admin.CommandLoops["Speed"] = false
end)

Admin:AddCommand("rejoin", {"rj"}, function(arguments)
	local placeId = game.PlaceId
	local jobId = game.JobId
	game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
end)

Admin:AddCommand("view", {}, function(arguments)
	local Target = GetTarget(arguments[1])
	
	if Target and Target.Character and Target.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = Target.Character.Humanoid
	end
end)

Admin:AddCommand("stopadmin", {}, function(arguments)
	Admin.Commands = {}
	for _, v in pairs(Admin.Connections) do
		v:Disconnect()
	end
	for _, v in pairs(Admin.CommandLoops) do
		Admin.CommandLoops[_] = false
	end
	Admin.CommandLoops = nil
	Admin.Commands = nil
	Admin.ClosedBarPosition = nil
	Admin.CommandBar = nil
	Admin.CommandShadow = nil
	Admin.Prefix, Admin.PrefixString = nil, nil
	Admin.CurrentlyTeleporting = nil
	Admin.LastNotification = nil
	Admin.OpenBarPosition = nil
	Admin.Gui:Destroy()
	Admin.Gui = nil
end)

Admin:AddCommand("unview", {}, function(arguments)
	if HasHumanoid() then
		workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
	end
end)

Admin:AddCommand("clicktp", {}, function(arguments)
	if Admin.Commands["ClickTeleport"] then
		Admin.Commands["ClickTeleport"]:Disconnect()
	end
	local Mouse = LocalPlayer:GetMouse()
	Admin.Commands["ClickTeleport"] = UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and (input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)) then
			if HasRootPart() then
				
				local UnitRay = Mouse.UnitRay
				local Result = workspace:Raycast(UnitRay.Origin, UnitRay.Direction * 500)
				
				if Result then
					local Position = Result.Position
					LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Position) * CFrame.new(0, 2.5, 0)
				end
			end
		end
	end)
end)

Admin:AddCommand("unclicktp", {}, function(arguments)
	if Admin.Commands["ClickTeleport"] then
		Admin.Commands["ClickTeleport"]:Disconnect()
	end
end)

Admin:AddCommand("place", {"placestructure"}, function(arguments)
	local amount = tonumber(arguments[1])
	if not amount then
		Admin:Notify("[place command]: First argument must be amount", 3)
		return
	end
	if not HasRootPart() or not HasHumanoid() then return end
	table.remove(arguments, 1)
	local name = table.concat(arguments, " ")
	
	local CF = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(
		0,
		-(LocalPlayer.Character.HumanoidRootPart.Size.Y / 2),
		-6
	)
	for i = 1, amount do
		ReplicatedStorage.Events.PlaceStructure:FireServer(
			name,
			CF,
			0
		)
	end
end)

Admin:AddCommand("plant", {"placeplants"}, function(arguments)
	if not HasRootPart() or not HasHumanoid() then return end
	
	local toPlant = "Bloodfruit"
	if arguments[1] then
		toPlant = table.concat(arguments, " ")
	end
	
	local Position = LocalPlayer.Character.HumanoidRootPart.Position
	for _, v in pairs(workspace.Deployables:GetChildren()) do
		if v.Name == "Plant Box" and (Position - v.PrimaryPart.Position).Magnitude < 50 then
			ReplicatedStorage.Events.InteractStructure:FireServer(v, toPlant)
		end
	end
end)

Admin:AddCommand("surround", {}, function(arguments)
	local Target = GetTarget(arguments[1])
	local Height = tonumber(arguments[2]) or 5
	
	if not HasRootPart() or not HasHumanoid() or not Target or not Target.Character or not Target.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local Start = Target.Character.HumanoidRootPart.CFrame
	
	LocalPlayer.Character.HumanoidRootPart.CFrame = Start
	
	local function PlaceChest(CF)
		return ReplicatedStorage.Events.PlaceStructure:FireServer(
			"Chest",
			CF,
			0
		)
	end
	
	local function CreateLayer(LayerY)
		for i = 0, 10, 0.35 do
			PlaceChest(
				Start * CFrame.new(math.sin(i) * 20, (-5) + (LayerY or 0), math.cos(i) * 20)
			)
			wait(0.001)
		end
	end
	
	for x = 1, 5 do
		CreateLayer(x*3)
	end
end)

Admin:AddCommand("kill", {}, function(arguments)
	local Target = GetTarget(arguments[1])
	if not HasRootPart() or not HasHumanoid() or not Target or not Target.Character or not Target.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local Model = Target.Character
	local RootPart = Model.HumanoidRootPart
	
	local lastSwing = 0
	
	if (LocalPlayer.Character.HumanoidRootPart.Position - RootPart.Position).Magnitude >= 85 then
		Admin:Notify("Make sure to be close to the player", 2.2)
		return
	end
	
	if not LocalPlayer.Character:FindFirstChild("Magnetite Stick") then
		Admin:Notify("Please equip a magnetite stick.", 2.5)
		repeat
			wait()
		until not LocalPlayer.Character or LocalPlayer.Character:FindFirstChild("Magnetite Stick")
		wait(0.1)
	end
	
	Admin.CurrentlyKilling = true
	
	local StopKill = false
	
	local UISConnection = UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Enum.KeyCode.P then -- to stop
			StopKill = true
		end
	end)
	
	local Offset = CFrame.new(0.25, 0, (RootPart.Size.Z / 2) + 2.75)
	
	repeat
		if (os.clock() - lastSwing) >= ((1/3)/2) then
			SwingTool({
				RootPart
			})
			lastSwing = os.clock()
		end
		if HasHumanoid() and LocalPlayer.Character.Humanoid.Sit == true then
			LocalPlayer.Character.Humanoid.Sit = false
		end
		if HasRootPart() then
			LocalPlayer.Character.HumanoidRootPart.CFrame = RootPart.CFrame * Offset
		end
		RunService.RenderStepped:Wait()
	until (not Target or not Model or not RootPart) or StopKill or (not LocalPlayer.Character or not HasRootPart() or not HasHumanoid()) or IsDead(LocalPlayer.Character) or IsDead(Model)
	UISConnection:Disconnect()
	Admin.CurrentlyKilling = false
end)

Admin:AddCommand("collect", {"getplants"}, function(arguments)
	if not HasRootPart() or not HasHumanoid() then return end
	if not fireproximityprompt then return end
	
	local Position = LocalPlayer.Character.HumanoidRootPart.Position
	
	for _, v in pairs(workspace:GetChildren()) do
		if string.match(string.lower(v.Name), "bush") and (Position - v.PrimaryPart.Position).Magnitude <= 50 then
			local ProximityPrompt = v:FindFirstChildOfClass("ProximityPrompt")
			if ProximityPrompt then
				fireproximityprompt(ProximityPrompt)
			end
			--ReplicatedStorage.Events.Pickup:FireServer(v)
		end
	end
end)

Admin:AddCommand("fly", {}, function(arguments)
	Unfly()
	wait()
	Fly()
end)

Admin:AddCommand("unfly", {"nofly"}, function(arguments)
	Unfly()
end)

Admin:AddCommand("pickup", {}, function(arguments)
	PickupNearbyItems()
end)

Admin:AddCommand("magplayers", {"getmagplrs", "getmagplayers"}, function(arguments)
	local MagPlayers = {}
	--local MagItems = {
	--	"Magnetite Mask",
	--	"Magnetite Chestplate",
	--	"Magnetite Greaves"
	--}
	-- Removed Character:FindFirstChild("Magnetite Mask") because they would have a hat
	-- as a replacement of it
	for _, v in ipairs(Players:GetPlayers()) do
		if v ~= LocalPlayer then
			local Character = v.Character
			if Character and Character:FindFirstChild("HumanoidRootPart") then
				if Character:FindFirstChild("Magnetite Left Shoulder") and Character:FindFirstChild("Magnetite Right Shoulder") and Character:FindFirstChild("Magnetite Chestplate") and Character:FindFirstChild("Magnetite Greaves Left Foot") and Character:FindFirstChild("Magnetite Greaves Right Foot") and Character:FindFirstChild("Magnetite Greaves Left Leg") and Character:FindFirstChild("Magnetite Greaves Right Leg") then
					table.insert(MagPlayers, v.Name)
				end
			end
		end
	end
	
	local PlayersToLog
	if #MagPlayers <= 0 then
		PlayersToLog = "None"
	else
		PlayersToLog = table.concat(MagPlayers, ", ")
	end
	
	Admin:Notify("Magnetite Players: " .. PlayersToLog, math.floor(
		(3 + (#MagPlayers * 1.2))
	))
end)

Admin:AddCommand("pickupkey", {"pickuphotkey"}, function(arguments)
	local A = arguments[1]
	if #A == 1 then
		local Success_1, B = pcall(function()
			return Enum.KeyCode[A]
		end)
		if B and Success_1 then
			Admin:Notify(
				"Pickup key is now " .. A,
				2.5
			)
			Admin.Keys.Pickup = B
		else
			
			local C = {
				["["] = "LeftBracket",
				["]"] = "RightBracket",
				[","] = "Comma",
				["`"] = "Backquote",
				[")"] = "LeftParenthesis",
				["("] = "RightParenthesis",
				["+"] = "Plus",
				["="] = "Equals",
				["%"] = "Percent",
				["*"] = "Asterisk",
				["^"] = "Caret"
			}
			if C[A] then
				local Success_0, KeyCode = pcall(function()
					return Enum.KeyCode[C[A]]
				end)
				if KeyCode and Success_0 then
					Admin:Notify(
						"Pickup key is now " .. A,
						2.5
					)
					Admin.Keys.Pickup = KeyCode
				end
			end
		end
	end
end)

Admin:AddCommand("serverhop", {"shop"}, function(arguments)
	local Servers = {}
	local server_json = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
	local servers_data = game:GetService("HttpService"):JSONDecode(server_json)
	for _, v in ipairs(servers_data.data) do
		if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
			table.insert(Servers, v.id)
		end
	end
	
	if #Servers > 0 then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)])
	end
end)

Admin:AddCommand("commands", {"cmds"}, function(arguments)
	local CommandCount = #Admin.Commands
	local Commands = Admin.Commands
	local Stuff = {}
	for _, v in ipairs(Commands) do
		table.insert(Stuff, v.Name)
	end
	
	
	Admin:Notify(
		table.concat(Stuff, ", "),
		math.ceil((CommandCount / 3) + 2)
	)
end)

--Admin:AddCommand("notify", {}, function(arguments)
--	local Duration = tonumber(arguments[1])
--	if Duration then
--		table.remove(arguments, 1)
--	else
--		Duration = 2.5
--	end
--	local String = table.concat(arguments, " ")
--	Admin:Notify(
--		String,
--		Duration
--	)
--end)

Admin:Notify(
	"Pickup key is [ (LeftBracket)",
	2.5
)
