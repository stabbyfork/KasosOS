local basalt = require("/KasosOS/PC/system/lib/basalt")
local screen = term.current()

--local mainFrame = basalt.createFrame()
--mainFrame:addTexture("/KasosOS/PC/system/assets/desktop/pack.bimg")
--mainFrame:setTextureMode("center")

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
        if event == "key" or "mouse_click" then
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
basalt.autoUpdate()