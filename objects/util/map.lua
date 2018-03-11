function map(array, func)
    local new_array = {}
    for k, v in ipairs(array) do
        new_array[k] = func(k, v)
    end
    return new_array
end