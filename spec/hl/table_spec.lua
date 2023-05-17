table = require('hl.table')

describe("default", function()
    it("number", function()
        assert.are.same(1, table.default(nil, 1))
    end)

    it("table and list", function()
        assert.are.same({a = 1, "b", "c"}, table.default({a = 1}, {"b", "c"}))
    end)

    it("table and table", function()
        assert.are.same(
            {a = true, b = true},
            table.default({a = true}, {a = false, b = true})
        )
    end)

    it("simple table", function()
        assert.are.same(
            {a = 1, b = 2, c = -2},
            table.default({a = 1, b = 2}, {a = 0, b = -1, c = -2})
        )
    end)

    it("nested table", function()
        assert.are.same(
            {a = 1, b = 2, c = -2, nested = {z = 100, x = 11}},
            table.default(
                {a = 1, b = 2, nested = {z = 100}},
                {a = 0, b = -1, c = -2, nested = {z = 10, x = 11}}
            )
        )
    end)

    it("double nested table", function()
        assert.are.same(
            {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}, b3 = {c = 22}}},
            table.default(
                {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}}},
                {a = 0, b = { b1 = {c = 10}, b2 = {c = 21}, b3 = {c = 22}}}
            )
        )
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
