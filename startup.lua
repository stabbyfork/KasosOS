local basalt = require("/KasosOS/PC/system/lib/basalt")
local mainFrame = basalt.createFrame()
mainFrame
    :setPosition(1,1)
    :setSize(30,30)
    :addTexture("/KasosOS/PC/system/assets/desktop/pack.nfp")

basalt.autoUpdate()