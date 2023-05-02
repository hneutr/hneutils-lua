table = require('hneutil.table')

describe("default", function()
    it("simple table", function()
        local original = {a = 1, b = 2}
        local defaults = {a = 0, b = -1, c = -2}

        assert.are.same(
            table.default(original, defaults),
            {a = 1, b = 2, c = -2}
        )
    end)

    it("nested table", function()
        local original = {a = 1, b = 2, nested = {z = 100}}
        local defaults = {a = 0, b = -1, c = -2, nested = {z = 10, x = 11}}

        assert.are.same(
            table.default(original, defaults),
            {a = 1, b = 2, c = -2, nested = {z = 100, x = 11}}
        )
    end)

    it("double nested table", function()
        local original = {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}}}
        local defaults = {a = 0, b = { b1 = {c = 10}, b2 = {c = 21}, b3 = {c = 22}}}

        assert.are.same(
            table.default(original, defaults),
            {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}, b3 = {c = 22}}}
        )
    end)
end)

describe("list_extend", function()
    it("extends the table", function()
        assert.are.same({1, 2, 3, 4}, table.list_extend({1}, {2, 3}, {4}))
    end)
end)

describe("reverse", function()
    it("does it", function()
        assert.are.same({3, 2, 1}, table.reverse({1, 2, 3}))
    end)
end)

describe("list_contains", function()
    it("element contained", function()
        assert(table.list_contains({1, 2, 3}, 3))
    end)
    it("element contained", function()
        assert.is_false(table.list_contains({1, 2, 3}, 4))
    end)
end)

describe("is_list", function()
    it("empty list", function()
        assert(table.is_list({}))
    end)
    it("list", function()
        assert(table.is_list({1, 2, 3}))
    end)
    it("dict", function()
        assert.falsy(table.is_list({a = 1, b = 2, c = 3}))
    end)
end)

describe("size", function()
    it("list", function()
        assert.are.same(3, table.size({1, 2, 3}))
    end)

    it("dict", function()
        assert.are.same(3, table.size({a = 1, b = 2, c = 3}))
    end)
end)

