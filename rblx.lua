--Services and requires
local ClothingInfo = require(game.ReplicatedStorage.Modules.ClothingInfo)
local Shime = require(game.ReplicatedStorage.Modules.Shime)
local TweenService = game:GetService("TweenService")
--local BuyService = game.ReplicatedStorage.RemoteFunctions.BuyClothesCheck -- Used in game
--local addToHotbar = game.ReplicatedStorage.RemoteEvents.AddToHotbar -- Used in game
local debris = game:GetService("Debris")

--Variables
local player = game.Players.LocalPlayer
local OpenProxGUI = game.ReplicatedStorage.RemoteEvents.OpenClothesGUI
local frame = script.Parent.Frame
local ClothingFrame = frame.ClothingFrame
local ArrowButtons = frame.ArrowButtons:GetChildren()
local CloseButton = script.Parent.CloseButton.TextButton
local ClothDispFrame = ClothingFrame.ClothingDisplay
local backgroundBlur = frame.Parent.BackgroundBlur
local ClothesButtons = {}
local ClothingDisTable = {}
local Positions = {}
local Tweening = false
local opened = false

--Functions

local function GetButtons()  -- Gets the buttons in the clothing display frame and puts them in a table
	ClothesButtons = {}
	local buttonIdx = 1
	for _, v in ClothDispFrame:GetChildren() do
		if v:IsA("ImageLabel") then
				ClothesButtons[buttonIdx] = v:FindFirstChildWhichIsA("ImageButton")
				if ClothesButtons[buttonIdx] == nil then --sanity check 
					warn("Nil at index", buttonIdx)
				end
			buttonIdx = buttonIdx + 1
		end
	end
end

GetButtons()

local function DescriptionInfo(ClothFrameDes, EnterExit) -- Creates the description box for the clothing
	if EnterExit == "Enter" then
		for i, v in ClothingInfo do
			if ClothFrameDes.Name == i then
				local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false)
				local endGoal = {Position = UDim2.new(-0.005, 0, -0.179, 0), Rotation = (0.01)} --Rotation set to bypass roblox clipdescendants
				local DescriptionBox = ClothFrameDes:FindFirstChild("InfoFrame")
				local tag = DescriptionBox:FindFirstChild("Tag")
				local tagC = tag:GetChildren()
				DescriptionBox.Tag.Position = UDim2.new(0.48, 0, -0.285, 0)
				DescriptionBox.Tag.Rotation = (-16)
				DescriptionBox.Tag.ImageTransparency = (0)
				for i, v in tagC do
					if v:IsA("TextLabel") then
						v.TextTransparency = (0)
					end
				end
				DescriptionBox.Visible = true
				TweenService:Create(DescriptionBox.Tag, TweenInfo, endGoal):Play()
				DescriptionBox.Tag.ClothesDesc.Text = v.Desc
				DescriptionBox.Tag.ClothesName.Text = v.Name
				DescriptionBox.Tag.ClothesPrice.Text = "$" .. string.format("%.2f", v.Price)
			end
		end
	elseif EnterExit == "Exit" then
		local DescriptionBox = ClothFrameDes:FindFirstChild("InfoFrame")
		DescriptionBox.Visible = false
	end
end

local function AddToHotbar(inWorldClothing)
	for i, v in ClothingInfo do
		if inWorldClothing.Name == i then
			--addToHotbar:FireServer(inWorldClothing, v) -- Used in game
		end
	end
end

