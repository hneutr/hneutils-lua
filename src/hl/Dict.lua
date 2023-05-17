require("pl.class").Dict()

function Dict:_init(...)
    self:update(...)
end

function Dict.update(t, t2, ...)
    if t == nil then
        t = t2
    elseif type(t) == 'table' and type(t2) == 'table' then
        for k, v2 in pairs(Dict.delist(t2)) do
            t[k] = Dict.update(t[k], v2)
        end
    end

    if ... then
        t = Dict.update(t, ...)
    end
        
    return t
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

return Dict
