-- Selenix UI Library with Debugging for Executor (Mobile & PC Friendly)

local SelenixUI = {}

-- Global styles
local styles = {
    primaryColor = Color3.fromRGB(50, 50, 50),
    secondaryColor = Color3.fromRGB(30, 30, 30),
    accentColor = Color3.fromRGB(0, 122, 204),
    textColor = Color3.fromRGB(255, 255, 255),
    font = Enum.Font.Gotham,
    textSize = 18 -- This can be dynamically scaled for mobile
}

-- Utility function to detect if on mobile
local function isMobile()
    return game:GetService("UserInputService").TouchEnabled
end

-- Get player's GUI (use PlayerGui for better executor compatibility)
local function getGuiParent()
    local player = game:GetService("Players").LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
        return player:FindFirstChild("PlayerGui")
    else
        return game:GetService("CoreGui")  -- Fallback to CoreGui
    end
end

-- Function to create a new button
function SelenixUI:CreateButton(text, position, size, parent, onClick)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Size = size or UDim2.new(0, 200, 0, 50)
    button.Parent = parent
    button.BackgroundColor3 = styles.primaryColor
    button.TextColor3 = styles.textColor
    button.Font = styles.font
    button.TextSize = isMobile() and styles.textSize * 1.5 or styles.textSize -- Scale up text on mobile
    button.BorderSizePixel = 0
    button.ZIndex = 10 -- Ensure the button is visible on top
    button.AutoButtonColor = false

    -- Click event handler
    button.MouseButton1Click:Connect(function()
        if onClick then
            onClick()  -- Call the provided function when the button is clicked
        end
    end)

    -- Add hover animation (PC)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = styles.accentColor
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = styles.primaryColor
    end)

    return button
end

-- Function to create a tabbed window
function SelenixUI:CreateWindowWithTabs(title, size)
    local parent = getGuiParent() -- Use PlayerGui or CoreGui

    local window = Instance.new("Frame")
    window.Size = size or UDim2.new(0.4, 0, 0.5, 0) -- Scales with screen size
    window.Position = UDim2.new(0.5, -window.Size.X.Offset/2, 0.5, -window.Size.Y.Offset/2) -- Center the window
    window.BackgroundColor3 = styles.secondaryColor
    window.BorderSizePixel = 0
    window.Visible = true
    window.Parent = parent
    window.ZIndex = 10 -- Ensure the window is on top of other UI elements
    window.Name = "SelenixWindow"

    -- Title Bar
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Text = title or "Selenix Window"
    titleBar.BackgroundColor3 = styles.primaryColor
    titleBar.TextColor3 = styles.textColor
    titleBar.Font = styles.font
    titleBar.TextSize = isMobile() and styles.textSize * 1.5 or styles.textSize
    titleBar.Parent = window
    titleBar.ZIndex = 11

    -- Tab Buttons Container
    local tabButtons = Instance.new("Frame")
    tabButtons.Size = UDim2.new(1, 0, 0, 30)
    tabButtons.Position = UDim2.new(0, 0, 0, 30)
    tabButtons.BackgroundColor3 = styles.primaryColor
    tabButtons.Parent = window
    tabButtons.ZIndex = 11

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, -60)
    tabContent.Position = UDim2.new(0, 0, 0, 60)
    tabContent.BackgroundColor3 = styles.secondaryColor
    tabContent.Parent = window
    tabContent.ZIndex = 10

    local tabs = {}
    local activeTab = nil

    -- Function to create a new tab
    function SelenixUI:CreateTab(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Position = UDim2.new(#tabs * 0.2, 0, 0, 0)
        tabButton.Text = tabName
        tabButton.TextColor3 = styles.textColor
        tabButton.BackgroundColor3 = styles.primaryColor
        tabButton.Parent = tabButtons
        tabButton.Font = styles.font
        tabButton.TextSize = isMobile() and styles.textSize * 1.5 or styles.textSize
        tabButton.ZIndex = 12

        -- Content for the tab
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundColor3 = styles.secondaryColor
        tabFrame.Visible = false
        tabFrame.Parent = tabContent
        tabFrame.ZIndex = 11

        -- Activate tab on button click
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                activeTab.Visible = false
            end
            tabFrame.Visible = true
            activeTab = tabFrame
        end)

        table.insert(tabs, {tabButton = tabButton, tabFrame = tabFrame})

        -- Auto-activate the first tab
        if #tabs == 1 then
            tabFrame.Visible = true
            activeTab = tabFrame
        end

        return tabFrame
    end

    return window
end

return SelenixUI
