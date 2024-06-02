local basalt = require("/KasosOS/PC/system/lib/basalt")

local mainFrame = basalt.createFrame()
local image = mainFrame:addImage()
image:loadImage("/KasosOS/PC/system/assets/desktop/pack.bimg")

basalt.autoUpdate()