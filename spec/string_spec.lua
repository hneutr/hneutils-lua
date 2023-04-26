string = require('hneutil.string')

describe("split", function()
    it("has nothing to split", function()
        assert.are.same({"a"}, string.split("a"))
    end)

    it("starts with sep", function()
        assert.are.same({"a"}, string.split(" a"))
    end)

    it("ends with sep", function()
        assert.are.same({"a"}, string.split("a "))
    end)

    it("once", function()
        assert.are.same({"a", "b"}, string.split("a b"))
    end)

    it("twice", function()
        assert.are.same({"a", "b", "c"}, string.split("a b c"))
    end)

    it("different sep", function()
        assert.are.same({"a", "b", "c"}, string.split("a-b-c", "-"))
    end)

    it("maxsplit", function()
        assert.are.same({"a", "b-c"},string.split("a-b-c", "-", 1))
    end)

    it("long sep", function()
        assert.are.same({"a", "b", "c"},string.split("a--b--c", "--"))
    end)
end)

describe("rsplit", function()
    it("base", function()
        assert.are.same({"a-b", "c"}, string.rsplit("a-b-c", "-", 1))
    end)

    it("long sep", function()
        assert.are.same({"a--b", "c"}, string.rsplit("a--b--c", "--", 1))
    end)
end)

describe("splitlines", function()
    it('base case', function() 
        assert.are.same({"a", "b", "c"}, string.splitlines("a\nb\nc"))
    end)

end)

describe("startswith", function()
    it('positive case', function() 
        assert(string.startswith("abc", "a"))
    end)

    it('negative case', function() 
        assert.is_false(string.startswith("abc", "b"))
    end)

    it('escaped string, plain', function() 
        assert(string.startswith([[%sa]], [[%s]]))
    end)

    it('escaped string, not plain', function() 
        assert.is_false(string.startswith([[%sa]], [[%s]], false))
    end)
end)

describe("endswith", function()
    it('+', function() 
        assert(string.endswith("abc", "c"))
    end)

    it('+: multichar ending', function() 
        assert(string.endswith("abc", "bc"))
    end)

    it('-', function() 
        assert.is_false(string.endswith("abc", "b"))
    end)

    it('escaped string, plain', function() 
        assert(string.endswith([[a%s]], [[%s]]))
    end)

    it('escaped string, not plain', function() 
        assert.is_false(string.endswith([[as%]], [[s%]], false))
    end)
end)

describe("join", function()
    it('does', function() 
        assert.are.equal("a, b, c", string.join(", ", {"a", "b", "c"}))
    end)
end)

describe("lstrip", function()
    it('whitespace', function() 
        assert.are.equal("a ", string.lstrip(" a "))
    end)

    it('multiple chars', function() 
        assert.are.equal("a ", string.lstrip("! a ", {"%s", "%!"}))
    end)
end)

describe("rstrip", function()
    it('whitespace', function() 
        assert.are.equal(" a", string.rstrip(" a "))
    end)

    it('multiple chars', function() 
        assert.are.equal("! a", string.rstrip("! a !", {"%s", "%!"}))
    end)
end)

describe("strip", function()
    it('whitespace', function() 
        assert.are.equal("a", string.strip(" a "))
    end)

    it('multiple chars', function() 
        assert.are.equal("a", string.strip("! a !", {"%s", "%!"}))
    end)
end)

describe("removeprefix", function()
    it('removes', function() 
        assert.are.equal("abcz", string.removeprefix("zabcz", "z"))
    end)

    it('multichar prefix', function() 
        assert.are.equal("abczzzz", string.removeprefix("zzzabczzzz", "zzz"))
    end)
end)

describe("removesuffix", function()
    it('removes', function() 
        assert.are.equal("zabc", string.removesuffix("zabcz", "z"))
    end)

    it('multichar prefix', function() 
        assert.are.equal("zzzabc", string.removesuffix("zzzabczzz", "zzz"))
    end)
end)

describe("partition", function()
    it("does", function()
        assert.are.same({"abc ", "1", " xyz"}, string.partition("abc 1 xyz", "1"))
    end)

    it("no sep", function()
        assert.are.same({"abc xyz", "", ""}, string.partition("abc xyz", "1"))
    end)
end)

describe("rpartition", function()
    it("does", function()
        assert.are.same({"abc 1 ", "1", " xyz"}, string.rpartition("abc 1 1 xyz", "1"))
    end)
end)

describe("rfind", function()
    it("does", function()
        assert.are.same(6, string.rfind("a bc bc d", "bc"))
    end)
end)

describe("center", function()
    it("does evenly", function()
        assert.are.same("    ab    ", string.center("ab", 10))
    end)

    it("does oddly", function()
        assert.are.same("     a    ", string.center("a", 10))
    end)

    it("long string", function()
        assert.are.same("a", string.center("a", 1))
    end)
end)

describe("escape", function()
    it("escapes", function()
        for _, char in ipairs({"^", "$", "(", ")", "%", ".", "[", "]", "*", "+", "-", "?"}) do
            assert.are.same("%" .. char, string.escape(char))
        end
    end)
end)

describe("keys", function()
    it("+", function()
        assert.are.same({'a', 'b', 'c'}, table.keys({a = 1, b = 2, c = 3}))
    end)
end)
