require 'busted.runner'()

describe("merge", function()
    before_each(function()
        table = require('util.table')
    end)

    it("simple table", function()
        local original = {a = 1, b = 2}
        local defaults = {a = 0, b = -1, c = -2}

        assert.are.same(
            table.merge(original, defaults),
            {a = 1, b = 2, c = -2}
        )
    end)

    it("nested table", function()
        local original = {a = 1, b = 2, nested = {z = 100}}
        local defaults = {a = 0, b = -1, c = -2, nested = {z = 10, x = 11}}

        assert.are.same(
            table.merge(original, defaults),
            {a = 1, b = 2, c = -2, nested = {z = 100, x = 11}}
        )
    end)

    it("double nested table", function()
        local original = {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}}}
        local defaults = {a = 0, b = { b1 = {c = 10}, b2 = {c = 21}, b3 = {c = 22}}}

        assert.are.same(
            table.merge(original, defaults),
            {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}, b3 = {c = 22}}}
        )
    end)
end)
