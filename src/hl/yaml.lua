string = require("hl.string")
local Path = require("hl.path")
local lyaml = require("lyaml")

local M = {}

M.load = lyaml.load
M.document_frontmatter_separator = "\n\n"

function M.dump(frontmatter_table)
    local str = lyaml.dump({frontmatter_table})
    str = str:removeprefix("---\n")
    str = str:removesuffix("...\n")
    return str
end

function M.write(path, frontmatter_table)
    Path.write(path, M.dump(frontmatter_table))
end

function M.read(path)
    return M.load(Path.read(path))
end

function M.write_document(path, frontmatter_table, text)
    local frontmatter_str = M.dump(frontmatter_table):rstrip()

    text = text or ''

    if type(text) == "table" then
        text = string.join("\n", text)
    end

    text = text:lstrip()

    if #text == 0 then
        text = "\n"
    end

    local content = frontmatter_str .. M.document_frontmatter_separator .. text

    Path.write(path, content)
end

function M.read_document(path)
    local contents = Path.read(path)
    local frontmatter_str, text = unpack(contents:split(M.document_frontmatter_separator, 1))
    text = text or ''
    return {M.load(frontmatter_str), text}
end

return M
