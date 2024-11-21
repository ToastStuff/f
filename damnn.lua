-- NewIDLib.lua
local Library = {}

-- Constants for window size and button spacing
local windowWidth = 400
local windowHeight = 500
local buttonWidth = 150
local buttonHeight = 30
local buttonSpacing = 40  -- Space between buttons


-- Create a New Window with Title and Close Button
function Library.NewWindow(title)
    -- Setup UI elements
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local CloseButton = Instance.new("TextButton")
    local TitleLabel = Instance.new("TextLabel")
    local Divider = Instance.new("Frame")
    local darkGray = Color3.fromRGB(169, 169, 169)  -- Dark gray color
    local buttons = {}  -- Store buttons to track their positions

    -- Set up the ScreenGui
    ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
    ScreenGui.Name = "DraggableFrameUI"
    ScreenGui.ResetOnSpawn = false

    -- Set up the Frame
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -300)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.001
    Frame.BorderSizePixel = 0

    -- Rounded corners
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = Frame

    -- Set up Title label
    TitleLabel.Parent = Frame
    TitleLabel.Size = UDim2.new(0, 220, 0, 30)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Text = title or "Default Title"
    TitleLabel.TextColor3 = darkGray
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    CloseButton.Parent = Frame
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0, 8)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = darkGray
    CloseButton.BackgroundTransparency = 1
    CloseButton.TextSize = 13
    CloseButton.Font = Enum.Font.GothamBold

    local TweenService = game:GetService("TweenService") -- Import TweenService for animations
    local MinimizeButton = Instance.new("TextButton")
    local isMinimized = false -- Track whether the window is minimized
    
    MinimizeButton.Parent = Frame
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 8) -- Next to the close button
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = darkGray
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.TextSize = 13
    MinimizeButton.Font = Enum.Font.GothamBold
    
    -- Function to smoothly resize the frame
    local function tweenFrameSize(newHeight)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- Smooth animation
        local goal = { Size = UDim2.new(0, windowWidth, 0, newHeight) }
        TweenService:Create(Frame, tweenInfo, goal):Play()
    end
    
    -- Minimize Button functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized -- Toggle minimized state
    
        -- Hide/show buttons and dividers
        for _, child in ipairs(Frame:GetChildren()) do
            if table.find(buttons, child) or child:IsA("Frame") and child.BackgroundColor3 == Color3.fromRGB(55, 53, 55) then
                child.Visible = not isMinimized -- Hide/show buttons and dividers
            end
        end
    
        -- Adjust frame height to 10% of original size when minimized, restore when maximized
        if isMinimized then
            tweenFrameSize(windowHeight * 0.090) -- Shrink frame height to 10%
        else
            tweenFrameSize(windowHeight) -- Restore original size
        end
    end)
 


    

    CloseButton.MouseButton1Click:Connect(function()
        -- Hide the main ScreenGui
        ScreenGui.Enabled = false
    
        -- Function to create a clean, sliding notification
        local function createNotification(message)
            local screenGui = Instance.new("ScreenGui")
            screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 100)
            frame.Position = UDim2.new(1, 0, 1, -120)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            frame.BorderSizePixel = 0
            frame.BackgroundTransparency = 0.2
            frame.Parent = screenGui
    
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 15)
            corner.Parent = frame
    
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, -20, 1, -20)
            textLabel.Position = UDim2.new(0, 10, 0, 10)
            textLabel.Text = message
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextSize = 26
            textLabel.TextWrap = true
            textLabel.TextXAlignment = Enum.TextXAlignment.Center
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.GothamBold
            textLabel.Parent = frame
    
            frame:TweenPosition(UDim2.new(1, -305, 1, -120), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
            wait(0.5)
            wait(2)
            frame:TweenPosition(UDim2.new(1, 0, 1, -120), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true)
            wait(0.5)
            screenGui:Destroy()
        end
    
        createNotification("Interface Hidden Press F1 To Bring It Back")
    end)

    -- Listen for F1 key to show the ScreenGui again
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F1 then
        -- Show the ScreenGui again when F1 is pressed
        ScreenGui.Enabled = true

        
    end
