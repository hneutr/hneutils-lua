package = "hneutil-lua"
version = "dev-1"
source = {
   url = "https://github.com/hneutr/hneutils-lua.git"
}
description = {
   homepage = "hne.golf",
   license = "MIT",
}
dependencies = {
   "lua ~> 5.1",
   "busted >= 2.1"
}
build = {
   type = "builtin",
   modules = {}
}
