-- VARIABLES FOR INSTALLATION
local OSPath = "/KasosOS/" -- important
local systemPath = fs.combine(OSPath, "PC/system") -- also important
-- paths that are nested in systemPath
local paths = {
    assetsPath = fs.combine(systemPath, "assets/"),
    usersPath = fs.combine(systemPath, ".users/"),
    installPath = fs.combine(systemPath, ".install/"),
    settingsPath = fs.combine(systemPath, ".settings"),
    libraryPath = fs.combine(systemPath, "lib/"),
    romPath = fs.combine(systemPath, ".rom/")
}

local defaultUser = "Guest"
local defaultPassword = "guestpassword"
local defaultProfileIcon = fs.combine(paths["assetsPath"], "default_profile.bimg")

os.pullEvent = os.pullEventRaw

local function downloadRepoRecursive(request)
    for _, url in ipairs(textutils.unserialiseJSON(request.readAll())) do
        local urlpath = "/" .. url.path
        if url.type == "file" then
            if fs.exists(urlpath) then
                print(urlpath .. " already exists")
                fs.delete(urlpath)
            end
            shell.run("wget", url.download_url, urlpath)
        elseif url.type == "dir" then
            fs.makeDir(urlpath)
            local newRequest, err, errResp = http.get({url=url.url, headers={["Accept"]="application/vnd.github.raw+json"}})
            if err then
                print(err, textutils.serialise(errResp))
            end
            downloadRepoRecursive(newRequest)
        end
    end
end

-- Installation
local function installFiles(installList)
    local toInstall = http.get(installList)
    local executable = ""
    local selectedName = ""

    for line in string.gmatch(toInstall.readAll(), "[^\r\n]+") do
    line = line:gsub("[\n\r]", " ")
    local firstChar = line:sub(1, 1)
    if firstChar == "#" then
        executable = line:sub(2)
        goto continue
    elseif firstChar == "!" then
        selectedName = line:sub(2)
        goto continue
    elseif firstChar == "?" then -- github repo
        local request, err, errResp = http.get({url=line:sub(2), headers={["Accept"]="application/vnd.github.raw+json"}})
        if err then
            print(err, errResp.readAll())
            request.close()
            goto continue
        end
        downloadRepoRecursive(request)
        request.close()
        goto continue
    end
    if selectedName == "" then
        local startIndex = line:find("KasosOS", 1, true)
        if startIndex then
            local path = line:sub(line:find("KasosOS", startIndex+1, true) + 7)
            shell.run(executable, line, path)
        else
            print("File without directory annotation: " .. line)
            os.sleep(0.5)
        end
    else
        if fs.exists(selectedName) then
            fs.delete(selectedName)
        end
        shell.run(executable, line, selectedName)
        selectedName = ""
    end
    ::continue::
    end
    toInstall.close()
end

installFiles("https://github.com/stabbyfork/KasosOS/raw/main" .. fs.combine(paths["installPath"], "install.txt"))

--- Set various paths
local function setPaths()
    package.path = fs.combine(paths["libraryPath"], '?.lua;') .. package.path
    shell.setPath(shell.path() .. ":" .. paths["libraryPath"])
end

setPaths()

local sha, userLib = require("sha2"), require("userlib")

local function setupUsers()
    settings.load(paths["settingsPath"])
    if settings.get(paths["usersPath"]) == nil then
        settings.define(paths["usersPath"], {default=paths["usersPath"], description="The path where userdata is stored, ONLY SYSTEM DATA, NOT APPS OR PROGRAMS", type="string"})
    end
    if settings.get("defaultProfileIcon") == nil then
        settings.define("defaultProfileIcon", {default=defaultProfileIcon, description="The default profile icon path", type="string"})
    end
    if settings.get("selectedUser") == nil then
        settings.define("selectedUser", {default=defaultUser, description="The selected user", type="string"})
    end

    if settings.get("defaultUser") == nil then
        settings.define("defaultUser", {default=defaultUser, description="The default user", type="string"})
        if not fs.exists(fs.combine(settings.get(paths["usersPath"]), settings.get("defaultUser"))) then -- concatenates paths["usersPath"] to defaultUser as it is where the default user is stored
            local user = userLib:new(settings.get("defaultUser"), sha.sha256(defaultPassword))
            user:save()
        end
    end

    settings.save(paths["settingsPath"])
end

-- TODO move to bios
local fs = fs
_G.fs = {
    open=fs.open,
    makeDir=fs.makeDir,
    list=fs.list,
    exists=fs.exists,
    delete=fs.delete,
    isDir=fs.isDir,
    isReadOnly=fs.isReadOnly,
    getFreeSpace=fs.getFreeSpace,
    combine=fs.combine,
    complete=fs.complete
}

-- USER SETUP
setupUsers()

print("Installer complete")
fs.delete(fs.combine(paths["assetsPath"], "install.txt"))
fs.delete(fs.combine(paths["assetsPath"], "installer.lua"))