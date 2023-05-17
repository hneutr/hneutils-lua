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
    if l.is_a == nil or not l.is_a(List) then
        l = List(l)
    end

    if l2 and #l2 then
        for _, v in ipairs(l2) do
            l:append(v)
        end
    end

    if ... then
        l = l:extend(...)
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

function List.is_like(v)
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