end)
    

    

    local dragging = false
    local dragStart = nil
    local startPos = nil
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local currentTween = nil
    
    -- Function to smoothly move the frame
    local function smoothMoveTo(frame, position)
        if currentTween then
            currentTween:Cancel()
        end
    
        local tweenInfo = TweenInfo.new(
            0.1, -- Tween time
            Enum.EasingStyle.Quad, -- Easing style
            Enum.EasingDirection.Out, -- Direction
            0, -- Repeat count
            false, -- Reverse
            0 -- Delay time
        )
    
        local goal = { Position = position }
        currentTween = TweenService:Create(frame, tweenInfo, goal)
        currentTween:Play()
    end
    
    -- Start dragging when the frame is clicked
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    
    -- Stop dragging when the mouse button is released globally
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            if currentTween then
                currentTween:Cancel()
            end
        end
    end)
    
    -- Track mouse movement globally for dragging
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            smoothMoveTo(Frame, newPosition)
        end
    end)
    


    function Library.NewToggle(text, callback)
        local ToggleButton = Instance.new("TextButton")
        local isOn = false -- Initial state of the toggle
        local offText = text .. "  ◯"
        local onText = text .. "  ◉"
    
        -- Configure the button
        ToggleButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
        ToggleButton.Text = offText
        ToggleButton.TextColor3 = Color3.fromRGB(169, 169, 169)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ToggleButton.BackgroundTransparency = 0.1
        ToggleButton.TextSize = 14
        ToggleButton.Font = Enum.Font.GothamBold
    
        -- Add rounded corners
        local ToggleButtonUICorner = Instance.new("UICorner")
        ToggleButtonUICorner.CornerRadius = UDim.new(0, 12)
        ToggleButtonUICorner.Parent = ToggleButton
    
        -- Calculate positions dynamically
        local buttonCount = #buttons
        local column = buttonCount % 2
        local row = math.floor(buttonCount / 2)
    
        local newX = column == 0 and 10 or (windowWidth - buttonWidth - 10)
        local newY = 50 + (row * (buttonHeight + buttonSpacing))
    
        ToggleButton.Position = UDim2.new(0, newX, 0, newY)
        ToggleButton.Parent = Frame
    
        -- Toggle functionality
        ToggleButton.MouseButton1Click:Connect(function()
            isOn = not isOn -- Toggle state
            ToggleButton.Text = isOn and onText or offText -- Update text
            if callback then
                callback(isOn) -- Execute callback with current state
            end
        end)
    
        -- Track button to calculate positions for the next one
        table.insert(buttons, ToggleButton)
    
        return ToggleButton
    end


    function Library.NewDivider()
        local Divider = Instance.new("Frame")
        Divider.Size = UDim2.new(0, windowWidth - 2, 0, 1)  -- Full width of the window minus borders
        Divider.BackgroundColor3 = Color3.fromRGB(55, 53, 55)  -- Dark gray color for the divider
    
        -- Calculate the position of the divider based on the last button's position
        local lastButton = buttons[#buttons]  -- Get the last button
        if lastButton then
            -- Position the divider just below the last button but with more space
            Divider.Position = UDim2.new(0, 1, 0, lastButton.Position.Y.Offset + lastButton.Size.Y.Offset + buttonSpacing - 5)  -- Increase the spacing
        else
            -- If no buttons exist, place the divider below the title
            Divider.Position = UDim2.new(0, 1, 0, 40)  -- Default position, below the title
        end
    
        Divider.Parent = Frame
    
        return Divider
    end
    

    -- Divider
    Divider.Parent = Frame
    Divider.Size = UDim2.new(0, 398, 0, 1)
    Divider.Position = UDim2.new(0, 1, 0, 40)
    Divider.BackgroundColor3 = Color3.fromRGB(55, 53, 55)
    

    -- Function to add a new button
    function Library.NewButton(text, callback)
        local NewButton = Instance.new("TextButton")
        NewButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
        NewButton.Text = text or "Click Me"
        NewButton.TextColor3 = darkGray
        NewButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        NewButton.BackgroundTransparency = 0.1
        NewButton.TextSize = 14
        NewButton.Font = Enum.Font.GothamBold

        -- Add rounded corners
        local NewButtonUICorner = Instance.new("UICorner")
        NewButtonUICorner.CornerRadius = UDim.new(0, 12)
        NewButtonUICorner.Parent = NewButton

        -- Calculate positions dynamically
        local buttonCount = #buttons  -- Number of existing buttons
        local column = buttonCount % 2  -- Alternate between 0 (left) and 1 (right)
        local row = math.floor(buttonCount / 2)  -- Determine the row

        -- Compute X and Y positions
        local newX = column == 0 and 10 or (windowWidth - buttonWidth - 10)  -- Align left or rightmost

        local newY = 50 + (row * (buttonHeight + buttonSpacing))  -- 50 px margin from the tops

        NewButton.Position = UDim2.new(0, newX, 0, newY)
        NewButton.Parent = Frame

        -- Button click functionality
        NewButton.MouseButton1Click:Connect(function()
            if callback then
                callback()  -- Call the provided function when clicked
            else
                print("Button clicked!")
            end
        end)

        -- Track button to calculate positions for the next one
        table.insert(buttons, NewButton)

        return NewButton
    end

   
    

    return Frame
end

-- Return the library
return Library
