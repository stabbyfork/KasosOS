local expectReq = require "cc.expect"
local expect = expectReq.expect

--- Generic user class with username and password pointer
---@class User
local User = {}
User.__index = User

--- Create a new user
---@param username string The username
---@param password string The password pointer
---@return User user The user object
function User:new(username, password)
    expect(1, username, "string")
    expect(2, password, "string")

    local instance = setmetatable({}, User)
    instance.username = username
    instance.password = password
    return instance
end

--- Get the username of the user
---@return string username The username
function User:getUsername()
    return self.username
end

--- Get the password pointer of the user
---@return string password The password pointer
function User:getPassword()
    return self.password
end

--- Set the username of the user
---@param username string The new username
function User:setUsername(username)
    expect(1, username, "string")
    self.username = username
end

--- Set the password pointer of the user
---@param password string The new password pointer
function User:setPassword(password)
    expect(1, password, "string")
    self.password = password
end

return User
