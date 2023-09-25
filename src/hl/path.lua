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

-- local lfs = require('lfs')
-- local Dict = require("hl.Dict")
-- local List = require("hl.List")
-- local PATH = require("path")
local TPath = require("hl.TPath")
-- string = require("hl.string")

local Path = {}

-- Path.exists = PATH.exists
-- Path.unlink = PATH.remove
-- Path.is_file = PATH.isfile
-- Path.is_dir = PATH.isdir
-- Path.mkdir = PATH.mkdir
-- Path.name = PATH.basename
-- Path.suffix = PATH.extension
-- Path.is_empty = PATH.isempty
-- Path.rename = PATH.rename

-- Path.rmdir = TPath.rmdir
-- Path.read = TPath.read
-- Path.readlines = TPath.readlines
-- Path.write = TPath.write
-- Path.touch = TPath.touch
-- Path.suffixes = TPath.suffixes
-- Path.stem = TPath.stem
-- Path.parts = TPath.parts
-- Path.with_name = TPath.with_name
-- Path.with_stem = TPath.with_stem
-- Path.with_suffix = TPath.with_suffix
-- Path.expanduser = TPath.expanduser
-- Path.is_relative_to = TPath.is_relative_to
-- Path.relative_to = TPath.relative_to
-- Path.resolve = TPath.resolve
-- Path.parents = TPath.parents
-- Path.parent = TPath.parent
-- Path.iterdir = TPath.iterdir
-- Path.is_file_like = TPath.is_file_like
-- Path.is_dir_like = TPath.is_dir_like

-- Path.joinpath = TPath.join
-- Path.home = TPath.home
-- Path.root = TPath.root
-- Path.cwd = TPath.cwd
-- Path.tempdir = TPath.tempdir

return TPath
