P = function (p)
    for r, v in pairs(p) do
        print(r,v)
    end
end

local M = {}

local pwd = "/Users/danielmathiot/Documents/000\\ Meta/00.01\\ NewBrain/"
local pwd2 = "/Users/danielmathiot/Documents/000 Meta/00.01 NewBrain/"
local directory = io.popen("ls -p " .. pwd)
M.tags = {}
M.files = {}

M.print_tags = function (tags)
    for tag,_ in pairs(tags) do
        print(tag)
    end
end

M.get_tags = function ()
    local T = {}
    for t,_ in pairs(M.tags) do
        table.insert(T, t)
    end
    return T
end

M.sort_tags = function (t)
    local sorter = function(a,b)
        if #M.tags[a] == #M.tags[b] then return false
        else return #M.tags[a] >= #M.tags[b] end
    end
    table.sort(t, sorter)
end

M.populate_tags = function (file)
    for c in io.lines(pwd2..file) do
        if c == nil then break end
        for t in c.gmatch(c, "#[%wéêèâàôù§-]+") do --> find iteratively the tags in a file
            if not M.tags[t] then M.tags[t] = {} end
            if M.tags[t] ~= nil then table.insert(M.tags[t], file) end
        end
    end
end

M.find_md_files = function ()
    if directory then
        for f in directory:lines() do
            if string.sub(f, -3, -1) == ".md" then
                table.insert(M.files, f)
            end
        end
    else
        print("pwd not found")
    end
end

M.find_tags_in_files = function()
    for _,file in pairs(M.files) do
        M.populate_tags(file)
    end
end

M.run = function()
    M.find_md_files()
    M.find_tags_in_files()
    t = M.get_tags()
    M.sort_tags(t)
    P(t)
end

M.run()

return M

