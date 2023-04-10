local Path = {}
local lfs = require('lfs')
local PATH = require("path")
string = require("util.string")


local Path = {}

Path.exists = PATH.exists
Path.unlink = PATH.remove
Path.is_file = PATH.isfile
Path.is_dir = PATH.isdir
Path.mkdir = PATH.mkdir
Path.rmdir = PATH.rmdir
Path.name = PATH.basename
Path.suffix = PATH.extension


function Path.read(p)
    local fh = io.open(p, "r")
    local content = fh:read("*a")
    fh:close()
    return content
end

function Path.readlines(path)
    return Path.read(path):splitlines()
end

function Path.write(p, content)
    if type(content) ~= "table" then
        content = {content}
    end

    for i, line in ipairs(content) do
        content[i] = tostring(line)
    end

    content = string.join("\n", content)

    local fh = io.open(p, "w")
    fh:write(content)
    fh:close()
end

function Path.touch(p)
    if not Path.exists(p) then
        Path.write(p, "")
    end
end

function Path.joinpath(one, two, ...)
    one = one or ''
    two = two or ''

    two = two:removeprefix("/")

    if two:len() > 0 then
        return PATH.join(one, two, ...)
    else
        return one
    end
end

function Path.suffixes(p)
    local name = Path.name(p)

    local suffixes = {}
    for i, suffix in ipairs(name:split(".")) do
        if i ~= 1 then
            suffixes[#suffixes + 1] = "." .. suffix
        end
    end

    return suffixes
end

function Path.stem(p)
    local name = Path.name(p)
    local stem, suffix = table.unpack(name:split(".", 1))
    return stem
end

function Path.parts(p)
    local parts = {}
    if p:startswith("/") then
        parts[1] = "/"
    end

    for _, part in ipairs(p:split("/")) do
        parts[#parts + 1] = part
    end

    return parts
end

function Path.parents(p)
    local reversedParents = {}

    for i, part in ipairs(Path.parts(p)) do
        local parent

        if i == 1 then
            parent = part
        else
            parent = Path.joinpath(reversedParents[#reversedParents], part)
        end
        reversedParents[#reversedParents + 1] = parent
    end

    local parents = {}
    for i=#reversedParents - 1, 1, -1 do
        parents[#parents + 1] = reversedParents[i]
    end

    return parents
end

function Path.parent(p)
    local parents = Path.parents(p)
    if #parents ~= nil then
        return parents[1]
    end
    return ""
end

function Path.with_name(p, name)
    return Path.joinpath(Path.parent(p), name)
end

function Path.with_stem(p, stem)
    return Path.with_name(p, stem .. Path.suffix(p))
end

function Path.with_suffix(p, suffix)
    return Path.with_name(p, Path.stem(p) .. suffix)
end

function Path.iterdir(dir)
    if recursive == nil then
        recursive = true 
    end

    local paths = {}

    local exclusions = {
        ["."] = true, 
        [".."] = true,
    }
    for stem in lfs.dir(dir) do
        if not exclusions[stem] then
            local path = Path.joinpath(dir, stem)
            paths[#paths + 1] = path

            if Path.is_dir(path) then
                for _, subpath in ipairs(Path.iterdir(path)) do
                    paths[#paths + 1] = subpath
                end
            end
        end
    end

    return paths
end

-- relative_to
-- is_relative_to

-- glob
-- rglob

-- rename: PATH.rename
-- link_to
-- readlink
-- symlink_to

-- home: PATH.user_home
-- root: PATH.root
-- cwd: PATH.currentdir
-- PATH.tmpdir
-- PATH.tmpname

-- expanduser
-- absolute: PATH.abspath

-- PATH.dirname
-- PATH.normalize
-- PATH.splitext
-- PATH.splitpath
-- PATH.split
-- PATH.splitroot

-- PATH.isfullpath
-- PATH.isabs
-- PATH.fullpath
-- PATH.islink
-- PATH.isempty

-- PATH.copy
-- PATH.chdir

return Path
