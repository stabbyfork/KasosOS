local function downloadRepoRecursive(request)
    for _, url in ipairs(textutils.unserialiseJSON(request.readAll())) do
        if url.type == "file" then
            if fs.exists(url.path) then
                print(url.path .. " already exists")
                fs.delete(url.path)
            end
            shell.run("wget", url.download_url, url.path)
        elseif url.type == "dir" then
            fs.makeDir(url.path)
            local newRequest, err, errResp = http.get({url=url.url, headers={["Accept"]="application/vnd.github.raw+json"}})
            if err then
                print(err, errResp)
            end
            downloadRepoRecursive(newRequest)
        end
    end
end

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
    elseif firstChar == "?" then -- github repo
        local request, err, errResp = http.get({url=line:sub(2), headers={["Accept"]="application/vnd.github.raw+json"}})
        if err then
            print(err, errResp)
        end
        downloadRepoRecursive(request)
        request.close()
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