--[[local function OnClickEvent(ImageButton, inWorldClothing)   --Used in game useless in showcase
	local decision, typeD = BuyService:InvokeServer(inWorldClothing)

	local infoFrame = ImageButton.Parent:FindFirstChild("InfoFrame")
	local tag = infoFrame:FindFirstChild("Tag")
	local tagC = tag:GetChildren()
	local cantBuyText = Instance.new("TextLabel")
	
	if decision == false then
		if typeD == "Money" then 
			print("Money")
			cantBuyText.Text = "You can't afford this!"
		elseif typeD == "Size" then
			print("Size")
			cantBuyText.Text = "Inventory is full!"
		end
		tag.Visible = false
		print("Yo")
		debris:AddItem(cantBuyText, 0.6)
		cantBuyText.Parent = frame.Parent
		cantBuyText.Position = UDim2.new(0.293, 0, 0.566, 0)
		cantBuyText.Size = UDim2.new(0.423, 0, 0.164, 0)
		cantBuyText.BackgroundTransparency = (1)
		cantBuyText.TextColor3 = Color3.new(1, 0, 0)
		cantBuyText.TextScaled = true
		cantBuyText.Font = Enum.Font.FredokaOne
		task.wait(0.2)
		local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 2, true)
		local goal = {Rotation = (15)}
		local tween = TweenService:Create(cantBuyText, tweenInfo, goal)
		tween:Play()
		tween.Completed:Wait()
		tag.Visible = true
		return
	end
	
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false)
	local goal = {Position = UDim2.new(-0.774, 0,0.17, 0), Rotation = (69), ImageTransparency = (1)}
	local tween = TweenService:Create(tag, tweenInfo, goal)
	tween:Play()
	
	for i, v in tagC do
		if v:IsA("TextLabel") then
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false)
			local goal = {TextTransparency = (1)}
			TweenService:Create(v, tweenInfo, goal):Play()
		end
	end
	
	AddToHotbar(inWorldClothing)
	tween.Completed:Wait()
	ImageButton.Parent:Destroy()
	inWorldClothing:Destroy()
	
	if not ClothDispFrame:FindFirstChildWhichIsA("ImageLabel") then
		frame.Visible = false
		backgroundBlur.Visible = false
		CloseButton.Visible = false
	end
	
end]]

