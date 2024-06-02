local basalt = require("/KasosOS/PC/system/lib/basalt")
local screen = term.current()

local mainFrame = basalt.createFrame()
mainFrame:addTexture("/KasosOS/PC/system/assets/desktop/pack.bimg")
mainFrame:setTextureMode("center")

--local selectedUser = fs.list(settings.)
local dataFrame = mainFrame:addFrame()
local userProfile = dataFrame:addImage()
userProfile
    :loadImage()

--- The time label
local timeDisplay = mainFrame:addLabel()
timeDisplay
    :setText("00:00")
    :setPosition(1, "parent.h")
    :setSize("parent.w", 1)
    :setBackground(colors.black)
    :setForeground(colors.white)

--- Updates the time label
local function updateTime()
    while true do
        local formattedTime = textutils.formatTime(os.time(), true)
        timeDisplay:setText(formattedTime)
        --basalt.debug(formattedTime)
        os.sleep(1)
    end
end

--- The pass input field, disappears after inactivity
local passInput = mainFrame:addInput()
passInput
    :setInputType("password")
    :setDefaultText("Password")
    :setPosition("parent.w / 4 + 1", "parent.h / 2 + 5")
    :setSize("parent.w / 2", 1)
    :setForeground(colors.white)
    :hide()

local function onEnter(self, event, key)
    if key == keys.enter then
        basalt.debug("password", self:getValue())
    end
end


-- Threads

local timeThread = mainFrame:addThread()
timeThread:start(updateTime)

local inputThread = mainFrame:addThread()

--- Wait for input
local function waitForInput()
    while true do
        local event, param = os.pullEvent()
        if event == "key" or event == "mouse_click" then
            --basalt.debug("key or mouse click")
            passInput:show()
            mainFrame:setFocusedChild(passInput)
            return
        elseif event == "monitor_touch" then
            screen = peripheral.wrap(param)
            term.redirect(screen)
            --basalt.debug("monitor touched")
            passInput:show()
            mainFrame:setFocusedChild(passInput)
            return
        end
    end
end

inputThread:start(waitForInput)
passInput:onKey(onEnter)

basalt.autoUpdate()