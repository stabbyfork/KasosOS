if not fs.exists("PC") then
    fs.makeDir("PC")
else
    print("PC directory already exists")
end
--[[fs.makeDir("PC/desktop")
fs.makeDir("PC/system")
fs.makeDir("PC/system/assets")
fs.makeDir("PC/system/config")
fs.makeDir("PC/system/logs")
fs.makeDir("PC/system/users")
fs.makeDir("PC/system/bootloader")
fs.makeDir("PC/system/assets/desktop")
fs.makeDir("PC/system/assets/system")
fs.makeDir("PC/system/lib")
fs.makeDir("PC/system/misc")
fs.makeDir("PC/system/install")--]]

local installList = "https://github.com/stabbyfork/KasosOS/raw/main/KasosOS/PC/system/install/install.txt"
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
    elseif firstChar == "?" then
        local request, err, errResp = http.get({url=line:sub(2), headers={["Accept"]="application/vnd.github.raw+json"}})
        if err then
            print(err, errResp)
        end
        print(request.readAll())
    end
    if selectedName == "" then
        local startIndex = line:find("KasosOS", 1, true)
        if startIndex then
            local path = line:sub(line:find("KasosOS", startIndex+1, true) + 8)
            shell.run(executable, line, path)
        else
            print("File without directory annotation: " .. line)
            os.sleep(0.5)
        end
    else
        shell.run(executable, line, selectedName)
        selectedName = ""
    end
    ::continue::
end
toInstall.close()

print("Installer complete")