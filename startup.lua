local basalt = require("/KasosOS/PC/system/lib/basalt")
local screen = term.current()

local mainFrame = basalt.createFrame()
mainFrame:addTexture("/KasosOS/PC/system/assets/desktop/pack.bimg")
mainFrame:setTextureMode("center")

local time = os.time()
local function updateTime()
    while true do
        time = os.time()
        print(textutils.formatTime(time))
        os.sleep(1)
    end
end

local function waitForInput()
    while true do
        local event, param = os.pullEvent()
        if event == "key" or event == "mouse_click" then
            print("key or mouse click")
            return
        elseif event == "monitor_touch" then
            screen = peripheral.wrap(param)
            term.redirect(screen)
            print("monitor touched")
            return
        end
    end
end

parallel.waitForAny(updateTime, waitForInput)
print("complete")
local passInput = mainFrame:addInput()
passInput
    :setInputType("password")
    :setDefaultText("Password")
    :setPosition("parent.w / 4", "parent.h / 2 + 11")
    :setSize("parent.w / 2", 2)

local function onEnter(self, event, key)
    if key == "enter" then
        basalt.debug("password", self:getText())
    end
end
passInput:onKey(onEnter)
basalt.autoUpdate()