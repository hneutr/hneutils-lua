local Path = {}
local lfs = require('lfs')
local Object = require("util.object")
local PATH = require("path")
string = require("util.string")


local Path = {}
Path.exists = PATH.exists

Path.joinpath = function(one, two, ...)
    one = one or ''
    two = two or ''

    if two:startswith("/") then
        if two:len() > 1 then
            two = two:sub(2)
        else
            two = ''
        end
    end

    if two:len() > 0 then
        return PATH.join(one, two, ...)
    else
        return one
    end
end

-- home: PATH.user_home
-- root: PATH.root
-- cwd: PATH.currentdir

-- is_file: PATH.isfile
-- unlink: PATH.remove

-- is_dir: PATH.isdir
-- mkdir: PATH.mkdir
-- rmdir: PATH.rmdir
-- iterdir

-- name: PATH.basename
-- with_name

-- parent
-- parents
-- parts

-- relative_to
-- is_relative_to

-- stem
-- with_stem

-- suffix: PATH.extension
-- suffixes
-- with_suffix

-- read_text
-- write_text

-- glob
-- rglob

-- rename: PATH.rename
-- touch
-- link_to
-- readlink
-- symlink_to

-- expanduser

-- absolute: PATH.abspath

-- PATH.has_dir_end
-- PATH.remove_dir_end
-- PATH.ensure_dir_end
-- PATH.normalize
-- PATH.splitext
-- PATH.splitpath
-- PATH.split
-- PATH.splitroot
-- PATH.splitdrive

-- PATH.dirname

-- PATH.isfullpath
-- PATH.isabs
-- PATH.tmpdir
-- PATH.tmpname

-- PATH.fullpath
-- PATH.islink
-- PATH.isempty

-- PATH.copy
-- PATH.chdir
-- PATH.each




-- PATH.flags
-- PATH.size
-- PATH.getsize
-- PATH.ctime
-- PATH.mtime
-- PATH.atime
-- PATH.cdate
-- PATH.mdate
-- PATH.adate
-- PATH.getctime
-- PATH.getmtime
-- PATH.getatime



--[[
-----------------------------------[ suffix ]-----------------------------------
-- dir/file.suffix → suffix
function Path.suffix(path)
    local pre, suffix = string.match(path, "(.*)%.(.%)")
    return suffix
end

-- dir/file.suffix → file
function Path.stem(path)
    if string.find(path, "/") ~= 0 then
        path = path:gsub(".*/", "")
    end

    local stem, suffix = path:match("(.*)%.(.*)")
    return stem
end

function Path.read(path)
    local file, errorString = io.open(path, "r")
    split = split or false

    local contents

    if file then
        contents = file:read("*a")
        io.close(file)

    else
        print( "File error: " .. errorString )
    end
    
    file = nil
    return contents
end

function Path.readlines(path)
    return string.split(Path.read(path), "\n")
end

------------------------------------[ trim ]------------------------------------
function Path.ltrim(path)
    local called_with = path
    path = path or ''
    path = tostring(path):gsub("^/", "", 1)
    return path
end

function Path.rtrim(path)
    local called_with = path
    path = path or ''
    path = tostring(path):gsub("/$", "", 1)
    return path
end

function Path.trim(path)
    return Path.ltrim(Path.rtrim(path))
end



function Path.join(left, right, ...)
    local path = tostring(Path.rtrim(left)) .. '/' .. tostring(Path.ltrim(right))
    path = Path.rtrim(path)

    if ... then
        path = Path.join(path, ...)
    end
    
    return path
end

function Path.listDir(dir)
    local items = {}
    local exclusions = {
        ["."] = true, 
        [".."] = true,
    }
    for stem in lfs.dir(dir) do
        if not exclusions[stem] then
            table.insert(items, Path.join(dir, stem))
        end
    end

    return items
end
]]
return Path
