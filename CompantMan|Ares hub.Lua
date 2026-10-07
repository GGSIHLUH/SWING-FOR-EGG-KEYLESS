local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("AresHub_UI") then
	PlayerGui.AresHub_UI:Destroy()
end

local _G_AutoSwing = false
local _G_AutoLoot = false
local _G_AutoFarmEgg = false
local _G_AutoHatch = false
local _G_AutoRebirth = false
local _G_AutoTreadmill = false
local _G_AutoPlaceEgg = false
local _G_EspEgg = false

local ScannedEggs = {}
local SelectedEggsMap = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AresHub_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = PlayerGui

local FloatingIcon = Instance.new("ImageButton", ScreenGui)
FloatingIcon.Name = "AresFloatingIcon"
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Position = UDim2.new(0.02, 0, 0.25, 0)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FloatingIcon.Image = "rbxassetid://94158239411156"
FloatingIcon.Active = true
FloatingIcon.Draggable = true

Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(0, 10)
local IconStroke = Instance.new("UIStroke", FloatingIcon)
IconStroke.Thickness = 1.5
IconStroke.Color = Color3.fromRGB(60, 60, 60)

local MainFrame = Instance.new("ImageLabel", ScreenGui)
MainFrame.Name = "AresMainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.Image = "rbxassetid://107592201437230"
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1
MainStroke.Color = Color3.fromRGB(45, 45, 50)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1

local HubTitle = Instance.new("TextLabel", TopBar)
HubTitle.Size = UDim2.new(0, 220, 1, 0)
HubTitle.Position = UDim2.new(0, 15, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "Ares Hub - Swing For Eggs | Free"
HubTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 13
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.TextSize = 14

CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

FloatingIcon.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 38)
ContentFrame.BackgroundTransparency = 1

local LeftColumn = Instance.new("ScrollingFrame", ContentFrame)
LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
LeftColumn.Position = UDim2.new(0, 0, 0, 0)
LeftColumn.BackgroundTransparency = 1
LeftColumn.ScrollBarThickness = 2
LeftColumn.BorderSizePixel = 0

local RightColumn = Instance.new("ScrollingFrame", ContentFrame)
RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
RightColumn.BackgroundTransparency = 1
RightColumn.ScrollBarThickness = 2
RightColumn.BorderSizePixel = 0

local LeftList = Instance.new("UIListLayout", LeftColumn)
LeftList.Padding = UDim.new(0, 6)

local RightList = Instance.new("UIListLayout", RightColumn)
RightList.Padding = UDim.new(0, 6)

local Library = {}

function Library:AddToggle(parent, text, default, callback)
	local ToggleFrame = Instance.new("Frame", parent)
	ToggleFrame.Size = UDim2.new(1, -6, 0, 26)
	ToggleFrame.BackgroundTransparency = 1

	local Label = Instance.new("TextLabel", ToggleFrame)
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 10
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local Switch = Instance.new("TextButton", ToggleFrame)
	Switch.Size = UDim2.new(0, 32, 0, 16)
	Switch.Position = UDim2.new(1, -35, 0.5, -8)
	Switch.BackgroundColor3 = default and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(50, 50, 55)
	Switch.Text = ""

	Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

	local Circle = Instance.new("Frame", Switch)
	Circle.Size = UDim2.new(0, 12, 0, 12)
	Circle.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

	local state = default
	Switch.MouseButton1Click:Connect(function()
		state = not state
		if state then
			Switch.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
			Circle.Position = UDim2.new(1, -14, 0.5, -6)
		else
			Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			Circle.Position = UDim2.new(0, 2, 0.5, -6)
		end
		callback(state)
	end)
end

