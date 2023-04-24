io = require('hneutil.io')
local Path = require("hneutil.path")

describe("command", function()
    it("simple command", function()
        assert.are.same('a\n', io.command("echo 'a'"))
    end)

    it("cd", function()
        local command = "cd " .. Path.tempdir() .. " && echo $PWD"
        assert.are.same(Path.tempdir() .. '\n', io.command(command))
    end)
end)
