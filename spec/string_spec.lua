require 'busted.runner'()

describe("split", function()
    before_each(function()
        string = require('util.string')
    end)

    it("nothing to split", function()
        local input = "a"
        local out = {"a"}
        assert.are.same(string.split(input), out)
    end)

    it("separator at start", function()
        local input = " a"
        local out = {"a"}
        assert.are.same(string.split(input), out)
    end)

    it("separator at end", function()
        local input = "a "
        local out = {"a"}
        assert.are.same(string.split(input), out)
    end)

    it("1 split", function()
        local input = "a b"
        local out = {"a", "b"}
        assert.are.same(string.split(input), out)
    end)

    it("2 split", function()
        local input = "a b c"
        local out = {"a", "b", "c"}
        assert.are.same(string.split(input), out)
    end)

    it("separator", function()
        local input = "a-b-c"
        local out = {"a", "b", "c"}
        assert.are.same(string.split(input, "-"), out)
    end)
end)
