local M = {}

local patterns = {}
patterns.tags = "#[%wdéêèâàôù§-]+"

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

M.populate_tags = function (file, tags, opts)
    for c in io.lines(opts.directory .. file) do
        if c == nil then break end
        for t in c.gmatch(c, patterns.tags) do --> find iteratively the tags in a file
            if not tags[t] then tags[t] = {} end
            if tags[t] ~= nil then table.insert(tags[t], file) end
        end
    end
end

M.find_md_files = function (opts)
    local dir = io.popen('ls -p ' .. '"' .. opts.directory .. '"')
    local files = {}
    for f in dir:lines() do
        if string.sub(f, -3, -1) == ".md" then
            table.insert(files, f)
        end
    end
    return files
end

M.find_tags_in_files = function(files, opts)
    local tags = {}
    for _,file in pairs(files) do
        M.populate_tags(file, tags, opts)
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
    local tags = M.find_tags_in_files(files, opts)
    return tags
end

return M


