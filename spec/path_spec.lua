Path = require('util.path')

local test_file_path = "/tmp/test-file.txt"

local test_dir_path = "/tmp/test-dir"
local test_dir_file_path = "/tmp/test-dir/test-file.txt"

local test_subdir_path = "/tmp/test-dir/subdir"
local test_subdir_file_path = "/tmp/test-dir/subdir/test-file.txt"

local test_subsubdir_path = "/tmp/test-dir/subdir/subsubdir"
local test_subsubdir_file_path = "/tmp/test-dir/subdir/subsubdir/test-file.txt"

before_each(function()
    Path.rmdir(test_dir_path, true)
    Path.unlink(test_file_path)
end)

describe("exists", function()
    it("does", function()
        assert(Path.exists("/Users/hne/Desktop"))
    end)

    it("doesn't", function()
        assert.is_false(Path.exists("steve"))
    end)
end)

describe("read", function()
    it("reads file", function()
        local content = "1\n2"

        local fh = io.open(test_file_path, "w")
        fh:write(content)
        fh:flush()
        fh:close()

        assert.are.equal(content, Path.read(test_file_path))
    end)
end)

describe("readlines", function()
    it("does", function()
        Path.write(test_file_path, "1\n2")

        assert.are.same({"1", "2"}, Path.readlines(test_file_path))
    end)
end)

describe("write", function()
    it("writes str", function()
        local content = "123"
        Path.write(test_file_path, content)
        assert.are.equal(content, Path.read(test_file_path))
    end)

    it("writes int", function()
        local content = 1
        Path.write(test_file_path, content)
        assert.are.equal(tostring(content), Path.read(test_file_path))
    end)

    it("writes table of strs", function()
        local content = {"a", "b"}
        Path.write(test_file_path, content)
        assert.are.equal("a\nb", Path.read(test_file_path))
    end)
end)

describe("unlink", function()
    it("removes existing file", function()
        Path.write(test_file_path, "1")

        assert(Path.exists(test_file_path))
        Path.unlink(test_file_path)
        assert.is_false(Path.exists(test_file_path))
    end)

    it("doesn't remove non-existing file", function()
        assert.is_false(Path.exists(test_file_path))
        Path.unlink(test_file_path)
        assert.is_false(Path.exists(test_file_path))
    end)
end)