local function DisplayClothingInfo(clothingItem)
	frame.Visible = true
	for i, v in ClothingInfo do
		if clothingItem.Name == i then
			local Template = game.ReplicatedStorage.Templates.Template
			local ClothDisp = Template:Clone()
			local ImageButton = ClothDisp:WaitForChild("ImageButton")
			local shimmer = Shime.new(ClothDisp, 2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
			if v.RarityAsNum >= 4 then
				shimmer:Play() -- Play shimmer if rarity is 4 or higher (rarity is expressed as numbers from low to high)
			end
			ClothDisp.Parent = ClothDispFrame
			ClothDisp.ImageColor3 = v.Color
			ClothDisp.Name = clothingItem.Name
			ImageButton.Image = "rbxassetid://".. v.Image
			
			ImageButton.MouseEnter:Connect(function()
				DescriptionInfo(ImageButton.Parent, "Enter")
			end)
			
			ImageButton.MouseLeave:Connect(function()
				DescriptionInfo(ImageButton.Parent, "Exit")
			end)
			
			ImageButton.MouseButton1Click:Connect(function()
				--OnClickEvent(ImageButton, clothingItem)
				print("Ingame Logic Here")
			end)
			
		end
	end
end

local function calculateMax() -- Calculates max value frame can offset to to prevent overscrolling
	local buttons = {}
	local frameC = ClothDispFrame:GetChildren()
	for i, v in frameC do
		if v:IsA("ImageLabel") then
			table.insert(buttons, v)
		end
	end
	local offsetButton1 = buttons[#buttons - 2] --offset button 1 to calculate from
	local offsetButton2 = buttons[#buttons - 1] --offset button 2 to calculate from
	if offsetButton1 == nil or offsetButton2 == nil then
		return (-1), 1000 --Return when theres less than 4 buttons to stop tweens from happening
	end
	local offset = math.floor(offsetButton1.AbsolutePosition.X - offsetButton2.AbsolutePosition.X)
	local max = offset * (#buttons - 3) --max offset to prevent overscrolling 3rd button so that 3 always stay in frame
	return offset, max
end

local function TweenClothes(dir: string, removed: boolean) -- Tween for clothing
	if Tweening == true then return end
	local offset, max = calculateMax()
	local min = 0
	local failedOffset = 50
	local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, 0)
	local x = ClothDispFrame.Position.X.Offset
	local y = ClothDispFrame.Position.Y.Scale
	if dir == -1 then -- Direction to tween left/right as numbers
		if x + offset < max then -- Tween that goes and scrolls back when out of bounds
			local goal = {Position = UDim2.new(0, x - failedOffset, y, 0)}
			local goal2 = {Position = UDim2.new(0, x, y, 0)}
			local Tween = TweenService:Create(ClothDispFrame, TweenInfo, goal)
			Tween:Play()
			Tweening = true
			Tween.Completed:Wait()
			local Tween2 = TweenService:Create(ClothDispFrame, TweenInfo, goal2)
			Tween2:Play()
			Tween2.Completed:Wait()
			Tweening = false
		else  --Success tween
			local goal = {Position = UDim2.new(0, x + offset, y, 0)}
			local Tween = TweenService:Create(ClothDispFrame, TweenInfo, goal)
			Tween:Play()
			Tweening = true
			Tween.Completed:Wait()
			Tweening = false
		end
	elseif dir == 1 then
		if x - offset > min then
			local goal = {Position = UDim2.new(0, x + failedOffset, y, 0)}
			local goal2 = {Position = UDim2.new(0, x, y, 0)}
			local Tween = TweenService:Create(ClothDispFrame, TweenInfo, goal)
			Tween:Play()
			Tweening = true
			Tween.Completed:Wait()
			local Tween2 = TweenService:Create(ClothDispFrame, TweenInfo, goal2)
			Tween2:Play()
			Tween2.Completed:Wait()
			Tweening = false
		else 
			local goal = {Position = UDim2.new(0, x - offset, y, 0)}
			local Tween = TweenService:Create(ClothDispFrame, TweenInfo, goal)
			Tween:Play()
			Tweening = true
			Tween.Completed:Wait()
			Tweening = false
		end
	elseif dir == nil then -- sanity check ig
		warn("direction is nil or wrong", dir)
	end
end

OpenProxGUI.OnClientEvent:Connect(function(prompt: ProximityPrompt, CurRack) --Open gui
	local promptHomePoint = prompt.Parent.Position --sets home point 
	if opened == true then return end -- makes sure you cant open multiple guis
	opened = true
	
	local distanceLogic = coroutine.create(function() --Makes sure player doesnt stray to far from clothing rack
		while frame.Visible == true do
			task.wait(0.5)
			local maxDistance = 8.5
			if (player.Character.HumanoidRootPart.Position - promptHomePoint).Magnitude > maxDistance then
				print("TooFar")
				local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0) --just a repeat of the closing of the gui
				local goal = {Position = UDim2.new(2.505, 0, 0.3, 0)}
				local tween = TweenService:Create(frame, tweenInfo, goal)
				tween:Play()
				tween.Completed:Wait()
				backgroundBlur.Visible = false
				frame.Visible = false
				CloseButton.Parent.Visible = false
				ClothDispFrame.Position = UDim2.new(0, 0, 0.083, 0)
				opened = false

				for i, v in ClothDispFrame:GetChildren() do
					if v:IsA("ImageLabel") then
						v:Destroy()
					end
				end
			end
		end
	end)
	
	frame.Visible = true --logic to open gui
	coroutine.resume(distanceLogic)
	CloseButton.Parent.Visible = true
	backgroundBlur.Visible = true
	
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
	local goal = {Position = UDim2.new(0.505, 0, 0.3, 0)}
	TweenService:Create(frame, tweenInfo, goal):Play()
	
	local Rack = CurRack:GetChildren() --sorts clothing rack
	table.sort(Rack, function(a, b)
		return a.Name < b.Name	
	end)
	
	for i = 1, #Rack do 
		local v = Rack[i]
		local c = v.Rig:GetChildren()

		for i, e in c do --displays clothing on gui
			if e:IsA("Accessory") then
				local ClothingItem = e 
				DisplayClothingInfo(ClothingItem)
			end
		end	
	end
end)

CloseButton.Activated:Connect(function() -- closes gui with tweens
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0)
	local goal = {Position = UDim2.new(2.505, 0, 0.3, 0)}
	local tween = TweenService:Create(frame, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
	backgroundBlur.Visible = false
	frame.Visible = false
	CloseButton.Parent.Visible = false
	ClothDispFrame.Position = UDim2.new(0, 0, 0.083, 0)
	opened = false
	
	for i, v in ClothDispFrame:GetChildren() do
		if v:IsA("ImageLabel") then
			v:Destroy()
		end
	end
end)

for i, button: GuiButton in ArrowButtons do -- arrow button logic
	button.Activated:Connect(function()
		local dir = 0
		if button.Name == "Right" then
			dir = -1
		elseif button.Name == "Left" then
			dir = 1
		end
		local removed = false
		TweenClothes(dir, removed)
	end)
end
