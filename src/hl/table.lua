local List = require("hl.List")
local Dict = require("hl.Dict")

function table.default(t, t2, ...)
    if t == nil then
        t = t2
    elseif type(t) == 'table' and type(t2) == 'table' then
        for _, _t2 in ipairs(t2) do
            table.insert(t, _t2)
        end

        for k, v2 in pairs(t2) do
            t[k] = table.default(t[k], v2)
        end
    end

    if ... then
        t = table.default(t, ...)
    end
        
    return t
end

return table
