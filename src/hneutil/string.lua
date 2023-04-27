-- ljust
-- rjust

-- lower
-- upper
-- capitalize

-- casefold
-- count
-- encode
-- expandtabs
-- format
-- format_map
-- isalnum
-- isalpha
-- isascii
-- isdecimal
-- isdigit
-- isidentifier
-- islower
-- isnumeric
-- isprintable
-- isspace
-- istitle
-- isupper
-- maketrans
-- swapcase
-- title
-- translate
-- zfill

PLAIN_DEFAULT = true

function _default_plain(plain)
    if plain == nil then
        plain = PLAIN_DEFAULT
    end
    return plain
end

-- function string.split(str, sep, maxsplit, plain)
--     sep = sep or " "
--     plain = _default_plain(plain)

--     local fields = {}
--     local pattern = string.format("([^%s]+)", sep)

--     if maxsplit then
--         for i=1, maxsplit do
--             local sepIndex = str:find(sep, 1, plain)
--             if sepIndex then
--                 fields[#fields + 1] = str:sub(1, sepIndex - 1)
--                 str = str:sub(sepIndex + sep:len())
--             end
--         end

--         if str:len() > 0 then
--             fields[#fields + 1] = str
--         end
--     else
--         str:gsub(pattern, function(c) fields[#fields + 1] = c end)
--     end
    
--     return fields
-- end
function string.split(str, sep, maxsplit, plain)
    default_sep = " "
    sep = sep or default_sep
    plain = _default_plain(plain)

    local splits = {}
    while str:len() > 0 and str:find(sep, 1, plain) do
        local sep_index = str:find(sep, 1, plain)
        if sep_index then
            splits[#splits + 1] = str:sub(1, sep_index - 1)
            str = str:sub(sep_index + sep:len())
        end

        if maxsplit and maxsplit == #splits then
            break
        end
    end

    if type(str) == 'string' then
        splits[#splits + 1] = str
    end

    if sep == default_sep then
        local filtered_splits = {}
        for _, split in ipairs(splits) do
            if split:len() > 0 then
                filtered_splits[#filtered_splits + 1] = split
            end
        end
        splits = filtered_splits
    end
    
    return splits
end


function string.rsplit(str, sep, maxsplit, plain)
    str = str:reverse()
    sep = sep:reverse()

    local reversedSplits = str:split(sep, maxsplit, plain)
    local splits = {}
    for i=#reversedSplits, 1, -1 do
        splits[#splits + 1] = reversedSplits[i]:reverse()
    end

    return splits
end

function string.splitlines(str)
    return str:split("\n")
end

function string.startswith(str, prefix, plain)
    plain = _default_plain(plain)
    return str:find(prefix, 1, plain) == 1
end

function string.endswith(str, suffix, plain)
    return str:reverse():startswith(suffix:reverse(), plain)
end

function string.join(sep, strs)
    local joined = ""
    for _, str in ipairs(strs) do
        if joined:len() > 0 then
            joined = joined .. sep
        end


        joined = joined .. str
    end

    return joined
end

function string.lstrip(str, charsToStrip)
    charsToStrip = charsToStrip or {"%s"}
    local pattern = string.format("^[%s]*(.*)", table.concat(charsToStrip))
    return str:match(pattern)
end

function string.rstrip(str, charsToStrip)
    return str:reverse():lstrip(charsToStrip):reverse()
end

function string.strip(str, charsToStrip)
    return str:lstrip(charsToStrip):rstrip(charsToStrip)
end

function string.removeprefix(str, prefix, plain)
    if str:startswith(prefix, plain) then
        str = str:sub(prefix:len() + 1)
    end

    return str
end

function string.removesuffix(str, suffix, plain)
    return str:reverse():removeprefix(suffix:reverse(), plain):reverse()
end

function string.partition(str, sep, plain)
    plain = _default_plain(plain)

    local sepIndex = str:find(sep, 1, plain)
    if sepIndex then
        pre = str:sub(1, sepIndex - 1)
        post = str:sub(sepIndex + sep:len())
        return {pre, sep, post}
    end

    return {str, '', ''}
end

function string.rpartition(str, sep, plain)
    local reversedPartition = str:reverse():partition(sep:reverse(), plain)
    local partition = {}
    for i=#reversedPartition, 1, -1 do
        partition[#partition + 1] = reversedPartition[i]:reverse()
    end

    return partition
end

function string.rfind(str, substr, plain)
    plain = _default_plain(plain)
    local index = str:reverse():find(substr:reverse(), 1, plain)

    if index then
        index = str:len() - index
    end

    return index
end

function string.center(str, width, fillchar)
    fillchar = fillchar or " "

    while str:len() < width do
        str = fillchar .. str

        if str:len() < width then
            str = str .. fillchar
        end
    end

    return str
end

function string.escape(str)
    return str:gsub('[%-%.%+%[%]%(%)%$%^%%%?%*]','%%%1')
end

return string
