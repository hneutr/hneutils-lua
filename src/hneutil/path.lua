--[[
unimplemented implement:
- pathlib (python):
    - glob
    - rglob
    - absolute: PATH.abspath
    - link_to
    - readlink
    - symlink_to
- lua-path:
    - PATH.chdir
    - PATH.dirname
    - PATH.normalize
    - PATH.splitext
    - PATH.splitpath
    - PATH.split
    - PATH.splitroot
    - PATH.isfullpath
    - PATH.isabs
    - PATH.fullpath
    - PATH.islink
    - PATH.copy
--]]

local lfs = require('lfs')
local PATH = require("path")
string = require("hneutil.string")
table = require("hneutil.table")

local Path = {}

Path.exists = PATH.exists
Path.unlink = PATH.remove
Path.is_file = PATH.isfile
Path.is_dir = PATH.isdir
Path.mkdir = PATH.mkdir
Path.name = PATH.basename
Path.suffix = PATH.extension
Path.is_empty = PATH.isempty
Path.rename = PATH.rename

function Path.rmdir(dir, force)
    force = force or false

    if not Path.exists(dir) then
        return
    end

    if force then
        for _, path in ipairs(table.reverse(Path.iterdir(dir))) do
            if Path.is_file(path) then
                Path.unlink(path)
            elseif Path.is_dir(path) then
                Path.rmdir(path)
            end
        end
    end

    if Path.is_empty(dir) then
        PATH.rmdir(dir)
    end
end

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

function Path.iterdir(dir, args)
    args = table.default(args, {recursive = true, files = true, dirs = true})

    local paths = {}

    local exclusions = {[[.]], [[..]]}
    for stem in lfs.dir(dir) do
        if not table.list_contains(exclusions, stem) then
            local path = Path.joinpath(dir, stem)

            if (Path.is_file(path) and args.files) or (Path.is_dir(path) and args.dirs) then
                paths[#paths + 1] = path
            end

            if Path.is_dir(path) and args.recursive then
                paths = table.list_extend(paths, Path.iterdir(path, args))
            end
        end
    end

    return paths
end

function Path.home()
    return os.getenv("HOME")
end

function Path.expanduser(p)
    if p:startswith("~/") then
        p = Path.joinpath(Path.home(), p:removeprefix("~/"))
    end

    return p
end

function Path.root()
    return "/"
end

function Path.cwd()
    return os.getenv("PWD")
end

function Path.tempdir()
    return Path.joinpath(Path.root(), "tmp")
end

function Path.is_relative_to(p, other)
    for _, parent in ipairs(Path.parents(p)) do
        if parent == other then
            return true
        end
    end

    return false
end

function Path.relative_to(p, other)
    if p:startswith(other) then
        return p:removeprefix(other):removeprefix("/")
    else
        error(p .. " is not relative to " .. other)
    end
end

function Path.resolve(p)
    if p:startswith(".") then
        p = p:removeprefix(".")
        -- p = Path.joinpath(Path.cwd(), p:removeprefix('.'))
    end

    if not Path.is_relative_to(p, Path.cwd()) then
        p = Path.joinpath(Path.cwd(), p)
    end

    local parts = {}
    for _, part in ipairs(Path.parts(p)) do
        if part == '..' then
            if #parts > 0 then
                parts[#parts] = nil
            end
        else
            parts[#parts + 1] = part
        end
    end

    if #parts == 0 then
        parts[#parts + 1] = Path.root()
    end

    p = Path.joinpath(table.unpack(parts))

    return p
end

return Path
