local expectReq = require "cc.expect"
local expect = expectReq.expect
settings.load("/.settings")

--- Generic user class with username and password
---@class User
local User = {}
User.__index = User

--- Create a new user
---@param username string The username
---@param password string The password as a string
---@param icon string | nil The path to the profile icon
---@return User user The user object
function User:new(username, password, icon)
    expect(1, username, "string")
    expect(2, password, "string")
    expect(3, icon, "string", "nil")

    ---@class User
    local instance = setmetatable({}, User)
    instance.username = username
    instance.password = password
    instance.profileIcon = icon or settings.get("defaultProfileIcon")
    return instance
end

--- Get an existing user
---@param username string The username
---@return User user The user object
function User:get(username)
    expect(1, username, "string")

    local user = require(fs.combine(settings.get("usersPath") .. username))
    return user
end

--- Save the userdata of the user
---@return string filepath The path to the saved userdata
function User:save()
    local filepath = fs.combine(settings.get("usersPath"), self.username)
    local file = fs.open(fs.combine(filepath, "data.lua"), "w")
    fs.copy(self:getProfileIcon(), fs.combine(filepath, "pfp.bimg"))
    self:setProfileIcon(fs.combine(filepath,"/pfp.bimg"))
    local serialisedData = textutils.serialise(self)
    file.write("return" .. serialisedData)
    file.close()
    return filepath
end

--- Get the username of the user
---@return string username The username
function User:getUsername()
    return self.username
end

--- Set the username of the user
---@param username string The new username
function User:setUsername(username)
    expect(1, username, "string")
    self.username = username
end

--- Get the password pointer of the user
---@return string password The password pointer
function User:getPassword()
    return self.password
end


--- Set the password pointer of the user
---@param password string The new password pointer
function User:setPassword(password)
    expect(1, password, "string")
    self.password = password
end

--- Get the profile icon path of the user
---@return string profileIcon The profile icon path
function User:getProfileIcon()
    return self.profileIcon
end

--- Set the profile icon path of the user
---@param profileIcon string The new profile icon path
function User:setProfileIcon(profileIcon)
    expect(1, profileIcon, "string")
    self.profileIcon = profileIcon
end


return User