describe("touch", function()
    it("creates file if it doesn't exist", function()
        Path.unlink(test_file_path)
        assert.is_false(Path.exists(test_file_path))
        Path.touch(test_file_path)
        assert(Path.exists(test_file_path))
    end)

    it("does not overwrite existing file", function()
        local content = "123"
        Path.write(test_file_path, content)
        Path.touch(test_file_path)
        assert(Path.exists(test_file_path))
        assert.are.equal(content, Path.read(test_file_path))
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

describe("is_file", function()
    it("+", function()
        Path.touch(test_file_path)
        assert(Path.is_file(test_file_path))
    end)

    it("-: non-existing", function()
        Path.unlink(test_file_path)
        assert.is_false(Path.is_file(test_file_path))
    end)

    it("-: dir", function()
        assert.is_false(Path.is_file("/tmp"))
    end)
end)

describe("is_dir", function()
    it("+", function()
        assert(Path.is_dir("/tmp"))
    end)

    it("-: non-existing", function()
        assert.is_false(Path.exists("/fake-dir"))
        assert.is_false(Path.is_dir("/fake-dir"))
    end)

    it("-: file", function()
        Path.touch(test_file_path)
        assert.is_false(Path.is_dir(test_file_path))
    end)
end)

describe("rmdir", function()
    it("doesn't remove non-existing", function()
        assert.is_false(Path.exists(test_dir_path))
    end)

    it("removes existing", function()
        Path.mkdir(test_dir_path)
        assert(Path.exists(test_dir_path))
        Path.rmdir(test_dir_path)
        assert.is_false(Path.exists(test_dir_path))
    end)

    it("doesn't remove if non-empty", function()
        Path.mkdir(test_dir_path)
        Path.touch(test_dir_file_path)
        Path.rmdir(test_dir_path)
        assert(Path.exists(test_dir_path))
    end)

    it("removes if non-empty and `force`", function()
        Path.mkdir(test_dir_path)
        Path.touch(test_dir_file_path)

        Path.mkdir(test_subdir_path)
        Path.touch(test_subdir_file_path)

        Path.mkdir(test_subsubdir_path)
        Path.touch(test_subsubdir_file_path)

        Path.rmdir(test_dir_path, true)
        assert.is_false(Path.exists(test_dir_path))
    end)
end)

describe("is_empty", function()
    it("empty dir", function()
        Path.mkdir(test_dir_path)
        assert(Path.is_empty(test_dir_path))
    end)

    it("non-empty dir", function()
        Path.mkdir(test_dir_path)
        Path.touch(test_dir_file_path)
        assert.is_false(Path.is_empty(test_dir_path))
    end)
end)

describe("mkdir", function()
    it("+", function()
        assert.is_false(Path.exists(test_dir_path))
        Path.mkdir(test_dir_path)
        assert(Path.is_dir(test_dir_path))
    end)

    it("existing", function()
        local content = "1"
        Path.mkdir(test_dir_path)
        Path.write(test_dir_file_path, content)
        Path.mkdir(test_dir_path)
        assert.are.equal(content, Path.read(test_dir_file_path))
    end)

    it("makes parents", function()
        assert.is_false(Path.exists(test_dir_path))
        assert.is_false(Path.exists(test_subdir_path))
        Path.mkdir(test_subdir_path)
        assert(Path.exists(test_dir_path))
        assert(Path.exists(test_subdir_path))
    end)
end)

describe("name", function()
    it("with suffix", function()
        assert.are.equal("c.txt", Path.name("a/b/c.txt"))
    end)

    it("no suffix", function()
        assert.are.equal("c", Path.name("a/b/c"))
    end)
end)

describe("suffix", function()
    it("with suffix", function()
        assert.are.equal(".txt", Path.suffix("a/b/c.txt"))
    end)

    it("no suffix", function()
        assert.are.equal("", Path.suffix("a/b/c"))
    end)

    it("multiple suffixes", function()
        assert.are.equal(".y", Path.suffix("a/b/c.x.y"))
    end)
end)

describe("suffixes", function()
    it("none", function()
        assert.are.same({}, Path.suffixes("a/b"))
    end)

    it("1", function()
        assert.are.same({".x"}, Path.suffixes("a/b.x"))
    end)

    it("2", function()
        assert.are.same({".x", ".y"}, Path.suffixes("a/b.x.y"))
    end)
end)

describe("stem", function()
    it("with suffix", function()
        assert.are.equal("c", Path.stem("a/b/c.txt"))
    end)

    it("no suffix", function()
        assert.are.equal("c", Path.stem("a/b/c"))
    end)
end)

describe("parts", function()
    it("single", function()
        assert.are.same({"a"}, Path.parts("a"))
    end)

    it("with root", function()
        assert.are.same({"/", "a"}, Path.parts("/a"))
    end)

    it("multiple", function()
        assert.are.same({"a", "b", "c"}, Path.parts("a/b/c"))
    end)
end)

describe("parents", function()
    it("has parents", function()
        assert.are.same({"a/b/c", "a/b", "a"}, Path.parents("a/b/c/d"))
    end)
    it("no parents", function()
        assert.are.same({}, Path.parents("a"))
    end)
    it("parents with root", function()
        assert.are.same({"/a/b/c", "/a/b", "/a", "/"}, Path.parents("/a/b/c/d"))
    end)
end)

describe("parent", function()
    it("has parent", function()
        assert.are.same("/a", Path.parent("/a/b"))
    end)
    it("no parent", function()
        assert.are.same("/", Path.parent("/a"))
    end)
end)

describe("with_name", function()
    it("does it", function()
        assert.are.same("/a/b/x.y", Path.with_name("/a/b/c.d", "x.y"))
    end)
end)

describe("with_stem", function()
    it("no suffix", function()
        assert.are.same("/a/b/x", Path.with_stem("/a/b/c", "x"))
    end)
    it("has suffix", function()
        assert.are.same("/a/b/x.d", Path.with_stem("/a/b/c.d", "x"))
    end)
end)

describe("with_suffix", function()
    it("no suffix", function()
        assert.are.same("/a/b/c.x", Path.with_suffix("/a/b/c", ".x"))
    end)
    it("has suffix", function()
        assert.are.same("/a/b/c.x", Path.with_suffix("/a/b/c.d", ".x"))
    end)
end)

describe("iterdir", function()
    it("works", function()
        local root = test_dir_path
        local a = Path.joinpath(root, "a")
        local b = Path.joinpath(a, "b")

        Path.mkdir(root)
        Path.mkdir(a)
        Path.mkdir(b)

        local root_f = Path.joinpath(root, "1.txt")
        local a_f = Path.joinpath(a, "2.txt")
        local b_f = Path.joinpath(b, "3.txt")

        Path.touch(root_f)
        Path.touch(a_f)
        Path.touch(b_f)

        local expected = {
            a,
            a_f,
            b,
            b_f,
            root_f,
        }

        assert.are.same(expected, Path.iterdir(root))
    end)

    it("doesn't recurse", function()
        local root = test_dir_path
        local subdir = Path.joinpath(root, "dir")
        local file = Path.joinpath(root, "file.txt")
        local subfile = Path.joinpath(subdir, "file.txt")

        Path.mkdir(root)
        Path.mkdir(subdir)
        Path.touch(file)
        Path.touch(subfile)

        local expected = {
            file,
            subdir,
        }

        assert.are.same(expected, Path.iterdir(root, {recursive = false}))
    end)

    it("files only", function()
        local root = test_dir_path
        local subdir = Path.joinpath(root, "dir")
        local file = Path.joinpath(root, "file.txt")
        local subfile = Path.joinpath(subdir, "file.txt")

        Path.mkdir(root)
        Path.mkdir(subdir)
        Path.touch(file)
        Path.touch(subfile)

        assert.are.same({file, subfile}, Path.iterdir(root, {dirs = false}))
    end)

    it("dirs only", function()
        local root = test_dir_path
        local subdir = Path.joinpath(root, "dir")
        local file = Path.joinpath(root, "file.txt")

        Path.mkdir(root)
        Path.mkdir(subdir)
        Path.touch(file)

        assert.are.same({subdir}, Path.iterdir(root, {files = false}))
    end)
end)
