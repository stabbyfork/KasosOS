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
    os.pullEvent()
    print("Something was done")
end

parallel.waitForAny(updateTime, waitForInput)
print("complete")
basalt.autoUpdate()