function Library:AddMultiDropdown(parent, text)
	local DropFrame = Instance.new("Frame", parent)
	DropFrame.Size = UDim2.new(1, -6, 0, 26)
	DropFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
	DropFrame.ClipsDescendants = true
	Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 5)

	local ToggleBtn = Instance.new("TextButton", DropFrame)
	ToggleBtn.Size = UDim2.new(1, 0, 0, 26)
	ToggleBtn.BackgroundTransparency = 1
	ToggleBtn.Text = "  " .. text .. " (0 Selected)"
	ToggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
	ToggleBtn.Font = Enum.Font.Gotham
	ToggleBtn.TextSize = 10
	ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

	local ListHolder = Instance.new("ScrollingFrame", DropFrame)
	ListHolder.Size = UDim2.new(1, 0, 0, 120)
	ListHolder.Position = UDim2.new(0, 0, 0, 26)
	ListHolder.BackgroundTransparency = 1
	ListHolder.ScrollBarThickness = 2
	ListHolder.BorderSizePixel = 0

	local Layout = Instance.new("UIListLayout", ListHolder)
	Layout.Padding = UDim.new(0, 2)

	local isOpen = false
	ToggleBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		DropFrame.Size = UDim2.new(1, -6, 0, isOpen and 150 or 26)
	end)

	local function UpdateText()
		local count = 0
		for _, selected in pairs(SelectedEggsMap) do
			if selected then count = count + 1 end
		end
		ToggleBtn.Text = "  " .. text .. " (" .. tostring(count) .. " Selected)"
	end

	local dropdownObj = {}
	function dropdownObj:Refresh(newList)
		for _, child in pairs(ListHolder:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		for _, item in ipairs(newList) do
			local ItemBtn = Instance.new("TextButton", ListHolder)
			ItemBtn.Size = UDim2.new(1, -4, 0, 20)
			ItemBtn.BackgroundColor3 = SelectedEggsMap[item.Key] and Color3.fromRGB(0, 140, 200) or Color3.fromRGB(18, 20, 25)
			ItemBtn.Text = "  " .. item.DisplayText
			ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
			ItemBtn.Font = Enum.Font.Gotham
			ItemBtn.TextSize = 9
			ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 4)

			ItemBtn.MouseButton1Click:Connect(function()
				SelectedEggsMap[item.Key] = not SelectedEggsMap[item.Key]
				ItemBtn.BackgroundColor3 = SelectedEggsMap[item.Key] and Color3.fromRGB(0, 140, 200) or Color3.fromRGB(18, 20, 25)
				UpdateText()
			end)
		end
		ListHolder.CanvasSize = UDim2.new(0, 0, 0, #newList * 22)
		UpdateText()
	end

	return dropdownObj
end

function Library:AddButton(parent, text, callback)
	local Btn = Instance.new("TextButton", parent)
	Btn.Size = UDim2.new(1, -6, 0, 24)
	Btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
	Btn.Text = text
	Btn.TextColor3 = Color3.fromRGB(240, 240, 240)
	Btn.Font = Enum.Font.GothamMedium
	Btn.TextSize = 10
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

	Btn.MouseButton1Click:Connect(callback)
end

Library:AddToggle(LeftColumn, "Auto Swing", false, function(v) _G_AutoSwing = v end)
Library:AddToggle(LeftColumn, "Auto Farm Selected Eggs", false, function(v) _G_AutoFarmEgg = v end)
Library:AddToggle(LeftColumn, "Auto Loot", false, function(v) _G_AutoLoot = v end)
Library:AddToggle(LeftColumn, "Auto Hatch", false, function(v) _G_AutoHatch = v end)

local MultiEggDropdown = Library:AddMultiDropdown(RightColumn, "Select Eggs")

local function ScanMapForEggs()
	ScannedEggs = {}
	local count = 0

	for _, obj in pairs(Workspace:GetDescendants()) do
		if count >= 300 then break end

		if obj:IsA("ProximityPrompt") then
			local parent = obj.Parent
			local name = parent and parent.Name or "Unknown"
			local lowerName = string.lower(name)

			if string.find(lowerName, "egg") or (parent and parent.Parent and string.find(string.lower(parent.Parent.Name), "egg")) then
				count = count + 1

				local rarity = "Common"
				if parent:FindFirstChild("Rarity") then
					rarity = tostring(parent.Rarity.Value)
				elseif parent:GetAttribute("Rarity") then
					rarity = tostring(parent:GetAttribute("Rarity"))
				else
					for _, rName in ipairs({"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Divine"}) do
						if string.find(name, rName) or string.find(parent.Parent and parent.Parent.Name or "", rName) then
							rarity = rName
							break
						end
					end
				end

				local key = name .. "_" .. tostring(count)
				local displayText = "[" .. rarity .. "] " .. name

				table.insert(ScannedEggs, {
					Key = key,
					Prompt = obj,
					TargetPart = parent:IsA("BasePart") and parent or (parent:IsA("Model") and (parent.PrimaryPart or parent:FindFirstChildOfClass("BasePart"))),
					DisplayText = displayText
				})
			end
		end
	end

	MultiEggDropdown:Refresh(ScannedEggs)
end

Library:AddButton(RightColumn, "🔍 Scan Eggs in Game (Max 300)", function()
	ScanMapForEggs()
end)

Library:AddToggle(RightColumn, "Auto Place Egg", false, function(v) _G_AutoPlaceEgg = v end)
Library:AddToggle(RightColumn, "AFK Treadmill", false, function(v) _G_AutoTreadmill = v end)
Library:AddToggle(RightColumn, "Auto Rebirth", false, function(v) _G_AutoRebirth = v end)
Library:AddToggle(RightColumn, "ESP Egg Target", false, function(v)
	_G_EspEgg = v
	if not v then
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj:FindFirstChild("EggHighlight") then
				obj.EggHighlight:Destroy()
			end
		end
	end
end)

task.spawn(function()
	while task.wait(0.1) do
		if _G_AutoSwing then
			pcall(function()
				local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool then tool:Activate() end
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(0.2) do
		if _G_AutoFarmEgg then
			pcall(function()
				for _, eggData in ipairs(ScannedEggs) do
					if not _G_AutoFarmEgg then break end
					if SelectedEggsMap[eggData.Key] and eggData.Prompt and eggData.Prompt.Parent then
						local char = LocalPlayer.Character
						if char and char:FindFirstChild("HumanoidRootPart") then
							if eggData.TargetPart then
								char.HumanoidRootPart.CFrame = eggData.TargetPart.CFrame * CFrame.new(0, 2, 0)
								task.wait(0.05)
								fireproximityprompt(eggData.Prompt)
							else
								fireproximityprompt(eggData.Prompt)
							end
						end
					end
				end
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(0.3) do
		if _G_AutoLoot then
			pcall(function()
				for _, drop in pairs(Workspace:GetChildren()) do
					if drop:IsA("BasePart") or drop:IsA("Model") then
						local name = string.lower(drop.Name)
						if string.find(name, "loot") or string.find(name, "egg") or string.find(name, "drop") or string.find(name, "gem") then
							if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
								if drop:IsA("Model") then
									drop:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame)
								else
									drop.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
								end
							end
						end
					end
				end
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(1) do
		if _G_EspEgg then
			pcall(function()
				for _, v in pairs(Workspace:GetDescendants()) do
					if v:IsA("BasePart") or v:IsA("Model") then
						if string.find(string.lower(v.Name), "egg") then
							if not v:FindFirstChild("EggHighlight") then
								local hl = Instance.new("Highlight", v)
								hl.Name = "EggHighlight"
								hl.FillColor = Color3.fromRGB(255, 215, 0)
								hl.OutlineColor = Color3.fromRGB(255, 255, 255)
							end
						end
					end
				end
			end)
		end
	end
end)
