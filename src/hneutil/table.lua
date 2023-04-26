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

function table.list_contains(tbl, item)
    for _, tbl_item in ipairs(tbl) do
        if tbl_item == item then
            return true
        end
    end

    return false
end

function table.is_list(tbl)
    if type(tbl) ~= 'table' then
        return false
    end

    -- objects always return empty size
    if #tbl > 0 then
        return true
    end

    -- only object can have empty length with elements inside
    for k, v in pairs(tbl) do
        return false
    end

    -- if no elements it can be array and not at same time
    return true
end

function table.size(tbl)
    if table.is_list(tbl) then
        return #tbl
    else
        local count = 0
        for k, v in pairs(tbl) do
            count = count + 1
        end
        return count
    end
end

return table
