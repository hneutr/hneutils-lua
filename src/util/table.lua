function table.default(tbl, other, ...)
    tbl = tbl or {}
    for k, v in pairs(other) do
        if tbl[k] == nil then
            tbl[k] = other[k]
        elseif type(v) == 'table' then
            tbl[k] = table.default(tbl[k], v)
        end
    end

    if ... then
        tbl = table.default(tbl, ...)
    end
        
    return tbl
end

function table.list_extend(tbl, other, ...)
    tbl = tbl or {}
    for _, val in ipairs(other) do
        tbl[#tbl + 1] = val
    end

    if ... then
        tbl = table.list_extend(tbl, ...)
    end
        
    return tbl
end

function table.reverse(tbl)
    local reversed = {}
    for i=#tbl, 1, -1 do
        reversed[#reversed + 1] = tbl[i]
    end
    return reversed
end

return table
