Path = require('util.path')

describe("exists", function()
    it("does", function()
        assert(Path.exists("/Users/hne/Desktop"))
    end)

    it("doesn't", function()
        assert.is_false(Path.exists("steve"))
    end)
end)

describe("joinpath", function()
    it("base case", function()
        assert.are.equal("a/b.c", Path.joinpath("a", "b.c"))
    end)

    it("empty second", function()
        assert.are.equal("a", Path.joinpath("a", ""))
    end)


    it("multiple", function()
        assert.are.equal("a/b/c.d", Path.joinpath("a", "b", "c.d"))
    end)

    it("trailing /", function()
        assert.are.equal("a/b", Path.joinpath("a/", "b"))
    end)

    it("leading /", function()
        assert.are.equal("a/b", Path.joinpath("a", "/b"))
    end)
end)
