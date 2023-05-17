local List = require("hl.List")

describe("append", function()
    it("works", function()
        local l = List()
        l:append("a")
        l:append("b")

        assert.are.same({"a", "b"}, l)
    end)
end)

describe("extend", function()
    it("works", function()
        local a = {1, 2, 3}
        local b = {4, 5, 6}

        local l = List(a, b)

        assert.are.same({1, 2, 3, 4, 5, 6}, l)
        assert.are.same({1, 2, 3}, a)
        assert.are.same({4, 5, 6}, b)
        local z
    end)

end)

describe("contains", function()
    it("+", function()
        assert(List({1, 2, 3}):contains(1))
    end)

    it("-", function()
        assert.falsy(List({1, 2, 3}):contains(4))
    end)
end)

describe("reverse", function()
    it("even", function()
        assert.are.same({1, 2, 3, 4}, List({4, 3, 2, 1}):reverse())
    end)

    it("odd", function()
        assert.are.same({1, 2, 3}, List({3, 2, 1}):reverse())
    end)
end)

describe("pop", function()
    it("empty", function()
        assert.is_nil(List():pop())
    end)

    it("non-empty", function()
        assert.are.same(3, List({1, 2, 3}):pop())
    end)
end)

describe("is_like", function()
    it("nil: -", function()
        assert.falsy(List.is_like())
    end)

    it("dict: -", function()
        assert.falsy(List.is_like({a = 1}))
    end)

    it("list: +", function()
        assert(List.is_like({1, 2, 3}))
    end)
end)
