string = require("hneutil.string")
local Path = require("hneutil.path")
local lyaml = require("lyaml")

local M = {}

M.load = lyaml.load
M.document_frontmatter_separator = "\n\n\n"

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
    local frontmatter_str = M.dump(frontmatter_table)

    text = text or ''

    if type(text) == "table" then
        text = string.join("\n", text)
    end

    local content = frontmatter_str:rstrip()
    if text:len() > 0 then
        content = content .. M.document_frontmatter_separator .. text:lstrip()
    end

    Path.write(path, content)
end

function M.read_document(path)
    local contents = Path.read(path)
    local frontmatter_str, text = unpack(contents:split("\n\n\n", 1))
    text = text or ''
    return {M.load(frontmatter_str), text}
end

return M
