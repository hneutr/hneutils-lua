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

local class = require("pl.class")

local lfs = require('lfs')
local PATH = require("path")

local Dict = require("hl.Dict")
local List = require("hl.List")
local Set = require("pl.Set")

string = require("hl.string")

class.TPath()

TPath.sep = "/"

function TPath.as_string(p)
    if type(p) ~= 'string' then
        p = tostring(p)
    end

    return p
end

function TPath.as_path(p)
    if TPath.is_a(p) ~= TPath then
        p = TPath(p)
    end

    return p
end

function TPath.make_fn_match_input(fn)
    return function(p, ...)
        local transform = TPath.as_path

        if type(p) == 'string' then
            transform = TPath.as_string
        end

        return transform(fn(p, ...))
    end
end

function TPath.make_list_fn_match_input(fn)
    return function(p, ...)
        local transformer = TPath.as_path

        if type(p) == 'string' then
            transformer = TPath.as_string
        end

        return fn(p, ...):transform(transformer)
    end
end

List({
    "startswith",
    "endswith",
    "split",
}):foreach(function(fn)
    TPath[fn] = function(p, ...)
        return string[fn](TPath.as_string(p), ...)
    end
end)


function TPath:_init(path)
    self.p = TPath.as_string(path)
end

function TPath:__concat(p)
    return self:join(p)
end

function TPath:__tostring()
    return self.p
end

function TPath.__eq(p1, p2)
    return TPath.as_string(p1) == TPath.as_string(p2)
end

function TPath.is_file(p)
    return PATH.isfile(TPath.as_string(p)) and true
end

function TPath.is_dir(p)
    return PATH.isdir(TPath.as_string(p)) and true
end

function TPath.exists(p)
    return PATH.exists(TPath.as_string(p)) and true
end

function TPath.is_empty(p)
    return PATH.isempty(TPath.as_string(p)) and true
end

function TPath.mkdir(p)
    PATH.mkdir(TPath.as_string(p))
end

function TPath.unlink(p)
    PATH.remove(TPath.as_string(p))
end

function TPath.parts(p)
    local parts = List(p:split(TPath.sep)):filter(function(part)
        return #part > 0
    end)

    if p:startswith(TPath.sep) then
        parts:put(TPath.sep)
    end

    return parts
end

function TPath.read(p)
    local fh = io.open(TPath.as_string(p), "r")
    local content = fh:read("*a")
    fh:close()
    return content
end

function TPath.readlines(p)
    return TPath.read(p):splitlines()
end

function TPath.write(p, content)
    p = TPath.as_path(p)

    if not p:parent():exists() then
        p:parent():mkdir()
    end

    content = List.as_list(content)
    content:transform(tostring)

    local fh = io.open(tostring(p), "w")
    fh:write(content:join("\n"))
    fh:close()
end

function TPath.touch(p)
    p = TPath.as_path(p)
    if not p:exists() then
        p:write("")
    end
end

TPath.removesuffix = TPath.make_fn_match_input(function(p, suffix)
    return string.removesuffix(TPath.as_string(p), suffix)
end)

TPath.removeprefix = TPath.make_fn_match_input(function(p, prefix)
    return string.removeprefix(TPath.as_string(p), prefix)
end)

TPath.expanduser = TPath.make_fn_match_input(function(p)
    if p:startswith("~") then
        return TPath.home:join(p:removeprefix("~"))
    end

    return p
end)

function TPath.rename(source, target)
    source = TPath.as_string(source)
    target = TPath.as_string(target)

    if TPath.is_file(source) then
        PATH.rename(source, target, true)
    elseif TPath.is_dir(source) then
        os.rename(source, target)

        if source ~= target then
            TPath(source):rmdir(true)
        end
    end
end

TPath.join = TPath.make_fn_match_input(function(p, p2, ...)
    p = TPath.as_string(p)
    p2 = TPath.as_string(p2)

    if p ~= TPath.sep then
        p = p:removesuffix(TPath.sep)
    end

    p2 = p2:removeprefix(TPath.sep)

    if #p2 > 0 then
        if p == TPath.sep then
            p = p .. p2
        else
            p = string.join(TPath.sep, {p, p2})
        end
    end

    if ... then
        p = TPath.join(p, ...)
    end

    return p
end)

