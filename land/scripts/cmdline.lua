_ENV = setenv(...,_ENV);

print("hello world! 你好，世界！");

local chatTrigger = common.CreateTrigger();
common.TriggerRegisterPlayerChatEvent(chatTrigger, common.Player(0), "-", false);

local chatEvent = function()
    local str = common.GetEventPlayerChatString();
    str = string.trim(str);
    if (string.startswith(str,"-")) then
        str = string.sub(str, 2, #str);

        if (string.isnullorempty(str)) then
            return;
        end

        local cmdlines = string.split(str, " ");
        local cmd = cmdlines[1];
        local args = {}
        for i,v in ipairs(cmdlines) do
            if (i > 1 ) then
                args[i-1] = v;
            end
         --   console.write(v);
        end
        local f = handler[cmd].f;
        if (f) then
            f(table.unpack(args));
        end
    end
end

common.TriggerAddAction(chatTrigger, chatEvent);

