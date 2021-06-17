P = function (p, opts)
    opts = opts or {}
    for r, v in pairs(p) do
        if opts.count == true then print(v.tag .. "\t" .. #v.files)
        else print(r,v) end
    end
end

local M = {}

local pwd = "/Users/danielmathiot/Documents/000\\ Meta/00.01\\ NewBrain/"
local pwd2 = "/Users/danielmathiot/Documents/000 Meta/00.01 NewBrain/"
local directory = io.popen("ls -p " .. pwd)

M.get_tags = function ()
    local T = {}
    for t,_ in pairs(M.tags) do
        table.insert(T, t)
    end
    return T
end

M.sort_tags = function (tags)
    local tags = tags
    local keys = {}
    local sorted = {}
    for k in pairs(tags) do
        table.insert(keys, k)
    end
    local sorter = function(a,b)
        if #tags[a] == #tags[b] then return false
        else return #tags[a] >= #tags[b] end
    end
    table.sort(keys, sorter)
    for _,key in ipairs(keys) do
        table.insert(sorted, { tag = key, files = tags[key] })
    end
    return sorted
end

M.populate_tags = function (file, tags)
    for c in io.lines(pwd2..file) do
        if c == nil then break end
        for t in c.gmatch(c, "#[%wdéêèâàôù§-]+") do --> find iteratively the tags in a file
            if not tags[t] then tags[t] = {} end
            if tags[t] ~= nil then table.insert(tags[t], file) end
        end
    end
end

M.find_md_files = function (opts)
    local dir = io.popen('ls -p ' .. opts.directory)
    local files = {}
    for f in dir:lines() do
        if string.sub(f, -3, -1) == ".md" then
            table.insert(files, f)
        end
    end
    return files
end

M.find_tags_in_files = function(files)
    local tags = {}
    for _,file in pairs(files) do
        M.populate_tags(file, tags)
    end
    return tags
end

M.parse_tags = function (opts)
    opts = opts or {}
    if opts.directory == nil then
        print 'Please specify a directory'
        return
    end
    local files = M.find_md_files(opts)
    local tags = M.find_tags_in_files(files)
    return tags
end

tags = M.parse_tags({ directory = "/Users/danielmathiot/Documents/000\\ Meta/00.01\\ NewBrain/" })
sorted = M.sort_tags(tags)
P(sorted, { count = true })
return M


