rockspec_format = "3.0"
package = "hneutil-lua"
version = "dev-16"
source = {
   url = "git://github.com/hneutr/hneutils-lua"
}
description = {
   homepage = "hne.golf",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1",
   "lua-path >= 0.3"
}
build = {
   type = "builtin",
   modules = {
      ["hl"] = "src/hl/init.lua",
      ["hl.io"] = "src/hl/io.lua",
      ["hl.object"] = "src/hl/object.lua",
      ["hl.string"] = "src/hl/string.lua",
      ["hl.yaml"] = "src/hl/yaml.lua",
      ["hl.Dict"] = "src/hl/Dict.lua",
      ["hl.List"] = "src/hl/List.lua",
      ["hl.Path"] = "src/hl/Path.lua",
   }
}
test = {
   type = "busted",
   platforms = {
      unix = {
         flags = {
            "--exclude-tags=ssh,git"
         }
      },
      windows = {
         flags = {
            "--exclude-tags=ssh,git,unix"
         }
      }
   }
}
