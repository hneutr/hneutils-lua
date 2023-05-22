local class = require("pl.class")

class.PList(require("pl.List"))

function PList:extend(l, ...)
    self = self._base.extend(self, l)

    if ... then
        self = self:extend(...)
    end

    return self
end

function PList.from(...)
    return PList():extend(...)
end

function PList.is_listlike(v)
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

function PList.as_list(v)
    if type(v) ~= 'table' then
        v = {v}
    end

    return PList(v)
end

return PList
