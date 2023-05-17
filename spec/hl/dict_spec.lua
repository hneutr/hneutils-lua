local Dict = require("hl.Dict")

describe("delist", function()
    it("works", function()
        assert.are.same(
            {a = 1, ["1"] = 2},
            Dict.delist({a = 1, ["1"] = 2, "b"})
        )
    end)
end)

describe("update", function()
    it("number", function()
        assert.are.same(1, Dict.update(nil, 1))
    end)

    it("table and table, ignores list", function()
        assert.are.same({a = 1, b = 2}, Dict.update({a = 1}, {b = 2, "c"}))
    end)

    it("table and table", function()
        assert.are.same(
            {a = true, b = true},
            Dict.update({a = true}, {a = false, b = true})
        )
    end)

    it("simple table", function()
        assert.are.same(
            {a = 1, b = 2, c = -2},
            Dict.update({a = 1, b = 2}, {a = 0, b = -1, c = -2})
        )
    end)

    it("nested table", function()
        assert.are.same(
            {a = 1, b = 2, c = -2, nested = {z = 100, x = 11}},
            Dict.update(
                {a = 1, b = 2, nested = {z = 100}},
                {a = 0, b = -1, c = -2, nested = {z = 10, x = 11}}
            )
        )
    end)

    it("double nested table", function()
        assert.are.same(
            {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}, b3 = {c = 22}}},
            Dict.update(
                {a = 1, b = { b1 = {c = 100}, b2 = {c = 20}}},
                {a = 0, b = { b1 = {c = 10}, b2 = {c = 21}, b3 = {c = 22}}}
            )
        )
    end)
end)
