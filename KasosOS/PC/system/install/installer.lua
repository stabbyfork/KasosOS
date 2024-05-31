if not fs.exists("PC") then
    fs.makeDir("PC")
else
    print("PC directory already exists")
end
print("1")
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
print("2")

local installList = "https://github.com/stabbyfork/KasosOS/blob/main/KasosOS/PC/system/install/install.txt"
local toInstall = http.get(installList).readAll()
print("3")
for line in toInstall:gmatch("[^\n]+") do
    shell.run("wget", "run", line)
end

print("Installer complete")