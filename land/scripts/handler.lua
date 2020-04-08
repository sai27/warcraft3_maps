_ENV = setenv(...,_ENV);

fog = {
    name = "fog",
    help = "设置战争迷雾(int opt)",
    f = function (option)
        option = tonumber(option);
        if (option ~= 0 or option == nil) then
            common.FogEnable(true);
            common.FogMaskEnable(true);
        else
            common.FogEnable(false);
            common.FogMaskEnable(false);
        end
    end
}

cq = {
    name = "create unit quad",
    help = "创建方形单位(name, playeridx, left, bottom, xcount, ycount, delta, angle)",
    -- -cq hfoo 0 0 0 30 30 80 270
    f = function (name, playeridx, left, bottom, xcount, ycount, delta, angle)
        name        = name or "hfoo";
        playeridx   = tonumber(playeridx) or 0;
        left        = tonumber(left) or 0;
        bottom      = tonumber(bottom) or 0;
        xcount      = tonumber(xcount) or 0;
        ycount      = tonumber(ycount) or 0;
        delta       = tonumber(delta) or 0;
        angle       = tonumber(angle) or 0;
        local x = left;
        local y = bottom;
        for i=1, xcount do
            for j=1, ycount do
                common.CreateUnit(common.Player(playeridx), base.string2id('hfoo'), x, y, angle);
                y = y + delta;
            end
            x = x + delta;
            y = bottom;
        end
    end
}