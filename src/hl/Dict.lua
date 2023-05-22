require("pl.class").Dict()

function Dict:_init(...)
    self:update(...)
end

function Dict.update(d, d2, ...)
    if d == nil then
        d = d2
    elseif type(d) == 'table' and type(d2) == 'table' then
        for k, v2 in pairs(Dict.delist(d2)) do
            d[k] = Dict.update(d[k], v2)
        end
    end

    if ... then
        d = Dict.update(d, ...)
    end
        
    return d
end

function Dict.delist(t)
    local _t = {}
    for k, v in pairs(t) do
        _t[k] = v
    end

    for i, v in ipairs(t) do
        _t[i] = nil
    end

    return _t
end

function Dict.keys(d)
    local keys = {}
    for key, _ in pairs(d) do
        table.insert(keys, key)
    end

    return keys
end

function Dict.values(d)
    local values = {}
    for _, value in pairs(d) do
        table.insert(values, value)
    end

    return values
end

return Dict
