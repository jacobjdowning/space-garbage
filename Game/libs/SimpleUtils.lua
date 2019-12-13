local SimpleUtils = {}

function SimpleUtils.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[SimpleUtils.deepcopy(orig_key)] = SimpleUtils.deepcopy(orig_value)
        end
        setmetatable(copy, SimpleUtils.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return SimpleUtils