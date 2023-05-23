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

function TPath:_init(path)
    self.p = tostring(path)
end

function TPath:__tostring()
    return self.p
end

function TPath.__eq(p1, p2)
    return tostring(p1) == tostring(p2)
end

function TPath.root()
    return TPath(TPath.sep)
end

function TPath.home()
    return TPath(os.getenv("HOME"))
end

function TPath.cwd()
    return TPath(os.getenv("PWD"))
end

function TPath:is_file()
    return PATH.isfile(tostring(self)) and true
end

function TPath:is_dir()
    return PATH.isdir(tostring(self)) and true
end

function TPath.tempdir()
    return TPath("/tmp")
end

function TPath:exists()
    return PATH.exists(tostring(self)) and true
end

function TPath:rename(target)
    if self:is_file() then
        PATH.rename(tostring(self), tostring(target), true)
    elseif self:is_dir() then
        PATH.copy(tostring(self), tostring(target))

        if tostring(self) ~= tostring(target) then
            self:rmdir(true)
        end
    end
end

function TPath:removesuffix(suffix)
    return TPath(self.p:removesuffix(suffix))
end

function TPath:removeprefix(prefix)
    return TPath(self.p:removeprefix(prefix))
end

function TPath:is_empty()
    return PATH.isempty(tostring(self)) and true
end

function TPath:mkdir()
    PATH.mkdir(tostring(self))
end

function TPath:unlink()
    PATH.remove(tostring(self))
end

function TPath:join(p2, ...)
    local p = self.p

    if p ~= self.sep then
        p = p:removesuffix(self.sep)
    end

    p2 = tostring(p2):removeprefix(self.sep)

    if #p2 > 0 then
        if p == self.sep then
            p = p .. p2
        else
            p = string.join(self.sep, {p, p2})
        end
    end

    p = TPath(p)

    if ... then
        p = p:join(...)
    end

    return p
end

function TPath:__concat(p)
    return self:join(p)
end

function TPath:parts()
    local parts = List()
    for _, part in ipairs(tostring(self):split(self.sep)) do
        if #part > 0 then
            parts:append(part)
        end
    end

    if tostring(self):startswith(self.sep) then
        parts:put(self.sep)
    end

    return parts
end

function TPath:parents()
    local parts = self:parts()
    parts:pop()
    local parents = List()
    for _, part in ipairs(parts:reverse()) do
        part = TPath(part)
        parents:transform(function(parent) return part:join(parent) end)
        parents:append(part)
    end

    return parents
end

function TPath:parent()
    return self:parents():pop(1)
end

function TPath:expanduser()
    if self.p:startswith("~/") then
        self.p = self.p:removeprefix("~/")
        return self.home():join(self)
    end

    return self
end

function TPath:write(content)
    if not self:parent():exists() then
        self:parent():mkdir()
    end

    content = List.as_list(content)
    content:transform(tostring)

    local fh = io.open(tostring(self), "w")
    fh:write(content:join("\n"))
    fh:close()
end

function TPath:read()
    local fh = io.open(tostring(self), "r")
    local content = fh:read("*a")
    fh:close()
    return content
end

function TPath:readlines()
    return self:read():splitlines()
end


function TPath:touch()
    if not self:exists() then
        self:write("")
    end
end

function TPath:iterdir(args)
    args = Dict.from(args, {recursive = true, files = true, dirs = true})

    local paths = List()

    local exclusions = Set({[[.]], [[..]]})
    for stem in lfs.dir(tostring(self)) do
        if not exclusions[stem] then
            local p = self:join(stem)

            if (p:is_file() and args.files) or (p:is_dir() and args.dirs) then
                paths:append(p)
            end

            if p:is_dir() and args.recursive then
                paths:extend(p:iterdir(args))
            end
        end
    end

    return paths
end

function TPath:rmdir(force)
    force = force or false

    if not self:exists() then
        return
    end

    if force then
        for _, p in ipairs(self:iterdir():reverse()) do
            if p:is_file() then
                p:unlink()
            elseif p:is_dir() then
                p:rmdir()
            end
        end
    end

    if self:is_empty() then
        PATH.rmdir(tostring(self))
    end
end

function TPath:name()
    return self:parts():pop()
end

function TPath:suffixes()
    local suffixes = List()
    for i, suffix in ipairs(self:name():split(".")) do
        if i ~= 1 then
            suffixes:append("." .. suffix)
        end
    end

    return suffixes
end

function TPath:suffix()
    return PATH.extension(tostring(self))
end

function TPath:stem(p)
    return self:name():split(".", 1)[1]
end

function TPath:with_name(name)
    return self:parent():join(name)
end

function TPath:with_stem(stem)
    return self:with_name(stem .. self:suffix())
end

function TPath.with_suffix(p, suffix)
    return TPath.with_name(p, TPath.stem(p) .. suffix)
end

function TPath:is_relative_to(other)
    other = tostring(other)
    if other == tostring(self) then
        return true
    end

    for _, parent in ipairs(self:parents()) do
        if tostring(parent) == other then
            return true
        end
    end

    return false
end

function TPath:relative_to(other)
    other = tostring(other)
    p = tostring(self)
    if p:startswith(other) then
        return TPath(p:removeprefix(other):removeprefix("/"))
    else
        error(p .. " is not relative to " .. other)
    end
end

function TPath:resolve()
    local p = TPath(tostring(self))

    if p:parts()[1] == "." then
        p = p:removeprefix(".")
    end

    if not p:is_relative_to(p.cwd()) then
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
        parts:append(p.root())
    end

    p = TPath(parts:pop(1))
    p = p:join(unpack(parts))
    return p
end

-- something is "file like" if it has a suffix
function TPath:is_file_like()
    return #self:suffix() > 0
end

-- something is "dir like" if it has no suffix
function TPath:is_dir_like()
    return #self:suffix() == 0
end


return TPath