TPath.joinpath = TPath.join

TPath.parents = TPath.make_list_fn_match_input(function(p)
    local parts = TPath.parts(p)
    parts:pop()

    local parents = List()
    for _, part in ipairs(parts:reverse()) do
        part = TPath(part)
        parents:transform(function(parent) return part:join(parent) end)
        parents:append(part)
    end

    return parents
end)

TPath.parent = TPath.make_fn_match_input(function(p)
    return TPath.parents(p):pop(1)
end)

function TPath.name(p)
    return TPath.parts(p):pop()
end

function TPath.suffixes(p)
    return List(TPath.name(p):split(".")):transform(function(s) return "." .. s end):remove(1)
end

function TPath.suffix(p)
    return PATH.extension(TPath.as_string(p))
end

function TPath.stem(p)
    return TPath.name(p):split(".", 1)[1]
end

TPath.with_name = TPath.make_fn_match_input(function(p, name)
    return TPath(p):parent():join(name)
end)

TPath.with_stem = TPath.make_fn_match_input(function(p, stem)
    return TPath(p):with_name(stem .. TPath.suffix(p))
end)

TPath.with_suffix = TPath.make_fn_match_input(function(p, suffix)
    return TPath(p):with_name(TPath.stem(p) .. suffix)
end)

function TPath.is_relative_to(p, p2)
    p = TPath.as_path(p)
    p2 = TPath.as_path(p2)

    if p == p2 then
        return true
    end

    for _, parent in ipairs(p:parents()) do
        if parent == p2 then
            return true
        end
    end

    return false
end

TPath.relative_to = TPath.make_fn_match_input(function(p, p2)
    p2 = tostring(p2)
    if p:startswith(p2) then
        return p:removeprefix(p2):removeprefix("/")
    else
        error(tostring(p) .. " is not relative to " .. p2)
    end
end)

TPath.resolve = TPath.make_fn_match_input(function(p)
    p = TPath.as_path(p)

    if p:parts()[1] == "." then
        p = p:removeprefix(".")
    end

    if not p:is_relative_to(TPath.cwd()) then
        p = TPath.cwd():join(p)
    end

    local parts = List()
    for _, part in ipairs(p:parts()) do
        if part == '..' then
            if #parts > 0 then
                parts:pop()
            end
        else
            parts:append(part)
        end
    end

    if #parts == 0 then
        parts:append(TPath.root())
    end

    p = TPath(parts:pop(1))
    p = p:join(unpack(parts))
    return p
end)

-- something is "file like" if it has a suffix
function TPath.is_file_like(p)
    return #TPath.suffix(p) > 0
end

-- something is "dir like" if it has no suffix
function TPath.is_dir_like(p)
    return #TPath.suffix(p) == 0
end

function TPath.cwd()
    return TPath(os.getenv("PWD"))
end

TPath.iterdir = TPath.make_list_fn_match_input(function(dir, args)
    args = Dict.from(args, {recursive = true, files = true, dirs = true})

    dir = TPath.as_path(dir)

    local paths = List()
    local exclusions = Set({[[.]], [[..]]})
    for stem in lfs.dir(TPath.as_string(dir)) do
        if not exclusions[stem] then
            local p = dir:join(stem)

            if (p:is_file() and args.files) or (p:is_dir() and args.dirs) then
                paths:append(p)
            end

            if p:is_dir() and args.recursive then
                paths:extend(p:iterdir(args))
            end
        end
    end

    return paths
end)

function TPath.rmdir(p, force)
    p = TPath.as_path(p)
    force = force or false

    if not p:exists() then
        return
    end

    if force then
        p:iterdir():reverse():foreach(function(_p)
            if _p:is_file() then
                _p:unlink()
            elseif _p:is_dir() then
                _p:rmdir()
            end
        end)
    end

    if p:is_empty() then
        PATH.rmdir(tostring(p))
    end
end

TPath.root = TPath(TPath.sep)
TPath.home = TPath(os.getenv("HOME"))
TPath.tempdir = TPath.root:join("tmp")

return TPath
