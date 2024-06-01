print(shell.path())

local expectReq, userCreator = require("cc.expect"), require("/KasosOS.PC.system.lib.usercreate")
local expect, range = expectReq.expect, expectReq.range

local user = userCreator.User("admin", "password")
print(user:getUsername())
--- Calculate the absolute position on the screen based on the relative position and screen size
---@param screenSize table The size of the screen in pixels
---@param relPos table The relative position on the screen in percent
---@return table absPos Absolute position on the screen in pixels
local function absolutePos(screenSize, relPos)
    return {math.floor(relPos[1]/100 * screenSize[1]), math.floor(relPos[2]/100 * screenSize[2])}
end

--- Generic element to be displayed on desktop
---@class DesktopElement
local DesktopElement = {}
DesktopElement.__index = DesktopElement

--- Create a new generic desktop element
---@param relPos table The position relative to the screen
---@param relSize table | nil The size relative to the screen
---@param icon string | nil The path to the icon
---@return DesktopElement element The new desktop element
function DesktopElement:__call(relPos, relSize, icon)
    expect(1, relPos, "table")
    range(relPos[1], 0, 100)
    range(relPos[2], 0, 100)
    expect(2, relSize, "table", "nil")
    if relSize then
        range(relSize[1], 0, 100)
        range(relSize[2], 0, 100)
    end
    expect(3, icon, "string", "nil")

    local instance = setmetatable({}, DesktopElement)
    instance.relPos = relPos
    instance.relSize = relSize or {10,10}
    instance.icon = icon or "PC/system/assets/desktop/default_icon.nfp"
    return instance
end

--- Set the relative position of the desktop element (%, e.g. {0,0} is top left)
---@param pos table The new relative position
function DesktopElement:setPos(pos)
    expect(1, pos, "table")
    range(pos[1], 0, 100)
    range(pos[2], 0, 100)
    self.relPos = pos
end

--- Get the relative position of the desktop element
---@return table relPos Table of position (x%,y%)
function DesktopElement:getPos()
    return self.relPos
end

--- Set the relative size of the desktop element (%, e.g. {100,100} is entire screen)
---@param size table The new relative size
function DesktopElement:setSize(size)
    expect(1, size, "table")
    range(size[1], 0, 100)
    range(size[2], 0, 100)
    self.relSize = size
end

--- Get the relative size of the desktop element
---@return table relSize Table of size (x%,y%)
function DesktopElement:getSize()
    return self.relSize
end

--- Set the icon path of the desktop element
---@param icon string The new icon path
function DesktopElement:setIcon(icon)
    expect(1, icon, "string")
    self.icon = icon
end

--- Get the icon path of the desktop element
---@return string icon Icon path
function DesktopElement:getIcon()
    return self.icon
end

local element = DesktopElement({0,0})
print(textutils.serialise(element:getSize()))

local element2 = DesktopElement({10,10})
print(textutils.serialise(element2:getPos()))

local monitor = peripheral.wrap("right")
local monitorX, monitorY = monitor.getSize()
print(monitorX, monitorY)
term.redirect(monitor)
print(element:getIcon())
local image = paintutils.loadImage(element:getIcon())
paintutils.drawImage(image, absolutePos({monitorX, monitorY}, element2:getPos())[1], absolutePos({monitorX, monitorY}, element2:getPos())[2])




local event, side, xCoord, yCoord = os.pullEvent("monitor_touch")
print(event, side, xCoord, yCoord)