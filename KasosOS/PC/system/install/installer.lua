if not fs.exists("PC") then
    fs.makeDir("PC")
else
    print("PC directory already exists")
end
fs.makeDir("PC/desktop")
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
fs.makeDir("PC/system/install")

local installList = "https://github.com/stabbyfork/KasosOS/raw/main/KasosOS/PC/system/install/install.txt"
local toInstall = http.get(installList)
local executable = ""
local selectedDir = ""
for line in string.gmatch(toInstall.readAll(), "[^\r\n]+") do
    line = line:gsub("[\n\r]", " ")
    local firstChar = line:sub(1, 1)
    if firstChar == "#" then
        executable = line:sub(2)
        goto continue
    elseif firstChar == "!" then
        selectedDir = line:sub(2)
        goto continue
    end
    local startIndex = line:find("KasosOS", 1, true)
    if startIndex then
        local path = line:sub(line:find("KasosOS", startIndex+1, true) + 8)
        shell.run(executable, line, path)
    else
        shell.run("cd", selectedDir)
        shell.run(executable, line)
    end
    selectedDir = ""
    ::continue::
end
toInstall.close()

print("Installer complete")