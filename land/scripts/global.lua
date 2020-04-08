function setenv(name,env)
    name = string.trim(name);
    local s = string.split(name,".");
    local t = env;
    for i, v in ipairs(s) do
        if (t[v] == nil) then
            t[v] = {};
            setmetatable(t[v], {__index = env});
        end
        t = t[v];
    end
    return t;
end

