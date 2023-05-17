require("pl.class").List()

function List:_init(...)
    self:extend(...)
end

function List.append(l, v)
    table.insert(l, v)
end

function List.pop(l)
    local item
    if #l > 0 then
        item = l[#l]
        l[#l] = nil
    end

    return item
end

function List.extend(l, l2, ...)
    if l2 and #l2 then
        for _, v in ipairs(l2) do
            List.append(l, v)
        end
    end

    if ... then
        l = List.extend(l, ...)
    end
        
    return l
end

function List.contains(l, item)
    for _, _item in ipairs(l) do
        if _item == item then
            return true
        end
    end

    return false
end

function List.reverse(l)
    local n = #l
    for i = 1, n/2 do
        l[i], l[n] = l[n], l[i]
        n = n - 1
    end

    return l
end

function List.is_listlike(v)
    if type(v) ~= 'table' then
        return false
    end

    if #v > 0 then
        return true
    end

    for _, _ in pairs(v) do
        return false
    end

    return true
end

return List
